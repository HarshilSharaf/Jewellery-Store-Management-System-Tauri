DROP procedure IF EXISTS `add_sub_category`;
DELIMITER $$
CREATE PROCEDURE `add_sub_category` (
	IN p_subCategoryName TEXT,
    IN p_subCategoryDescription TEXT
)
BEGIN
    SET time_zone = 'SYSTEM';

    INSERT INTO subcategories (subCategoryName, subCategoryDescription)
    VALUES (p_subCategoryName, p_subCategoryDescription);
END$$

DELIMITER ;

