----------------------------------------------------------------------------------------------
-----------------------------Feature Engineering----------------------------------------------
---------------------------------time_of_day--------------------------------------------------

SELECT 
time,
(CASE 
WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
ELSE "Evening"
END
) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20)

UPDATE sales
SET time_of_day = ( 
CASE 
WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
ELSE "Evening"
END); 
    
-----------------------------------Creating the table day_name--------------------------------------------
    
SELECT date,DAYNAME(date) FROM sales
    
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10)
    
UPDATE sales 
SET day_name = DAYNAME(date)


-----------------------------Creating the table month_name----------------------------------
	
SELECT date,MONTHNAME(date)
FROM sales

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date)

----------------------------Exploratory Data Analysis (EDA)------------------------------------
--------------------------------Generic Questions----------------------------------------------

--How many unique cities does the data have?
SELECT COUNT(DISTINCT city) FROM sales

--In which city is each branch?
SELECT DISTINCT(city),branch FROM sales

---------------------------------------Product-------------------------------------------------

--How many unique product lines does the data have?
SELECT COUNT(DISTINCT product_line) FROM sales

--What is the most common payment method?
SELECT payment_method,COUNT(payment_method) AS pmt FROM sales
GROUP BY payment_method
ORDER BY pmt DESC
LIMIT 1

--What is the most selling product line?
SELECT product_line,SUM(quantity) AS total_quantity FROM sales
GROUP BY product_line
ORDER BY total_quantity DESC
LIMIT 1

--What is the total revenue by month?
SELECT month_name,SUM(total) AS total_revenue FROM sales
GROUP BY month_name

--What month had the largest COGS?
SELECT month_name,SUM(cogs) AS total_cogs FROM sales
GROUP BY month_name
ORDER BY total_cogs DESC
LIMIT 1

--What product line had the largest revenue?
SELECT product_line,SUM(total) AS total_revenue FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC
LIMIT 1

--What is the city with the largest revenue?
SELECT city,SUM(total) AS total_revenue FROM sales
GROUP BY city
ORDER BY total_revenue DESC
LIMIT 1

What product line had the largest VAT?
SELECT product_line,SUM(VAT) AS total_vat FROM sales
GROUP BY product_line
ORDER BY total_vat DESC
LIMIT 1

--Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT 
 AVG(quantity) AS avg_qnty
FROM sales;

SELECT product_line,
CASE WHEN AVG(quantity) > 5.4995 THEN "Good" ELSE "Bad" END AS performance
FROM sales
GROUP BY product_line

--Which branch sold more products than average product sold?
SELECT branch,SUM(quantity) AS qty
FROM sales
GROUP BY branch 
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales)

--------------------------------------Sales--------------------------------------------------
	
--Number of sales made in each time of the day per weekday
SELECT quantity,time,day_name
FROM sales
WHERE day_name IN ('Monday','Tuesday','Wednesday','Thursday','Friday')

--Which of the customer types brings the most revenue?
SELECT customer_type,SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY SUM(total) DESC
LIMIT 1

--Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city,SUM(VAT) AS total_vat
FROM sales
GROUP BY city
ORDER BY SUM(VAT) DESC
LIMIT 1

--Which customer type pays the most in VAT?
SELECT customer_type,SUM(VAT) AS total_vat
FROM sales
GROUP BY customer_type
ORDER BY SUM(VAT) DESC
LIMIT 1

-----------------------------------Customer------------------------------------------------

--How many unique customer types does the data have?
SELECT COUNT(DISTINCT customer_type) AS unique_customer_types FROM sales

--How many unique payment methods does the data have?
SELECT COUNT(DISTINCT payment_method) FROM sales

--What is the most common customer type?
SELECT customer_type,COUNT(1) as no_of_customers FROM sales
GROUP BY customer_type
ORDER BY no_of_customers DESC
LIMIT 1

--Which customer type buys the most?
SELECT customer_type,SUM(quantity) AS products_bought
FROM sales
GROUP BY customer_type
ORDER BY products_bought DESC
LIMIT 1

--What is the gender of most of the customers?
SELECT gender,COUNT(1) AS no_of_customers 
FROM sales
GROUP BY gender
ORDER BY no_of_customers DESC
LIMIT 1

--What is the gender distribution per branch?
SELECT branch,
COUNT(CASE WHEN gender = 'Male' THEN 1 END) AS male,
COUNT(CASE WHEN gender = 'Female' THEN 1 END) AS female
FROM sales
GROUP BY branch


--Which time of the day do customers give most ratings?
SELECT time_of_day,
COUNT(CASE WHEN rating IS NOT NULL THEN 1 ELSE 0 END) AS rating
FROM sales
GROUP BY time_of_day
ORDER BY rating DESC
LIMIT 1

--Which time of the day do customers give most ratings per branch?
SELECT branch, time_of_day, AVG(rating) AS average_rating
FROM sales 
GROUP BY branch, time_of_day 
ORDER BY average_rating DESC;

--Which day of the week has the best avg ratings?
SELECT day_name,AVG(rating) AS ratings
FROM sales
GROUP BY day_name
ORDER BY ratings DESC
LIMIT 1

--Which day of the week has the best average ratings per branch?
SELECT day_name,branch,AVG(rating) AS ratings
FROM sales
GROUP BY day_name,branch
ORDER BY ratings DESC
LIMIT 3
