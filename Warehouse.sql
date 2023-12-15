-- Creating a database for a warehouse
-- Parker Ward

-- Create table Categories
CREATE TABLE Categories ( 
    CategoryID INT PRIMARY KEY, 
    CategoryName VARCHAR(255) NOT NULL, 
    Description TEXT, 
    Active BOOLEAN, 
    CreatedAt DATE 
); 


-- Insert values into categories
INSERT INTO Categories (CategoryID, CategoryName, Description, Active, CreatedAt) 
VALUES  (1, 'Electronics', 'Electronic devices and accessories', TRUE, '2023-01-01'), 
		(2, 'Clothing', 'Apparel and accessories', TRUE, '2023-01-02'), 
		(3, 'Furniture', 'Home and office furniture', TRUE, '2023-01-03'), 
		(4, 'Books', 'Educational and entertainment books', TRUE, '2023-01-04'), 
		(5, 'Groceries', 'Food items and essentials', TRUE, '2023-01-05'); 

  
-- Create table Products
CREATE TABLE Products ( 
    ProductID INT PRIMARY KEY, 
    ProductName VARCHAR(255) NOT NULL, 
    Price DECIMAL(10, 2) CHECK (Price > 0), 
    CategoryID INT, 
    StockQuantity INT, 
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) 

); 


-- Insert values into table Products
INSERT INTO Products (ProductID, ProductName, Price, CategoryID, StockQuantity)  
VALUES  (1, 'Smartphone', 299.99, 1, 50), 
		(2, 'Headphones', 49.99, 1, 100), 
		(3, 'T-Shirt', 19.99, 2, 150), 
		(4, 'Desk Chair', 89.99, 3, 30), 
		(5, 'Cooking Book', 24.99, 4, 70); 

  
-- Create table Inventory
CREATE TABLE Inventory ( 
    InventoryID INT PRIMARY KEY, 
    ProductID INT, 
    Quantity INT CHECK (Quantity >= 0), 
    LastUpdated DATE, 
    Location VARCHAR(255), 
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) 
); 


-- Insert values into table Inventory
INSERT INTO Inventory (InventoryID, ProductID, Quantity, LastUpdated, Location)  
VALUES  (1, 1, 50, '2023-11-01', 'Warehouse A'), 
		(2, 2, 100, '2023-11-01', 'Warehouse B'), 
		(3, 3, 150, '2023-11-02', 'Warehouse C'), 
		(4, 4, 30, '2023-11-02', 'Warehouse A'), 
		(5, 5, 70, '2023-11-03', 'Warehouse B'); 

  
-- Create table Customers
CREATE TABLE Customers ( 
    CustomerID INT PRIMARY KEY, 
    CustomerName VARCHAR(255) NOT NULL, 
    ContactEmail VARCHAR(255), 
    Address TEXT, 
    JoinDate DATE 
); 


-- Insert values into table Customers
INSERT INTO Customers (CustomerID, CustomerName, ContactEmail, Address, JoinDate)  
VALUES  (1, 'John Doe', 'johndoe@email.com', '123 Main St, Anytown', '2023-01-01'), 
		(2, 'Jane Smith', 'janesmith@email.com', '456 Elm St, Othertown', '2023-01-02'), 
		(3, 'Bob Johnson', 'bobjohnson@email.com', '789 Oak St, Thistown', '2023-01-03'), 
		(4, 'Alice Brown', 'alicebrown@email.com', '101 Pine St, Thatown', '2023-01-04'), 
		(5, 'Charlie Davis', 'charliedavis@email.com', '102 Maple St, Theothertown', '2023-01-05'); 

  
-- Create table Orders
CREATE TABLE Orders ( 
    OrderID INT PRIMARY KEY, 
    CustomerID INT, 
    OrderDate DATE NOT NULL, 
    TotalAmount DECIMAL(10, 2), 
    Status VARCHAR(50), 
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) 
); 


-- Insert values into table Orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, Status)  
VALUES  (1, 1, '2023-11-01', 349.98, 'Shipped'), 
		(2, 2, '2023-11-02', 69.98, 'Processing'), 
		(3, 3, '2023-11-03', 109.98, 'Delivered'), 
		(4, 4, '2023-11-04', 114.98, 'Cancelled'), 
		(5, 5, '2023-11-05', 44.98, 'Shipped'); 

 

--Q1 A simple query that pulls all columns and rows from a table 
SELECT * FROM Products; 

--Q2 A query that displays a subset of columns
SELECT ProductName, Price FROM Products; 

--Q3 A query that displays a subset of columns with a single clause WHERE statement
SELECT CustomerName, ContactEmail FROM Customers WHERE JoinDate >= '2023-01-03'; 

--Q4 A query that displays a subset of columns with a multi-clause WHERE statement using AND/OR
SELECT ProductName, Price, StockQuantity FROM Products WHERE Price > 20 AND StockQuantity < 100; 

--Q5 A query that performs a single table join.
SELECT Orders.OrderID, Customers.CustomerName, Orders.TotalAmount  
FROM Orders  
JOIN Customers ON Orders.CustomerID = Customers.CustomerID; 

--Q6 A query that performs a multi-table join
SELECT Orders.OrderID, Customers.CustomerName, Products.ProductName, Orders.TotalAmount  
FROM Orders  
JOIN Customers ON Orders.CustomerID = Customers.CustomerID  
JOIN Inventory ON Inventory.InventoryID = Orders.OrderID  
JOIN Products ON Inventory.ProductID = Products.ProductID; 

--Q7 A query that performs an aggregate
SELECT COUNT(*) AS TotalProducts FROM Products; 

--Q8 A query that performs an aggregate with a GROUP BY
SELECT CategoryID, AVG(Price) AS AveragePrice FROM Products GROUP BY CategoryID; 

--Q9 A query that performs an aggregate with a GROUP BY and a HAVING clause
SELECT CategoryID, SUM(StockQuantity) AS TotalStock  
FROM Products  
GROUP BY CategoryID  
HAVING SUM(StockQuantity) > 200; 

--Q10 A query that performs a subquery either as part of the WHERE clause or as a derived/virtual table
SELECT CustomerName  
FROM Customers  
WHERE CustomerID IN (SELECT CustomerID FROM Orders WHERE TotalAmount > 100); 

--Q11 A query that performs an aggregate with a join and a group by: 
SELECT Customers.CustomerName, SUM(Orders.TotalAmount) AS TotalSpent  
FROM Orders  
JOIN Customers ON Orders.CustomerID = Customers.CustomerID  
GROUP BY Customers.CustomerName; 

-- Creating a dynamic view for Query 4
CREATE VIEW ProductFilterView AS
SELECT ProductName, Price, StockQuantity
FROM Products
WHERE Price > 20 AND StockQuantity < 100;

-- Selecting from the created view
SELECT * FROM ProductFilterView;

-- Creating a dynamic view for Query 9
CREATE VIEW CategoryAveragePriceView AS
SELECT CategoryID, AVG(Price) AS AveragePrice
FROM Products
GROUP BY CategoryID;

---- Selecting from the created view
SELECT * FROM CategoryAveragePriceView;


  

  