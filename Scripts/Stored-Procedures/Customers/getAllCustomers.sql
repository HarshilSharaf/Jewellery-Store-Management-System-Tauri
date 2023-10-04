DROP procedure IF EXISTS `get_all_customers`;
DELIMITER $$
CREATE PROCEDURE `get_all_customers` (
IN fetchImage boolean,
itemsPerPage INT,
pageNumber INT,
IN fetchAll boolean,
searchQuery VARCHAR(255)
)
BEGIN

DECLARE startIndex INT;
DECLARE searchPattern VARCHAR(255);

SET searchPattern = CONCAT('%', searchQuery, '%');
SET startIndex = (pageNumber - 1) * itemsPerPage;

IF fetchAll = 0 THEN
    SELECT
        COUNT(A.id) AS 'totalRecords' 
    FROM customers A 
    WHERE 
    A.firstName LIKE searchPattern OR
    A.lastName LIKE searchPattern OR
    A.phoneNumber LIKE searchPattern OR
    A.email LIKE searchPattern AND
    A.deletedAt IS NULL; 

	SELECT 
        A.id,
        A.customerGuid,
        A.firstName,
        A.lastName,
        A.email,
        A.gender,
        A.city,
        A.phoneNumber,
    CASE WHEN fetchImage THEN A.imagePath ELSE NULL END AS imagePath
    FROM customers A
    WHERE 
        A.firstName LIKE searchPattern OR
        A.lastName LIKE searchPattern OR
        A.phoneNumber LIKE searchPattern OR
        A.email LIKE searchPattern AND
        A.deletedAt IS NULL
    LIMIT itemsPerPage OFFSET startIndex;

ELSE 
    SELECT 
        A.id,
        A.customerGuid,
        A.firstName,
        A.lastName,
        A.email,
        A.gender,
        A.city,
        A.phoneNumber,
    CASE WHEN fetchImage THEN A.imagePath ELSE NULL END AS imagePath
    FROM customers A
    WHERE 
        A.firstName LIKE searchPattern OR
        A.lastName LIKE searchPattern OR
        A.phoneNumber LIKE searchPattern OR
        A.email LIKE searchPattern AND
        A.deletedAt IS NULL;
END IF;

END$$

DELIMITER ;

