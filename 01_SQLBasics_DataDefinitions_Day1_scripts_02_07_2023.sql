---------------------------------------------------------------------------------------------------------------------------
/*
Module 1. Querying data by sorting and limiting
This Module helps you understand learn how to query data from the SQL Server database. 
Note: Before executing make sure you have executed the Create table scripts and Insert scripts that load sample data of sales and production
We will start with a simple query that allows you to retrieve data from a single table then sort and limit.

SELECT – show you how to query data against a single table.

#Sorting data
ORDER BY – sort the result set based on values in a specified list of columns

#Limiting rows
OFFSET FETCH – limit the number of rows returned by a query.
SELECT TOP – limit the number of rows or percentage of rows returned in a query’s result set.
*/

SELECT first_name, last_name FROM sales.customers;
SELECT * FROM sales.customers WHERE  state = 'CA';
SELECT * FROM sales.customers WHERE  state = 'CA' order by first_name
SELECT first_name, last_name FROM sales.customers WHERE  state = 'CA' order by first_name DESC
SELECT city,first_name, last_name FROM sales.customers ORDER BY city,first_name;
SELECT city,first_name, last_name FROM sales.customers ORDER BY city DESC,first_name ASC;
SELECT first_name, last_name FROM sales.customers ORDER BY LEN(first_name) DESC;
SELECT * FROM sales.customers WHERE  state = 'CA' group by city order by first_name 
SELECT * FROM sales.customers WHERE  state = 'CA' group by city having count(*)> 10  order by first_name 

--To skip the first 10 products and return the rest, you use the OFFSET clause as shown in the following statement:
SELECT product_name,list_price FROM production.products ORDER BY list_price,product_name OFFSET 10 ROWS;

--To skip the first 10 products and select the next 10 products, you use both OFFSET and FETCH clauses as follows:
SELECT product_name,list_price FROM production.products ORDER BY list_price,product_name OFFSET 10 ROWS 
FETCH NEXT 10 ROWS ONLY;

--To get the top 10 most expensive products you use both OFFSET and FETCH clauses:
SELECT product_name, list_price FROM production.products ORDER BY list_price DESC ,product_name 
OFFSET 0 ROWS 
FETCH FIRST 10 ROWS ONLY;

--Using TOP Keyword with a constant value
SELECT TOP 10  product_name,list_price FROM  production.products ORDER BY list_price DESC;
SELECT TOP 10  product_name,list_price FROM  production.products ORDER BY list_price ASC;
SELECT TOP 1 PERCENT  product_name,list_price FROM  production.products ORDER BY list_price DESC;

--*******************************************************************************************************************************
/*
Module 2. Data definition

This section shows you how to manage the most important database objects including databases and tables.

1.CREATE DATABASE	– show you how to create a new database in a SQL Server instance using the CREATE DATABASE statement and SQL Server Management Studio.
2.DROP DATABASE		– learn how to delete existing databases.
3.CREATE SCHEMA		– describe how to create a new schema in a database.
4.ALTER SCHEMA		– show how to transfer a securable from a schema to another within the same database.
5.DROP SCHEMA		– learn how to delete a schema from a database.
6.CREATE TABLE		– walk you through the steps of creating a new table in a specific schema of a  database.
7.Identity column(Surrogatekey)	– learn how to use the IDENTITY property to create the identity column for a table.
8.Sequence			– describe how to generate a sequence of numeric values based on a specification.
9.ALTER TABLE ALTER COLUMN – show you how to change the definition of existing columns in a table.
10.ALTER TABLE ADD & DROP COLUMN – learn how to drop one or more columns from a table.
11.Computed columns	– how to use the computed columns to resue the calculation logic in multiple queries.
12.DROP TABLE		– show you how to delete tables from the database.
13.TRUNCATE TABLE	– delete all data from a table faster and more efficiently.
14.SELECT INTO(Table Backup)– learn how to create a table and insert data from a query into it.
15.Rename a table	–  walk you through the process of renaming a table to a new one.
16.Temporary tables	– introduce you to the temporary tables for storing temporarily immediate data in stored procedures or database session.
17.Synonym			– explain you the synonym and show you how to create synonyms for database objects.
*/
-----------------------------------------------------------------------------------------------------------------------
/*
01.CREATE Database:
*/
CREATE DATABASE TestDb;

Use TestDB

--To view all the system databases that are there already we can use below commands
select * from master.sys.databases
SELECT name FROM master.sys.databases ORDER BY  name;
EXEC sp_databases;

--we can create a database manually from UI as well.
-------------------------------------------------------------------------------------------------------------------------
/*
02.DROP DATABASE:
*/

DROP DATABASE IF EXISTS TestDb;

--we can create a delete the database manually from UI as well by rt clikking on database
------------------------------------------------------------------------------------------------------------------------
/*
03.CREATE SCHEMA:
*/

CREATE SCHEMA customer_services;

--we can also view all the schemas in the current database by expanding Security Folder then expand Schema folder
--If you want to list all schemas in the current database, you can query schemas from the sys.schemas
select * from sys.schemas

----------------------------------------------------------------------------------------------------------------------
/*
04.ALTER THE SCHEMA OF A TABLE:(Moving table under one schema to another schema)
*/

CREATE TABLE customer_services.offices
(
    office_id      INT
    PRIMARY KEY IDENTITY(1,1), 
    office_name    NVARCHAR(40) NOT NULL, 
    office_address NVARCHAR(255) NOT NULL, 
    phone          VARCHAR(20),
);

INSERT INTO 
    customer_services.offices(office_name, office_address)
VALUES
    ('Silicon Valley','400 North 1st Street, San Jose, CA 95130'),
    ('Sacramento','1070 River Dr., Sacramento, CA 95820');


select * from customer_services.offices

CREATE SCHEMA test;

/*This below command will transfer the table offices from customer_services schema to test schema 
that we created just above*/

ALTER SCHEMA test TRANSFER OBJECT::customer_services.offices;

----------------------------------------------------------------------------------------------------------------------
/*
05.DROP SCHEMA:
(Note: we cannot drop the schema if we have any tables under that schema,
first drop tables and then only  we can drop the schema)
*/

CREATE TABLE customer_services.jobs
(
    office_id      INT
    PRIMARY KEY IDENTITY(1,1), 
    office_name    NVARCHAR(40) NOT NULL, 
    office_address NVARCHAR(255) NOT NULL, 
    phone          VARCHAR(20),
);

INSERT INTO 
    customer_services.jobs(office_name, office_address)
VALUES
    ('Silicon Valley','400 North 1st Street, San Jose, CA 95130'),
    ('Sacramento','1070 River Dr., Sacramento, CA 95820');

DROP SCHEMA customer_services;--this will throw error as this schema contains tables

-- we cannot drop a schema directly if we have tables in that schema, first drop all the tables then drop the schema

DROP TABLE customer_services.jobs;
--Now we can drop the schema

---------------------------------------------------------------------------------------------------------------------
/*
06.CREATE TABLE:
*/
CREATE TABLE dbo.offices
(
    office_id      INT
    PRIMARY KEY IDENTITY, 
    office_name    NVARCHAR(40) NOT NULL, 
    office_address NVARCHAR(255) NOT NULL, 
    phone          VARCHAR(20),
);

INSERT INTO 
    dbo.offices(office_name, office_address)
VALUES
    ('Silicon Valley_1','400 North 1st Street, San Jose, CA 95130'),
    ('Sacramento','1070 River Dr., Sacramento, CA 95820');

select * from dbo.offices
---------------------------------------------------------------------------------------------------------------------
/*07: IDENTITY:(Also called as Surrogatekey that gives unique id to the rows of a table)
Syntax: [(seed,increment)]
To create an identity column for a table, you use the IDENTITY property 
The seed is the value of the first row loaded into the table.
The increment is the incremental value added to the identity value of the previous row.
The default value of seed and increment is 1 i.e., (1,1). It means that the first row, 
which was loaded into the table, will have the value of one, the second row will have the value of 2 and so on....
For Suppose for example, you want the value of the identity column of the first row as 10 and incremental value is 10,
you use the following syntax:IDENTITY (10,10)

*/

CREATE SCHEMA hr;

CREATE TABLE hr.person (
    person_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender CHAR(1) NOT NULL
);

INSERT INTO hr.person(first_name, last_name, gender)
VALUES('John','Doe', 'M');
--now  insert another row into the person table:
INSERT INTO hr.person(first_name, last_name, gender)
VALUES('Ranjith','Deva', 'M'),('hari','Ram', 'M')


select * from hr.person
--As you can see clearly from the output, the second row has the value of two in the person_id

/*V.Imp Note: 
SQL Server does not reuse the identity values. If you insert/delete a row into table and the insert statement is failed or rolled back,
then the identity sequence value will be lost and will not be generated again. This results in gaps in the identity column.
To fix this gaps either we can use  command (DBCC CHECKIDENT ('hr.person', RESEED, 1))
we need to truncate the table and reload the entire data.
*/

delete from hr.person where person_id =2

select * from hr.person

DBCC CHECKIDENT ('hr.person', RESEED, 1);--Using this we can ressed the Identity index from a certain row value

INSERT INTO hr.person(first_name, last_name, gender)
VALUES('Test','sandy', 'M');

select * from hr.person -- now the above row is inserted at person_id 2

-- we can also truncate the table and reinsert the data back again if we have all rows insert scripts
truncate table hr.person 
--delete from hr.person -- if we delete the table data we will not get the Identity sequence back.

--Now insert the data back gain we get the Identity sequence back again

INSERT INTO hr.person(first_name, last_name, gender)
VALUES('John','Doe', 'M');
--now  insert another row into the person table:
INSERT INTO hr.person(first_name, last_name, gender)
VALUES('Ranjith','Deva', 'M'),('hari','Ram', 'M')

select * from hr.person 

--drop table hr.person

-------------------------------------------------------------------------------------------------------------------------
/*08. SEQUENCES:
What is a sequence?
A sequence is simply a list of numbers, in which their orders are important. 
For example, the {1,2,3} is a sequence .
A sequence is a user-defined schema-bound object that generates a sequence of numbers according to a specified specification. 
A sequence of numeric values can be in ascending or descending order at a defined interval 

SYNTAX: 
CREATE SEQUENCE [schema_name.] sequence_name  
    [ AS integer_type ]  
    [ START WITH start_value ]  
    [ INCREMENT BY increment_value ]  
    [ { MINVALUE [ min_value ] } | { NO MINVALUE } ]  
    [ { MAXVALUE [ max_value ] } | { NO MAXVALUE } ]  
    [ CYCLE | { NO CYCLE } ]  
    [ { CACHE [ cache_size ] } | { NO CACHE } ];
	
*/
CREATE SEQUENCE sai AS INT
    START WITH 1
    INCREMENT BY 1;

SELECT NEXT VALUE FOR sai as sequence_count;

drop sequence sai 

SELECT * FROM sys.sequences;-- we can see all the sequences present in the current Database

--Where/How we can make use of sequences in our daily scripts?:

CREATE TABLE production.purchase_orders(
    order_id INT PRIMARY KEY,
    vendor_id int NOT NULL,
    order_date date NOT NULL
);
INSERT INTO production.purchase_orders
    (order_id,
    vendor_id,
    order_date)
VALUES
    (NEXT VALUE FOR sai,54678,'2019-04-30');

select * from production.purchase_orders
--drop table production.purchase_orders

--so we can observe that for a particular order_id column to get the sequential order ids we can make use of sequences
--Note we can also use same single sequence on multiple tables
----------------------------------------------------------------------------------------------------------------------
/*09. ALTER TABLE ALTER COLUMN:
SQL Server allows you to perform the following changes using alter command :
--Modify the data type of a column
--Change the size of the datatype for a column
--Add or modify the column constraint to a column */

CREATE TABLE table1 (col1 INT);
INSERT INTO table1 VALUES (1),(2),(3);
--Now lets modify the datatype of the column from int to varchar using alter as below
ALTER TABLE table1 ALTER COLUMN col1 VARCHAR (2);
INSERT INTO table1 VALUES ('Ranjith'),('Siva'),('Deva');--This will throw error as size given is only 2 chars
ALTER TABLE table1 ALTER COLUMN col1 VARCHAR (20);--changed size of the column to 20 char
INSERT INTO table1 VALUES ('Ranjith'),('Siva'),('Deva'); --This should work now
ALTER TABLE table1 ALTER COLUMN col1 VARCHAR (5);--This will throw error as the data in the column is of more size we cannot reduce the size of the column


--Add a NOT NULL constraint to a null column
CREATE TABLE table2 (col1 VARCHAR(50));
INSERT INTO table2 VALUES (1),(NULL),(NULL);--Now i have nulls in the table
select * from table2

--If you want to add the NOT NULL constraint to the column col1, you must update NULL to non-null some value first
UPDATE table2 SET col1 = 'Test' WHERE  col1 IS NULL;
--Now we can add the NOT NULL constraint to the table using alter
ALTER TABLE table2 ALTER COLUMN col1 VARCHAR (20) NOT NULL;

INSERT INTO table2 VALUES (2),(NULL),(NULL);--Now the column won't allow null as we have applied NOT NULL constraint
--drop table table2

----------------------------------------------------------------------------------------------------------------------------
--10.Alter Table to Add and  Drop Columns:
--Using Alter table  we can drop a particular column as shown below:

CREATE TABLE sales.quotations (
    quotation_no INT IDENTITY PRIMARY KEY,
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL
);

--Add new  column to a table
ALTER TABLE sales.quotations ADD description VARCHAR (255) NOT NULL;
--we can add multiple columns also at a time to the table
ALTER TABLE sales.quotations ADD amount DECIMAL (10, 2) NOT NULL,customer_name VARCHAR (50) NOT NULL;

--Drop one or more columns
ALTER TABLE sales.quotations DROP COLUMN description;
ALTER TABLE sales.quotations DROP COLUMN valid_from, valid_to;--multiple columns can also be dropped at a time
--drop table sales.quotations
-------------------------------------------------------------------------------------------------------------------------
/*--11: Computed/Calculated columns:
SQL Server provides us with a feature called computed columns that allows you to 
add a new column to a table with the value derived from the values of other columns in the same table.*/

CREATE TABLE persons
(
    person_id  INT PRIMARY KEY IDENTITY, 
    first_name NVARCHAR(100) NOT NULL, 
    last_name  NVARCHAR(100) NOT NULL,   
    dob        DATE
);


INSERT INTO 
    persons(first_name, last_name, dob)
VALUES
    ('John','Doe','1990-05-01'),
    ('Jane','Doe','1995-03-01');

select * from dbo.persons
--drop table dbo.persons

SELECT  person_id,first_name + ' ' + last_name AS full_name,dob
FROM    persons order by full_name  --This will just select and show the computed column data.

--To create a computed column physically we can use below code
ALTER TABLE persons ADD full_name1 AS (first_name + ' ' + last_name);

ALTER TABLE persons ADD age_in_years 
    AS (CONVERT(INT,CONVERT(CHAR(8),GETDATE(),112))-CONVERT(CHAR(8),dob,112))/10000;

--we can expand table in leftside section then expand columns.We can see 2 new columns created as computed columns 
-------------------------------------------------------------------------------------------------------------------
/*12.DROP TABLE:
--drop table table_name
--We can also drop multiple tables at a time as shown below*/
DROP TABLE IF EXISTS dbo.persons, procurement.supplier_groups;

--------------------------------------------------------------------------------------------------------------------
--13.TRUNCATE:

CREATE TABLE sales.customer_groups (
    group_id INT PRIMARY KEY IDENTITY,
    group_name VARCHAR (50) NOT NULL
);

INSERT INTO sales.customer_groups (group_name)
VALUES
    ('Intercompany'),
    ('Third Party'),
    ('One time');

select * from sales.customer_groups
--drop table sales.customer_groups

DELETE FROM sales.customer_groups where group_id =1;
TRUNCATE TABLE sales.customer_groups where group_id =1;--This will thow error we cannot filter a table using where in Truncate

--If the table truncated has an identity column,Identity counter for that column is reset to the seed value to zero.
--when data is deleted by the delete TABLE statement it will not reset the seed value.
--Truncate is faster than delete
--We cannot filter data and delete rows using truncate, Only Using delete we can filter an delete 
--Both Truncate and Delete will not remove the table structure only when we drop the table its structure get removed.
--They will only remove rows data

----------------------------------------------------------------------------------------------------------------------------
--14. SELECT INTO:   Mostly used to take a BACKUP of A TABLE

--To take entire table backup we can use below query 
SELECT * INTO sales.bckup FROM sales.orders;

--drop table sales.bckup
-- To take only certain filtered data backup into another table we can use below code as well.
SELECT  
    customer_id, 
    first_name, 
    last_name, 
    email
INTO sales.bckup2 FROM sales.customers WHERE  state = 'CA';

select * from sales.bckup

--drop table sales.bckup2
-----------------------------------------------------------------------------------------------------------------------
--15.Rename a table: we can do it two ways 
--1. EXEC sp_rename 2.From UI Go to table rt click and rename it directly 

CREATE TABLE sales.contr (
    contract_no INT IDENTITY PRIMARY KEY,
    start_date DATE NOT NULL,
    expired_date DATE,
    customer_id INT,
    amount DECIMAL (10, 2)
); 

--exec sp_rename 'schema.old_table_name', 'new_table_name'
EXEC sp_rename 'sales.contr', 'sales.contract';

select * from sales.contract

--drop table sales.contracts
--we can also rename tables from the UI by rt clicking on the table and then select rename

-----------------------------------------------------------------------------------------------------------------------------
--16.Creating temporary tables (Local,Global):
--SQL Server provided two ways to create temporary tables 1.  SELECT columns INTO TempTableName or using  2. CREATE TABLE statement
--The name of the temporary table starts with a hash symbol (#)
SELECT
    product_name,
    list_price
INTO #trek_products --- temporary table
FROM
    production.products
WHERE
    brand_id = 9;

--Now navigate to UI left side section System Databases>>tempdb>>TemporaryTables section 

--drop table #trek_products

--Create temparary tables using create statement

CREATE TABLE #localtemptable (
    product_name VARCHAR(MAX),
    list_price DEC(10,2)
);

INSERT INTO #localtemptable
values ('test',2400)


select * from #localtemptable

/*Global temporary tables
Sometimes, you may want to create a temporary table that is accessible across session tabs . In this case, you can use global temporary tables.

the name of a global temporary table starts with a double hash symbol (##).*/


CREATE TABLE ##Globaltemptable (
    product_name VARCHAR(MAX),
    list_price DEC(10,2)
);

INSERT INTO ##Globaltemptable
values('test1123', '5000')

select * from tempdb.#localtemptable

select * from tempdb.##Globaltemptable

--drop table tempdb.##Globaltemptable

--Now open a new session in another tab we cannot see the local temp table but we can see global temptable 

----------------------------------------------------------------------------------------------------------------------
/*
17.SYNONYM :
In SQL Server, a synonym is an alias or alternative name for a database object such as a table, view, stored procedure,
user-defined function, and sequence. 
*/

CREATE SYNONYM ranjith FOR sales.bckup;

SELECT * FROM ranjith;
--To Listing all the synonyms of the current database we can use below query
SELECT name, base_object_name, type FROM sys.synonyms ORDER BY name;
    
DROP SYNONYM IF EXISTS ranjith;

--******************************************************************************************************************************