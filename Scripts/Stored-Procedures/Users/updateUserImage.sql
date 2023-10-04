DROP procedure IF EXISTS `update_user_image`;
DELIMITER $$
CREATE PROCEDURE `update_user_image`(
IN p_uid INT,
IN p_imageFileName TEXT
)
BEGIN
	DECLARE l_imageFileName TEXT DEFAULT NULL;
    DECLARE oldFileName TEXT DEFAULT NULL;
    
    SET oldFileName = (SELECT imagePath FROM users WHERE uid = p_uid);
    
	SET time_zone = 'SYSTEM';
    SET l_imageFileName = CONCAT('user-', p_uid, '-', p_imageFileName);
    
	UPDATE users
    SET imagePath = l_imageFileName
    WHERE uid = p_uid;
    
    SELECT 
		imagePath,
        oldFileName
	FROM users 
    WHERE uid = p_uid;
END$$

DELIMITER ;
;

