--Use AdventureWorks database
USE AdventureWorks2017;
GO

--Create a procedure with parameters @City and @PostalCode
CREATE PROC dbo.uspGetAddress3 @City nvarchar(30), @PostalCode nvarchar(10)
AS
SELECT * FROM Person.Address
WHERE City LIKE @City + '%' AND PostalCode LIKE @PostalCode
GO

--To execute proc, run this command:
EXEC dbo.uspGetAddress3 @City = 'New', @PostalCode = '[98]%'


