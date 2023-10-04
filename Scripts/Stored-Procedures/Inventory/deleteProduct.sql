DROP procedure IF EXISTS `delete_product`;
DELIMITER $$
CREATE PROCEDURE `delete_product` (
IN p_hardDelete TINYINT(1),
IN p_productGuid char(36)
)
BEGIN
	-- Set the time zone to the server's global time zone
    SET time_zone = 'SYSTEM';
	
    IF(p_hardDelete = 1) 
		THEN
			BEGIN
				DELETE FROM products
                WHERE productGuid = p_productGuid;
            END;
		
        ELSE 
			BEGIN
				UPDATE products
                SET deletedAt = CURRENT_TIMESTAMP()
                WHERE productGuid = p_productGuid;
            END;
	END IF;
    
    
END$$

DELIMITER ;

