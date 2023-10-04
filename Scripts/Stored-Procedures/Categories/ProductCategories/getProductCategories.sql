DROP procedure IF EXISTS `get_product_categories`;
DELIMITER $$
CREATE PROCEDURE `get_product_categories` ()
BEGIN
	
	SELECT * FROM productcategories;
    
END$$

DELIMITER ;

