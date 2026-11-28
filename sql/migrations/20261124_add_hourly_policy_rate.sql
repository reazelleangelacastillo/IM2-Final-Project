-- Align an existing borrowing_policy table with the current hourly-fine schema.

SET @column_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'borrowing_policy'
      AND column_name = 'fine_rate_per_hour'
);
SET @migration_sql = IF(
    @column_exists = 0,
    'ALTER TABLE borrowing_policy ADD COLUMN fine_rate_per_hour DECIMAL(10,2) NOT NULL DEFAULT 2.00 AFTER loan_duration_days',
    'SELECT 1'
);
PREPARE migration_statement FROM @migration_sql;
EXECUTE migration_statement;
DEALLOCATE PREPARE migration_statement;

INSERT INTO borrowing_policy (policy_id, max_books_allowed, loan_duration_days, fine_rate_per_hour)
SELECT 'POL001', 3, 7, 2.00
WHERE NOT EXISTS (SELECT 1 FROM borrowing_policy);
