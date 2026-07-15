#Basic query

CREATE DATABASE Procurement_Analytics;
USE Procurement_Analytics;
SHOW TABLES;
SELECT COUNT(*) FROM Fact_Orders;
SELECT * FROM Fact_Orders LIMIT 10;
SELECT SUM(Sales) AS Total_Purchase_Spend FROM Fact_Orders;
SELECT COUNT(DISTINCT `Order Id`) AS Total_Orders FROM Fact_Orders;
SELECT SUM(`Order Item Quantity`) AS Total_Quantity FROM Fact_Orders;

#Business SQL Queries

SELECT Market, ROUND(SUM(Sales), 2) AS Total_Purchase_Spend FROM Fact_Orders GROUP BY Market ORDER BY Total_Purchase_Spend DESC;
SELECT `Category Name`, ROUND(SUM(Sales),2) AS Purchase_Spend FROM Fact_Orders GROUP BY `Category Name` ORDER BY Purchase_Spend DESC LIMIT 10;
SELECT `Shipping Mode`, COUNT(DISTINCT `Order Id`) AS Total_Orders FROM Fact_Orders GROUP BY `Shipping Mode` ORDER BY Total_Orders DESC;
SELECT `Delivery Status`, COUNT(*) AS Total_Orders FROM Fact_Orders GROUP BY `Delivery Status` ORDER BY Total_Orders DESC;
SELECT ROUND(AVG(`Days for shipping (real)` - `Days for shipment (scheduled)`),2) AS Avg_Delivery_Delay FROM Fact_Orders;
SELECT ROUND(SUM(CASE WHEN `Delivery Status` = 'Shipping on time' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS On_Time_Delivery_Percentage FROM Fact_Orders;
SELECT DATE_FORMAT(`order date (DateOrders)`, '%Y-%m') AS Month, ROUND(SUM(Sales),2) AS Purchase_Spend FROM Fact_Orders GROUP BY Month ORDER BY Month;

#SQL Filtering & Advanced Business Analysis

SELECT * FROM Fact_Orders WHERE Market = 'Europe';
SELECT * FROM Fact_Orders WHERE Market = 'Europe' AND `Shipping Mode` = 'Standard Class';
SELECT * FROM Fact_Orders WHERE Market = 'Europe' OR Market = 'LATAM';
SELECT * FROM Fact_Orders WHERE Market IN ('Europe','LATAM','Pacific Asia');
SELECT * FROM Fact_Orders WHERE Sales > 1000;
SELECT * FROM Fact_Orders WHERE Sales BETWEEN 500 AND 1000; 
SELECT DISTINCT `Category Name` FROM Fact_Orders WHERE `Category Name` LIKE '%Golf%';
SELECT Market, ROUND(SUM(Sales),2) AS Total_Sales FROM Fact_Orders GROUP BY Market HAVING SUM(Sales) > 5000000 ORDER BY Total_Sales DESC;
SELECT `Order Country`, ROUND(SUM(Sales),2) AS Total_Sales FROM Fact_Orders GROUP BY `Order Country` ORDER BY Total_Sales DESC LIMIT 5;
SELECT `Shipping Mode`, COUNT(*) AS Orders FROM Fact_Orders GROUP BY `Shipping Mode` ORDER BY Orders DESC;
SELECT * FROM Fact_Orders WHERE `Delivery Status`='Late delivery';
SELECT `Category Name`, ROUND(AVG(`Order Profit Per Order`),2) AS Avg_Profit FROM Fact_Orders GROUP BY `Category Name` ORDER BY Avg_Profit DESC;
SELECT `Category Name`, ROUND(SUM(Sales),2) AS Total_Sales FROM Fact_Orders WHERE Market='Europe' AND Sales>500 GROUP BY `Category Name` ORDER BY Total_Sales DESC LIMIT 10;

#Advanced SQL

CREATE VIEW vw_market_sales AS SELECT Market, ROUND(SUM(Sales),2) AS Total_Sales FROM Fact_Orders GROUP BY Market;
SELECT * FROM vw_market_sales;
SELECT Market, ROUND(SUM(Sales),2) AS Total_Sales, RANK() OVER(ORDER BY SUM(Sales) DESC) AS Market_Rank FROM Fact_Orders GROUP BY Market;
SELECT * FROM (SELECT `Category Name`, SUM(Sales) AS Total_Sales, RANK() OVER(ORDER BY SUM(Sales) DESC) AS Category_Rank FROM Fact_Orders GROUP BY `Category Name`) A WHERE Category_Rank<=5;
SELECT AVG(Sales) FROM Fact_Orders;
SELECT * FROM Fact_Orders WHERE Sales > (SELECT AVG(Sales) FROM Fact_Orders);
WITH MarketSales AS (SELECT Market, SUM(Sales) AS TotalSales FROM Fact_Orders GROUP BY Market) SELECT * FROM MarketSales ORDER BY TotalSales DESC;
SELECT `Category Name`, ROUND(AVG(`Order Profit Per Order`), 2) AS AvgProfit FROM Fact_Orders GROUP BY `Category Name` ORDER BY AvgProfit DESC;
SELECT SUM(Sales) AS PurchaseSpend, COUNT(DISTINCT `Order Id`) AS Orders, SUM(`Order Item Quantity`) AS Quantity, ROUND(AVG(`Days for shipping (real)`- `Days for shipment (scheduled)`),2) AS AvgDelay FROM Fact_Orders;