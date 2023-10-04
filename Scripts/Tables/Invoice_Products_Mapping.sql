CREATE TABLE `invoice_products_mappings` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `sgst` DOUBLE NOT NULL,
  `cgst` DOUBLE NOT NULL,
  `discount` DOUBLE NOT NULL,
  `labour` DOUBLE NOT NULL,
  `price` DOUBLE NOT NULL,
  `finalAmount` DOUBLE NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `invoiceId` INT DEFAULT NULL,
  `ProductId` INT DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_invoice_products_mappings_invoiceId_ProductId` (`invoiceId`,`ProductId`),
  KEY `fk_invoice_products_mappings_invoiceId_idx` (`invoiceId`),
  CONSTRAINT `fk_invoice_products_mappings_invoiceId` FOREIGN KEY (`invoiceId`) REFERENCES `invoices` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_invoice_products_mappings_ProductId` FOREIGN KEY (`ProductId`) REFERENCES `products` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
