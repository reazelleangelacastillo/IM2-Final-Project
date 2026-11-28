-- Add the selected report period to existing reports tables.

SET @column_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'reports'
      AND column_name = 'period_start'
);
SET @migration_sql = IF(
    @column_exists = 0,
    'ALTER TABLE `reports` ADD COLUMN period_start DATE DEFAULT NULL AFTER date_generated',
    'SELECT 1'
);
PREPARE migration_statement FROM @migration_sql;
EXECUTE migration_statement;
DEALLOCATE PREPARE migration_statement;
