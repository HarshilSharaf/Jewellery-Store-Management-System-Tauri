DROP procedure IF EXISTS `loginUser`;
DELIMITER $$
CREATE DEFINER=`sa`@`%` PROCEDURE `loginUser`(
IN uName varchar(255)
)
BEGIN
	SET time_zone = 'SYSTEM';
	IF EXISTS(SELECT * FROM users WHERE userName = uName)
		THEN 
			BEGIN
				UPDATE users
					SET last_login_date = current_timestamp()
                    WHERE userName = uName;
				SELECT 
					UID,
					userName,
					email,
					type,
                    password,
					last_login_date
				FROM
					users
				WHERE userName = uName;
			END;
		END IF;
END$$

DELIMITER ;
;