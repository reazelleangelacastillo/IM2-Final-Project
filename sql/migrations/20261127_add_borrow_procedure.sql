-- Install the procedure used by php/transactions_api.php to record new borrows.

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_borrow`$$

CREATE PROCEDURE `sp_borrow`(IN p_borrower_id VARCHAR(10), IN p_copy_id VARCHAR(20), IN p_libstaff_id VARCHAR(20))
BEGIN
  DECLARE v_user_id INT DEFAULT NULL;
  DECLARE v_status_type VARCHAR(30) DEFAULT NULL;
  DECLARE v_condition VARCHAR(50) DEFAULT NULL;
  DECLARE v_unpaid DECIMAL(10,2) DEFAULT 0;
  DECLARE v_overdue INT DEFAULT 0;
  DECLARE v_active INT DEFAULT 0;
  DECLARE v_policy VARCHAR(20) DEFAULT NULL;
  DECLARE v_max INT DEFAULT 0;
  DECLARE v_days INT DEFAULT 0;
  DECLARE v_next INT DEFAULT 0;
  DECLARE v_id VARCHAR(20);
  DECLARE v_now DATETIME;
  DECLARE v_due DATETIME;
  DECLARE v_msg VARCHAR(255) DEFAULT NULL;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;
  START TRANSACTION;
  SELECT `user_id` INTO v_user_id FROM `borrower` WHERE `borrower_id` = p_borrower_id;
  IF v_user_id IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Borrower not found.';
  END IF;
  SELECT s.`status_type`, s.`condition` INTO v_status_type, v_condition
    FROM `pub copies` pc JOIN `status` s ON s.`status_id` = pc.`status_id`
    WHERE pc.`copy_id` = p_copy_id FOR UPDATE;
  IF v_status_type IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Copy not found.';
  END IF;
  IF v_status_type <> 'Available' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Copy is not available.';
  END IF;
  IF v_condition = 'Damaged' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Copy is damaged and cannot be borrowed.';
  END IF;
  SELECT COALESCE(SUM(f.`amount`), 0) INTO v_unpaid
    FROM `fines` f JOIN `borrows` b ON b.`borrow_id` = f.`borrow_id`
    WHERE b.`user_id` = v_user_id AND f.`status` = 'Unpaid';
  IF v_unpaid > 0 THEN
    SET v_msg = CONCAT('Borrower has an unpaid fine of ', FORMAT(v_unpaid, 2), '.');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
  END IF;
  SELECT COUNT(*) INTO v_overdue FROM `borrows`
    WHERE `user_id` = v_user_id AND `date_returned` IS NULL AND `due_date` < NOW();
  IF v_overdue > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Borrower has an overdue book that has not been returned.';
  END IF;
  SELECT `policy_id`, `max_books_allowed`, `loan_duration_days` INTO v_policy, v_max, v_days
    FROM `borrowing_policy` ORDER BY `policy_id` LIMIT 1;
  SELECT COUNT(*) INTO v_active FROM `borrows`
    WHERE `user_id` = v_user_id AND `date_returned` IS NULL;
  IF v_active >= v_max THEN
    SET v_msg = CONCAT('Borrower has reached the maximum of ', v_max, ' books.');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
  END IF;
  SELECT COALESCE(MAX(CAST(SUBSTRING(`borrow_id`, 4) AS UNSIGNED)), 0) + 1 INTO v_next FROM `borrows` FOR UPDATE;
  SET v_id = CONCAT('TRX', LPAD(v_next, 3, '0'));
  SET v_now = NOW();
  SET v_due = DATE_ADD(v_now, INTERVAL v_days DAY);
  INSERT INTO `borrows` (`borrow_id`, `user_id`, `date_borrowed`, `date_returned`, `due_date`, `copy_id`, `policy_id`, `libstaff_id`)
    VALUES (v_id, v_user_id, v_now, NULL, v_due, p_copy_id, v_policy, p_libstaff_id);
  UPDATE `status` SET `status_type` = 'Borrowed'
    WHERE `status_id` = (SELECT `status_id` FROM `pub copies` WHERE `copy_id` = p_copy_id);
  COMMIT;
  SELECT v_id AS `transaction_id`, v_due AS `due_date`;
END$$

DELIMITER ;
