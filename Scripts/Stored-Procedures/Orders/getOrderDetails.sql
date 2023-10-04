DROP procedure IF EXISTS `get_order_details`;
DELIMITER $$
CREATE PROCEDURE `get_order_details`(
  IN orderGuid char(36)
)
BEGIN 
SELECT 
    A.id,
    A.invoiceGuid,
    A.createdAt as 'orderDate',
    A.isPaymentDone,
    A.remarks,
    A.totalAmountWithGst,
    A.totalAmountWithoutGstAndDiscount,
    A.totalDiscount,
    A.totalGst,
    A.totalLabour,
    A.updatedAt,
  (
    SELECT 
      json_arrayagg(
        json_object(
          'SGST', ipm.sgst,
          'CGST', ipm.cgst, 
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
        'imagePath', cu.imagePath,
        'firstName', cu.firstName, 
        'lastName', cu.lastName,
        'gender', cu.gender,
        'city', cu.city
      ) 
    FROM 
      customers cu 
    WHERE 
      cu.id = A.soldToCustomer
  ) as customer_details, 
  (
    SELECT 
      JSON_ARRAYAGG(
        JSON_OBJECT(
          'amount', p.amount,
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
where 
  A.invoiceGuid = orderGuid 
  and A.cancelledAt IS NULL;
END$$ 
DELIMITER ;
