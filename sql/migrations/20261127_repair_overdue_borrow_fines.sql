-- Reconnect legacy borrows to the sole active policy so overdue joins and
-- fine calculations include them.
SET @policy_count = (SELECT COUNT(*) FROM `borrowing_policy`);
SET @migration_sql = IF(
    @policy_count = 1,
    'UPDATE `borrows` SET `policy_id` = (SELECT `policy_id` FROM `borrowing_policy` LIMIT 1) WHERE `policy_id` IS NULL',
    'SELECT 1'
);
PREPARE migration_statement FROM @migration_sql;
EXECUTE migration_statement;
DEALLOCATE PREPARE migration_statement;

SET @missing_policy_count = (
    SELECT COUNT(*) FROM `borrows` WHERE `policy_id` IS NULL
);
SET @policy_nullable = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'borrows'
      AND column_name = 'policy_id'
      AND is_nullable = 'YES'
);
SET @migration_sql = IF(
    @missing_policy_count = 0 AND @policy_nullable = 1,
    'ALTER TABLE `borrows` MODIFY COLUMN `policy_id` VARCHAR(20) NOT NULL',
    'SELECT 1'
);
PREPARE migration_statement FROM @migration_sql;
EXECUTE migration_statement;
DEALLOCATE PREPARE migration_statement;

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_return`$$

CREATE PROCEDURE `sp_return`(IN p_borrow_id VARCHAR(20), IN p_libstaff_id VARCHAR(20))
BEGIN
  DECLARE v_copy VARCHAR(20) DEFAULT NULL;
  DECLARE v_returned DATETIME DEFAULT NULL;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    SET @return_staff_id = NULL;
    ROLLBACK;
    RESIGNAL;
  END;
  START TRANSACTION;
  SELECT `copy_id`, `date_returned` INTO v_copy, v_returned
    FROM `borrows` WHERE `borrow_id` = p_borrow_id FOR UPDATE;
  IF v_copy IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction not found.';
  END IF;
  IF v_returned IS NOT NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Book was already returned.';
  END IF;
  SET @return_staff_id = p_libstaff_id;
  UPDATE `borrows` SET `date_returned` = NOW() WHERE `borrow_id` = p_borrow_id;
  UPDATE `status` SET `status_type` = 'Available'
    WHERE `status_id` = (SELECT `status_id` FROM `pub copies` WHERE `copy_id` = v_copy);
  SET @return_staff_id = NULL;
  COMMIT;
  SELECT b.`borrow_id` AS `transaction_id`, b.`date_returned`, f.`fine_id`, f.`hours_late`,
         COALESCE(f.`amount`, 0) AS `fine_amount`
    FROM `borrows` b LEFT JOIN `fines` f ON f.`borrow_id` = b.`borrow_id`
    WHERE b.`borrow_id` = p_borrow_id;
END$$

DROP PROCEDURE IF EXISTS `sp_pay_fine`$$

CREATE PROCEDURE `sp_pay_fine`(IN p_fine_id VARCHAR(30))
BEGIN
  DECLARE v_status VARCHAR(10) DEFAULT NULL;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;
  START TRANSACTION;
  SELECT `status` INTO v_status FROM `fines` WHERE `fine_id` = p_fine_id FOR UPDATE;
  IF v_status IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fine not found.';
  END IF;
  IF v_status = 'Paid' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fine is already paid.';
  END IF;
  UPDATE `fines` SET `status` = 'Paid', `date_paid` = NOW() WHERE `fine_id` = p_fine_id;
  COMMIT;
  SELECT `fine_id`, `status`, `date_paid` FROM `fines` WHERE `fine_id` = p_fine_id;
END$$

DROP TRIGGER IF EXISTS `trg_borrows_after_return`$$

CREATE TRIGGER `trg_borrows_after_return` AFTER UPDATE ON `borrows`
FOR EACH ROW
BEGIN
  DECLARE v_hours INT;
  DECLARE v_rate DECIMAL(10,2);
  DECLARE v_next INT;
  IF OLD.`date_returned` IS NULL AND NEW.`date_returned` IS NOT NULL THEN
    SET v_hours = fn_hours_late(NEW.`due_date`, NEW.`date_returned`);
    IF v_hours >= 1 THEN
      SELECT `fine_rate_per_hour` INTO v_rate
        FROM `borrowing_policy` WHERE `policy_id` = NEW.`policy_id`;
      SELECT COALESCE(MAX(CAST(SUBSTRING(`fine_id`, 3) AS UNSIGNED)), 0) + 1
        INTO v_next FROM `fines` FOR UPDATE;
      INSERT INTO `fines` (`fine_id`, `libstaff_id`, `borrow_id`, `amount`, `hours_late`,
                           `rate_applied`, `date_assessed`, `status`, `date_paid`)
        VALUES (CONCAT('FN', LPAD(v_next, 3, '0')),
                COALESCE(@return_staff_id, NEW.`libstaff_id`), NEW.`borrow_id`,
                fn_calc_fine(NEW.`due_date`, NEW.`date_returned`, v_rate),
                v_hours, v_rate, NOW(), 'Unpaid', NULL);
    END IF;
  END IF;
END$$

DELIMITER ;
