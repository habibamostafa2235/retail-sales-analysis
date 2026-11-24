SELECT * FROM Stores;
SELECT * FROM dbo.Calendar;
SELECT * FROM dbo.Customers;
SELECT * FROM Products;
SELECT * FROM [Sales 2017];
SELECT * FROM [Sales 2018];
SELECT * FROM Region;
SELECT * FROM Returns;

	CREATE VIEW Sales AS
	SELECT* FROM dbo.[Sales 2017]
	UNION ALL
	SELECT* FROM dbo.[Sales 2018]


	SELECT 
	*
	FROM
	Sales;

	-- KPI --
	CREATE VIEW KPI AS
	SELECT 
	SUM(S.quantity * PP.product_retail_price) AS "Total Revenue",
	SUM((PP.product_retail_price - PP.product_cost) * S.quantity) AS "Profit",
	SUM(S.quantity) AS "Total Quantity",
		COUNT(DISTINCT C.customer_id) AS "TotalCustomer"
	FROM
	Sales S
	JOIN 
		Products PP
		on S.product_id = PP.product_id
		JOIN 
	Customers C
		ON S.customer_id = C.customer_id;

		SELECT * FROM KPI;

	-- Which country generates the highest total revenue?
	CREATE VIEW RevenueByCountry AS
	SELECT 
	C.customer_country,
	SUM(S.quantity * PP.product_retail_price) AS "Total Revenue"
	FROM
	Sales S
	JOIN 
	Customers C
		ON S.customer_id = C.customer_id
		JOIN
		Products PP
		ON S.product_id = PP.product_id
	GROUP BY C.customer_country;

	SELECT * FROM RevenueByCountry;

	-- Which product generates the highest revenue?
	CREATE VIEW RevenueByProduct AS
	SELECT 
	P.product_brand,
	SUM(S.quantity * P.product_retail_price) AS "Total Revenue"
	FROM
	Sales S
	JOIN 
		Products P
		ON S.product_id = P.product_id
		GROUP BY P.product_brand;

		SELECT * FROM RevenueByProduct ORDER BY "Total Revenue" DESC;


	-- What are the top 5 best-selling products Brand?
	CREATE VIEW top5_ProductSelling AS
	SELECT 
	TOP 5
	P.product_name,
	SUM(S.quantity * P.product_retail_price) AS "Total Revenue"
	FROM
	Sales S
	JOIN 
		Products P
		ON S.product_id = P.product_id
		GROUP BY P.product_name;

		SELECT * FROM top5_ProductSelling ORDER BY "Total Revenue" DESC;

	-- Which country sold the largest quantity?
	CREATE VIEW CountryBySold AS
	SELECT 
	C.customer_country,
	SUM(S.quantity) AS "Total Units Sold"
	FROM Sales S
	JOIN Customers C 
	ON 
		S.customer_id = C.customer_id
	GROUP BY C.customer_country;

	SELECT * FROM CountryBySold;

	-- How many customers do we have per country?
	CREATE VIEW CountCustomerByCountry AS 
	SELECT 
	C.customer_country,
	COUNT(DISTINCT C.customer_id) AS "TotalCustomers"
	FROM
	Sales S
	JOIN 
	Customers C
		ON S.customer_id = C.customer_id
	GROUP BY C.customer_country;

	SELECT * FROM CountCustomerByCountry;

	--Which membership category generates the highest revenue?
	CREATE VIEW MemberByRevenue AS
	SELECT 
	C.member_card,
		SUM(S.quantity * P.product_retail_price) AS "Total Revenue"
	FROM
	Sales S
	JOIN 
		Products P
		on S.product_id = P.product_id
		JOIN 
	Customers C
		ON S.customer_id = C.customer_id
		GROUP BY C.member_card;

		SELECT * FROM MemberByRevenue;

	-- Which member buys the most products?
	CREATE VIEW MemberBySold AS
	SELECT 
	C.member_card,
	SUM(S.quantity) AS "Total Units Sold"
	FROM Sales S
	JOIN Customers C
	ON S.customer_id = C.customer_id
	GROUP BY C.member_card;

	SELECT * FROM MemberBySold;

	-- Which product has the highest number of returns?
	CREATE VIEW Prouduct_Return AS
	SELECT
	TOP 5
	P.product_name,
	COUNT(R.product_id) AS "Total Returns"
	FROM 
	Returns R
	JOIN
	Products P ON R.product_id = P.product_id
	GROUP BY P.product_name;

	SELECT * FROM  Prouduct_Return ORDER BY [Total Returns] DESC;

	-- Which product brand has the highest return rate?
	CREATE VIEW Pouduct_BrandName AS 
	SELECT
	TOP 5
	P.product_brand,
	COUNT(R.product_id) AS "Total Returns"
	FROM 
	Returns R
	JOIN
	Products P ON R.product_id = P.product_id
	GROUP BY P.product_brand;

	SELECT * FROM Pouduct_BrandName ORDER BY [Total Returns] DESC;


-- Which region generates the highest total revenue?
CREATE VIEW RegionByRevenue AS
	SELECT 
    R.sales_region,
    SUM(S.quantity * P.product_retail_price) AS "Total Revenue"
FROM 
	Sales S
JOIN 
	Stores ST ON S.store_id = ST.store_id
JOIN 
	Region R ON ST.region_id = R.region_id
JOIN 
	Products P ON S.product_id = P.product_id
GROUP BY R.sales_region;

SELECT * FROM RegionByRevenue;


-- Which sales district has the most customers?
CREATE VIEW CustomersByDistrict AS
SELECT 
    R.sales_region,
    COUNT(DISTINCT C.customer_id) AS "Total Customers"
FROM 
	Sales S
JOIN 
	Customers C 
	ON 
	S.customer_id = C.customer_id
JOIN 
Stores ST 
ON 
S.store_id = ST.store_id
JOIN 
Region R 
ON 
ST.region_id = R.region_id
GROUP BY R.sales_region;

SELECT * FROM CustomersByDistrict ORDER BY [Total Customers] DESC;


-- Which store type generates the highest revenue?
CREATE VIEW RevenueByStore AS
	SELECT 
    ST.store_type,
    SUM(S.quantity * P.product_retail_price) AS "Total Revenue"
FROM 
	Sales S
JOIN 
	Stores ST ON S.store_id = ST.store_id
JOIN 
	Products P ON S.product_id = P.product_id
GROUP BY ST.store_type;

SELECT * FROM RevenueByStore;

