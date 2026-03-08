USE BookstoreDB;
GO

CREATE OR ALTER PROCEDURE dbo.usp_InsertBookAndAuthor
    @AuthorName VARCHAR(100),
    @Nationality VARCHAR(50),
    @BookTitle VARCHAR(100),
    @Genre VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @AuthorID INT;

    INSERT INTO dbo.Authors (author_name, nationality)
    VALUES (@AuthorName, @Nationality);

    SET @AuthorID = SCOPE_IDENTITY();

    INSERT INTO dbo.Books (title, genre, author_id)
    VALUES (@BookTitle, @Genre, @AuthorID);
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetBooksByNationality
    @Nationality VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        books.title AS book_title,
        authors.author_name,
        authors.nationality
    FROM dbo.Books AS books
    INNER JOIN dbo.Authors AS authors
        ON authors.author_id = books.author_id
    WHERE authors.nationality = @Nationality
    ORDER BY books.title;
END;
GO

EXEC dbo.usp_InsertBookAndAuthor
    @AuthorName = 'Roxane Gay',
    @Nationality = 'American',
    @BookTitle = 'Hunger',
    @Genre = 'Memoir';

EXEC dbo.usp_GetBooksByNationality @Nationality = 'Japanese';
GO
