DROP procedure IF EXISTS `get_product_image`;
DELIMITER $$
CREATE PROCEDURE `get_product_image` (
IN p_productGuid char(36)
)
BEGIN
	SELECT 
		imagePath
	FROM products
    WHERE productGuid = p_productGuid;
END$$

DELIMITER ;

