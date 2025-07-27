drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
Category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountpercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightINgms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

--data exploration
--counting no of rows
SELECT COUNT(*)FROM zepto;
--sample data
SELECT * FROM zepto
LIMIT 10;
--LOOK FOR NULL VALUES
SELECT * FROM zepto
WHERE name IS NULL
OR
Category IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfSTOCK IS NULL
OR
quantity IS NULL;

--diffrent product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- products in stock and out of stock
SELECT outOfStock,COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

--product name present multiple times
SELECT name,COUNT(sku_id) as "number of SKUs"
FROM zepto
GROUP BY NAME
HAVING count(sku_id)>1
ORDER BY COUNT(sku_id) DESC;

--data cleaning

--products with price = 0
SELECT*FROM zepto 
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp=0;

--convert paise to rps
UPDATE zepto
SET mrp=mrp/100.0,
discountedSellingPrice=discountedSellingPrice/100.0;

SELECT mrp,discountedSellingPrice FROM zepto

-- 1)top 10 best value products based on discount percetage 
SELECT DISTINCT name,mrp,discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

--2) What are the products with high mrp but out of stock
SELECT DISTINCT NAME,mrp 
FROM zepto
WHERE outOfStock=TRUE and mrp>300
ORDER BY mrp DESC;

--3)Calculated estimated revenue for each category
SELECT category,
SUM(discountedSellingPrice*availableQuantity)AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--4)Find all products where mrp is greater than 500 and discount is less than 10%
SELECT DISTINCT name,mrp,discountPercent
FROM zepto
WHERE mrp>500 AND discountPercent<10
ORDER BY mrp DESC,discountPercent DESC;

--5)Identify the top 5 categories offering the highest average dicount percent
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--6)Find the price per gms for the product above 100g and sort by best value
SELECT DISTINCT name,weightINgms,discountedSellingPrice,
ROUND(discountedSellingPrice/weightINgms,2) AS price_per_gms
FROM zepto
WHERE weightINgms>=100
ORDER BY price_per_gms;

--7)Group the products in categories like low,medium,bulk.
SELECT DISTINCT name,weightINgms,
CASE WHEN weightINgms<1000 THEN 'Low'
 WHEN weightINgms<5000 THEN 'Medium'
 ELSE 'Bulk'
 END AS weigth_category
FROM zepto; 

--8)what is the total inventory weight per category
SELECT category,
SUM(weightINgms*availableQuantity)AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;