CREATE TABLE `payments` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `paymentGuid` CHAR(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `amount` DOUBLE NOT NULL,
  `paymentType` ENUM('cash', 'cheque', 'online') NOT NULL,
  `remarks` TEXT,
  `receivedOn` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `invoiceId` INT NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_receivedOn` (`receivedOn`),
  KEY `fk_payments_invoices` (`invoiceId`),
  CONSTRAINT `fk_payments_invoices` FOREIGN KEY (`invoiceId`) REFERENCES `invoices` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
