DROP procedure IF EXISTS `get_customer_details`;
DELIMITER $$
CREATE PROCEDURE `get_customer_details`(
IN p_customerGuid char(36))
BEGIN
	
    SELECT 
		firstName,
        lastName,
        dateOfBirth,
        gender,
        address,
        email,
        phoneNumber,
        city
	FROM customers
	WHERE customerGuid = p_customerGuid
    AND deletedAt IS NULL;

END$$

DELIMITER ;
;

