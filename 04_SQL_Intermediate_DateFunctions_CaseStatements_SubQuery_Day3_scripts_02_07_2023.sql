
/*
Some table create and insert scripts for us to work on queries down in the script

*/

create table employee(
		emp_id int,
		emp_name varchar(20),
		dept_id int,
		salary int,
		manager_id int,
		emp_age int
	);

insert into employee values(1,'Ranjith',100,10000,4,39);
insert into employee values(2,'Mohit',100,15000,5,48);
insert into employee values(3,'Vikas',100,10000,4,37);
insert into employee values(4,'Rohit',100,5000,2,16);
insert into employee values(5,'Mudit',200,12000,6,55);
insert into employee values(6,'Agam',200,12000,2,14);
insert into employee values(7,'Sanjay',200,9000,2,13);
insert into employee values(8,'Ashish',200,5000,2,12);
insert into employee values(9,'Mukesh',300,6000,6,51);
insert into employee values(10,'Rakesh',500,7000,6,50);


create table dept ( 
dep_id int,
dep_name varchar(20))


insert into dept 
values (100,'Analytics'),(200,'IT'),
(300,'HR'),(400,'Admin')


create table table1(
		id int,
		name varchar(20))
insert into table1 values(1,'A');
insert into table1 values(2,'B');
insert into table1 values(3,'C');
insert into table1 values(4,'D');
insert into table1 values(5,'E');
insert into table1 values(NULL,'E');

create table table2(
		id int,
		name nvarchar(20))
insert into table2 values(4,'D');
insert into table2 values(5,'E');
--insert into table2 values(3,'C');
insert into table2 values(6,'F');
insert into table2 values(7,'G');
insert into table2 values(8,'H');
----------------------------------------------------------------------------------------------
/*
Quick recap of self join:

And to find employees whose salary is greater than their managers salary
*/
--Self Join:
select * from employee
select * from employee
select * from dept

select 
e1.emp_id,e1.emp_name,e2.emp_name as manager_name
from 
employee e1
inner join employee e2 on e1.manager_id=e2.emp_id
where e1.salary > e2.salary;

------------------------------------------------------------------------------------------------------------------------
/*
Set Operations:
1. Union, Union All
2. Intersect
3. Minus
*/


/*1. Union Operator:
SQL Server UNION is one of the set operations that allow you to combine results of two SELECT statements into a single result set 
which includes all the rows that belong to the SELECT statements in the union.

The following are requirements for the queries in the syntax above:
		--The number and the order of the columns must be the same in both queries.
		--The data types of the corresponding columns must be the same or compatible.

UNION vs. UNION ALL
By default, the UNION operator removes all duplicate rows from the result sets. 
However, if you want to retain the duplicate rows, you need to specify the ALL keyword is explicitly 
the UNION  operator removes the duplicate rows while the UNION ALL operator includes the duplicate rows in the final result set.


UNION vs. JOIN
The join such as INNER JOIN or LEFT JOIN combines columns from two tables while the UNION combines rows from two queries.

In other words, join appends the result sets horizontally while union appends the result set vertically.
*/

select * from table1
select * from table2

select * from table1
union all
select * from table2

--delete from table1
--drop table table1
--drop table table2

--------------------------------------------------------------------------------------------------------------------
/*
INTERSECT:
Intersect combines result sets of two or more queries and returns distinct rows that are output by both queries.
Similar to the UNION operator, the queries in the syntax above must conform to the following rules:

		Both queries must have the same number and order of columns.
		The data type of the corresponding columns must be the same or compatible.

INNER JOIN VS INTERSECT:

The INNER JOIN will return duplicates, if id is duplicated in either table. INTERSECT removes duplicates. 
The INNER JOIN will never return NULL, but INTERSECT will return NULL.

*/


select * from table1
select * from table2

select * from table1
intersect 
select * from table2

select * from table1 a inner join table2 b on a.id = b.id
-------------------------------------------------------------------------------------------------------------------------------------
/*
Except:

The SQL Server EXCEPT compares the result sets of two queries and returns the distinct rows from the first query that are not output by the second query. 
In other words, the EXCEPT subtracts the result set of a query from another.

The following are the rules for combining the result sets of two queries in the above syntax:

		The number and order of columns must be the same in both queries.
		The data types of the corresponding columns must be the same or compatible.
*/
select * from table1
select * from table2

select * from table1
except 
select * from table2
--The except of the table1 and table2 returns 1,2, 3 which is the distinct row from the table1 result set that does not appear in the table1	 result set.

-------------------------------------------------------------------------------------------------------------------------------------------
/*
String  Functions:
There are lot of string functions let see some import once remaning you can get it from w3 schools or any other refrences given below:
https://learn.microsoft.com/en-us/sql/t-sql/functions/string-functions-transact-sql?view=sql-server-ver16
https://www.w3schools.com/sql/sql_ref_sqlserver.asp
*/

select order_id, customer_name from orders

--LEN : Returns the length of a string
select Top 10 order_id, customer_name,LEN(order_id) as length from orders

--LEFT: Extracts a number of characters from a string (starting from left)
select Top 10 order_id, customer_name,left(customer_name,5) as left_4 from orders

--RIGHT:Extracts a number of characters from a string (starting from right)
select Top 10 order_id, customer_name,right(customer_name,7) as right_5 from orders

--SUBSTRING	 Extracts some characters from a string: SUBSTRING(string, start, length)

select Top 10 order_id, customer_name,SUBSTRING(order_id,1,7) as substr from orders

select Top 10 order_id, customer_name,SUBSTRING(order_id,4,4) as substr from orders

--CHARINDEX	Returns the position of a substring in a string : CHARINDEX ( expressionToFind , expressionToSearch [ , start_location ] )
select Top 20 order_id, customer_name,CHARINDEX('n', customer_name) as substr from orders

select Top 20 order_id, customer_name,CHARINDEX('n', customer_name, 3) as substr from orders

select Top 20 order_id, customer_name, CHARINDEX(' ',customer_name,6) as space_position from orders

--CONCAT() function adds two or more strings together.

SELECT CONCAT('SQL', ' is', ' EasyToLearn');
SELECT Top 20 order_id, customer_name, order_id+' '+customer_name, CONCAT(order_id,' ', customer_name) as id_concact_name from orders



--Now lets extract first name from the customer name
select top 20  order_id, customer_name from  orders
select  Top 20 left(customer_name, CHARINDEX(' ',customer_name))  from orders
select  Top 20 right(customer_name, CHARINDEX(' ',customer_name))  from orders


--REPLACE	Replaces all occurrences of a substring within a string, with a new substring: REPLACE(string, old_string, new_string)
select top 20  order_id, customer_name from  orders
SELECT Top 20 order_id, customer_name, REPLACE(order_id, 'CA', 'RKSAI') replaced_order_id from orders

--TRIM	Removes leading and trailing spaces (or other specified characters) from a string
--Remove characters and spaces from a string:
SELECT TRIM('#! ' FROM '    #DE Learnings!    ') AS TrimmedString;

--REVERSE	Reverses a string and returns the result
SELECT REVERSE('DE Learnings');
SELECT Top 20 order_id, customer_name,REVERSE(customer_name)FROM orders;

--LTRIM	Removes leading spaces from a string
SELECT LTRIM('     DE Learnings') AS LeftTrimmedString;

--RTRIM	Removes trailing spaces from a string
SELECT RTRIM('DE Learnings     ') AS RightTrimmedString;

--------------------------------------------------------------------------------------------------------------------------
/*
String Aggregate Functions:

*/
select * from employee
--Getting avg salary of employee for each department id:

select dept_id, avg(salary) as avg_salary from employee group by dept_id

--Now i want deparment wise employee names in one column concatenated in alist

select dept_id, STRING_AGG(emp_name,'-') WITHIN GROUP(ORDER BY salary) as list_of_empoyees, avg(salary) as avg_slary
from employee 
group by dept_id 

--In postgress and redshift its LIST_AGG function not STRING_AGG

---------------------------------------------------------------------------------------------------------------------------
/*
Date Important Functions:
*/
-------------------------------------------------------------------------------------------------------------------------

SELECT GETDATE() as todays_date;
SELECT GETUTCDATE() as  UTC_date_time;
SELECT CURRENT_TIMESTAMP as currenttimestamp;
SELECT SYSDATETIME() AS SysDateTime;
SELECT DATEFROMPARTS(2018, 10, 31) AS DateFromParts;
SELECT ISDATE('2017-08-25');
SELECT ISDATE('2017');
SELECT ISDATE('RK!');

select * from orders

select order_id, order_date , 
DAY(order_date) as day,
MONTH(order_date) as month,
YEAR(order_date) as year
from orders

----------------------------------------------------------------------------------------------------------

/*
datepart function:
		year, yyyy, yy = Year
		quarter, qq, q = Quarter
		month, mm, m = month
		dayofyear, dy, y = Day of the year
		day, dd, d = Day of the month
		week, ww, wk = Week
		weekday, dw, w = Weekday
		hour, hh = hour
		minute, mi, n = Minute
		second, ss, s = Second
		millisecond, ms = Millisecond
		microsecond, mcs = Microsecond
		nanosecond, ns = Nanosecond
		tzoffset, tz = Timezone offset
		iso_week, isowk, isoww = ISO week

*/


select order_id, order_date , datepart(year, order_date) as order_date_year ,
 datepart(month, order_date) as order_date_month,
 datepart(day, order_date) as order_date_day,
 datepart(week, order_date) as order_date_week
 from orders
 where datepart(year, order_date) =2020
 --------------------------------------------------------------------------------------------------------------------------
/*
datename function:
		year, yyyy, yy = Year
		quarter, qq, q = Quarter
		month, mm, m = month
		dayofyear = Day of the year
		day, dy, y = Day
		week, ww, wk = Week
		weekday, dw, w = Weekday
		hour, hh = hour
		minute, mi, n = Minute
		second, ss, s = Second
		millisecond, ms = Millisecond
*/


select order_id, order_date , datename(year, order_date) as order_date_year ,
 datename(month, order_date) as order_date_month,
 datename(day, order_date) as order_date_day,
 datename(week, order_date) as order_date_week,
 datename(weekday, order_date) as order_date_week_name
 from orders
 where datename(year, order_date) =2020
 --------------------------------------------------------------------------------------------------------------------------
 /*
dateadd function:

*/
select *  from orders

--Adding days, weeks, months, years to the order_date column
select order_id, order_date 
,dateadd(day, 5, order_date) as order_date_five 
,dateadd(week, 5, order_date) as order_date_week_five
,dateadd(month, 1, order_date) as order_date_month_1
,dateadd(Year, 2, order_date) as order_date_Year_2
from orders

--Removing days, weeks, months, years to the order_date column
select order_id, order_date 
,dateadd(Year, -2, order_date) as order_date_Year_two
,dateadd(month, -1, order_date) as order_date_month_one
,dateadd(day, -5, order_date) as order_date_days_five
,dateadd(week, -5, order_date) as order_date_week_five
from orders

 --------------------------------------------------------------------------------------------------------------------------

 /*
 datadiff function:
  now lets see how many days it took for an order to ship:
 */


select order_id, order_date , ship_date 
,datediff(day,order_date,ship_date) as datediff_in_days
,datediff(week,order_date,ship_date) as datediff_in_week
,datediff(month,order_date,ship_date) as datediff_in_month
,datediff(Year,order_date,ship_date) as datediff_in_year
from orders

-----------------------------------------------------------------------------------------------------------------------

--lets create below sample tables to work on remaning further functions

create table emp2 ( 
	emp_id int,
	emp_name varchar(20),
	department_id int,
	salary int,
	manager_id int,
	emp_age int,
	dep_id int,
	dep_name varchar(20),
	gender varchar(20),
	mobile1 varchar(25),
	mobile2 varchar(25),
	landline varchar(24));


insert into emp2 
values (1,'Ankit Kumar',100,10000,4,39,100,'Analytics','Female','(516) 379-8888)','(516) 379-9999)',NULL),
(2,'Mohit Yedav',100,15000,5,48,200,'IT','Male',NULL,NULL,'(516) 379-7659)'),
(3,'Vikas',100,10000,4,37,100,'Analytics','Female',NULL,'(516) 379-6666)',NULL),
(4,'Rohit Shetty',100,5000,2,16,100,'Analytics','Female','(516) 379-4444)','(516) 379-9999)',NULL),
(5,'Mudit Goyal',200,12000,6,55,200,'IT','Male',NULL,'(516) 379-1111)',NULL),
(6,'Sivam Mittal',200,12000,2,14,200,'IT','Male',NULL,'(516) 379-9848)',NULL),
(7,'Sanjay Dutt',200,NULL,2,28,200,'IT','Male','(516) 379-4444)','(516) 379-0000)',NULL),
(8,'Ashish',200,NULL,2,NULL,2001,'IT','Male','(516) 379-4444)','(516) 379-7777)',NULL),
(9,'Ranjith Kum Amirneni',900,12000,2,51,300,'HR','Male','(516) 379-4444)','(516) 379-3333)',NULL),
(10,'Raju Ram Sundaram',4000,12000,2,50,300,'HR','Male',NULL,NULL,'(516) 379-9704)'),
(11,'unknown',null,null,null,null,null,null,null,null,null,null)

CREATE TABLE salaries (
    staff_id INT PRIMARY KEY,
    hourly_rate decimal,
    weekly_rate decimal,
    monthly_rate decimal)
   

INSERT INTO 
    salaries(staff_id,hourly_rate, weekly_rate,monthly_rate)
		VALUES(1,20, NULL,NULL),
			(2,30, NULL,NULL),
			(3,NULL, 1000,NULL),
			(4,NULL, NULL,6000),
			(5,NULL, NULL,6500),
			(6,NULL, NULL,NULL);

-----------------------------------------------------------------------------------------------------------------------------
select * from dbo.emp2 

/*
Dealing with NULLS:
Using NULL functions(IS NULL, COALESCE)  
*/
--1. IS NULL Function:
--lets says we generating report and i dont want nulls 
select emp_id, emp_name, isnull(salary, 0) new_sal from dbo.emp2 where salary is null

--2. COALESCE Function: 
--In SQL Server COALESCE expression accepts a number of arguments, evaluates them in sequence, and returns the first non-null argument.
--this also works similar, But where as in coalesce function we can pass more than 3 arguments:

SELECT COALESCE(NULL, NULL, NULL, 'Hello', NULL) result;

--we can pass multiple columns to the coalesce function and it will return the first not null value or the default value
--if all of the column values are NULL it will return default value specified.
SELECT staff_id,hourly_rate, weekly_rate, monthly_rate FROM salaries ORDER BY staff_id;

SELECT staff_id,COALESCE(hourly_rate*22*8, weekly_rate*4,monthly_rate,0) monthly_salary
FROM salaries;
--mostly in real time they use COALESCE than is null. 
--And COALESCE will work with any datatypes like date, int, char, varchar, bit but conversion should to same data type.
------------------------------------------------------------------------------------------------------------------------------
--3. Cast: The CAST() function converts a value (of any type) into a specified datatype. 
SELECT CAST(25.65 AS int);
SELECT CAST(25.65 AS varchar);
SELECT CAST('2017-08-25' AS datetime);
select top 5 order_id, Sales, cast(sales as int) casted_sales, round(sales,1) rounded_sales from orders

--4. Round function: Round the number to n decimal places:ROUND(number, decimals)
SELECT ROUND(235.414, 3) AS RoundValue;
SELECT ROUND(235.414, 2) AS RoundValue;
SELECT ROUND(235.414, 1) AS RoundValue;
SELECT ROUND(235.414, 0) AS RoundValue;
select top 5 order_id, Sales,round(sales,2) rounded_sales from orders

--------------------------------------------------------------------------------------------------------------------------------
/*
CASE STATEMENT EXPRESSIONS:

COALESCE VS CASE EXPRESSION:
The COALESCE expression is a syntactic sugar of the CASE expression.
Syntactic sugar can improve code readability it's important to note that the underlying functionality and behavior remain the same, 
and understanding the underlying concepts is still essential 


COALESCE(e1,e2,e3)

CASE
    WHEN e1 IS NOT NULL THEN e1
    WHEN e2 IS NOT NULL THEN e2
    ELSE e3
END
*/


select order_id, profit  from orders

/*In any programming language we know if else statement rt , here case expressions also works the same.

we write some thing in python as similar to below rt
if profit < 100  then 'low profit' 
else if  profit > 100  then 'profit' 
else end


But in core SQL we don't have if else statements direct instaed of if we use when  but in pl sql we have if else .
Instead we can use case statements
*/

---------------------------------------------------------------------------------------------------------------------------------------
select order_id, profit ,
case 
	when profit < 10  then 'LOW PROFIT'
	when profit < 100 then 'MEDIUM PROFIT'
	when profit < 200 then 'HIGH PROFIT'
	ELSE 'VERY HIGH PROFIT'
end as profit_category
from orders
/*

--Now if you see the result its showing low profit why not medium profit , its satisfying the seond condition also rt
--Here comes the important concept of case statements, case statements are always executed from top to bottom.
--As soon as it satify the condition it stops or else it keep going.

*/

--Now what happens if i do this as below: It is executing top to bottom if condition met it stops if not met it move to next statement

select order_id, profit ,
case 
	when profit < 100 then 'MEDIUM PROFIT'
	when profit < 10  then 'LOW PROFIT'
	when profit < 200 then 'HIGH PROFIT'
	ELSE 'VERY HIGH PROFIT'
end as profit_category
from orders


------------------------------------------------------------
--And always we can specify a range as well to make the logic apply better

select order_id, profit ,
case 
	when profit < 10 then 'LOW PROFIT'
	when profit > 10 AND  profit < 100 then 'MEDIUM PROFIT'--We can also use between operator also But note between also includes the boundaries
	when profit > 100 AND profit < 200 then 'HIGH PROFIT'
	ELSE 'VERY HIGH PROFIT'
end as profit_category
from orders


--In when condition there is no limitation what we can put in when , we can use where caluses
-- all other conditional statements and other inbuilt function what ever you put for filters(where, Like, AND,  OR, BETWEEN) we can put here it will works
----------------------------------------------------------------
--Just put a comma and write multiple case statement in same query

select order_id, profit ,
case 
	when profit < 100 then 'MEDIUM PROFIT'
	when profit < 10  then 'LOW PROFIT'
	when profit < 200 then 'HIGH PROFIT'
	ELSE 'VERY HIGH PROFIT'
end as profit_category,
case 
	when profit < 10 then 'LOW PROFIT'
	when profit > 10 AND  profit < 100 then 'MEDIUM PROFIT'
	when profit > 100 AND profit < 200 then 'HIGH PROFIT'
	ELSE 'VERY HIGH PROFIT'
end as profit_category
from orders


----------------------------------------------------------------------------------------------------------------------------------
SELECT    
    order_status, 
    COUNT(order_id) order_count
FROM    
    sales.orders
WHERE 
    YEAR(order_date) = 2018
GROUP BY 
    order_status;
---------------------------------------------------------------------------------------------------------------------------------
select * from sales.orders
SELECT  order_status , 
    CASE order_status
        WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Processing'
        WHEN 3 THEN 'Rejected'
        WHEN 4 THEN 'Completed'
    END AS order_status, 
    COUNT(order_id) order_count
FROM    
    sales.orders
WHERE 
    YEAR(order_date) = 2018
GROUP BY 
    order_status;

---------------------------------------------------------------------------------------------------------------------------------------
/* Just create an emp schema and employee table in that schema 
using below create and insert scripts to see more scenarios on case statements using employee table
*/

create schema emp

CREATE TABLE emp.employee
( 
EmployeeID INT IDENTITY PRIMARY KEY, 
EmployeeName VARCHAR(100) NOT NULL, 
Gender VARCHAR(1) NOT NULL, 
StateCode VARCHAR(20) NOT NULL, 
Salary money NOT NULL,
) 

SET IDENTITY_INSERT [emp].[Employee] ON 
GO
INSERT [emp].[Employee] ([EmployeeID], [EmployeeName], [Gender], [StateCode], [Salary]) VALUES (201, N'Jerome', N'M', N'FL', 83000.0000)
GO
INSERT [emp].[Employee] ([EmployeeID], [EmployeeName], [Gender], [StateCode], [Salary]) VALUES (202, N'Ray', N'M', N'AL', 88000.0000)
GO
INSERT [emp].[Employee] ([EmployeeID], [EmployeeName], [Gender], [StateCode], [Salary]) VALUES (203, N'Stella', N'F', N'AL', 76000.0000)
GO
INSERT [emp].[Employee] ([EmployeeID], [EmployeeName], [Gender], [StateCode], [Salary]) VALUES (204, N'Gilbert', N'M', N'Ar', 42000.0000)
GO
INSERT [emp].[Employee] ([EmployeeID], [EmployeeName], [Gender], [StateCode], [Salary]) VALUES (205, N'Edward', N'M', N'FL', 93000.0000)
GO
INSERT [emp].[Employee] ([EmployeeID], [EmployeeName], [Gender], [StateCode], [Salary]) VALUES (206, N'Ernest', N'F', N'Al', 64000.0000)
GO
INSERT [emp].[Employee] ([EmployeeID], [EmployeeName], [Gender], [StateCode], [Salary]) VALUES (207, N'Jorge', N'F', N'IN', 75000.0000)
GO
INSERT [emp].[Employee] ([EmployeeID], [EmployeeName], [Gender], [StateCode], [Salary]) VALUES (208, N'Nicholas', N'F', N'Ge', 71000.0000)
GO
INSERT [emp].[Employee] ([EmployeeID], [EmployeeName], [Gender], [StateCode], [Salary]) VALUES (209, N'Lawrence', N'M', N'IN', 95000.0000)
GO
INSERT [emp].[Employee] ([EmployeeID], [EmployeeName], [Gender], [StateCode], [Salary]) VALUES (210, N'Salvador', N'M', N'Co', 75000.0000)
GO
SET IDENTITY_INSERT [emp].[Employee] OFF
GO
--------------------------------------------------------------------------------------------------------------------------------------
select * from emp.employee

--lets work on gender column to specify the full form of the gender using case statements
select employeename,gender,
CASE
	WHEN gender='M' then 'MALE'
	WHEN gender='F' then 'FEMALE'
	ELSE 'N/A'
END as full_gender
from emp.employee
---------------------------------------------------------------------------------------------------------------------------------
--lets categorize/label the employees based on their salary

Select employeename,salary,
 CASE
	WHEN Salary >=80000 AND Salary <=100000 THEN 'Director'
	WHEN Salary >=50000 AND Salary <80000 THEN 'Senior Developer'
Else 'Junior Developer'
END AS Designation

from emp.employee
-------------------------------------------------------------------------------------------------------------------------------------
--Order By clause case statement usage:
--case statement with orderby clause, we can use case statement within orderby clause as well!

Select EmployeeName,Gender,Salary
from emp.Employee
ORDER BY  
		CASE Gender
				WHEN 'F' THEN Salary 
		End DESC,

		Case Gender      
				WHEN 'M' THEN Salary  
		END ASC
----------------------------------------------------------------------------------------------------------------------------------
/*Group BY Clause case statement usage:
--We can use a Case statement with Group By clause as well. Suppose we want to group employees based on their salary. 
--We further want to calculate the minimum and maximum salary for a particular range of employees.
*/

Select 
		CASE
			WHEN Salary >=80000 AND Salary <=100000 THEN 'Director'
			WHEN Salary >=50000 AND Salary <80000 THEN 'Senior Consultant'
			Else 'Director'
		END AS Designation,
		Min(salary) as MinimumSalary,
		Max(Salary) as MaximumSalary
from emp.Employee
Group By 
		CASE
			WHEN Salary >=80000 AND Salary <=100000 THEN 'Director'
			WHEN Salary >=50000 AND Salary <80000 THEN 'Senior Consultant'
			Else 'Director'
		END
------------------------------------------------------------------------------------------------------------------------------------
/*Update table using case statements:
We can use a Case statement in SQL with update DML as well. 

Suppose we want to update Statecode of employees based on Case statement conditions.

for the  following conditions.
				If employee statecode is AR, then update to FL
				If employee statecode is GE, then update to AL
				For all other statecodes update value to IN

*/

select * from emp.employee
select * into emp.employee_bckup from emp.employee

update emp.employee set statecode = 
									case 
										when statecode='AR' then 'FL'
										when statecode='GE' then 'AL'
										else 'IN'
									end

select * from emp.employee
select * from emp.employee_bckup
---------------------------------------------------------------------------------------------------------------------------------------

--Nested case statements example.
/*COALESCE Vs CASE STATEMENT: using nested case statements
*/

select * from dbo.emp2

--using coalesce to fectch employee phone number from dbo.emp2 table 
select emp_id, emp_name,mobile1,mobile2,landline, COALESCE(mobile1,mobile2,landline, 'Unknown') as phone_number 
from dbo.emp2 


--using case statements to fetch employeee phone number
SELECT emp_id, emp_name,gender, mobile1,mobile2,landline,
       CASE
            WHEN gender = 'Male' THEN
                CASE
                    WHEN mobile1 IS NOT NULL THEN mobile1
                    WHEN mobile2 IS NOT NULL  THEN mobile2
					WHEN landline IS NOT NULL  THEN landline
                    ELSE 'UNKNOWN'
                END
            WHEN gender = 'Female' THEN
                CASE
                    WHEN mobile1 IS NOT NULL THEN mobile1
                    WHEN mobile2 IS NOT NULL THEN mobile2
                    ELSE 'UNKNOWN'
                END
            ELSE 'Gender Is Null'
       END AS 'phone_number'
FROM dbo.emp2;

--------------------------------------------------------------------------------------------------------------------------------------------
/*
T-SQL script to understand usage of case statements:
*/
DECLARE @Exam_Result int;
SET @Exam_Result = 85
IF @Exam_Result >= 85
   PRINT 'Passed In Distinction';
ELSE 
BEGIN
    SELECT
	CASE 
	WHEN @Exam_Result BETWEEN 0 AND 34 THEN 'Failed'
	WHEN @Exam_Result BETWEEN 35 AND 64 THEN 'Passed In First Class'
	WHEN @Exam_Result BETWEEN 65 AND 84 THEN 'Passed in Second Class'
	END AS ExamResult	
END

select * from emp.employee_bckup
---------------------------------------------------------------------------------------------------------------------------------------------
/*
Case Statement limitations:
	We can have multiple conditions in a Case statement; however, it works in a sequential model. 
	If one condition is satisfied, it stops checking further conditions
*/
--------------------------------------------------------------------------------------------------------------------------------------------
