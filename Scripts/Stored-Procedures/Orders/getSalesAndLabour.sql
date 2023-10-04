DROP procedure IF EXISTS `get_sales_labour`;
DELIMITER $$
CREATE PROCEDURE `get_sales_labour`(
    IN p_timeInterval INT
)
BEGIN
    DECLARE cutoffDate DATE;
    DECLARE monthYearFormat CHAR(7) DEFAULT '%Y-%m';
    
    -- Calculate the cutoff date based on the input parameter
    SET cutoffDate = DATE_SUB(NOW(), INTERVAL p_timeInterval MONTH);
    
    SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'month_year', month_year,
                'sales', sales,
                'labour', labour
            )
        ) as "monthlySalesAndLabour"
    FROM (
        -- Retrieve the sales and labour data for the specified time interval
        SELECT DATE_FORMAT(createdAt, monthYearFormat) AS month_year,
               SUM(totalAmountWithGst) AS sales,
               SUM(totalLabour) AS labour
        FROM invoices
        WHERE createdAt >= cutoffDate
        GROUP BY DATE_FORMAT(createdAt, monthYearFormat)
        HAVING SUM(totalAmountWithGst) > 0 AND SUM(totalLabour) > 0
        ORDER BY month_year
        -- Limit the number of rows returned by the query, if desired
        -- LIMIT 100
    ) AS sales_labour;
    
END$$

DELIMITER ;
;

