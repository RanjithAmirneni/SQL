--******************************************************************************************************************************
/*
Module 2. SQL Server Data Types:

SQL Server data types – give you an overview of the built-in SQL Server data types.

BIT – store bit data i.e., 0, 1, or NULL in the database with the BIT data type.SQL Server converts a string value TRUE to 1 and FALSE to 0. It also converts any nonzero value to 1.
INT – learn about various integer types in SQL server including BIGINT(8 Bytes), INT(4 Bytes), SMALLINT(2 Bytes), and TINYINT(1 byte).
DECIMAL – By using DECIMAL or NUMERIC data type we store numbers that have fixed precision and scale.
CHAR – learn how to store fixed-length(1 to 8,000), non-Unicode character string in the database.
NCHAR –  show you how to store fixed-length(1,4000), Unicode character strings and Need 1 byte to store a char, need 2 bytes to store a nchar.
VARCHAR – store variable-length, non-Unicode string data of length that ranges from 1 to 8,000. If you don’t specify n, its default value is 1.
		- Used when data length is variable or variable length columns and if actual data is always way less than capacity
		- stores Non-unicode or English character data types, and it can contain a maximum of 8000 characters. It only supports ASCII values.
NVARCHAR – It store variable-length, Unicode string data string length that ranges from 1 to 4,000. If you don’t specify the string length, its default value is 1
	     - used only if you need Unicode support such as the Japanese Kanji or Korean Hangul characters.
		 -Unicode or Non-English character data types, and it can contain a maximum of 4000 characters. 
		 -It supports ASCII values as well as special characters.To support multiple languages

DATETIME– illustrate how to store both date and time data in a database.
DATETIME2 – illustrate how to store both date and time data in a database.
DATE – discuss the date data type and how to store the dates in the table.
TIME – show you how to store time data in the database by using the TIME data type.
DATETIMEOFFSET – show you how to manipulate datetime with the time zone.YYYY-MM-DDThh:mm:ss[.nnnnnnn][{+|-}hh:mm]

*/
------------------------------------------------------------------------------------------------------------------

--BIT datatype & CDate datatype:
CREATE TABLE production.datatypes (
    integer_col INT ,
	bit_col  BIT,
	char_col CHAR(4),
    varchar_col VARCHAR (50) NOT NULL,
    date_col DATETIMEOFFSET
);

INSERT INTO production.datatypes(integer_col,bit_col,char_col,varchar_col,Date_col )
VALUES(1, 'False' ,'ABCD', 'test', GETDATE()); 

select * from production.datatypes

delete from production.datatypes
drop table production.datatypes 

--DATETIMEOFFSET
SELECT *, 
  Date_col AT TIME ZONE 'Pacific Standard Time' AS 'Pacific Standard Time',
  Date_col AT TIME ZONE 'SE Asia Standard Time' AS 'SE Asia Standard Time'
FROM production.datatypes;

-----------------------------------------------------------------------------------------------------------------
--Integer data type:

CREATE TABLE production.sql_server_integers (
	bigint_col bigint,
	int_col INT,
	smallint_col SMALLINT,
	tinyint_col tinyint
);
INSERT INTO production.sql_server_integers (
	bigint_col,
	int_col,
	smallint_col,
	tinyint_col
)VALUES(9223372036854775809,
		2147483647,
		32767,
		255);
select * from production.sql_server_integers
drop table production.sql_server_integers

------------------------------------------------------------------------------------------------------------------
/*DecimalDataTypes:DECIMAL(p,s)
p is the precision which is the maximum total number of decimal digits that will be stored, 
both to the left and to the right of the decimal point. The precision has a range from 1 to 38. 
The default precision is 38.
s is the scale which is the number of decimal digits that will be stored to the right of the decimal point. 
The scale has a range from 0 to p (precision). 
The scale can be specified only if the precision is specified. By default, the scale is zero.
Precision	Storage bytes
1 – 9			5
10-19			9
20-28			13
29-38			17
*/

CREATE TABLE test.sql_server_decimal (
    dec_col DECIMAL (5, 2),
    num_col NUMERIC (5, 2)
);

INSERT INTO test.sql_server_decimal (dec_col, num_col)
VALUES(10.05, 20.05);

INSERT INTO test.sql_server_decimal (dec_col, num_col)
VALUES  (99.99677, 12.34678);


select * from test.sql_server_decimal 

INSERT INTO test.sql_server_decimal(dec_col, num_col)
VALUES(10000.05, 56777.99);

drop table test.sql_server_decimal  

--******************************************************************************************************************************
/*
Module 2. Constraints
1.Primary key  – explain you to the primary key concept and show you how to use the primary key constraint to manage a primary key of a table.
2.Foreign key – introduce you to the foreign key concept and show you use the FOREIGN KEY constraint to enforce the link of data in two tables.
3.NOT NULL constraint – show you how to ensure a column not to accept NULL.
4.UNIQUE constraint – ensure that data contained in a column, or a group of columns, is unique among rows in a table.
5.CHECK constraint – walk you through the process of adding logic for checking data before storing them in tables.
*/

--**************************************************************************************************************************************************************
/*
1. Primary key: 

A primary key is a column  that uniquely identifies each row in a table.
Each table can contain only one primary key. All columns that participate in the primary key must be defined as NOT NULL. 
SQL Server automatically sets the NOT NULL constraint for all the primary key columns if the NOT NULL constraint is not specified for these columns.
In SQL Server, a table can have only one primary key defined. The primary key is a constraint that uniquely identifies each record in the table and enforces data integrity by ensuring the uniqueness and non-nullability of the key column(s).
However, it is possible to have a composite primary key that consists of multiple columns. This means the primary key is defined on more than one column, creating a unique combination of values across those columns.
*/

--PK at column level
CREATE TABLE sales.activities (
    activity_id INT PRIMARY KEY IDENTITY,
    activity_name VARCHAR (255) NOT NULL,
    activity_date DATE NOT NULL
);

--Pk at table level for more than one column 

CREATE TABLE sales.participants(
    activity_id int,
    customer_id int,
    PRIMARY KEY(activity_id, customer_id)
);

--We can also define a PK after a table is created using alter

CREATE TABLE sales.events(
    event_id INT NOT NULL,
    event_name VARCHAR(255),
    start_date DATE NOT NULL,
    duration DEC(5,2)
);
INSERT INTO sales.events(event_id, event_name, start_date, duration)
VALUES(1,'function', GETDATE(), 10.02);


select * from sales.events

ALTER TABLE sales.events ADD PRIMARY KEY(event_id);

--drop table sales.activities

--------------------------------------------------------------------------------------------------------------------------------
/*
2. Foriegn Key Constraint:

-When a foreign key is defined in a table, it creates a relationship between two tables: 
the referencing table (also known as the child table) and the referenced table (also known as the parent table).
-The foreign key in the child table references the primary key in the parent table.
- By default, foreign keys can contain NULL values, indicating that the relationship is optional. 
  However, you can also enforce the foreign key to be NOT NULL, making the relationship mandatory.
- A foreign key can be defined on one or more columns in a table. If it involves multiple columns, 
  the combination of these columns in the child table must match the primary key columns' values in the parent table.
The foreign key column(s) in the child table contains values that correspond to the primary key column(s) in the parent table.
This establishes a link between the two tables.
*/



CREATE TABLE production.parent (
    emp_id INT IDENTITY PRIMARY KEY,
    emp_name VARCHAR (100) NOT NULL
);

CREATE TABLE production.child (
        dept_id INT IDENTITY PRIMARY KEY,
        dept_name VARCHAR(100) NOT NULL,
        emp_id INT NOT NULL,
);


/*With the current tables setup, you can insert a row into the  vendors table without a corresponding row in the parent table. 
Similarly, you can also delete a row in the parent table without updating or deleting the corresponding rows in the  child table
To enforce the link/relationhip between data in the parent table and child tables, you need to establish a foreign key in the child table.

*/

DROP TABLE production.child;

CREATE TABLE production.child (
        dept_id INT IDENTITY PRIMARY KEY,
        dept_name VARCHAR(100) NOT NULL,
        emp_id INT NOT NULL,
        CONSTRAINT fk_empid FOREIGN KEY (emp_id) 
        REFERENCES production.parent(emp_id)
);

/*Now production.parent table now is called the parent table that is the table to which the foreign key constraint references. 
The production.child table is called the child table that is the table to which the foreign key constraint is applied.
*/

INSERT INTO production.parent(emp_name)
VALUES('Ranjith'),
      ('Kailash Nadh'),
      ('Siva');

select * from production.parent
select * from production.child

INSERT INTO production.child(dept_name, emp_id)
VALUES('ABC Corp',1), ('ABC Corp',2), ('ABC Corp',3);

select * from production.child

--Now try to insert a new vendor whose vendor group does not exist in the vendor_groups table:
INSERT INTO production.child(dept_name, emp_id)
VALUES('XYZ Corp',3);--this will throw error

--The foreign key constraint ensures referential integrity. 
--It means that you can only insert a row into the child table if there is a corresponding row in the parent table.

INSERT INTO production.child(dept_name, emp_id)
VALUES('XYZ Corp',2);--this will work

select * from production.parent
select * from production.child

delete from production.parent where emp_id =2

drop table production.parent

drop table production.child

------------------------------------------------------------------------------------------------------------------------
/*
3. Not NULL Constraint:
*/
CREATE TABLE hr.persons(
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20)
);

INSERT INTO hr.persons(first_name, last_name,email,phone)
VALUES('siva','deva','ranjithamirneni@gmail.com', NULL),
('sam','ravi','teja@gmail.com', NULL)


select * from hr.persons

/*
By default, if you don’t specify the NOT NULL constraint, SQL Server will allow the column to accepts NULL. 
In this example, the phone column can accept NULL.

To add the NOT NULL constraint to an existing column,

First, update the table so there is no NULL in the column:
Second, alter the table to change the property of the column:

*/

UPDATE hr.persons SET phone = '(408) 123 4567' WHERE phone IS NULL;

ALTER TABLE hr.persons ALTER COLUMN phone VARCHAR(20) NOT NULL;--This will apply not null constraint

--drop table hr.persons 

INSERT INTO hr.persons(first_name, last_name,email,phone)
VALUES('siva','deva','ranjithamirneni@gmail.com', NULL),
('sam','ravi','teja@gmail.com', NULL)

--Remove the not null constraint
ALTER TABLE hr.persons ALTER COLUMN phone VARCHAR(20) NULL;

---------------------------------------------------------------------------------------------------------------------------------
/*
4.UNIQUE KEY CONSTRAINT:

*/

--column level unique key constraint
CREATE TABLE hr.persons(
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE
);

/*
Behind the scenes, SQL Server automatically creates a UNIQUE index to enforce the uniqueness of data stored in the columns that participate in the UNIQUE constraint. Therefore, if you attempt to insert a duplicate row, 
SQL Server rejects the change and returns an error message stating that the UNIQUE constraint has been violated.

*/

INSERT INTO hr.persons(first_name, last_name, email)
VALUES('John','Doe','j.doe@bike.stores');

INSERT INTO hr.persons(first_name, last_name, email) --This throws error Violation of unique key contraint
VALUES('Jane','Doe','j.doe@bike.stores');

/*Although both UNIQUE and PRIMARY KEY constraints enforce the uniqueness of data, 
you should use the UNIQUE constraint instead of PRIMARY KEY constraint when you want to enforce the uniqueness of a column, or a group of columns, that are not the primary key columns.

UNIQUE constraints allow one NULL in the column where as primiary key doesn't allow null . Moreover, 
UNIQUE constraints treat the NULL as a regular value, therefore, it only allows one NULL per column.

*/

INSERT INTO hr.persons(first_name, last_name, email) --This is allowed as its 1 st NULL
VALUES('Jane','Doe', NULL);

INSERT INTO hr.persons(first_name, last_name, email) --This throws error Violation of unique key contraint
VALUES('Jane','Doe', NULL);

-- Table level unique key constraints on multiple columns

CREATE TABLE hr.persons_skills(
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
	phone VARCHAR(20)
    UNIQUE(email,phone)
);

--We can also use alter command and add 

ALTER TABLE hr.persons_skills ADD CONSTRAINT unique_phone UNIQUE(phone); 


-- Delete UNIQUE constraints

ALTER TABLE hr.persons_skills DROP CONSTRAINT unique_phone;

--we does not have any direct statement to modify a UNIQUE constraint, therefore, 
--you need to drop the constraint first and recreate it if you want to change the constraint.

---------------------------------------------------------------------------------------------------------------------------
/*
5.CHECK CONSTRAINT:

*/

CREATE SCHEMA test;
GO

CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) CHECK(unit_price > 0)
);

select * from test.products


INSERT INTO test.products(product_name, unit_price)
VALUES ('Awesome Free Bike', 0);


INSERT INTO test.products(product_name, unit_price)
VALUES ('Awesome Free Bike', 500);


drop table test.products


CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2),
    discounted_price DEC(10,2),
    CHECK(unit_price > 0),
    CHECK(discounted_price > 0),
    CHECK(discounted_price > unit_price)
);

INSERT INTO test.products(product_name, unit_price, discounted_price)
VALUES ('Awesome Free Bike', 1, 2);
CK__products__3BFFE745,CK__products__discou__3B0BC30C,CK__products__unit_p__3A179ED3

INSERT INTO test.products(product_name, unit_price, discounted_price)
VALUES ('Awesome Free Bike', 600, 500);
--Now how to drop the contraints

--execute this command to see all the constraints
EXEC sp_help 'test.products';

--Drop each of the contraint using alter
ALTER TABLE test.products DROP CONSTRAINT CK__products__unit_p__3A179ED3 ;

--drop table test.products

--*******************************************************************************************************************************
/*
Table Relationships
1. One to one 
2. One to Many
3. Many to Many
*/

--1. one to one relationship:

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Address VARCHAR(100)
);

CREATE TABLE EmployeeDetails (
    EmployeeID INT PRIMARY KEY,
    PhoneNumber VARCHAR(15),
    Email VARCHAR(50),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);


-- Insert into Employee table
INSERT INTO Employee (EmployeeID, Name, Address)
VALUES (1, 'John Smith', '123 Main St'),
(2, 'Ranjith Kumar', '456 Main St'),
(3, 'Raghu Ram', '789 Main St');

-- Insert into EmployeeDetails table
INSERT INTO EmployeeDetails (EmployeeID, PhoneNumber, Email)
VALUES (1, '555-1234', 'johnsmith@example.com'),
(2, '765-9988', 'ranjith@example.com'),
(3, '445-7766', 'ragu@example.com');

select * from Employee

select * from EmployeeDetails

drop table Employee 
---------------------------------------------------------------------

--2. One to Many relationship:

CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    Name VARCHAR(50)
);

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

-- Insert into Department table
INSERT INTO Department (DepartmentID, Name)
VALUES (1, 'HR');

-- Insert into Employee table
INSERT INTO Employee (EmployeeID, Name, DepartmentID)
VALUES (1, 'Sai Teja', 1),
(2, 'Ranjith Kumar', 1),
(3, 'Siva', 1);

select * from department

select * from employee

drop table employee 
----------------------------------------------------------------------------
--3. Many to Many relationship:

CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(50)
);

CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    Name VARCHAR(50)
);

CREATE TABLE Enrollment (
    StudentID INT,
    CourseID INT,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Insert into Student table
INSERT INTO Student (StudentID, Name)
VALUES (1, 'Siva'),
(2, 'Ranjith'),
(3, 'Parameshwar');

-- Insert into Course table
INSERT INTO Course (CourseID, Name)
VALUES (1, 'datascience'),
(2, 'dataengineering'),
(3, 'cloud');

-- Insert into Enrollment table
INSERT INTO Enrollment (StudentID, CourseID)
VALUES (1, 1),(1, 2),(2, 1),(2,3),(3,2),(3,3);

select * from Student 
select * from  Course
select * from Enrollment

--drop table   Course


--********************************************************************************************************************************
