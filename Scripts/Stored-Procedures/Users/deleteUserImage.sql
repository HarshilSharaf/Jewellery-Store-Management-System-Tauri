DROP procedure IF EXISTS `delete_user_image`;
DELIMITER $$
CREATE PROCEDURE `delete_user_image` (
IN p_uid INT
)
BEGIN
	DECLARE oldFileName TEXT DEFAULT NULL;
    
   	SET time_zone = 'SYSTEM';
    SET oldFileName = (SELECT imagePath FROM users WHERE uid = p_uid);
    
	UPDATE users
    SET imagePath = NULL
    WHERE uid = p_uid;

	SELECT oldFileName;
END$$

DELIMITER ;

