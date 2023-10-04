DROP procedure IF EXISTS `delete_customer_image`;
DELIMITER $$
CREATE PROCEDURE `delete_customer_image`(
IN p_customerGuid char(36))
BEGIN
	DECLARE oldFileName TEXT DEFAULT NULL;
    
	SET time_zone = 'SYSTEM';
    SET oldFileName = (SELECT imagePath FROM customers WHERE customerGuid = p_customerGuid);
    
	UPDATE customers
    SET imagePath = NULL
    WHERE customerGuid = p_customerGuid;

	SELECT oldFileName;

END$$

DELIMITER ;
;

