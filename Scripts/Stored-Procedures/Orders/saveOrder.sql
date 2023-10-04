DROP procedure IF EXISTS `save_order`;
DELIMITER $$
CREATE PROCEDURE `save_order`(
IN p_totalAmountWithGst DOUBLE,
IN p_totalAmountWithoutGstAndDiscount DOUBLE,
IN p_totalDiscount DOUBLE,
IN p_totalLabour DOUBLE,
IN p_totalGst DOUBLE,
IN p_remarks TEXT,
IN p_soldToCustomer INT,
IN p_amountPaid DOUBLE,
IN p_paymentMethod VARCHAR(6),
IN p_productsData JSON
)
BEGIN
	DECLARE l_invoiceGuid CHAR(36);
    DECLARE l_paymentGuid CHAR(36);
	DECLARE i INT DEFAULT 0;
	DECLARE arr_length INT DEFAULT JSON_LENGTH(p_productsData);
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
    SET l_invoiceGuid = UUID();
    SET l_paymentGuid = UUID();
    
	START TRANSACTION;
		
        INSERT INTO INVOICES 
			(
				invoiceGuid,
				totalAmountWithGst,
                totalAmountWithoutGstAndDiscount,
                totalDiscount,
                totalLabour,
                totalGst,
                isPaymentDone,
                remarks,
                soldToCustomer
			)
		VALUES 
			(
				l_invoiceGuid,
                p_totalAmountWithGst,
                p_totalAmountWithoutGstAndDiscount,
                p_totalDiscount,
                p_totalLabour,
                p_totalGst,
                (
					CASE 
						WHEN p_amountPaid >= p_totalAmountWithGst THEN 1
						ELSE 0
					END
                ),
                p_remarks,
                p_soldToCustomer
            );
            
        SET l_invoiceId = LAST_INSERT_ID();
        
		INSERT INTO payments 
			(
				paymentGuid,
				invoiceId,
                amount,
                paymentType,
                remarks
            )
		VALUES 
			(
				l_paymentGuid,
				l_invoiceId,
                p_amountPaid,
                p_paymentMethod,
                'Paid while giving order'
            );
		
		WHILE i < arr_length DO
			
			INSERT INTO invoice_products_mappings
			(
				price,
                finalAmount,
                labour,
                sgst,
                cgst,
                discount,
                invoiceId,
                ProductId
			)
            VALUES
            (
				JSON_EXTRACT(p_productsData, CONCAT('$[', i, '].price')),
                JSON_EXTRACT(p_productsData, CONCAT('$[', i, '].finalAmount')),
                JSON_EXTRACT(p_productsData, CONCAT('$[', i, '].labour')),
                JSON_EXTRACT(p_productsData, CONCAT('$[', i, '].SGST')),
                JSON_EXTRACT(p_productsData, CONCAT('$[', i, '].CGST')),
                JSON_EXTRACT(p_productsData, CONCAT('$[', i, '].discount')),
                l_invoiceId,
                JSON_EXTRACT(p_productsData, CONCAT('$[', i, '].id'))
            );

			UPDATE products
            SET isSold = 1 
            WHERE id = JSON_EXTRACT(p_productsData, CONCAT('$[', i, '].id'));

			SET i = i + 1;
		END WHILE;		
        
	COMMIT;


END$$

DELIMITER ;
;

