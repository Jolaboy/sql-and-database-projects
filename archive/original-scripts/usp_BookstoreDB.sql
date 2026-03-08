
/* Stored Procedure for BookstoreDB */

USE [BookstoreDB]
GO

--1. usp_InsertBookAndAuthor: Adds a new author and one of their books
CREATE PROCEDURE usp_InsertBookAndAuthor
    @AuthorName VARCHAR(100),
    @Nationality VARCHAR(50),
    @BookTitle VARCHAR(100),
    @Genre VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @AuthorID INT;

    -- Insert author and retrieve generated ID
    INSERT INTO dbo.Authors (author_name, nationality)
    VALUES (@AuthorName, @Nationality);

    SET @AuthorID = SCOPE_IDENTITY();

    -- Insert associated book
    INSERT INTO dbo.Books (title, genre, author_id)
    VALUES (@BookTitle, @Genre, @AuthorID);

    PRINT 'Author and book successfully added.';
END;


--Insert more Books and Authors
--You’d run it like this:
EXEC usp_InsertBookAndAuthor
    @AuthorName = 'Roxane Gay',
    @Nationality = 'American',
    @BookTitle = 'Hunger',
    @Genre = 'Memoir';




