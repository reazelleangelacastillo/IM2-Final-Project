ALTER TABLE reports
    MODIFY report_id INT NOT NULL AUTO_INCREMENT,
    MODIFY report_type ENUM('Weekly', 'Monthly', 'Annual') NOT NULL;
