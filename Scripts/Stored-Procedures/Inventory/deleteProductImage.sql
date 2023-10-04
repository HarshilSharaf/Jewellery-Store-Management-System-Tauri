DROP procedure IF EXISTS `delete_product_image`;
DELIMITER $$
CREATE PROCEDURE `delete_product_image` (
IN p_productGuid CHAR(36)
)
BEGIN
	DECLARE oldFileName TEXT DEFAULT NULL;
    
    SET time_zone = 'SYSTEM';
    SET oldFileName = (SELECT imagePath FROM products WHERE productGuid = p_productGuid);
    
	UPDATE products
    SET imagePath = NULL
    WHERE productGuid = p_productGuid;

	SELECT oldFileName;
END$$

DELIMITER ;

