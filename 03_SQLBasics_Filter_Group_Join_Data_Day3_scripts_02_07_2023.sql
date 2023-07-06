
/*
Filtering and Grouping Data:
1.WHERE		– filter rows in the output of a query based on one or more conditions.
2.AND, OR   – combine two Boolean expressions AND return true if all expressions are true. 
			- combine two Boolean expressions  OR  return true if either of conditions is true
3.IN NOT    – check whether a value matches any value in a list or a subquery.
  BETWEEN   – test if a value is between a range of values.
4.LIKE Pattern Matching  –  check if a character string matches a specified pattern.
5.Column & table aliases – show you how to use column aliases to change the heading of the query output and table alias to improve the readability of a query.
6.DISTINCT  – select distinct values in one or more columns of a table.
7.GROUP BY  – group the query result based on the values in a specified list of column expressions.
8.HAVING    – specify a search condition for a group or an aggregate.

*/
----------------------------------------------------------------------------------------------------------------------------
/* 
1.WHERE:
When you use the SELECT statement to query data against a table, you get all the rows of that table, 
which is unnecessary because the application may only process a set of rows at the time.
To get the rows from the table that satisfy one or more conditions, you use the WHERE clause.

In the WHERE clause, you specify a search condition to filter rows returned by the FROM clause. 
The WHERE clause only returns the rows that cause the search condition to evaluate to TRUE
The search condition is a logical expression or a combination of multiple logical expressions. 
In SQL, a logical expression is often called a predicate.

SQL Server uses three-valued predicate logic where a logical expression can evaluate to TRUE, FALSE, or UNKNOWN. 
The WHERE clause will not return any row that causes the predicate to evaluate to FALSE or UNKNOWN.

Predicate pushdown, also known as pushdown optimization, is a query optimization technique used in database systems to improve query performance. 
It involves pushing filtering predicates or conditions closer to the data source, such as a table or a view,
to reduce the amount of data processed.

When a query is executed, the database optimizer determines the most efficient way to retrieve the required data.
Predicate pushdown allows the optimizer to analyze the query and identify filtering conditions that can be pushed down to the data source for early filtering. 
By pushing down these predicates, the database system can minimize the amount of data that needs to be read and processed.

This means that the database system can apply these conditions early during the data retrieval process, 
filtering out irrelevant rows and reducing the amount of data that needs to be processed further.

By applying filtering conditions early, predicate pushdown can significantly improve query performance, especially when dealing with large tables or complex queries. 
It reduces the amount of data transferred over the network and the computational resources required to process the query.

*/

select * from production.products

--filter rows that meet a condition
SELECT product_id,product_name,category_id, model_year,list_price FROM production.products 
WHERE category_id = 1 ORDER BY list_price DESC; --This line will perform optimization

--filter rows that meet two conditions
SELECT  product_id,product_name, category_id, model_year,list_price
FROM production.products WHERE category_id = 1 AND model_year = 2018
ORDER BY list_price DESC;

--filter rows by using a comparison operator

SELECT product_id,product_name,category_id,model_year,list_price FROM production.products
WHERE list_price > 300 OR model_year = 2023 ORDER BY list_price DESC;

--filter rows that meet any of two conditions
SELECT product_id,product_name,category_id,model_year,list_price FROM production.products
WHERE list_price > 3000 OR model_year = 2018 ORDER BY list_price DESC;

--filter rows with the value between two values
SELECT product_id,product_name,category_id,model_year,list_price FROM production.products
WHERE list_price BETWEEN 1899.00 AND 1999.99 ORDER BY list_price DESC;

--filter rows with the values in a list of values
SELECT product_id,product_name,category_id,model_year,list_price FROM production.products
WHERE list_price  IN (299.99, 369.99, 489.99) ORDER BY list_price DESC;


--filter rows that that contain a certain string value
SELECT product_id,product_name,category_id,model_year,list_price FROM production.products
WHERE product_name LIKE '%Cruiser%' ORDER BY list_price ;
--------------------------------------------------------------------------------------------------------------------------------
/*
2. AND , OR OPERATORS:
--AND is a logical operator that allows you to combine two Boolean expressions.
It returns TRUE only when both expressions evaluate to TRUE.

--OR is a logical operator that allows you to combine two Boolean expressions. 
It returns TRUE when either of the conditions evaluates to TRUE.

When you use more than one logical operator in an expression, SQL Server always evaluates the AND operators first.
However, you can change the order of evaluation by using parentheses.

*/

select  * from production.products

SELECT product_id,product_name,category_id,model_year,list_price FROM production.products
WHERE category_id = 1 OR list_price > 34400 ORDER BY list_price DESC;


SELECT product_id,product_name,category_id,model_year,list_price FROM production.products
WHERE list_price < 200 OR list_price > 6000 ORDER BY list_price DESC;

--multiple AND
SELECT * FROM production.products 
WHERE category_id = 1 AND list_price > 400 AND brand_id = 1
ORDER BY list_price DESC;

--multiple OR 
SELECT product_name,brand_id FROM production.products
WHERE brand_id = 1 OR brand_id = 2 OR brand_id = 4
ORDER BY brand_id DESC;

--Using both AND and OR operators:
SELECT * FROM production.products 
WHERE brand_id = 1 OR brand_id = 2 AND list_price > 1000 ORDER BY list_price DESC;

--we used both OR and AND operators in the condition. As always, SQL Server evaluated the AND operator first. 
--Therefore, the query retrieved the products whose brand id is two and list price is greater than 1,000 or those whose brand id is one.


SELECT * FROM production.products
WHERE (brand_id = 1 OR brand_id = 2) AND list_price > 1000 ORDER BY brand_id;
--It gies us product whose brand id is one or two and list price is larger than 1,000, you use parentheses 


----------------------------------------------------------------------------------------------------------------------------------
/*
3.IN, NOT IN , BETWEEN , LIKE

*/

SELECT product_name,list_price FROM production.products
WHERE list_price IN (89.99, 109.99, 159.99)
ORDER BY list_price;

SELECT product_name,list_price FROM production.products
WHERE list_price NOT IN (89.99,109.99, 159.99)
ORDER BY list_price


-- lets see in operator with a sub query example:

SELECT product_id   FROM production.stocks WHERE  store_id = 1 AND quantity >= 30;

SELECT product_name, list_price FROM  production.products
WHERE product_id IN ( SELECT product_id FROM production.stocks WHERE store_id=1 and quantity >=30)
ORDER BY product_name;

--BETWEEN OPERATOR
SELECT   product_id,  product_name,  list_price FROM   production.products
WHERE  list_price BETWEEN 149.99 AND 199.99 ORDER BY   list_price;

SELECT   product_id,  product_name,  list_price FROM   production.products
WHERE  list_price NOT BETWEEN 149.99 AND 199.99 ORDER BY   list_price; 

SELECT order_id,customer_id,order_date, order_status FROM sales.orders
WHERE order_date  BETWEEN '20170115' AND '20170117'ORDER BY order_date;

---------------------------------------------------------------------------------------------------------------------------
/*4. Like Operator :
SQL Server LIKE is a logical operator that determines if a character string matches a specified pattern. A pattern may include regular characters and wildcard characters. 
The LIKE operator is used in the WHERE clause of the SELECT, UPDATE, and DELETE statements to filter rows based on pattern matching.
*/

select * from sales.customers
--Exact pattern match
select customer_id,first_name, last_name from sales.customers where first_name like 'Andria'

--% character says you can have 0 or more charecters starting with Andrew
select customer_id,first_name, last_name from sales.customers where first_name like 'And%'

--% character says you can have 0 or more charecters ending with Allen
select customer_id,first_name, last_name from sales.customers where first_name like '%ina'

--% character says you can have 0 or more charecters starting with A and ending with n
select customer_id,first_name, last_name from sales.customers where first_name like 'A%n'


--% character says you can have 0 or more charecters having All in between some where in the string
select customer_id,first_name, last_name from sales.customers where first_name like '%All%'

--'_' represents a single character 
-- To get all the first_names where second character is 'a' and after that anything can come.
select customer_id,first_name, last_name from sales.customers where first_name like '_a%'

--'_' represents a single character , so if i mention 2 underscores then 3rd charcater should be 'a' 
select customer_id,first_name, last_name from sales.customers where first_name like '__a%'


--'[]' So anything with in [] brackets can come 
--So what i am saying is first character should be A  and second character could be N or S anything
select customer_id,first_name, last_name from sales.customers where first_name like 'A[NS]%'

--So If you mention cap then first character should be A  and second character could be  anything apart from N or S that means reverse of above condition
select customer_id,first_name, last_name from sales.customers where first_name like 'A[^NS]%'


--So first character should be A  and give me all characters between B to E(its range wild character)
select customer_id, first_name, last_name from sales.customers where first_name like 'A[B-E]%'

--IMP NOTE:  Now for all the above wild cards you can say NOT LIKE for excluding them it will negate that pattern

-----------------------------------------------------------------------------------------------------------------------------
/*
5. Column & Table Aliases: 
In SQL server to assign a column or an expression a temporary name during the query execution, you use a column alias.
*/
--Column alias
SELECT customer_id,first_name,last_name, first_name + ' ' + last_name 
FROM sales.customers ORDER BY first_name;


SELECT customer_id,first_name,last_name, first_name + ' ' + last_name AS full_name 
FROM sales.customers ORDER BY first_name;

select * from  production.categories 

SELECT category_name 'Product Category' FROM production.categories ORDER BY  category_name;  
SELECT category_name 'Product Category' FROM  production.categories ORDER BY 'Product Category' DESC;

--Now lets see Table Alias:

SELECT
    sales.customers.customer_id,
    first_name,
    last_name,
    order_id
FROM
    sales.customers  --Both tables have common column of customer_id
INNER JOIN sales.orders ON sales.orders.customer_id = sales.customers.customer_id;

--We can alias the table name as below during join conditions
SELECT
    c.customer_id,
    first_name,
    last_name,
    order_id
FROM
    sales.customers c
INNER JOIN sales.orders o ON o.customer_id = c.customer_id;

------------------------------------------------------------------------------------------------------------------------------
/*
6.Distinct:
*/

select * from sales.customers
SELECT city FROM sales.customers ORDER BY city
;
--we can see clearly from the output, the cities are duplicates.
--To get distinct cities, you add the DISTINCT keyword 

SELECT DISTINCT  city FROM sales.customers ORDER BY city
;

SELECT DISTINCT Top 10 city FROM sales.customers ORDER BY city
;

SELECT DISTINCT Top 10 city FROM sales.customers ORDER BY city DESC
;

--Now lets see DISTINCT on multiple columns 

SELECT DISTINCT state,city FROM sales.customers
;

--Lets see the distinct phone numbers of the customers:

SELECT DISTINCT  phone FROM  sales.customers ORDER BY  phone
;

--so we can see that  DISTINCT clause kept only one NULL in the phone column and removed the other NULLs.

--DISTINCT vs. GROUP BY
SELECT 	city, state, zip_code FROM 	sales.customers GROUP BY city, state, zip_code
ORDER BY city, state, zip_code
--This group by also return distinct cities together with state and zip code from the sales.customers table
--which is same as distinct.

SELECT DISTINCT city, state, zip_code FROM sales.customers
;

/*So what is difference between Groupby and Distinct
Both DISTINCT and GROUP BY clause reduces the number of returned rows in the result set by removing the duplicates.
However, you should use the GROUP BY clause when you want to apply an aggregate function on one or more columns.
*/
-------------------------------------------------------------------------------------------------------------------------------
/*
7. Group BY :
The GROUP BY clause allows you to arrange the rows of a query in groups. 
The groups are determined by the columns that you specify in the GROUP BY clause.
*/

select * from sales.orders

SELECT customer_id,YEAR(order_date) as year,MONTH(order_date) as mnth
FROM sales.orders WHERE customer_id IN (1, 2)
ORDER BY customer_id
--you can see clearly from the output, the customer with the id one placed one order in 2016 and two orders in 2018. 
--The customer with id two placed two orders in 2017 and one order in 2018.

SELECT customer_id,YEAR (order_date) order_year FROM sales.orders
WHERE customer_id IN (1, 2)
GROUP BY customer_id,YEAR (order_date)
ORDER BY customer_id;

--The same can be done with distinct?
SELECT DISTINCT customer_id,YEAR (order_date) order_year FROM   sales.orders
WHERE customer_id IN (1, 2) ORDER BY customer_id;
/*The GROUP BY clause arranged the first three rows into two groups and the next three rows into the other 
two groups with the unique combinations of the customer id and order year.
Functionally speaking, the GROUP BY clause in the above query produced the same result 
as the following query that uses the DISTINCT clause
IMPNOTE: But what is the major difference between both uses?
In practice,DISTINCT clause can only give distinct records where as 
the GROUP BY clause is used with aggregate functions for generating summary reports.

An aggregate function performs a calculation on a group and returns a unique value per group. 
For example, COUNT() returns the number of rows in each group.
Other commonly used aggregate functions are SUM(), AVG() (average), MIN() (minimum), MAX() (maximum).
The GROUP BY clause arranges rows into groups and an aggregate function returns the 
summary (count, min, max, average, sum, etc.,) for each group.
*/

SELECT customer_id, YEAR (order_date) order_year,COUNT (order_id) as order_placed
FROM sales.orders WHERE customer_id IN (1, 2)
GROUP BY customer_id,YEAR (order_date)  ORDER BY customer_id; 

/*IMP Note:
If you want to reference a column or expression that is not listed in the GROUP BY clause,
you must use that column as the input of an aggregate function. 
Otherwise, you will get an error because there is no guarantee that the column or expression will return a single value per group. 
For example, the following query will fail:
*/

SELECT customer_id, YEAR (order_date) order_year FROM  sales.orders
WHERE  customer_id IN (1, 2)
GROUP BY
    customer_id,
    YEAR (order_date)
ORDER BY
    customer_id;

--So if you remove orderstatus column it will work

select  *  from sales.orders group by order_status--This won't work

select * from sales.customers 
--More examples of group by with aggregation:
SELECT city, COUNT (customer_id) customer_count FROM sales.customers 
GROUP BY city
ORDER BY city;


SELECT  city, state, COUNT (customer_id) customer_count FROM sales.customers
GROUP BY state,city
ORDER BY city, state;

--Group by with MIN, MAX, AVG exmaple 
SELECT brand_name, MIN (list_price) min_price, MAX (list_price) max_price, AVG(list_price) avg_price
FROM production.products p
INNER JOIN production.brands b ON b.brand_id = p.brand_id
WHERE
    model_year = 2018
GROUP BY
    brand_name
ORDER BY
    brand_name;


select * from sales.order_items
--Using the SUM() function to get the net value of every order:
SELECT  order_id,count(discount) as discount, SUM ( quantity) total_quantity
FROM
    sales.order_items
GROUP BY
    order_id;
-----------------------------------------------------------------------------------------------------------------------

/*
8. Having Clause:

The HAVING clause is  used with the GROUP BY clause to filter groups based on a specified list of conditions.
*/

select * from sales.orders

/*Note: SQL Server processes the HAVING clause after the GROUP BY clause, 
you cannot refer to the aggregate function specified in the select list by using the column alias*/
select * from sales.orders
SELECT
    customer_id,
    YEAR (order_date) as Year,
    COUNT (order_id) order_count
FROM
    sales.orders
GROUP BY
    customer_id,
    YEAR (order_date)
HAVING
    COUNT (order_id) >= 2
ORDER BY
    customer_id;

/*
First, the GROUP BY clause groups the sales order by customer and order year. 
The COUNT() function returns the number of orders each customer placed in each year.
Second, the HAVING clause filtered out all the customers whose number of orders is less than two.
*/
select * from sales.order_items
SELECT order_id, SUM (quantity) total_quantity
FROM
    sales.order_items
GROUP BY
    order_id
HAVING
     SUM (quantity) > 3
ORDER BY
    order_id, total_quantity;


SELECT
    category_id,
    MAX (list_price) max_list_price,
    MIN (list_price) min_list_price,
	AVG (list_price) avg_list_price
FROM
    production.products
GROUP BY
    category_id
HAVING
    MAX (list_price) > 4000 OR MIN (list_price) >500 --AND AVG(list_price) <300 ;

-------------------------------------------------------------------------------------------------------------------------------

/*
Module 6: JOINS
Joins		– give you a brief overview of joins types in SQL Server including inner join, left join, right join and full outer join.
INNER JOIN	– select rows from a table that have matching rows in another table.
LEFT JOIN	– return all rows from the left table and matching rows from the right table. In case the right table does not have the matching rows, use null values for the column values from the right table.
RIGHT JOIN	– learn a reversed version of the left join.
FULL OUTER JOIN – return matching rows from both left and right tables, and rows from each side if no matching rows exist.
CROSS JOIN	– join multiple unrelated tables and create Cartesian products of rows in the joined tables.
Self join	– show you how to use the self-join to query hierarchical data and compare rows within the same table.
*/

/*
Overview of Joins:

In a relational database, data is distributed in multiple logical tables. 
To get a complete meaningful set of data, you need to query data from these tables using joins. 
SQL Server supports many kinds of joins, including inner join, left join, right join, full outer join, and cross join. 
Each join type specifies how SQL Server uses data from one table to select rows in another table.

*/


create table students(
		student_id int,
		student_name varchar(20))
insert into students values(1,'A');
insert into students values(2,'B');
insert into students values(3,'C');
insert into students values(4,'D');
insert into students values(5,'E');


create table department(
			student_id int,
			department varchar(20))

insert into department values(4,'CSE');
insert into department values(5,'ECE');
insert into department values(6,'CIVIL');
insert into department values(7,'MECH');
insert into department values(8,'EEE');
---------------------------------------------------------------------------------------------------------------------
select * from students
select * from department		

--Inner Join
select * from students s inner join department d 
on s.student_id = d.student_id
-----------------------------------------------------------------------------------------------------------------------
select * from students
select * from department		

--left Join
select * from students s left join department d 
on s.student_id = d.student_id
----------------------------------------------------------------------------------------------------------------------
--left outer join
select * from students
select * from department

SELECT  
    s.student_id ,
    s.student_name,
    d.student_id ,
    d.department
FROM 
    students s
    left JOIN department d 
    ON s.student_id = d.student_id
WHERE
	 d.student_id IS NULL
---------------------------------------------------------------------------------------------------------------------
--right Join
select * from students
select * from department

select * from students s right join department d 
on s.student_id = d.student_id


----------------------------------------------------------------------------------------------------------------------------
--right outer Join
select * from students
select * from department

SELECT  
    s.student_id ,
    s.student_name,
    d.student_id ,
    d.department
FROM 
    students s
    right JOIN department d 
    ON s.student_id = d.student_id
WHERE
	 s.student_id IS NULL
--------------------------------------------------------------------------------------------------------------------------
--FULL JOIN 

select * from students
select * from department

SELECT  
    s.student_id ,
    s.student_name,
    d.student_id ,
    d.department
FROM 
    students s
    FULL  JOIN department d 
    ON s.student_id = d.student_id

-------------------------------------------------------------------------------------------------------------------------
--FULL OUTER JOIN

select * from students
select * from department

SELECT  
    s.student_id ,
    s.student_name,
    d.student_id ,
    d.department
FROM 
    students s
    FULL OUTER JOIN department d 
    ON s.student_id = d.student_id
WHERE s.student_id IS NULL OR
	  d.student_id IS NULL

------------------------------------------------------------------------------------------------------------------------
--Cross join will give catesian product of two tables

--cross Join
select * from students s cross join department d 
--on s.student_id = d.student_id
-------------------------------------------------------------------------------------------------------------------------
/*
SELF JOIN:
A self join allows you to join a table to itself. It helps query hierarchical data or compare rows within the same table.
A self join uses the inner join or left join clause. Because the query that uses the self join references the same table, 
the table alias is used to assign different names to the same table within the query.
*/


/*
Lets see the sales.staffs  table 
The  staffs table stores the staff information such as id, first name, last name, and email. 
It also has a column named manager_id that specifies the direct manager. 
For example, Mireya reports to Fabiola because the value in the manager_id of  Mireya is Fabiola.
Fabiola has no manager, so the manager id column has a NULL.

*/

select * from sales.staffs
--now lets see who will report to whom

SELECT
    e.first_name + ' ' + e.last_name employee,
    m.first_name + ' ' + m.last_name manager
FROM
    sales.staffs e
    INNER JOIN sales.staffs m 
   ON m.staff_id = e.manager_id
ORDER BY
    manager;

--Now we can see that we don't have manager name coming we only have 9 employees
--To see the manager as well we can use left join inside above query.
--IMP NOTE: EVEN though you use INNER Join,LEFT joins in the query we are joinining the on the same table.So it is called as self join only.
--

---------------------------------------------------------------------------------------------------------------------
/* Now lets see what if we have duplicates and nulls in table join keys*/

create table students1(
		student_id int,
		student_name varchar(20))
insert into students1 values(1,'A');
insert into students1 values(2,'B');
insert into students1 values(3,'C');
insert into students1 values(4,'D');
insert into students1 values(5,'E');
--insert into students1 values(NULL,'E');
--insert into students1 values(5,'E');


create table department1(
			student_id int,
			department varchar(20))

insert into department1 values(4,'CSE');
insert into department1 values(5,'ECE');
insert into department1 values(6,'CIVIL');
insert into department1 values(7,'MECH');
insert into department1 values(8,'EEE');
insert into department1 values(NULL,'IT');
insert into department1 values(5,'ECE');

select * from students1
select * from department1	
--Inner Join
select * from students1 s inner join department1 d 
on s.student_id = d.student_id

--left Join
select * from students1 s left join department1 d 
on s.student_id = d.student_id


--right Join
select * from students1 s right join department1 d 
on s.student_id = d.student_id

--full outer Join
select * from students1 s full  join department1 d 
on s.student_id = d.student_id


--cross Join
select * from students1 s cross join department1 d 
--on s.student_id = d.student_id

