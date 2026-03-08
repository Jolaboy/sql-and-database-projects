/* Create stored procedure to get addresses from the Address table */

USE AdventureWorks2017
GO

CREATE PROCEDURE dbo.uspGetAddress
AS
SELECT * FROM Person.Address
GO

EXEC dbo.uspGetAddress

-- Lets delete the stored procedure
DROP PROCEDURE IF EXISTS dbo.uspGetAddress

-- To delete multiple procedures; use syntax:
DROP PROCEDURE IF EXISTS dbo.uspGetAddress, dbo.uspGetAddress2, dbo.uspGetAddress3, dbo.uspGetAddress4
