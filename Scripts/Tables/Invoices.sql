CREATE TABLE `invoices` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `invoiceGuid` CHAR(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `totalAmountWithGst` DOUBLE NOT NULL,
  `totalAmountWithoutGstAndDiscount` DOUBLE NOT NULL,
  `totalDiscount` DOUBLE NOT NULL,
  `totalLabour` DOUBLE NOT NULL,
  `totalGst` DOUBLE NOT NULL,
  `isPaymentDone` TINYINT(1) NOT NULL DEFAULT '0',
  `remarks` TEXT,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `cancelledAt` DATETIME NULL DEFAULT NULL,
  `soldToCustomer` INT NOT NULL,
  PRIMARY KEY (`id`),
  KEY `soldToCustomer` (`soldToCustomer`),
  CONSTRAINT `fk_invoices_soldToCustomer` FOREIGN KEY (`soldToCustomer`) REFERENCES `customers` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
