-- Apply this migration to the selected BookTrace database when upgrading an
-- existing installation whose catalog tables predate the timestamp columns.

SET @column_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'books'
      AND column_name = 'created_at'
);
SET @migration_sql = IF(
    @column_exists = 0,
    'ALTER TABLE books ADD COLUMN created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP',
    'SELECT 1'
);
PREPARE migration_statement FROM @migration_sql;
EXECUTE migration_statement;
DEALLOCATE PREPARE migration_statement;

SET @column_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'publication'
      AND column_name = 'publisher_id'
);
SET @migration_sql = IF(
    @column_exists = 0,
    'ALTER TABLE publication ADD COLUMN publisher_id VARCHAR(30) DEFAULT NULL AFTER language_used',
    'SELECT 1'
);
PREPARE migration_statement FROM @migration_sql;
EXECUTE migration_statement;
DEALLOCATE PREPARE migration_statement;

SET @column_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'books'
      AND column_name = 'updated_at'
);
SET @migration_sql = IF(
    @column_exists = 0,
    'ALTER TABLE books ADD COLUMN updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP',
    'SELECT 1'
);
PREPARE migration_statement FROM @migration_sql;
EXECUTE migration_statement;
DEALLOCATE PREPARE migration_statement;

SET @column_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'books'
      AND column_name = 'acquired_at'
);
SET @migration_sql = IF(
    @column_exists = 0,
    'ALTER TABLE books ADD COLUMN acquired_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP',
    'SELECT 1'
);
PREPARE migration_statement FROM @migration_sql;
EXECUTE migration_statement;
DEALLOCATE PREPARE migration_statement;

SET @column_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'periodicals'
      AND column_name = 'created_at'
);
SET @migration_sql = IF(
    @column_exists = 0,
    'ALTER TABLE periodicals ADD COLUMN created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP',
    'SELECT 1'
);
PREPARE migration_statement FROM @migration_sql;
EXECUTE migration_statement;
DEALLOCATE PREPARE migration_statement;

SET @column_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'periodicals'
      AND column_name = 'updated_at'
);
SET @migration_sql = IF(
    @column_exists = 0,
    'ALTER TABLE periodicals ADD COLUMN updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP',
    'SELECT 1'
);
PREPARE migration_statement FROM @migration_sql;
EXECUTE migration_statement;
DEALLOCATE PREPARE migration_statement;

SET @column_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'periodicals'
      AND column_name = 'acquired_at'
);
SET @migration_sql = IF(
    @column_exists = 0,
    'ALTER TABLE periodicals ADD COLUMN acquired_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP',
    'SELECT 1'
);
PREPARE migration_statement FROM @migration_sql;
EXECUTE migration_statement;
DEALLOCATE PREPARE migration_statement;
