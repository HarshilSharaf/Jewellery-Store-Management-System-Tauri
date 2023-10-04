DROP procedure IF EXISTS `get_all_orders`;
DELIMITER $$
CREATE PROCEDURE `get_all_orders`(
itemsPerPage INT,
pageNumber INT,
searchQuery VARCHAR(255)
)
BEGIN

DECLARE startIndex INT;
DECLARE searchPattern VARCHAR(255);

SET searchPattern = CONCAT('%', searchQuery, '%');
SET startIndex = (pageNumber - 1) * itemsPerPage;

SELECT 
  COUNT(A.id) AS 'totalRecords' 
FROM invoices A 
INNER JOIN customers B
  ON A.soldToCustomer = B.id
WHERE 
  B.firstName LIKE searchPattern OR
  B.lastName LIKE searchPattern OR
  A.totalAmountWithGst LIKE searchPattern;

SELECT 
  distinct A.*, 
  (
    SELECT 
      json_arrayagg(
        json_object(
          'sgst', ipm.sgst,
          'cgst', ipm.cgst, 
          'discount', ipm.discount,
          'labour', ipm.labour,
          'price', ipm.price,
          'finalAmount', ipm.finalAmount,
          'productId', p.id, 
          'productGuid', p.productGuid,
          'productWeight', p.productWeight,
          'masterCategory', m.masterCategoryName,
          'subCategory', s.subCategoryName,
          'productCategory', pc.productCategoryName
        )
      ) 
    FROM 
      invoice_products_mappings ipm 
      inner join products p on ipm.ProductId = p.id 
      inner join masterCategories m on p.mid = m.id 
      inner join subcategories s on p.sid = s.id 
      inner join productcategories pc on p.pid = pc.id 
    where 
      ipm.invoiceId = A.id
  ) AS invoice_products, 
  (
    SELECT 
      json_object(
        'customerId', cu.id,
        'customerGuid', cu.customerGuid,
        'firstName', cu.firstName, 
        'lastName', cu.lastName,
        'gender', cu.gender
      ) 
    FROM 
      customers cu 
    WHERE 
      cu.id = A.soldToCustomer
  ) as 'customer_details', 
  (
    SELECT 
      JSON_ARRAYAGG(
        JSON_OBJECT(
          'paymentAmount', p.amount,
          'paymentType', p.paymentType,
          'remarks', p.remarks, 
          'receivedOn', p.receivedOn
        )
      ) 
    FROM 
      payments p 
    WHERE 
      p.invoiceId = A.id
  ) as 'payments' 
FROM 
  invoices A
INNER JOIN customers B
  ON A.soldToCustomer = B.id
WHERE
  A.totalAmountWithGst LIKE searchPattern OR
  B.firstName LIKE searchPattern OR
  B.lastName LIKE searchPattern
  LIMIT itemsPerPage OFFSET startIndex;

END$$

DELIMITER ;
;
