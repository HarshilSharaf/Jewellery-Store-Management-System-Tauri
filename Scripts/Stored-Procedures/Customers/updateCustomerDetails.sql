DROP procedure IF EXISTS `update_customer_details`;
DELIMITER $$
CREATE PROCEDURE `update_customer_details` (
IN p_customerGuid CHAR(36),
IN p_firstName TEXT,
IN p_lastName TEXT,
IN p_dateOfBirth DATE,
IN p_address TEXT,
IN p_city TEXT,
IN p_email VARCHAR(255),
IN p_phoneNumber BIGINT,
IN p_gender VARCHAR(6)
)
BEGIN

	UPDATE customers
    SET 
		firstName   	= p_firstName,
        lastName    	= p_lastName,
        dateOfBirth 	= p_dateOfBirth,
        address     	= p_address,
		city        	= p_city,
        email       	= p_email,
        phoneNumber 	= p_phoneNumber,
        gender      	= p_gender
	WHERE customerGuid  = p_customerGuid;
END$$

DELIMITER ;

