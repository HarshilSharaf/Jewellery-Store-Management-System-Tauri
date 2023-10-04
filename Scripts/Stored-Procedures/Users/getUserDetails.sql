DROP procedure IF EXISTS `get_user_details`;
DELIMITER $$
CREATE PROCEDURE `get_user_details` (
IN p_userId INT
)
BEGIN
	
    SELECT * FROM users where uid = p_userId;
    
END$$

DELIMITER ;

