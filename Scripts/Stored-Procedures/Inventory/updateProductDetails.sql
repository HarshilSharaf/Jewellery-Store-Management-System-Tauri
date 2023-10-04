DROP procedure IF EXISTS `update_product_details`;
DELIMITER $$
CREATE PROCEDURE `update_product_details` (
IN p_productGuid CHAR(36),
IN p_productDescription TEXT,
IN p_productWeight DOUBLE,
IN p_mid INT,
IN p_sid INT,
IN p_pid INT
)
BEGIN
	UPDATE products
    SET
		productDescription = p_productDescription,
        productWeight      = p_productWeight,
        mid				   = p_mid,
        sid				   = p_sid,
        pid				   = p_pid
	WHERE productGuid = p_productGuid;
END$$

DELIMITER ;

