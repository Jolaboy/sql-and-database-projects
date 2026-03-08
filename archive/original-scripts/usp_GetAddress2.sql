
--Create stored procedure dbo.GetAddress2
USE AdventureWorks2017;
GO
CREATE PROCEDURE dbo.uspGetAddress2 @City nvarchar(30)
AS

SELECT * FROM Person.Address
WHERE City LIKE @City + '%'
GO

--Execute procedure below:
EXEC dbo.uspGetAddress2 @City = 'NEW'

CREATE PROC dbo.uspGetAddress3 @City nvarchar(30), @PostalCode nvarchar(10)
AS
SELECT * FROM Person.Address
WHERE City LIKE @City + '%' AND PostalCode LIKE @PostalCode
GO

EXEC dbo.uspGetAddress3 @City = 'New', @PostalCode = '[98]%'
