DROP procedure IF EXISTS `add_product_category`;
DELIMITER $$
CREATE PROCEDURE `add_product_category` (
	IN p_productCategoryName TEXT,
    IN p_productCategoryDescription TEXT
)
BEGIN
	SET time_zone = 'SYSTEM';

    INSERT INTO productcategories (productCategoryName, productCategoryDescription)
    VALUES (p_productCategoryName, p_productCategoryDescription);
END$$

DELIMITER ;

