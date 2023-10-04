DROP procedure IF EXISTS `cancel_order`;
DELIMITER $$
CREATE PROCEDURE `cancel_order` (
IN p_orderGuid CHAR(36)
)
BEGIN
	
    DECLARE l_invoiceId INT DEFAULT NULL;

    DECLARE error_code INT DEFAULT 0;
    DECLARE error_msg VARCHAR(255) DEFAULT '';
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		GET STACKED DIAGNOSTICS CONDITION 1 error_code = MYSQL_ERRNO, error_msg = MESSAGE_TEXT;
		SELECT CONCAT('Error: ', error_code, ', ', error_msg) AS message;
	END;
	
    SET time_zone = 'SYSTEM';
	SET l_invoiceId = (SELECT id from invoices where invoiceGuid = p_orderGuid);
    
    IF(l_invoiceId IS NOT NULL) THEN
		START TRANSACTION;
        
			UPDATE products
			SET isSold = 0
			WHERE id in (SELECT ProductId FROM invoice_products_mappings WHERE invoiceId = l_invoiceId);
            
            DELETE FROM invoice_products_mappings
            WHERE invoiceId = l_invoiceId;
            
            UPDATE invoices
            SET cancelledAt = CURRENT_TIMESTAMP()
            WHERE id = l_invoiceId;
		COMMIT;
	END IF;
END$$

DELIMITER ;

