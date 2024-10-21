--SQL Retail Sales Analysis -P1
Create DATABASE sql_project_p1;

--Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id	INT,
	gender VARCHAR(15),
	age	INT,
	category VARCHAR(15),
	quantiy	INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT

);


select * from retail_sales LIMIT 10;
SELECT COUNT(*) FROM retail_sales;

--Data Cleaning
select * from retail_sales 
WHERE 
	transactions_id is null 
	or sale_date is null
	or sale_time is null
	or customer_id is null
	or gender is null
	or age is null
	or category is null
	or quantiy is null
	or price_per_unit is null
	or cogs is null 
	or total_sale is null


Delete from retail_sales 
WHERE 
	transactions_id is null 
	or sale_date is null
	or sale_time is null
	or customer_id is null
	or gender is null
	or age is null
	or category is null
	or quantiy is null
	or price_per_unit is null
	or cogs is null 
	or total_sale is null

--Data Exploration

--How many sales ?
select count(*) as total_sale from retail_sales;
-- How many unique Customer?
select count(distinct(customer_id)) as Total_Customer from retail_sales;
--How many unique Category?
select count(distinct(category)) as Total_Customer from retail_sales;


--Data Analysis and Business Key problems

--1.query to retrieve all columns for sales made on '2022-11-05:
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

--2.query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select * from retail_sales
where category='Clothing' 
and quantiy >= 4 and TO_CHAR(sale_date,'YYYY-MM')='2022-11' ;

--3.query to calculate the total sales (total_sale) for each category.:
select category, sum(total_sale) as net_sale ,count(*) as total_order from retail_sales GROUP BY CATEGORY;

--4.query to find the average age of customers who purchased items from the 'Beauty' category.:
select Round(AVG(age),2) as Average_age from retail_sales
where category='Beauty'

--5.query to find all transactions where the total_sale is greater than 1000.:
SELECT * FROM retail_sales
WHERE total_sale > 1000

--6.query to find the total number of transactions (transaction_id) made by each gender in each category.:
select gender,category, count(transactions_id) as transactions  from retail_sales GROUP BY 1,2 order by 1;

--7.query to calculate the average sale for each month. Find out best selling month in each year:

SELECT 
       year,
       month,
    avg_sale
FROM (SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2) as t1 where rank=1

--8.query to find the top 5 customers based on the highest total sales
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--9.query to find the number of unique customers who purchased items from each category.:
SELECT 
	category,
    count(distinct(customer_id)) as Number_of_Customer
FROM retail_sales
GROUP BY 1

--10.query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift


