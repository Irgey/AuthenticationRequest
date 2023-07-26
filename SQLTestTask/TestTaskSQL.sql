--1. Create a query that returns values from the Name and Notes columns for all contacts where the value in the Age column is greater than 3 (assuming that there are concurrent insert and update queries being executed, and our data retrieval query should not be blocked by these insert/update operations).

BEGIN TRANSACTION;

SELECT Name, Notes
FROM [Creatio].[dbo].[Contact] c WITH (UPDLOCK) -- Використовуємо оптимістичне блокування UPDLOCK
WHERE Age > 3;

COMMIT TRANSACTION;


--2. Optimize the query from step 1 to utilize a non-clustered index for data retrieval. Display the execution time, IO operations, and the execution plan of the query.

CREATE NONCLUSTERED INDEX IX_Contacts_Age
ON [Creatio].[dbo].[Contact] (Age);

SET STATISTICS TIME ON; -- Показати статистику про час виконання запиту
SET STATISTICS IO ON; -- Показати статистику про операції вводу/виводу

BEGIN TRANSACTION;

SELECT *
FROM [Creatio].[dbo].[Contact] c WITH (UPDLOCK) -- Використовуємо оптимістичне блокування UPDLOCK
WHERE Age > 3;

COMMIT TRANSACTION;

SET STATISTICS TIME OFF; -- Вимкнути статистику про час виконання запиту
SET STATISTICS IO OFF; -- Вимкнути статистику про операції вводу/виводу


--3. Select the names of all contacts and their associated accounts (related by the AccountId column, with the related table being Account) where the AccountId column is populated.

SELECT c.name, c.AccountId
FROM [Creatio].[dbo].[Contact] c
INNER JOIN [Creatio].[dbo].[Account] a ON c.AccountId = a.Id

--4. Select all contacts whose names start with the word "iri".

SELECT *
FROM [Creatio].[dbo].[Contact] c
WHERE c.name LIKE 'iri%';


--5. Display information about the name and maximum age (Age column) of contacts where the maximum age is less than 25.

Select name, MAX(age)
FROM [Creatio].[dbo].[Contact]
GROUP BY name
HAVING MAX(age) < 25;

--6. When dealing with larger volumes of data, the query from step 5 may become a heavy operation for the server. It is necessary to optimize the query using an index. Display the statistics (time + IO operations) for the query and the execution plan before creating the index and after creating the index.

DROP INDEX IX_Contacts_Age
ON [Creatio].[dbo].[Contact];

SET STATISTICS TIME ON; -- Показати статистику про час виконання запиту
SET STATISTICS IO ON; -- Показати статистику про операції вводу/виводу


Select name, MAX(age)
FROM [Creatio].[dbo].[Contact]
GROUP BY name
HAVING MAX(age) < 25;


CREATE NONCLUSTERED INDEX IX_Contacts_Age
ON [Creatio].[dbo].[Contact] (Age);


Select name, MAX(age)
FROM [Creatio].[dbo].[Contact]
GROUP BY name
HAVING MAX(age) < 25;



SET STATISTICS TIME OFF; -- Вимкнути статистику про час виконання запиту
SET STATISTICS IO OFF; -- Вимкнути статистику про операції вводу/виводу

--7. Display the names of contacts that were created in the year 2019 (CreatedOn column).
SELECT Name
FROM [Creatio].[dbo].[Contact]
WHERE YEAR(CreatedOn) = 2019;

--8. Count the number of contacts where the AccountId column is populated and the Notes column contains the word "test" or the age is less than 40.
SELECT count(AccountId)
FROM [Creatio].[dbo].[Contact]
WHERE AccountId IS NOT NULL
AND (Notes LIKE '%test%' OR Age < 40);

--9. In the SysSchema table, there is a column called MetaData of type varbinary. You need to find the record with Id 379B0E78-9332-4AD5-A7A1-C8C14CBE031B and display the decrypted text stored in the MetaData column using Management Studio tools (an online varbinary decoder won't be suitable).
SELECT CONVERT(VARCHAR(MAX), MetaData, 0) AS DecodedText, MetaData
FROM [Creatio].[dbo].[SysSchema]
WHERE Id = '379B0E78-9332-4AD5-A7A1-C8C14CBE031B'



--10. Create a trigger that logs the current date/time of creating a new record in the Contact table. The logging table should include the current date and time of creation, the name, and the ID of the created contact.
CREATE TABLE [Creatio].[dbo].[ContactLog] (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    CreatedDateTime DATETIME,
    ContactName NVARCHAR(255),
    ContactID UNIQUEIDENTIFIER
);
--creating a triiger for Contact table
USE [Creatio]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER tr_Contact_Insert
ON Contact
AFTER INSERT
AS
BEGIN
    INSERT INTO ContactLog (CreatedDateTime, ContactName, ContactID)
    SELECT GETDATE(), i.Name, i.Id
    FROM inserted i;
END;
GO
--test purposes
SELECT * 
FROM [Creatio].[dbo].[ContactLog]

INSERT INTO Contact (name, email, surname,MiddleName)
VALUES ('Serhii', 'stest@gmail.com', 'Parfentiev','Valerii');

--11. Create a function that, when called, returns information about the name (Name), age (Age), and notes (Notes) of a contact whose name is passed as an argument to the function.

--creating a scalar value function in programabilty

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Serhii Parfentiev>
-- Create date: <Create Date, ,7/22/2023>
-- Description:	<Description, ,get info about contact by ContactName>
-- =============================================
CREATE FUNCTION dbo.fn_GetContactInfo (@ContactName NVARCHAR(500))
RETURNS TABLE
AS
RETURN
(
    SELECT Name, Age, Notes
    FROM Contact
    WHERE Name = @ContactName
);

GO

--testing function 
SELECT *
FROM dbo.fn_GetContactInfo('Serhii');

--12. There are three tables: SysModule, SysModuleEntity, and SysSchema. The linking column in SysModule to the SysModuleEntity table is SysModuleEntityId, and the linking column in SysModuleEntity to the SysSchema table is SysEntitySchemaUId (based on the UId column in the SysSchema table). Task: Retrieve all records from SysModule that are associated with the schema named "Case".

SELECT sm.*
FROM [Creatio].[dbo].[SysModule] sm
INNER JOIN [Creatio].[dbo].[SysModuleEntity] sme ON sm.SysModuleEntityId = sme.Id INNER JOIN [Creatio].[dbo].[SysSchema] ss ON sme.SysEntitySchemaUId = ss.UId
WHERE ss.Name = 'Case';

--13. Delete 200 records from the Contact table where the name starts with the words "Sample data".
DELETE TOP (200)
FROM [Creatio].[dbo].[Contact]
WHERE Name LIKE 'Sample data%';