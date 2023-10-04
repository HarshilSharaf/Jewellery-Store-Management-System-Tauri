CREATE TABLE `productcategories` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `productCategoryName` VARCHAR(255) NOT NULL,
  `productCategoryDescription` TEXT,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_productCategoryName` (`productCategoryName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
