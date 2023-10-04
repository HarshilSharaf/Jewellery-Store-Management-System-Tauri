DROP procedure IF EXISTS `get_user_image`;
DELIMITER $$
CREATE PROCEDURE `get_user_image` (
p_uid INT
)
BEGIN
	
    SELECT 
		imagePath
	FROM users
    WHERE uid = p_uid;
    
END$$

DELIMITER ;

