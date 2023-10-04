DROP procedure IF EXISTS `delete_customer`;
DELIMITER $$
CREATE PROCEDURE `delete_customer` (
IN p_hardDelete TINYINT(1),
IN p_customerGuid char(36)
)
BEGIN
	-- Set the time zone to the server's global time zone
    SET time_zone = 'SYSTEM';
	
    IF(p_hardDelete = 1) 
		THEN
			BEGIN
				DELETE FROM customers
                WHERE customerGuid = p_customerGuid;
            END;
		
        ELSE 
			BEGIN
				UPDATE customers
                SET deletedAt = CURRENT_TIMESTAMP()
                WHERE customerGuid = p_customerGuid;
            END;
	END IF;
END$$

DELIMITER ;

