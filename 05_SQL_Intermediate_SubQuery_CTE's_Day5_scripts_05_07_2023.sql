/*
SUB QUERY:
A subquery is a query nested inside another statement such as SELECT, INSERT, UPDATE, or DELETE.
*/
--------------------------------------------------------------------------------------------------------------------------------
--sub query inside where

select * from dbo.orders
--1. find avg order value
select avg(sales) from dbo.orders--210

select avg(order_sales) as avg_order_value from 
(select order_id, sum(sales) as order_sales 
from dbo.orders 
group by order_id) as orders_aggregated --403
---------------------------------------------------------------------------------------------------------------
--2. find all the orders whose sales > avg_order value
select order_id from dbo.orders group by order_id having sum(sales) >
(select avg(order_sales) as avg_order_value from 
(select order_id, sum(sales) as order_sales 
from dbo.orders 
group by order_id) as orders_aggregated)

--lets check and see 
select * from dbo.orders where order_id = 'CA-2018-104563'
------------------------------------------------------------------------------------------------------------------------
select *  from employee
select * from dept 

--Now we have an employee whose dept is not present in the department table like 500
--earlier we used left join to find it

select * from employee e left join dept d on e.dept_id = d.dep_id where  d.dep_id is null
-- I need all the employess whose dept_id not present in department table

select * from employee where dept_id not in (select dep_id from dept)
--note that in this subquery we need to select only one column dep_id that we have to check using the outer query.

select * from employee where dept_id > (select dep_id from dept)-- This doesn't work
select * from employee where dept_id > (select max(dep_id) from dept)-- This will work

select *, (select avg(salary) from employee) avg_sal from employee --we can also use sub query inside select
 where dept_id not in (select dep_id from dept)

 --so far we have seen sub query usage in select, from, where , having 
---------------------------------------------------------------------------------------------------------------------
--lets see how to find the department wise average salary
select * from employee

select dept_id, avg(salary) as avg_department_salary from employee group by dept_id


select e.*, d.avg_department_salary from employee e
inner join
(select dept_id, avg(salary) as avg_department_salary from employee group by dept_id) d
on e.dept_id = d.dept_id

-- now join these two tables on department_id and get the average salary
---------------------------------------------------------------------------------------------------------------------
--using below sub query we are trying to find the sales orders of the customers located in New York
SELECT order_id,order_date,customer_id FROM sales.orders
WHERE  customer_id IN (SELECT customer_id  FROM sales.customers WHERE city = 'New York') 
ORDER BY  order_date DESC;

/*
Nested sub_query :

  1.We fetch get the list of brand identification numbers of the Strider and Trek brands
  2.We calculate  the average price list of all products that belong to those brands.
  3.We will find the the products whose list price is greater than the average list price 
  of all products with the Strider or Trek brand.
*/

SELECT product_name,list_price FROM production.products
WHERE list_price > (SELECT AVG (list_price) FROM production.products WHERE brand_id IN (SELECT brand_id
																						FROM
																							production.brands
																						WHERE
																							brand_name = 'Strider'
																						OR brand_name = 'Trek'))
																						ORDER BY
																							list_price;
--------------------------------------------------------------------------------------------------------------------------------
/*In sql we can use sub query in many places
								--1. In place of an expression
								--2. With IN or NOT IN
								--3. With ANY or ALL
								--4. With EXISTS or NOT EXISTS
								--5. In UPDATE, DELETE, orINSERT statement
								--6. In the FROM clause


*/ 
------------------------------------------------------------------------------------------------------------------------------

/*1. subquery usage in place of an expression:
If a subquery returns a single value, it can be used anywhere an expression is used.
*/

SELECT order_id, order_date,( SELECT MAX (list_price) FROM sales.order_items i WHERE i.order_id = o.order_id) AS total_amount
FROM sales.orders o
order by order_date desc;
--------------------------------------------------------------------------------------------------------------------------------
/*2. Using subquery with IN operator:
If A subquery that is used with the IN operator returns a set of zero or more values. 
After the subquery returns values, the outer query can make use of them.
*/

SELECT  product_id,product_name FROM  production.products
WHERE category_id IN (SELECT
							category_id
						FROM
							production.categories
						WHERE
							category_name = 'Mountain Bikes'
						  OR category_name = 'Road Bikes');
----------------------------------------------------------------------------------------------------------------------------
/*
3. subquery is used with ANY & ALL operator:
--ANY operator: The ANY operator returns true if the comparison holds true for at least one value in the set.
				Assuming that the subquery returns a list of value v1, v2, � vn. The ANY operator returns TRUE 
				if one of a comparison pair (scalar_expression, vi) evaluates to TRUE; otherwise, it returns FALSE.

--The ALL operator returns TRUE if all comparison pairs (scalar_expression, vi) evaluate to TRUE; otherwise, it returns FALSE.
ALL operator:	The ALL operator returns true if the comparison holds true for all values in the set.
*/
--For each brand, the subquery finds the maximum list price. 
--The outer query uses these max prices and determines which individual product�s list price is greater than or equal to any brand�s maximum list price.

select * from production.products
SELECT  product_name, list_price FROM  production.products WHERE  list_price >= ANY (SELECT
																							AVG (list_price)
																						FROM
																							production.products
																						GROUP BY brand_id)

SELECT product_name, list_price FROM  production.products WHERE list_price >= ALL (SELECT
																						AVG (list_price)
																					FROM
																						production.products
																					GROUP BY
																						brand_id)	
--------------------------------------------------------------------------------------------------------------------------------
/*
subquery is used with EXISTS or NOT EXISTS
The EXISTS operator returns TRUE if the subquery return results; otherwise, it returns FALSE.

The NOT EXISTS negates the EXISTS operator.
*/

--The below query finds the customers who bought products in 2017
--If you use the NOT EXISTS instead of EXISTS, you can find the customers who did not buy any products in 2017.

SELECT customer_id, first_name,last_name, city 
FROM sales.customers c WHERE EXISTS (
									SELECT
										customer_id
									FROM
										sales.orders o
									WHERE
										o.customer_id = c.customer_id
									AND YEAR (order_date) = 2017)
						ORDER BY
							first_name,
							last_name;

SELECT customer_id, first_name,last_name, city 
FROM sales.customers c WHERE NOT EXISTS (
									SELECT
										customer_id
									FROM
										sales.orders o
									WHERE
										o.customer_id = c.customer_id
									AND YEAR (order_date) = 2017)
						ORDER BY
							first_name,
							last_name;

------------------------------------------------------------------------------------------------------------------------
/*
SUB QUERY IN FROM CLAUSE:

To find the average of the sum of orders of all sales staff?

	1. first find the number of orders by staff:
	2.Then, you can apply the AVG() function to this result set. Since a query returns a result set that looks like a virtual table,
	   now you can place the whole query in the FROM clause of another query

*/
SELECT AVG(order_count) average_order_count_by_staff FROM(
															SELECT 
																staff_id, 
																COUNT(order_id) order_count
															FROM 
															sales.orders
															GROUP BY staff_id) tble;

-----------------------------------------------------------------------------------------------------------------------------

/* Correlated subquery:

A correlated subquery is a subquery that uses the values of the outer query. In other words, the correlated subquery depends on the outer query for its values.

Because of this dependency, a correlated subquery cannot be executed independently as a simple subquery.

Moreover, a correlated subquery is executed repeatedly, once for each row evaluated by the outer query. 
The correlated subquery is also known as a repeating subquery.

*/

select max(list_price) from production.products where category_id =3

SELECT  product_name,list_price,category_id
FROM production.products p1 WHERE list_price IN (SELECT
														MAX (p2.list_price)
													FROM
														production.products p2
													WHERE
														p2.category_id = p1.category_id
													GROUP BY
														p2.category_id)
													ORDER BY
														category_id,
														product_name;

/*So in above query for each product evaluated by the outer query, 
the subquery finds the highest price of all products in its category.
If the price of the current product is equal to the highest price of all products in its category, 
the product is included in the result set. This process continues for the next product and so on.
As you can see, the correlated subquery is executed once for each product evaluated by the outer query.
*/

-----------------------------------------------------------------------------------------------------------------------------------
/* 
COMMON TABLE EXPRESSION(CTE):

A CTE allows you to define a temporary named result set that available temporarily in the execution 
scope of a statement such as SELECT, INSERT, UPDATE, DELETE, or MERGE.

Note: We prefer to use common table expressions rather than to use subqueries because common table expressions are more readable. 
We also use CTE in the queries that contain analytic functions (or window functions)

*/
select * from dbo.emp2

with cte (emp_id, emp_name, department_id)as 

(select emp_id, emp_name, department_id from dbo.emp2 where gender = 'Male')  
 
SELECT emp_id, emp_name, department_id FROM cte 

-------------------------------------------------------------------------------------------------------------
--we will find the department wise average salary using the cte now

with cte1 as (select dept_id, avg(salary) as avg_department_salary from employee group by dept_id)

select e.*, d.* from 
employee e
inner join
cte1 d
on e.dept_id = d.dept_id


----------------------------------------------------------------------------------------------------------------------
-- we can also write nested cte's also:

with cte1 as (select dept_id, avg(salary) as avg_department_salary from employee group by dept_id),
total_slary as (select sum(avg_department_salary) as total_salary from cte1)

select e.*, d.* from 
employee e
inner join
cte1 d
on e.dept_id = d.dept_id
--------------------------------------------------------------------------------------------------------------------------

--This CTE return the sales amounts by sales staffs in 2018:
WITH cte_sales_amounts (staff, sales, year) AS (
												SELECT    
													first_name + ' ' + last_name as staff_fullname, 
													SUM(quantity) as quantity_sum,
													YEAR(order_date) order_year
												FROM    
													sales.orders o
												INNER JOIN sales.order_items i ON i.order_id = o.order_id
												INNER JOIN sales.staffs s ON s.staff_id = o.staff_id
												GROUP BY 
													first_name + ' ' + last_name,
													year(order_date))

SELECT staff, sales FROM cte_sales_amounts WHERE year = 2018;

-------------------------------------------------------------------------------------------------------------------------------