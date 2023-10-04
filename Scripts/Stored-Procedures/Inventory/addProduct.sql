DROP procedure IF EXISTS `add_product`;
DELIMITER $$
CREATE PROCEDURE `add_product`(
IN p_productWeight DOUBLE,
IN p_productDescription TEXT,
IN p_productCategoryId INT,
IN p_subCategoryId INT,
IN p_masterCategoryId INT,
IN p_imageFileName TEXT
)
BEGIN
DECLARE l_imageFileName TEXT DEFAULT NULL;
DECLARE fileExtension VARCHAR(6) DEFAULT NULL;
DECLARE l_productGuid CHAR(36);

SET l_productGuid = UUID();
SET time_zone = 'SYSTEM';

IF(p_imageFileName IS NOT NULL) THEN
	BEGIN
	SET fileExtension = (SELECT substring_index(p_imageFileName,'.',-1));
    SET l_imageFileName = CONCAT(UNIX_TIMESTAMP(), '-product-', l_productGuid, '.', fileExtension);
    END;
END IF;

INSERT INTO products
(
	productGuid,
	productWeight,
	productDescription,
	imagePath,
	isSold,
	mid,
	sid,
	pid
)
VALUES 
(
	l_productGuid,
    p_productWeight,
    p_productDescription,
    l_imageFileName,
    0,
    p_masterCategoryId,
    p_subCategoryId,
    p_productCategoryId
);

SELECT * FROM products WHERE id = LAST_INSERT_ID();

END$$

DELIMITER ;
;

