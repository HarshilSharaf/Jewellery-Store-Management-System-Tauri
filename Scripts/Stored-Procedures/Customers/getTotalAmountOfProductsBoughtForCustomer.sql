DROP procedure IF EXISTS `get_total_amount_of_products_bought_for_customer`;
DELIMITER $$
CREATE PROCEDURE `get_total_amount_of_products_bought_for_customer`(
IN p_customerGuid CHAR(36)
)
BEGIN

	SELECT
		SUM(totalAmountWithGst) as 'totalAmount'
	FROM invoices
    WHERE soldToCustomer = (SELECT id FROM customers WHERE customerGuid = p_customerGuid)
    AND cancelledAt IS NULL;
		
END$$

DELIMITER ;
;

