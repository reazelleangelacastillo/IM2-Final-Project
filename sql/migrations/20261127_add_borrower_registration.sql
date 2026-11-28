-- Align existing borrower tables with the current registration form and
-- install the procedure used by php/borrower_search.php.

ALTER TABLE `borrower` MODIFY COLUMN `borrower_type` VARCHAR(30) NOT NULL;

SET @constraint_exists = (
    SELECT COUNT(*)
    FROM information_schema.table_constraints
    WHERE constraint_schema = DATABASE()
      AND table_name = 'borrower'
      AND constraint_name = 'chk_borrower_category'
      AND constraint_type = 'CHECK'
);
SET @migration_sql = IF(
    @constraint_exists = 0,
    'ALTER TABLE `borrower` ADD CONSTRAINT `chk_borrower_category` CHECK (`borrower_type` IN (''Internal'', ''External'', ''Student'', ''Teacher'', ''Researcher'', ''Community Resident'', ''Other''))',
    'SELECT 1'
);
PREPARE migration_statement FROM @migration_sql;
EXECUTE migration_statement;
DEALLOCATE PREPARE migration_statement;

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_register_borrower`$$

CREATE PROCEDURE `sp_register_borrower`(
  IN p_fname VARCHAR(50), IN p_lname VARCHAR(50), IN p_mid VARCHAR(50), IN p_birth DATE,
  IN p_gender VARCHAR(10), IN p_brgy VARCHAR(100), IN p_municipality VARCHAR(100),
  IN p_province VARCHAR(100), IN p_email VARCHAR(100), IN p_category VARCHAR(30),
  IN p_id_type VARCHAR(100), IN p_id_number VARCHAR(30))
BEGIN
  DECLARE v_exists INT DEFAULT 0;
  DECLARE v_user_next INT DEFAULT 0;
  DECLARE v_bor_next INT DEFAULT 0;
  DECLARE v_borrower_id VARCHAR(10);
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;
  IF NULLIF(TRIM(p_fname), '') IS NULL OR NULLIF(TRIM(p_lname), '') IS NULL
     OR p_birth IS NULL OR NULLIF(TRIM(p_gender), '') IS NULL
     OR NULLIF(TRIM(p_category), '') IS NULL OR NULLIF(TRIM(p_id_type), '') IS NULL
     OR NULLIF(TRIM(p_id_number), '') IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Required field missing.';
  END IF;
  IF p_category NOT IN ('Student', 'Teacher', 'Researcher', 'Community Resident', 'Other') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid borrower category.';
  END IF;
  START TRANSACTION;
  SELECT COUNT(*) INTO v_exists FROM `borrower`
    WHERE `ID_type` = TRIM(p_id_type) AND `ID_number` = TRIM(p_id_number) FOR UPDATE;
  IF v_exists > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A borrower with this ID type and number already exists.';
  END IF;
  SELECT COALESCE(MAX(`user_id`), 100000) + 1 INTO v_user_next FROM `user` FOR UPDATE;
  SELECT COALESCE(MAX(CAST(SUBSTRING(`borrower_id`, 4) AS UNSIGNED)), 0) + 1 INTO v_bor_next FROM `borrower` FOR UPDATE;
  SET v_borrower_id = CONCAT('BOR', LPAD(v_bor_next, 3, '0'));
  INSERT INTO `user` (`user_id`, `user_fname`, `user_lname`, `user_midInit`, `birth_date`, `gender`, `email`,
                      `user_type`, `user_brgy`, `user_municipality`, `user_province`)
    VALUES (v_user_next, TRIM(p_fname), TRIM(p_lname), NULLIF(TRIM(p_mid), ''), p_birth, TRIM(p_gender),
            NULLIF(TRIM(p_email), ''), 'Borrower', NULLIF(TRIM(p_brgy), ''),
            NULLIF(TRIM(p_municipality), ''), NULLIF(TRIM(p_province), ''));
  INSERT INTO `borrower` (`borrower_id`, `user_id`, `borrower_type`, `ID_type`, `ID_number`)
    VALUES (v_borrower_id, v_user_next, p_category, TRIM(p_id_type), TRIM(p_id_number));
  COMMIT;
  SELECT v_borrower_id AS `borrower_id`;
END$$

DELIMITER ;
