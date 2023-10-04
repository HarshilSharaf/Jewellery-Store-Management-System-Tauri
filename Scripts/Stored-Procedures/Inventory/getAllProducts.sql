DROP procedure IF EXISTS `get_all_products`;
DELIMITER $$
CREATE  PROCEDURE `get_all_products`(
IN p_fetchSoldProducts TINYINT(1),
IN itemsPerPage INT,
IN pageNumber INT,
IN searchQuery VARCHAR(255)
)
BEGIN
	DECLARE startIndex INT;
	DECLARE searchPattern VARCHAR(255);

	SET searchPattern = CONCAT('%', searchQuery, '%');
	SET startIndex = (pageNumber - 1) * itemsPerPage;

    IF(p_fetchSoldProducts = 0) THEN
		BEGIN
    		SELECT 
				COUNT(A.id) AS 'totalRecords' 
			FROM products A 
			INNER JOIN mastercategories B
				ON A.mid = B.id
			INNER JOIN subcategories C
				ON A.sid = C.id
			INNER JOIN productcategories D
				ON A.pid = D.id			
			WHERE 
				( 
					A.productDescription LIKE searchPattern OR
					A.productWeight LIKE searchPattern OR
					B.masterCategoryName LIKE searchPattern OR
					B.masterCategoryDescription LIKE searchPattern OR
					C.subCategoryName LIKE searchPattern OR
					C.subCategoryDescription LIKE searchPattern OR
					D.productCategoryName LIKE searchPattern OR
					D.productCategoryDescription LIKE searchPattern
				) AND
				A.isSold = 0 AND 
				A.deletedAt IS NULL;

			SELECT 
				A.id,
				A.productDescription,
				A.productGuid,
				A.productWeight,
				B.masterCategoryName as 'masterCategory',
				C.subCategoryName as 'subCategory',
				D.productCategoryName as 'productCategory',
				A.imagePath,
				A.createdAt,
				A.isSold
			FROM products A
			INNER JOIN mastercategories B
				ON A.mid = B.id
			INNER JOIN subcategories C
				ON A.sid = C.id
			INNER JOIN productcategories D
				ON A.pid = D.id
			WHERE
				( 
					A.productDescription LIKE searchPattern OR
					A.productWeight LIKE searchPattern OR
					B.masterCategoryName LIKE searchPattern OR
					B.masterCategoryDescription LIKE searchPattern OR
					C.subCategoryName LIKE searchPattern OR
					C.subCategoryDescription LIKE searchPattern OR
					D.productCategoryName LIKE searchPattern OR
					D.productCategoryDescription LIKE searchPattern
				) AND
			 	A.isSold = 0 AND
				A.deletedAt IS NULL
			LIMIT itemsPerPage OFFSET startIndex;
		END;
        
	ELSE 
		BEGIN
    		SELECT 
				COUNT(A.id) AS 'totalRecords' 
			FROM products A
			INNER JOIN mastercategories B
				ON A.mid = B.id
			INNER JOIN subcategories C
				ON A.sid = C.id
			INNER JOIN productcategories D
				ON A.pid = D.id			
			WHERE 
				( 
					A.productDescription LIKE searchPattern OR
					A.productWeight LIKE searchPattern OR
					B.masterCategoryName LIKE searchPattern OR
					B.masterCategoryDescription LIKE searchPattern OR
					C.subCategoryName LIKE searchPattern OR
					C.subCategoryDescription LIKE searchPattern OR
					D.productCategoryName LIKE searchPattern OR
					D.productCategoryDescription LIKE searchPattern
				) AND
			 	A.deletedAt IS NULL;

			SELECT 
				A.id,
				A.productDescription,
				A.productGuid,
				A.productWeight,
				B.masterCategoryName as 'masterCategory',
				C.subCategoryName as 'subCategory',
				D.productCategoryName as 'productCategory',
				A.imagePath,
				A.createdAt,
				A.isSold
			FROM products A
			INNER JOIN mastercategories B
				ON A.mid = B.id
			INNER JOIN subcategories C
				ON A.sid = C.id
			INNER JOIN productcategories D
				ON A.pid = D.id
			WHERE
				( 
					A.productDescription LIKE searchPattern OR
					A.productWeight LIKE searchPattern OR
					B.masterCategoryName LIKE searchPattern OR
					B.masterCategoryDescription LIKE searchPattern OR
					C.subCategoryName LIKE searchPattern OR
					C.subCategoryDescription LIKE searchPattern OR
					D.productCategoryName LIKE searchPattern OR
					D.productCategoryDescription LIKE searchPattern
				) AND
				A.deletedAt IS NULL
			LIMIT itemsPerPage OFFSET startIndex;
        END;
        
	END IF;

END$$

DELIMITER ;
;

