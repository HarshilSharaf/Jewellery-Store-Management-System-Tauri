DROP procedure IF EXISTS `update_user_details`;
DELIMITER $$
CREATE PROCEDURE `update_user_details`(
IN p_userId INT,
IN p_userName TEXT,
IN p_password TEXT,
IN p_email TEXT
)
BEGIN
	SET time_zone = 'SYSTEM';
	UPDATE users
    SET userName = p_userName,
		password = IFNULL(p_password, password),
        email = p_email
	WHERE uid = p_userId;
END$$

DELIMITER ;
;

