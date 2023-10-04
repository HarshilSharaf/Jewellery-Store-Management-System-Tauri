DROP procedure IF EXISTS `add_master_category`;
DELIMITER $$
CREATE PROCEDURE `add_master_category` (
    IN p_masterCategoryName TEXT,
    IN p_masterCategoryDescription TEXT
)
BEGIN
    SET time_zone = 'SYSTEM';

    INSERT INTO mastercategories (masterCategoryName, masterCategoryDescription)
    VALUES (p_masterCategoryName, p_masterCategoryDescription);
END$$

DELIMITER ;

