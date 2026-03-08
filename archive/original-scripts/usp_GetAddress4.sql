--Use AdventureWorks database
USE AdventureWorks2017;
GO

--It is possible to pass information out of a stored procedure as well (as opposed to just in).
--To do so, we add the syntax OUTPUT, as follows:
CREATE PROC dbo.uspGetAddress4 @CityName nvarchar(30) OUTPUT
AS
SELECT City FROM Person.Address
WHERE AddressID = 38 AND PostalCode = 48226
GO
DECLARE @CityName nvarchar(30)
exec dbo.uspGetAddress4 @CityName = @CityName OUTPUT
PRINT @CityName