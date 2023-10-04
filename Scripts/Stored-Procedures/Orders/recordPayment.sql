DROP procedure IF EXISTS `record_payment`;
DELIMITER $$
CREATE PROCEDURE `record_payment`(
IN p_orderGuid CHAR(36),
IN p_paymentType VARCHAR(6),
IN p_remarks TEXT,
IN p_paymentAmount DOUBLE,
IN p_receivedOn DATE
)
BEGIN
    DECLARE l_invoiceId INT DEFAULT NULL;
	DECLARE l_totalBillAmount DOUBLE DEFAULT 0;
	DECLARE l_totalPaymentRecieved DOUBLE DEFAULT 0;
	DECLARE l_paymentGuid CHAR(36) DEFAULT NULL;

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
     SET l_paymentGuid = UUID();
     
	 IF(l_invoiceId IS NOT NULL) THEN
		START TRANSACTION;
			SET l_totalBillAmount = (SELECT totalAmountWithGst FROM invoices WHERE id = l_invoiceId);
            
            INSERT INTO payments
            (
				paymentGuid,
                amount,
                paymentType,
                remarks,
                receivedOn,
                invoiceId
            )
            VALUES
            (
				l_paymentGuid,
                p_paymentAmount,
                p_paymentType,
                p_remarks,
                p_receivedOn,
                l_invoiceId
            );
            
            IF( (SELECT SUM(amount) FROM payments WHERE invoiceId = l_invoiceId) >= l_totalBillAmount) THEN
				UPDATE invoices
                SET isPaymentDone = 1
                WHERE id = l_invoiceId;
            END IF;
            
		COMMIT;
	END IF;
     

END$$

DELIMITER ;
;

