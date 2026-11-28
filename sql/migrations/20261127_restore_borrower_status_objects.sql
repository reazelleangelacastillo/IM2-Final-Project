-- Restore the borrower and overdue views and fine calculation functions
-- required by the current borrower, transaction, and fines screens.

SET @column_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'fines'
      AND column_name = 'hours_late'
);
SET @migration_sql = IF(
    @column_exists = 0,
    'ALTER TABLE `fines` ADD COLUMN `hours_late` INT DEFAULT NULL AFTER `amount`',
    'SELECT 1'
);
PREPARE migration_statement FROM @migration_sql;
EXECUTE migration_statement;
DEALLOCATE PREPARE migration_statement;

SET @column_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'fines'
      AND column_name = 'rate_applied'
);
SET @migration_sql = IF(
    @column_exists = 0,
    'ALTER TABLE `fines` ADD COLUMN `rate_applied` DECIMAL(10,2) NOT NULL DEFAULT 2.00 AFTER `hours_late`',
    'SELECT 1'
);
PREPARE migration_statement FROM @migration_sql;
EXECUTE migration_statement;
DEALLOCATE PREPARE migration_statement;

SET @column_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'fines'
      AND column_name = 'date_assessed'
);
SET @migration_sql = IF(
    @column_exists = 0,
    'ALTER TABLE `fines` ADD COLUMN `date_assessed` DATETIME DEFAULT NULL AFTER `rate_applied`',
    'SELECT 1'
);
PREPARE migration_statement FROM @migration_sql;
EXECUTE migration_statement;
DEALLOCATE PREPARE migration_statement;

SET @column_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'fines'
      AND column_name = 'status'
);
SET @migration_sql = IF(
    @column_exists = 0,
    'ALTER TABLE `fines` ADD COLUMN `status` VARCHAR(10) NOT NULL DEFAULT ''Unpaid'' AFTER `date_assessed`',
    'SELECT 1'
);
PREPARE migration_statement FROM @migration_sql;
EXECUTE migration_statement;
DEALLOCATE PREPARE migration_statement;

SET @column_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'fines'
      AND column_name = 'date_paid'
);
SET @migration_sql = IF(
    @column_exists = 0,
    'ALTER TABLE `fines` ADD COLUMN `date_paid` DATETIME DEFAULT NULL AFTER `status`',
    'SELECT 1'
);
PREPARE migration_statement FROM @migration_sql;
EXECUTE migration_statement;
DEALLOCATE PREPARE migration_statement;

SET @legacy_pub_id_required = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'fines'
      AND column_name = 'pub_id'
      AND is_nullable = 'NO'
);
SET @migration_sql = IF(
    @legacy_pub_id_required > 0,
    'ALTER TABLE `fines` MODIFY COLUMN `pub_id` VARCHAR(20) DEFAULT NULL',
    'SELECT 1'
);
PREPARE migration_statement FROM @migration_sql;
EXECUTE migration_statement;
DEALLOCATE PREPARE migration_statement;

DELIMITER $$

DROP FUNCTION IF EXISTS `fn_hours_late`$$

CREATE FUNCTION `fn_hours_late`(p_due DATETIME, p_end DATETIME) RETURNS INT
DETERMINISTIC
BEGIN
  IF p_due IS NULL OR p_end IS NULL OR p_end <= p_due THEN
    RETURN 0;
  END IF;
  RETURN FLOOR(TIMESTAMPDIFF(SECOND, p_due, p_end) / 3600);
END$$

DROP FUNCTION IF EXISTS `fn_calc_fine`$$

CREATE FUNCTION `fn_calc_fine`(p_due DATETIME, p_end DATETIME, p_rate DECIMAL(10,2)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  RETURN fn_hours_late(p_due, p_end) * p_rate;
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
  fn_hours_late(b.`due_date`, NOW()) AS `hours_late`,
  fn_calc_fine(b.`due_date`, NOW(), bp.`fine_rate_per_hour`) AS `live_fine`
FROM `borrows` b
JOIN `borrower` br ON br.`user_id` = b.`user_id`
JOIN `user` u ON u.`user_id` = b.`user_id`
JOIN `pub copies` pc ON pc.`copy_id` = b.`copy_id`
JOIN `publication` p ON p.`pub_id` = pc.`pub_id`
JOIN `borrowing_policy` bp ON bp.`policy_id` = b.`policy_id`
WHERE b.`date_returned` IS NULL AND b.`due_date` < NOW();

CREATE OR REPLACE VIEW `v_borrower_status` AS
SELECT
  br.`borrower_id`,
  br.`user_id`,
  CONCAT(u.`user_fname`, ' ', u.`user_lname`) AS `borrower_name`,
  br.`borrower_type`,
  (SELECT COUNT(*) FROM `borrows` b
    WHERE b.`user_id` = br.`user_id` AND b.`date_returned` IS NULL) AS `active_borrows`,
  (SELECT COUNT(*) FROM `borrows` b
    WHERE b.`user_id` = br.`user_id` AND b.`date_returned` IS NULL AND b.`due_date` < NOW()) AS `overdue_count`,
  (SELECT COALESCE(SUM(f.`amount`), 0) FROM `fines` f
    JOIN `borrows` b ON b.`borrow_id` = f.`borrow_id`
    WHERE b.`user_id` = br.`user_id` AND f.`status` = 'Unpaid') AS `unpaid_fine_total`
FROM `borrower` br
JOIN `user` u ON u.`user_id` = br.`user_id`;
