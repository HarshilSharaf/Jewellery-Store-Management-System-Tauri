DROP procedure IF EXISTS `update_customer_image`;
DELIMITER $$
CREATE PROCEDURE `update_customer_image`(
IN p_customerGuid char(36),
IN imageFileName text
)
BEGIN
	DECLARE l_imageFileName TEXT DEFAULT NULL;
    DECLARE oldFileName TEXT DEFAULT NULL;
    
    SET oldFileName = (SELECT imagePath FROM customers WHERE customerGuid = p_customerGuid);
    
	SET time_zone = 'SYSTEM';
    SET l_imageFileName = CONCAT(p_customerGuid,'-customer-',imageFileName);
    
	UPDATE customers
    SET imagePath = l_imageFileName
    WHERE customerGuid = p_customerGuid;
    
    SELECT 
		imagePath,
        oldFileName
	FROM customers 
    WHERE customerGuid = p_customerGuid;
END$$

DELIMITER ;
;

