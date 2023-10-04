DROP procedure IF EXISTS `get_product_details`;
DELIMITER $$
CREATE PROCEDURE `get_product_details` (
IN p_productGuid char(36))
BEGIN
	SELECT 
		id,
        productGuid,
        productDescription,
        productWeight,
        mid as 'masterCategoryId',
        sid as 'subCategoryId',
        pid as 'productCategoryId',
        isSold
	FROM products
    WHERE productGuid = p_productGuid;
END$$

DELIMITER ;

