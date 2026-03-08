
/* Store Procedure to retrieve author by nationality */

USE [BookstoreDB]
GO

-- 2. usp_GetBooksByNationality: Returns all books by authors of a given nationality
CREATE PROCEDURE usp_GetBooksByNationality
    @Nationality VARCHAR(50)
AS
BEGIN
    SELECT 
        b.title AS [Book Title], 
        a.author_name AS [Author], 
        a.nationality
    FROM dbo.Books b
    INNER JOIN dbo.Authors a ON b.author_id = a.author_id
    WHERE a.nationality = @Nationality;
END;


--Use case example
EXEC usp_GetBooksByNationality @Nationality = 'Japanese';
