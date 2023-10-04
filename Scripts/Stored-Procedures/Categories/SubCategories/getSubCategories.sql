DROP procedure IF EXISTS `get_sub_categories`;
DELIMITER $$
CREATE PROCEDURE `get_sub_categories` ()
BEGIN
	
    SELECT * FROM subcategories;
    
END$$

DELIMITER ;

