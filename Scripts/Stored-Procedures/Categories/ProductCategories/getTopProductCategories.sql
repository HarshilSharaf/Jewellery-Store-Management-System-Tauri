DROP procedure IF EXISTS `get_top_product_categories`;
DELIMITER $$
CREATE PROCEDURE `get_top_product_categories`(
IN p_numberOfCategories INT
)
BEGIN
 SELECT 
        B.productCategoryName, 
        SUM(A.productWeight) as total_weight,
        ROUND(SUM(A.productWeight) * 100 / (SELECT SUM(P.productWeight) FROM products P	WHERE P.isSold = 1
    AND P.deletedAt IS NULL), 2) as percentage
    FROM 
        products A
        INNER JOIN productcategories B ON A.pid = B.id
	WHERE A.isSold = 1
    AND A.deletedAt IS NULL
    GROUP BY 
        A.pid
    ORDER BY 
        total_weight DESC 
    LIMIT p_numberOfCategories;
END$$

DELIMITER ;
;

