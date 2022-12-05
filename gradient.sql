CREATE DATABASE Gradient

/*creating tables*/

CREATE TABLE Clients (
  ClientID int PRIMARY KEY IDENTITY(1,1),
  ClientName text,
  ClientBio text,
  Email varchar(255),
  Phone varchar(255)
);
GO

CREATE TABLE Employees (
  EmployeeID int PRIMARY KEY IDENTITY(1,1),
  LastName varchar(255),
  FirstName varchar(255)
);
GO

CREATE TABLE Orders (
    OrderID int IDENTITY(1,1) PRIMARY KEY,
    OrderLocation text,
    OrderComment text,
    OrderState varchar(255) NOT NULL,
    OrderDateStart datetime NOT NULL,
    OrderDateEnd datetime,
    PayCheckType varchar(255),
    PaySum money,
    PaySumAfterStateTax money,
    CONSTRAINT FK_ClientID FOREIGN KEY (ClientID) REFERENCES Clients (ClientID)
);
GO



CREATE TABLE EmployeesWorkDay (
    EmployeeID int,
    OrderID int,
    CONSTRAINT FK_EmployeeID FOREIGN KEY (EmployeeID) REFERENCES Employees (EmployeeID),
    CONSTRAINT FK_OrderID FOREIGN KEY (OrderID) REFERENCES Orders (OrderID)
);
GO

CREATE TABLE EquipmentInStock (
  EquipmentID int PRIMARY KEY IDENTITY(1,1),
  EquipmentPieceName varchar(255),
  EquipmentDescription text,
);
GO

CREATE TABLE OrderedEquipment (
  EquipmentID int,
  OrderID int,
  CONSTRAINT FK_EquipmentID FOREIGN KEY (EquipmentID) REFERENCES EquipmentInStock (EquipmentID),
  CONSTRAINT FK_OrderID2 FOREIGN KEY (OrderID) REFERENCES Orders (OrderID),
);
GO

/*3 triggers*/
/*Subtract state tax*/
CREATE TRIGGER AfterStateTax
ON Orders
AFTER INSERT, UPDATE AS
	UPDATE Orders
    SET PaySumAfterStateTax = PaySum * 0.9515 WHERE OrderID = (
	SELECT TOP 1 OrderID FROM Orders
	ORDER BY OrderID DESC)

/*email the boss about a new order*/
CREATE TRIGGER Reminder  
ON Orders  
AFTER INSERT
AS  
   EXEC msdb.dbo.sp_send_dbmail  
        @profile_name = 'Gradient Administrator',  
        @recipients = 'GradientAlerts@gmail.com',  
        @body = 'A new order has been added! Check out the website for denial/approval',  
        @subject = 'New Order';  

/*email about update in an order*/
CREATE TRIGGER Reminder2  
ON Orders  
AFTER UPDATE
AS  
   EXEC msdb.dbo.sp_send_dbmail  
        @profile_name = 'Gradient Administrator',  
        @recipients = 'GradientAlerts@gmail.com',  
        @body = 'An Order has been updated! Check out the website for denial/approval',  
        @subject = 'New Order';  


/*Inserting data*/

INSERT INTO Employees (FirstName, LastName) VALUES ('Mason', 'Cottam'),
    ('Daniil', 'Kiselev'),
    ('Gage', 'Pectol'),
    ('Dummy', 'Worker1'),
    ('Dummy', 'Worker2'),
    ('Dummy', 'Worker3'),
    ('Dummy', 'Worker4'),
    ('Dummy', 'Worker5'),
    ('Dummy', 'Worker6'),
    ('Dummy', 'Worker7');
GO



INSERT INTO Clients (ClientName, ClientBio, Email, Phone) VALUES 
    ('Harry', 'Sand Hollow Resort', 'sandhollow@gmail.com', 4351666675),
    ('Joshua', 'Cedar City Town Hall', 'cedarhall@yahoo.com', NULL),
    ('Claire', 'Diamond Z Arena', 'Claire@gmail.com', 4357661284),
    ('Roxanne', 'St. George Central Park', NULL, 4357884621),
    ('Darwin', 'SUU', 'events@suu.edu', 485765124),
    ('Lexi', 'UTU', 'events@utu.edu', 457884425),
    ('Jared', 'Main Street Park - Cedar City', 'mainparkcedar@gmail.com', 578445813),
    ('Charlie', 'ICAMA', NULL, 4357884512),
    ('Layla', 'Brian Head Resort', 'brianheadresort@gmail.com', 487596312),
    ('Danny', 'Iron Springs', 'ironspringsmail@gmail.com', 43527895),
    ('Douglas', 'St. George Music Rental Company', NULL, NULL),
    ('Rick', 'Springdale', 'rickproduction@gmail.com', 8014987531);
GO

INSERT INTO Orders (ClientID, OrderLocation, OrderComment, OrderState, OrderDateStart, OrderDateEnd, PayCheckType, PaySum) VALUES
    (3, 'Diamond Z Arena', 'Small system to run a party of 150 in Cedar City', 'Approved', '2022-12-1 12:00:00', '2022-12-1 15:00:00', 'Invoice', 3000.00),
    (11, 'Springdale, Utah', 'A 3 day festival rig in Springdale', 'Approved', '2022-12-2 7:00:00', '2022-12-4 23:00:00', 'Cash', 10000.00),
    (8, 'Brian Head', 'A show for skiers in a restaurant', 'Approved', '2022-12-5 8:00:00', '2022-12-5 15:00:00', 'Invoice', 500.00),
    (11, 'Springdale', 'Zion Canyon Music Festival', 'Approved', '2022-12-5 6:00:00', '2022-12-8 20:00:00', 'Invoice', 8000.00),
    (6, 'Cedar City', 'Music in the park', 'Pending', '2023-1-5 9:00:00', '2023-1-6 18:00:00', 'Invoice', 4000.00),
    (10, 'St. George', 'Marathon sound system', 'Pending', '2023-2-5 4:00:00', '2023-2-5 9:00:00', 'Cash', 0),
    (1, 'Chillys', 'lounge music in the background for a party', 'Pending', '2023-2-7 10:00:00', '2023-2-7 15:00:00', 'Cash', 300.00),
    (8, 'Brian Head', 'Weekly 3-band show', 'Approved', '2023-2-6 6:00:00', '2023-2-6 23:00:00', 'Invoice', 1500.00),
    (8, 'Brian Head', 'Weekly 3-band show', 'Approved', '2023-2-12 6:00:00', '2023-2-12 23:00:00', 'Invoice', 1500.00),
    (8, 'Brian Head', 'Weekly 3-band show', 'Approved', '2023-3-10 6:00:00', '2023-2-10 23:00:00', 'Invoice', 1500.00),
    (1, 'Sand Hollow', 'A local artist performance, soundcheck at noon', 'Approved', '2023-1-10 8:00:00', '2023-1-10 23:00:00', 'Invoice', 2000.00);
GO

INSERT INTO EmployeesWorkDay (EmployeeID, OrderID) VALUES
  (1, 1),
  (2, 1),
  (2, 2),
  (1, 3),
  (2, 4),
  (3, 5),
  (5, 6),
  (6, 7),
  (7, 8),
  (2, 8),
  (9, 9),
  (1, 10);
GO


INSERT INTO EquipmentInStock (EquipmentPieceName, EquipmentDescription) VALUES 
  ('shure_sm58', 'Wired vocal microphone'),
  ('shure_sm58', 'Wired vocal microphone'),
  ('shure_sm58', 'Wired vocal microphone'),
  ('shure_sm58', 'Wired vocal microphone'),
  ('shure_sm58', 'Wired vocal microphone'),
  ('shure_sm57', 'Wired instrument microphone'),
  ('shure_sm57', 'Wired instrument microphone'),
  ('shure_sm57', 'Wired instrument microphone'),
  ('shure_sm57_beta', 'Wired instrument microphone'),
  ('shure_sm57_beta', 'Wired instrument microphone'), /*10*/
  ('dbtechnologies_line_array', 'A line array module, takes XLR input, needs a neutrik power plug'),
  ('dbtechnologies_line_array', 'A line array module, takes XLR input, needs a neutrik power plug'),
  ('dbtechnologies_line_array', 'A line array module, takes XLR input, needs a neutrik power plug'),
  ('dbtechnologies_line_array', 'A line array module, takes XLR input, needs a neutrik power plug'),
  ('dbtechnologies_line_array', 'A line array module, takes XLR input, needs a neutrik power plug'),
  ('dbtechnologies_line_array', 'A line array module, takes XLR input, needs a neutrik power plug'),
  ('dbtechnologies_line_array', 'A line array module, takes XLR input, needs a neutrik power plug'),
  ('dbtechnologies_line_array', 'A line array module, takes XLR input, needs a neutrik power plug'),
  ('ev_xline_subwoofer', 'A passive subwoofer, 2x18'),
  ('ev_xline_subwoofer', 'A passive subwoofer, 2x18'), /*20*/
  ('ev_xline_subwoofer', 'A passive subwoofer, 2x18'),
  ('ev_xline_subwoofer', 'A passive subwoofer, 2x18'),
  ('ev_xline_subwoofer', 'A passive subwoofer, 2x18'),
  ('ev_xline_subwoofer', 'A passive subwoofer, 2x18'),
  ('ev_amplifier', 'Each amp can power up to 3 EV XLine Subwoofers'),
  ('ev_amplifier', 'Each amp can power up to 3 EV XLine Subwoofers'),
  ('qsc_speaker', 'A monitor speaker made by QSC, can be used on poles'),
  ('qsc_speaker', 'A monitor speaker made by QSC, can be used on poles'),
  ('midas_m32', 'Mixing console'),
  ('ev_evolve_30m', 'Medium Speaker'), /*30*/
  ('ev_evolve_30m', 'Medium Speaker');
GO


INSERT INTO OrderedEquipment (OrderID, EquipmentID) VALUES 
  (1, 27),
  (1, 28),
  (1, 1),
  (1, 2),
  (2, 11),
  (2, 12),
  (2, 13),
  (2, 14),
  (2, 15),
  (2, 16),
  (2, 17),
  (2, 18),
  (2, 1),
  (2, 2),
  (2, 3),
  (2, 4),
  (2, 5),
  (2, 6),
  (2, 7),
  (2, 19),
  (2, 20),
  (2, 21),
  (2, 22),
  (2, 23),
  (2, 24),
  (2, 25),
  (2, 26),
  (3, 27),
  (3, 28),
  (3, 1),
  (3, 2),
  (4, 11),
  (4, 12),
  (4, 13),
  (4, 14),
  (4, 15),
  (4, 16),
  (4, 17),
  (4, 18),
  (4, 1),
  (4, 2),
  (4, 3),
  (4, 4),
  (4, 5),
  (4, 6),
  (4, 7),
  (4, 19),
  (4, 20),
  (4, 21),
  (4, 22),
  (4, 23),
  (4, 24),
  (4, 25),
  (4, 26),
  (5, 11),
  (5, 12),
  (5, 13),
  (5, 14),
  (5, 15),
  (5, 16),
  (5, 17),
  (5, 18),
  (5, 1),
  (5, 2),
  (5, 3),
  (5, 4),
  (5, 5),
  (5, 6),
  (5, 7),
  (5, 19),
  (5, 20),
  (5, 21),
  (5, 22),
  (5, 23),
  (5, 24),
  (5, 25),
  (5, 26),
  (6, 30),
  (6, 31),
  (6, 1),
  (6, 2),
  (7, 30),
  (7, 31),
  (7, 1),
  (7, 2),
  (8, 11),
  (8, 12),
  (8, 13),
  (8, 14),
  (8, 15),
  (8, 16),
  (8, 17),
  (8, 18),
  (8, 1),
  (8, 2),
  (8, 3),
  (8, 4),
  (8, 5),
  (8, 6),
  (8, 7),
  (8, 19),
  (8, 20),
  (8, 21),
  (8, 22),
  (8, 23),
  (8, 24),
  (8, 25),
  (8, 26),
  (9, 11),
  (9, 12),
  (9, 13),
  (9, 14),
  (9, 15),
  (9, 16),
  (9, 17),
  (9, 18),
  (9, 1),
  (9, 2),
  (9, 3),
  (9, 4),
  (9, 5),
  (9, 6),
  (9, 7),
  (9, 19),
  (9, 20),
  (9, 21),
  (9, 22),
  (9, 23),
  (9, 24),
  (9, 25),
  (9, 26),
  (10, 11),
  (10, 12),
  (10, 13),
  (10, 14),
  (10, 15),
  (10, 16),
  (10, 17),
  (10, 18),
  (10, 1),
  (10, 2),
  (10, 3),
  (10, 4),
  (10, 5),
  (10, 6),
  (10, 7),
  (10, 19),
  (10, 20),
  (10, 21),
  (10, 22),
  (10, 23),
  (10, 24),
  (10, 25),
  (10, 26);
GO

/*dates when a particular employee (ID #1) is booked by a specified client (ID #8)*/
SELECT Orders.OrderID, Orders.OrderDateStart, Orders.OrderDateEnd, Employees.EmployeeID, Clients.ClientID FROM EmployeesWorkDay
  JOIN Orders ON Orders.OrderID = EmployeesWorkDay.OrderID 
  JOIN Employees ON Employees.EmployeeID = EmployeesWorkDay.EmployeeID 
  JOIN Clients ON Clients.ClientID = Orders.ClientID
  WHERE Employees.EmployeeID = 1 AND Clients.ClientID = 8;

/*past orders of a client with an ID of 3*/
SELECT * FROM Orders
WHERE ClientID = 3 AND OrderDateEnd <  CURRENT_TIMESTAMP;

/*Orders of ClientID #11 that involve a particular microphone EquipmentID #1*/
SELECT Orders.*, EquipmentInStock.EquipmentPieceName, OrderedEquipment.EquipmentID FROM Orders
  JOIN OrderedEquipment ON Orders.OrderID = OrderedEquipment.OrderID
  JOIN EquipmentInStock ON EquipmentInStock.EquipmentID = OrderedEquipment.EquipmentID
WHERE OrderedEquipment.EquipmentID = 1 AND ClientID = 1;

/*a number of orders next year*/
SELECT COUNT(OrderDateStart) as NumberOfOrdersNextYear FROM Orders
WHERE OrderDateStart > CURRENT_TIMESTAMP AND OrderDateStart < DATEADD(year, 1, CURRENT_TIMESTAMP);

/*company's income this year so far*/
SELECT SUM(PaySum) as LastYearsIncome FROM Orders
WHERE OrderDateStart < CURRENT_TIMESTAMP;

/*an employee that worked the most*/
SELECT TOP 1 EmployeeID,
  COUNT(EmployeeID) as EmployeeCount
  FROM EmployeesWorkDay
  GROUP BY EmployeeID
  ORDER BY EmployeeCount DESC;

/*the most used piece of equipment*/
SELECT TOP 1 OrderedEquipment.EquipmentID, COUNT(OrderedEquipment.EquipmentID) as TimesUsed FROM OrderedEquipment 
  JOIN EquipmentInStock ON EquipmentInStock.EquipmentID = OrderedEquipment.EquipmentID
  GROUP BY OrderedEquipment.EquipmentID
  ORDER BY TimesUsed DESC;

/*top 5 dates that have multiple events happening at once*/
SELECT TOP 5 FORMAT(OrderDateStart, 'yy.MM.dd') as EventsDate,
	COUNT(FORMAT(OrderDateStart, 'yy.MM.dd')) as NumberInADay
	FROM Orders
	GROUP BY FORMAT(OrderDateStart, 'yy.MM.dd')
	ORDER BY NumberInADay DESC;

/*top 5 events that need more than one technician*/
SELECT TOP 5 OrderID,
	COUNT(EmployeeID) as NumberOFTechnicians
	FROM EmployeesWorkDay
	GROUP BY OrderID
	ORDER BY NumberOFTechnicians DESC;

/*a new table with monthly income*/
CREATE TABLE MonthlyIncome(
  MonthlyCheck money,
  Monthly datetime,
);

INSERT INTO MonthlyIncome 
SELECT SUM(PaySum) as LastMonthsIncome, CURRENT_TIMESTAMP as Monthly FROM Orders
WHERE OrderDateStart < CURRENT_TIMESTAMP AND OrderDateStart > DATEADD(month, -1, CURRENT_TIMESTAMP);


/*new scenarios*/
/*adding a birthday column and a value into it*/
ALTER TABLE Employees
ADD Birthday date;
GO

UPDATE Employees
SET Birthday = '2001-05-16' WHERE Employees.FirstName = 'Daniil';
GO

/*removing an employee's data*/
UPDATE Employees 
SET FirstName = NULL, LastName = NULL
WHERE FirstName = 'Worker1';

/*3 views*/
/*Accountant's view*/
CREATE VIEW AccountingView WITH SCHEMABINDING AS
SELECT Orders.OrderID, Orders.PaySum, EmployeesWorkDay.EmployeeID, Employees.FirstName, Employees.LastName,
Orders.OrderLocation, Orders.OrderComment, Orders.OrderState, Orders.PayCheckType, 
Clients.ClientName, Clients.ClientBio, Clients.Email, Clients.Phone FROM Orders
JOIN EmployeesWorkDay ON EmployeesWorkDay.OrderID = Orders.OrderID 
JOIN Employees ON Employees.EmployeeID = EmployeesWorkDay.EmployeeID
JOIN Clients ON Orders.ClientID = Clients.ClientID

SELECT * FROM AccountingView;

/*Warehouse view*/
CREATE VIEW WarehouseView AS
SELECT * FROM EquipmentInStock;
GO

SELECT * FROM WarehouseView;

/*Employee's View*/
CREATE VIEW EmployeeView AS
SELECT Employees.FirstName, Employees.LastName, Orders.OrderDateStart, Orders.OrderDateEnd, Orders.OrderLocation as Location, Orders.OrderComment, Clients.ClientName, Clients.Phone
FROM Employees
JOIN EmployeesWorkDay ON EmployeesWorkDay.EmployeeID = Employees.EmployeeID
JOIN Orders ON EmployeesWorkDay.OrderID = Orders.OrderID
JOIN Clients ON Orders.ClientID = Clients.ClientID;

SELECT * FROM EmployeeView ORDER BY OrderDateStart
SELECT * FROM EmployeeView WHERE FirstName = 'Daniil';


/*3 procedures*/
/*A sum of paychecks based on two dates revenue*/
CREATE PROCEDURE SumBetweenTwoDates @dateStart date, @dateEnd date AS
  SELECT SUM(PaySum) AS Income, @dateStart as DateStart, @dateEnd as DateEnd FROM Orders
  WHERE OrderDateStart > @dateStart AND OrderDateEnd < @dateEnd;

EXEC SumBetweenTwoDates @dateStart = '2022-12-04', @dateEnd = '2023-12-01';

/*A show that paid the most within the given time period*/
CREATE PROCEDURE MostPayingShow @dateStart date, @dateEnd date AS
  SELECT TOP 1 PaySum, PayCheckType, Orders.ClientID, Clients.ClientName, OrderLocation, OrderComment, Employees.FirstName, Employees.LastName FROM Orders
  JOIN EmployeesWorkDay ON Orders.OrderID = EmployeesWorkDay.OrderID
  JOIN Employees ON EmployeesWorkDay.EmployeeID = Employees.EmployeeID
  JOIN Clients ON Clients.ClientID = Orders.OrderID
  WHERE OrderDateStart > @dateStart AND OrderDateEnd < @dateEnd;

EXEC MostPayingShow @dateStart = '2022-12-04', @dateEnd = '2023-12-01';
/*A client that had the most orders within the given time period*/
CREATE PROCEDURE MostFrequesntClient @dateStart date, @dateEnd date AS
  SELECT TOP 1 Orders.ClientID, COUNT(Orders.ClientID) as NumberOfOrders FROM Orders
  WHERE Orders.OrderDateStart > @dateStart AND Orders.OrderDateEnd < @dateEnd
  GROUP BY Orders.ClientID
  ORDER BY NumberOfOrders DESC

EXEC MostFrequesntClient @dateStart = '2021-1-04', @dateEnd = '2024-12-01';

/*2 logins*/
CREATE LOGIN Administrator WITH PASSWORD = 'pasScode435%'
MUST_CHANGE, CHECK_EXPIRATION = ON

CREATE USER Administrator
FOR LOGIN Administrator

CREATE LOGIN Accountant WITH PASSWORD = 'pa5sc0deMuSTChange*'
MUST_CHANGE, CHECK_EXPIRATION = ON

CREATE USER Accountant FOR LOGIN Accountant

CREATE LOGIN Employee1 WITH PASSWORD = 'passccc0deMuSTTTChange*'
MUST_CHANGE, CHECK_EXPIRATION = ON

CREATE USER Employee1 FOR LOGIN Employee1

/*granting permissions*/
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES, ALTER 
TO Administrator

GRANT SELECT, REFERENCES 
TO Accountant 

GRANT SELECT, REFERENCES 
TO Employee1 
