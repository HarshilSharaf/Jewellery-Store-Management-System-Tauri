DROP procedure IF EXISTS `get_customer_image`;
DELIMITER $$
CREATE PROCEDURE `get_customer_image`(
IN p_customerGuid char(36))
BEGIN

	SELECT 
    imagePath
    FROM customers
    WHERE customerGuid = p_customerGuid
    AND deletedAt IS NULL;

END$$

DELIMITER ;
;

