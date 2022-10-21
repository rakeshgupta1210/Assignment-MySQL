/* Table 1: SalesPeople
Snum is Primary key
Sname is Unique constraint
Snum Sname City Comm
1001 Peel. London .12
1002  Serres Sanjose .13
1004 Motika London .11
1007 Rifkin Barcelona .15
1003 Axelrod Newyork .10*/

CREATE DATABASE edyoda_assignmt_db;


USE edyoda_assignmt_db;

CREATE TABLE SalesPeople(
    Snum INT,
    Sname VARCHAR(255),
    City VARCHAR(255),
    Comm FLOAT(5, 2),
    PRIMARY KEY (Snum),
    UNIQUE (Sname)
);

INSERT INTO SalesPeople
    VALUES
    (1001, "Peel.", "London", 0.12),
    (1002, "Serres", "Sanjose", 0.13),
    (1004, "Motika", "London", 0.11),
    (1007, "Rifkin", "Barcelona", 0.15),
    (1003, "Axelrod", "Newyork", 0.10);

/*Table 2: Customers
Cnum is Primary Key
City has not null constraint .
Snum is foreign key constraint refers Snum column of SalesPeople table.
Cnum Cname City Snum
2001  Hoffman London 1001
2002  Giovanni Rome 1003
2003  Liu Sanjose 1002
2004  Grass Berlin 1002
2006 Clemens London 1001
2008 Cisneros Sanjose 1007
2007 Pereira Rome 1004*/

CREATE TABLE Customers(
    Cnum INT,
    Cname VARCHAR(255),
    City VARCHAR(255) NOT NULL,
    Snum INT,
    PRIMARY KEY (Cnum),
    FOREIGN KEY (Snum) REFERENCES SalesPeople(Snum)
);

INSERT INTO Customers
    VALUES
    (2001, "Hoffman", "London", 1001),
    (2002, "Giovanni", "Rome", 1003),
    (2003, "Liu", "Sanjose", 1002),
    (2004, "Grass", "Berlin", 1002),
    (2006, "Clemens", "London", 1001),
    (2008, "Cisneros", "Sanjose", 1007),
    (2007, "Pereira", "Rome", 1004);

/*Table 3: Orders
Onum is Primary key
Cnum is foreign key refers to Cnum column of Customers table. Snum is foreign key refers Snum column of SalesPeople table.
Onum Amt Odate Cnum Snum
3001 18.69 3-10-1990 2008 1007
3003 767.19 3-10-1990 2001 1001
3002 1900.10 3-10-1990 2007 1004
3005  5160.45 3-10-1990 2003 1002
3006  1098.16 3-10-1990 2008 1007
3009 1713.23 4-10-1990 2002 1003
3007  75.75 4-10-1990 2004 1002
3008  4273.00 5-10-1990 2006 1001
3010  1309.95 6-10-1990 2004 1002
3011  9891.88 6-10-1990 2006 1001 */

CREATE TABLE Orders(
    Onum INT,
    Amt FLOAT(10, 2),
    Odate DATETIME,
    Cnum INT,
    Snum INT,
    PRIMARY KEY (Onum),
    FOREIGN KEY (Cnum) REFERENCES Customers(Cnum),
    FOREIGN KEY (Snum) REFERENCES SalesPeople(Snum)
);

INSERT INTO Orders
    VALUES
    (3001, 18.69, "1990-10-03 00:00:00", 2008, 1007),
    (3003, 767.19, "1990-10-03 00:00:00", 2001, 1001),
    (3002, 1900.10, "1990-10-03 00:00:00", 2007, 1004),
    (3005, 5160.45, "1990-10-03 00:00:00", 2003, 1002),
    (3006, 1098.16, "1990-10-03 00:00:00", 2008, 1007),
    (3009, 1713.23, "1990-10-04 00:00:00", 2002, 1003),
    (3007, 75.75, "1990-10-04 00:00:00", 2004, 1002),
    (3008, 4273.00, "1990-10-05 00:00:00", 2006, 1001),
    (3010, 1309.95, "1990-10-06 00:00:00", 2004, 1002),
    (3011, 9891.88, "1990-10-06 00:00:00", 2006, 1001);


-- On the basis of above tables perform given below questions

--  Count the number of Salesperson whose name begin with ‘a’/’A’.
SELECT COUNT(*) FROM SalesPeople WHERE Sname LIKE "A%";
/* +----------+
| COUNT(*) |
+----------+
|        1 |
+----------+ */

--  Display all the Salesperson whose all orders worth is more than Rs. 2000.
SELECT * FROM SalesPeople WHERE Snum IN 
    (SELECT Snum FROM Orders WHERE Amt > 2000 GROUP BY Snum);
/* +------+--------+---------+------+
| Snum | Sname  | City    | Comm |
+------+--------+---------+------+
| 1001 | Peel.  | London  | 0.12 |
| 1002 | Serres | Sanjose | 0.13 |
+------+--------+---------+------+ */

--  Count the number of Salesperson belonging to Newyork.
SELECT Count(*) AS Count_Salesperson_NY FROM SalesPeople WHERE City = "Newyork";
/* +----------------------+
| Count_Salesperson_NY |
+----------------------+
|                    1 |
+----------------------+ */

--  Display the number of Salespeople belonging to London and belonging to Paris.
SELECT Count(*) AS Count_Salesperson_Lon_Par FROM SalesPeople WHERE City IN ("London", "Paris");

-- Display the number of orders taken by each Salesperson and their date of orders.
/* SELECT col1, col2, ..., colN
GROUP_CONCAT ( [DISTINCT] col_name1 
[ORDER BY clause]  [SEPARATOR str_val] ) 
FROM table_name GROUP BY col_name2; */


SELECT Snum, COUNT(*) AS Num_Orders, GROUP_CONCAT(DATE(Odate)) AS "ODates"  FROM Orders GROUP BY Snum;
/* +------+------------+----------------------------------+
| Snum | Num_Orders | ODates                           |
+------+------------+----------------------------------+
| 1001 |          3 | 1990-10-03,1990-10-05,1990-10-06 |
| 1002 |          3 | 1990-10-03,1990-10-04,1990-10-06 |
| 1003 |          1 | 1990-10-04                       |
| 1004 |          1 | 1990-10-03                       |
| 1007 |          2 | 1990-10-03,1990-10-03            |
+------+------------+----------------------------------+ */