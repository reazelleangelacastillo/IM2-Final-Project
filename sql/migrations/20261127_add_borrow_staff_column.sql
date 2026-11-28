-- Add staff attribution required by sp_borrow while preserving legacy rows
-- whose original staff member is unknown.

SET @column_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'borrows'
      AND column_name = 'libstaff_id'
);
SET @migration_sql = IF(
    @column_exists = 0,
    'ALTER TABLE `borrows` ADD COLUMN `libstaff_id` VARCHAR(20) DEFAULT NULL',
    'SELECT 1'
);
PREPARE migration_statement FROM @migration_sql;
EXECUTE migration_statement;
DEALLOCATE PREPARE migration_statement;

SET @constraint_exists = (
    SELECT COUNT(*)
    FROM information_schema.table_constraints
    WHERE constraint_schema = DATABASE()
      AND table_name = 'borrows'
      AND constraint_name = 'fk_borrows_libstaff'
      AND constraint_type = 'FOREIGN KEY'
);
SET @migration_sql = IF(
    @constraint_exists = 0,
    'ALTER TABLE `borrows` ADD CONSTRAINT `fk_borrows_libstaff` FOREIGN KEY (`libstaff_id`) REFERENCES `library_staff` (`libstaff_id`)',
    'SELECT 1'
);
PREPARE migration_statement FROM @migration_sql;
EXECUTE migration_statement;
DEALLOCATE PREPARE migration_statement;
