-- Allow the currently accrued balance on an active overdue borrow to be paid.
-- Fine rows record paid hour segments; a later return assesses only unpaid hours.

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_pay_overdue_fine`$$

CREATE PROCEDURE `sp_pay_overdue_fine`(IN p_borrow_id VARCHAR(20), IN p_libstaff_id VARCHAR(20))
BEGIN
  DECLARE v_found TINYINT DEFAULT 1;
  DECLARE v_due DATETIME DEFAULT NULL;
  DECLARE v_returned DATETIME DEFAULT NULL;
  DECLARE v_policy_id VARCHAR(20) DEFAULT NULL;
  DECLARE v_rate DECIMAL(10,2) DEFAULT NULL;
  DECLARE v_total_hours INT DEFAULT 0;
  DECLARE v_paid_hours INT DEFAULT 0;
  DECLARE v_hours INT DEFAULT 0;
  DECLARE v_next INT DEFAULT 0;
  DECLARE v_fine_id VARCHAR(30);
  DECLARE v_amount DECIMAL(10,2) DEFAULT 0;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_found = 0;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

  START TRANSACTION;
  SELECT `due_date`, `date_returned`, `policy_id`
    INTO v_due, v_returned, v_policy_id
    FROM `borrows`
    WHERE `borrow_id` = p_borrow_id
    FOR UPDATE;
  IF v_found = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction not found.';
  END IF;
  IF v_returned IS NOT NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Book was already returned.';
  END IF;
  IF v_due IS NULL OR v_due >= NOW() THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This transaction has no overdue balance.';
  END IF;

  SET v_found = 1;
  SELECT `fine_rate_per_hour` INTO v_rate
    FROM `borrowing_policy`
    WHERE `policy_id` = v_policy_id;
  IF v_found = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Borrowing policy not found.';
  END IF;

  SET v_total_hours = fn_hours_late(v_due, NOW());
  SELECT COALESCE(SUM(`hours_late`), 0) INTO v_paid_hours
    FROM `fines`
    WHERE `borrow_id` = p_borrow_id AND `status` = 'Paid';
  SET v_hours = GREATEST(v_total_hours - v_paid_hours, 0);
  SET v_amount = ROUND(v_hours * v_rate, 2);
  IF v_hours < 1 OR v_amount <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'There is no unpaid overdue balance to collect.';
  END IF;

  SELECT COALESCE(MAX(CAST(SUBSTRING(`fine_id`, 3) AS UNSIGNED)), 0) + 1
    INTO v_next FROM `fines` FOR UPDATE;
  SET v_fine_id = CONCAT('FN', LPAD(v_next, 3, '0'));
  INSERT INTO `fines` (`fine_id`, `libstaff_id`, `borrow_id`, `amount`, `hours_late`,
                       `rate_applied`, `date_assessed`, `status`, `date_paid`)
    VALUES (v_fine_id, p_libstaff_id, p_borrow_id, v_amount, v_hours,
            v_rate, NOW(), 'Paid', NOW());
  COMMIT;
  SELECT `fine_id`, `amount`, `date_paid` FROM `fines` WHERE `fine_id` = v_fine_id;
END$$

DROP TRIGGER IF EXISTS `trg_borrows_after_return`$$

CREATE TRIGGER `trg_borrows_after_return` AFTER UPDATE ON `borrows`
FOR EACH ROW
BEGIN
  DECLARE v_total_hours INT DEFAULT 0;
  DECLARE v_paid_hours INT DEFAULT 0;
  DECLARE v_hours INT DEFAULT 0;
  DECLARE v_rate DECIMAL(10,2);
  DECLARE v_next INT;
  IF OLD.`date_returned` IS NULL AND NEW.`date_returned` IS NOT NULL THEN
    SET v_total_hours = fn_hours_late(NEW.`due_date`, NEW.`date_returned`);
    SELECT COALESCE(SUM(`hours_late`), 0) INTO v_paid_hours
      FROM `fines`
      WHERE `borrow_id` = NEW.`borrow_id` AND `status` = 'Paid';
    SET v_hours = GREATEST(v_total_hours - v_paid_hours, 0);
    IF v_hours >= 1 THEN
      SELECT `fine_rate_per_hour` INTO v_rate
        FROM `borrowing_policy` WHERE `policy_id` = NEW.`policy_id`;
      SELECT COALESCE(MAX(CAST(SUBSTRING(`fine_id`, 3) AS UNSIGNED)), 0) + 1
        INTO v_next FROM `fines` FOR UPDATE;
      INSERT INTO `fines` (`fine_id`, `libstaff_id`, `borrow_id`, `amount`, `hours_late`,
                           `rate_applied`, `date_assessed`, `status`, `date_paid`)
        VALUES (CONCAT('FN', LPAD(v_next, 3, '0')),
                COALESCE(@return_staff_id, NEW.`libstaff_id`), NEW.`borrow_id`,
                ROUND(v_hours * v_rate, 2), v_hours, v_rate, NOW(), 'Unpaid', NULL);
    END IF;
  END IF;
END$$

DELIMITER ;

CREATE OR REPLACE VIEW `v_overdue_borrows` AS
SELECT
  b.`borrow_id` AS `transaction_id`,
  br.`borrower_id`,
  CONCAT(u.`user_fname`, ' ', u.`user_lname`) AS `borrower_name`,
  b.`copy_id`,
  p.`title`,
  b.`due_date`,
  GREATEST(
    fn_hours_late(b.`due_date`, NOW()) -
    COALESCE((SELECT SUM(f.`hours_late`) FROM `fines` f
              WHERE f.`borrow_id` = b.`borrow_id` AND f.`status` = 'Paid'), 0),
    0
  ) AS `hours_late`,
  GREATEST(
    fn_hours_late(b.`due_date`, NOW()) -
    COALESCE((SELECT SUM(f.`hours_late`) FROM `fines` f
              WHERE f.`borrow_id` = b.`borrow_id` AND f.`status` = 'Paid'), 0),
    0
  ) * bp.`fine_rate_per_hour` AS `live_fine`
FROM `borrows` b
JOIN `borrower` br ON br.`user_id` = b.`user_id`
JOIN `user` u ON u.`user_id` = b.`user_id`
JOIN `pub copies` pc ON pc.`copy_id` = b.`copy_id`
JOIN `publication` p ON p.`pub_id` = pc.`pub_id`
JOIN `borrowing_policy` bp ON bp.`policy_id` = b.`policy_id`
WHERE b.`date_returned` IS NULL AND b.`due_date` < NOW();
