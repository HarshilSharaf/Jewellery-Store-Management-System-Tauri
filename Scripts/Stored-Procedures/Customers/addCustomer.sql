DROP procedure IF EXISTS `add_customer`;
DELIMITER $$ 
CREATE PROCEDURE `add_customer` (
  IN fName text, 
  IN lName text, 
  IN dob date, 
  IN gender varchar(6), 
  IN address text, 
  IN city text, 
  IN email varchar(255), 
  IN phoneNumber bigint, 
  IN imageFileName text
) 
BEGIN

DECLARE GUID CHAR(36);
DECLARE l_imageFileName TEXT DEFAULT NULL;
SET GUID = UUID();

IF(imageFileName IS NOT NULL)
	THEN 
		BEGIN
			SET l_imageFileName = CONCAT(GUID,'-customer-',imageFileName);
		END;
	END IF;

    -- Set the time zone to the server's global time zone
    SET time_zone = 'SYSTEM';
    INSERT INTO customers(
      customerGuid, firstName, lastname, 
      dateOfBirth, gender, address, city, 
      email, phoneNumber, imagePath, createdAt
    ) 
    VALUES 
      (
        uuid(), 
        fName, 
        lName, 
        dob, 
        gender, 
        address, 
        city, 
        email, 
        phoneNumber, 
        l_imageFileName, 
        current_timestamp()
      );

      SELECT * FROM customers WHERE id = last_insert_id();
END$$ 
DELIMITER ;
;
