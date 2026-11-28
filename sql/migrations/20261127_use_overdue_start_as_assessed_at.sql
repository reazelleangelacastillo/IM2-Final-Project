-- Keep the assessed time stored on each fine; no schema changes are made.

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_sync_overdue_fines`$$

CREATE PROCEDURE `sp_sync_overdue_fines`()
BEGIN
  DECLARE v_done TINYINT DEFAULT 0;
  DECLARE v_lock INT DEFAULT 0;
  DECLARE v_borrow_id VARCHAR(20);
  DECLARE v_due DATETIME;
  DECLARE v_returned DATETIME;
  DECLARE v_policy_id VARCHAR(20);
  DECLARE v_copy_id VARCHAR(20);
  DECLARE v_libstaff_id VARCHAR(20);
  DECLARE v_pub_id VARCHAR(20);
  DECLARE v_rate DECIMAL(10,2);
  DECLARE v_total_hours INT DEFAULT 0;
  DECLARE v_paid_hours INT DEFAULT 0;
  DECLARE v_unpaid_hours INT DEFAULT 0;
  DECLARE v_next INT DEFAULT 0;
  DECLARE v_fine_id VARCHAR(30);
  DECLARE v_unpaid_fine_id VARCHAR(30);
  DECLARE v_amount DECIMAL(10,2) DEFAULT 0;
  DECLARE overdue_cursor CURSOR FOR
    SELECT `borrow_id`
    FROM `borrows`
    WHERE `date_returned` IS NULL AND `due_date` < NOW()
    ORDER BY `borrow_id`;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    IF v_lock = 1 THEN
      DO RELEASE_LOCK('booktrace_overdue_fine_sync');
    END IF;
    RESIGNAL;
  END;

  SELECT GET_LOCK('booktrace_overdue_fine_sync', 10) INTO v_lock;
  IF v_lock IS NULL OR v_lock <> 1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Could not synchronize overdue fine records.';
  END IF;

  START TRANSACTION;
  SELECT COALESCE(MAX(CAST(SUBSTRING(`fine_id`, 3) AS UNSIGNED)), 0)
    INTO v_next FROM `fines` FOR UPDATE;
  OPEN overdue_cursor;

  sync_loop: LOOP
    FETCH overdue_cursor INTO v_borrow_id;
    IF v_done = 1 THEN
      LEAVE sync_loop;
    END IF;

    SELECT b.`due_date`, b.`date_returned`, b.`policy_id`, b.`copy_id`,
           b.`libstaff_id`, bp.`fine_rate_per_hour`, pc.`pub_id`
      INTO v_due, v_returned, v_policy_id, v_copy_id, v_libstaff_id, v_rate, v_pub_id
      FROM `borrows` b
      JOIN `borrowing_policy` bp ON bp.`policy_id` = b.`policy_id`
      JOIN `pub copies` pc ON pc.`copy_id` = b.`copy_id`
      WHERE b.`borrow_id` = v_borrow_id
      FOR UPDATE;

    IF v_returned IS NULL AND v_due < NOW() THEN
      SET v_total_hours = fn_hours_late(v_due, NOW());
      SELECT COALESCE(SUM(`hours_late`), 0) INTO v_paid_hours
        FROM `fines`
        WHERE `borrow_id` = v_borrow_id AND `status` = 'Paid';
      SET v_unpaid_hours = GREATEST(v_total_hours - v_paid_hours, 0);
      SET v_amount = ROUND(v_unpaid_hours * v_rate, 2);
      SELECT MIN(`fine_id`) INTO v_unpaid_fine_id
        FROM `fines`
        WHERE `borrow_id` = v_borrow_id AND `status` = 'Unpaid';

      IF v_unpaid_hours >= 1 AND v_amount > 0 THEN
        IF v_unpaid_fine_id IS NULL THEN
          SET v_next = v_next + 1;
          SET v_fine_id = CONCAT('FN', LPAD(v_next, 3, '0'));
          INSERT INTO `fines` (`fine_id`, `libstaff_id`, `borrow_id`, `amount`, `hours_late`,
                               `rate_applied`, `date_assessed`, `status`, `date_paid`, `pub_id`)
            VALUES (v_fine_id, v_libstaff_id, v_borrow_id, v_amount, v_unpaid_hours,
                    v_rate, v_due, 'Unpaid', NULL, v_pub_id);
        ELSE
          UPDATE `fines`
            SET `libstaff_id` = COALESCE(`libstaff_id`, v_libstaff_id),
                `amount` = v_amount,
                `hours_late` = v_unpaid_hours,
                `rate_applied` = v_rate,
                `pub_id` = v_pub_id
            WHERE `fine_id` = v_unpaid_fine_id;
        END IF;
      END IF;
    END IF;
  END LOOP;

  CLOSE overdue_cursor;
  COMMIT;
  DO RELEASE_LOCK('booktrace_overdue_fine_sync');
  SET v_lock = 0;
  SELECT 1 AS synchronized;
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
  DECLARE v_fine_id VARCHAR(30) DEFAULT NULL;
  DECLARE v_pub_id VARCHAR(20);
  IF OLD.`date_returned` IS NULL AND NEW.`date_returned` IS NOT NULL THEN
    SET v_total_hours = fn_hours_late(NEW.`due_date`, NEW.`date_returned`);
    SELECT COALESCE(SUM(`hours_late`), 0) INTO v_paid_hours
      FROM `fines`
      WHERE `borrow_id` = NEW.`borrow_id` AND `status` = 'Paid';
    SET v_hours = GREATEST(v_total_hours - v_paid_hours, 0);
    IF v_hours >= 1 THEN
      SELECT `fine_rate_per_hour` INTO v_rate
        FROM `borrowing_policy` WHERE `policy_id` = NEW.`policy_id`;
      SELECT `pub_id` INTO v_pub_id
        FROM `pub copies` WHERE `copy_id` = NEW.`copy_id`;
      SELECT MIN(`fine_id`) INTO v_fine_id
        FROM `fines`
        WHERE `borrow_id` = NEW.`borrow_id` AND `status` = 'Unpaid';

      IF v_fine_id IS NULL THEN
        SELECT COALESCE(MAX(CAST(SUBSTRING(`fine_id`, 3) AS UNSIGNED)), 0) + 1
          INTO v_next FROM `fines` FOR UPDATE;
        SET v_fine_id = CONCAT('FN', LPAD(v_next, 3, '0'));
        INSERT INTO `fines` (`fine_id`, `libstaff_id`, `borrow_id`, `amount`, `hours_late`,
                             `rate_applied`, `date_assessed`, `status`, `date_paid`, `pub_id`)
          VALUES (v_fine_id, COALESCE(@return_staff_id, NEW.`libstaff_id`), NEW.`borrow_id`,
                  ROUND(v_hours * v_rate, 2), v_hours, v_rate, NEW.`due_date`, 'Unpaid', NULL, v_pub_id);
      ELSE
        UPDATE `fines`
          SET `libstaff_id` = COALESCE(@return_staff_id, `libstaff_id`, NEW.`libstaff_id`),
              `amount` = ROUND(v_hours * v_rate, 2),
              `hours_late` = v_hours,
              `rate_applied` = v_rate,
              `pub_id` = v_pub_id
          WHERE `fine_id` = v_fine_id;
      END IF;
    END IF;
  END IF;
END$$

DELIMITER ;
