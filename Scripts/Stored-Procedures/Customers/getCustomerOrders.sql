DROP procedure IF EXISTS `get_customer_orders`;
DELIMITER $$
CREATE PROCEDURE `get_customer_orders`(
IN p_getCancelledOrders TINYINT(1),
IN p_customerGuid char(36),
IN itemsPerPage INT,
IN pageNumber INT,
IN searchQuery VARCHAR(255)
)
BEGIN
DECLARE startIndex INT;
DECLARE l_customerID INT;
DECLARE searchPattern VARCHAR(255);

SET searchPattern = CONCAT('%', searchQuery, '%');
SET startIndex = (pageNumber - 1) * itemsPerPage;
SET l_customerID = (SELECT id FROM customers WHERE customerGuid = p_customerGuid);

    IF(p_getCancelledOrders = 1) 
		THEN
			BEGIN
                SELECT 
                    COUNT(A.id) AS 'totalRecords' 
                FROM invoices A
                WHERE 
                    ( A.totalAmountWithGst LIKE searchPattern OR
                    A.remarks LIKE searchPattern ) AND
                    A.soldToCustomer = l_customerID; 

				SELECT 
					A.id as 'orderId',
                    A.invoiceGuid,
					COUNT(B.ProductId) as 'numberOfProducts',
                    A.totalAmountWithGst,
                    A.createdAt as 'orderDate',
                    A.remarks,
                    A.cancelledAt,
                    A.isPaymentDone as 'paymentStatus'
                FROM invoices A
                -- left join is implemented as while cancelling any order the entries from
                -- invoice_products_mappings will be hard deleted
                LEFT JOIN invoice_products_mappings B
					ON A.id = B.InvoiceId
                INNER JOIN customers C
					ON C.Id = A.soldToCustomer
                WHERE C.customerGuid = p_customerGuid
                GROUP BY A.id
                HAVING 
                    A.totalAmountWithGst LIKE searchPattern OR
                    A.remarks LIKE searchPattern
                LIMIT itemsPerPage OFFSET startIndex;

            END;
        ELSE
			BEGIN

                SELECT 
                    COUNT(A.id) AS 'totalRecords' 
                FROM invoices A 
                WHERE 
                    ( A.totalAmountWithGst LIKE searchPattern OR
                    A.remarks LIKE searchPattern ) AND
                    A.soldToCustomer = l_customerID AND
				    A.cancelledAt IS NULL; 

				SELECT 
					A.id as 'orderId',
					COUNT(B.ProductId) as 'numberOfProducts',
                    A.totalAmountWithGst,
                    A.createdAt as 'orderDate',
                    A.remarks,
                    A.cancelledAt,
                    A.isPaymentDone as 'paymentStatus'
                FROM invoices A
                INNER JOIN invoice_products_mappings B
					ON A.id = B.InvoiceId
                INNER JOIN customers C
					ON C.Id = A.soldToCustomer
                WHERE C.customerGuid = p_customerGuid 
                AND A.cancelledAt IS NULL
                GROUP BY A.id
                HAVING 
                    A.totalAmountWithGst LIKE searchPattern OR
                    A.remarks LIKE searchPattern
                LIMIT itemsPerPage OFFSET startIndex;
            END;
	END IF;

END$$

DELIMITER ;
;

