DROP procedure IF EXISTS `get_total_customers`;
DELIMITER $$
CREATE PROCEDURE `get_total_customers`()
BEGIN
	DECLARE current_count INT;
    DECLARE previous_count INT;
	DECLARE percent_increase DOUBLE(5, 2);
    DECLARE total INT;
    
    SET time_zone = 'SYSTEM';
    
	-- Get the current count of customers
    SELECT COUNT(*) INTO current_count FROM customers WHERE createdAt >= DATE_SUB(NOW(), INTERVAL 6 MONTH) AND deletedAt IS NULL;
    
	-- Get the count of customers 6 months ago
    SELECT COUNT(*) INTO previous_count FROM customers WHERE createdAt < DATE_SUB(NOW(), INTERVAL 6 MONTH) AND deletedAt IS NULL;
    
	IF previous_count = 0 THEN
        SET percent_increase = 100.0;
    ELSE
        SET percent_increase = ((current_count - previous_count) / previous_count) * 100.0;
    END IF;
    
    IF percent_increase IS NULL THEN
		SET percent_increase = 0;
    END IF;
    
	SELECT COUNT(*) INTO total FROM customers WHERE deletedAt IS NULL;
    
    SELECT total, percent_increase;
END$$

DELIMITER ;
;

