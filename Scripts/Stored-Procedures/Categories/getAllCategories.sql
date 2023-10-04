DROP procedure IF EXISTS `get_all_categories`;
DELIMITER $$
CREATE DEFINER=`sa`@`%` PROCEDURE `get_all_categories`()
BEGIN
	
    SELECT 	
		json_arrayagg(
			json_object(
			'id',id,
            'masterCategoryName',masterCategoryName
			)
        ) as 'MasterCategoriesData'
		
	FROM mastercategories;
    
	SELECT 
		json_arrayagg(
			json_object(
			'id',id,
            'subCategoryName',subCategoryName
			)
        ) as 'SubCategoriesData'
	FROM subcategories;
    
	SELECT 
		json_arrayagg(
			json_object(
			'id',id,
            'productCategoryName',productCategoryName
			)
        ) as 'ProductCategoriesData'
	FROM productcategories;

END$$

DELIMITER ;

