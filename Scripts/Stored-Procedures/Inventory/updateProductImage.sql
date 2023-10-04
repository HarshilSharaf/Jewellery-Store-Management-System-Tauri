DROP procedure IF EXISTS `update_product_image`;
DELIMITER $$
CREATE PROCEDURE `update_product_image` (
IN p_productGuid CHAR(36),
IN p_imageFileName TEXT
)
BEGIN
	DECLARE l_imageFileName TEXT DEFAULT NULL;
    DECLARE oldFileName TEXT DEFAULT NULL;
    DECLARE fileExtension VARCHAR(6) DEFAULT NULL;
    
    SET fileExtension = (SELECT substring_index(p_imageFileName,'.',-1));
    SET oldFileName = (SELECT imagePath FROM products WHERE productGuid = p_productGuid);
	SET time_zone = 'SYSTEM';
    
    SET l_imageFileName = CONCAT(UNIX_TIMESTAMP(), '-product-', p_productGuid, '.', fileExtension);
    
    UPDATE products
    SET imagePath = l_imageFileName 
    WHERE productGuid = p_productGuid;
    
    SELECT 
		imagePath,
        oldFileName
	FROM products
    WHERE productGuid = p_productGuid;

END$$

DELIMITER ;

