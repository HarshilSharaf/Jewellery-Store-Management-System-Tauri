DROP procedure IF EXISTS `get_recent_orders`;
DELIMITER $$
CREATE PROCEDURE `get_recent_orders`(
IN p_numberOfOrders INT
)
BEGIN

	SELECT 
	distinct A.*, 
	(
		SELECT 
			COUNT(*)
		FROM 
		invoice_products_mappings ipm 
		WHERE 
		ipm.invoiceId = A.id
	) AS total_products, 
	(
		SELECT 
		json_object(
			'customerId', cu.id,
			'firstName', cu.firstName, 
			'lastName', cu.lastName,
			'gender', cu.gender
		) 
		FROM 
		customers cu 
		WHERE 
		cu.id = A.soldToCustomer
	) as 'customer_details'
	FROM 
	invoices A
	WHERE A.cancelledAt IS NULL
	ORDER BY A.createdAt DESC
	LIMIT p_numberOfOrders;
	


END$$

DELIMITER ;
;

