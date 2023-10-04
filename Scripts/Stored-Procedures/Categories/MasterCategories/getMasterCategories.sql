DROP procedure IF EXISTS `get_master_categories`;
DELIMITER $$
CREATE PROCEDURE `get_master_categories`()
BEGIN
	
	SELECT * FROM mastercategories;

END$$

DELIMITER ;
;

