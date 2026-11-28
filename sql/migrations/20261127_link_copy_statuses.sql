-- Link each existing book copy to its status row. Older installations may
-- contain status records but leave every pub-copies status_id unset.

START TRANSACTION;

INSERT INTO `status` (`status_id`, `status_type`, `libstaff_id`, `condition`)
SELECT
    CAST(110000 + CAST(SUBSTRING(pc.`copy_id`, 5) AS UNSIGNED) AS CHAR),
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM `borrows` b
            WHERE b.`copy_id` = pc.`copy_id`
              AND b.`date_returned` IS NULL
        ) THEN 'Borrowed'
        ELSE 'Available'
    END,
    (SELECT MIN(ls.`libstaff_id`) FROM `library_staff` ls),
    'Good'
FROM `pub copies` pc
LEFT JOIN `status` s
    ON s.`status_id` = CAST(110000 + CAST(SUBSTRING(pc.`copy_id`, 5) AS UNSIGNED) AS CHAR)
WHERE pc.`copy_id` REGEXP '^COPY[0-9]+$'
  AND s.`status_id` IS NULL;

UPDATE `pub copies` pc
JOIN `status` s
    ON s.`status_id` = CAST(110000 + CAST(SUBSTRING(pc.`copy_id`, 5) AS UNSIGNED) AS CHAR)
SET pc.`status_id` = s.`status_id`
WHERE pc.`copy_id` REGEXP '^COPY[0-9]+$'
  AND pc.`status_id` IS NULL;

UPDATE `status` s
JOIN `pub copies` pc ON pc.`status_id` = s.`status_id`
SET s.`status_type` = 'Borrowed'
WHERE s.`status_type` <> 'Borrowed'
  AND EXISTS (
      SELECT 1
      FROM `borrows` b
      WHERE b.`copy_id` = pc.`copy_id`
        AND b.`date_returned` IS NULL
  );

UPDATE `status` s
JOIN `pub copies` pc ON pc.`status_id` = s.`status_id`
SET s.`status_type` = 'Available'
WHERE s.`status_type` IN ('Borrowed', 'Overdue')
  AND NOT EXISTS (
      SELECT 1
      FROM `borrows` b
      WHERE b.`copy_id` = pc.`copy_id`
        AND b.`date_returned` IS NULL
  );

COMMIT;
