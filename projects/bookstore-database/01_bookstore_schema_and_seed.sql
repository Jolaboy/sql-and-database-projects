USE master;
GO

IF DB_ID('BookstoreDB') IS NULL
BEGIN
    CREATE DATABASE BookstoreDB;
END;
GO

USE BookstoreDB;
GO

IF OBJECT_ID('dbo.Books', 'U') IS NOT NULL DROP TABLE dbo.Books;
IF OBJECT_ID('dbo.Authors', 'U') IS NOT NULL DROP TABLE dbo.Authors;
GO

CREATE TABLE dbo.Authors (
    author_id INT IDENTITY(1,1) PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL,
    nationality VARCHAR(50) NOT NULL
);

CREATE TABLE dbo.Books (
    book_id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    genre VARCHAR(50) NOT NULL,
    author_id INT NOT NULL,
    CONSTRAINT fk_books_author FOREIGN KEY (author_id)
        REFERENCES dbo.Authors(author_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

INSERT INTO dbo.Authors (author_name, nationality)
VALUES ('Chimamanda Ngozi Adichie', 'Nigerian'),
       ('Haruki Murakami', 'Japanese'),
       ('Toni Morrison', 'American'),
       ('Gabriel Garcia Marquez', 'Colombian'),
       ('Kazuo Ishiguro', 'British');

INSERT INTO dbo.Books (title, genre, author_id)
VALUES ('Norwegian Wood', 'Fiction', 2),
       ('Beloved', 'Historical Fiction', 3),
       ('Purple Hibiscus', 'Coming of Age', 1),
       ('The Remains of the Day', 'Drama', 5),
       ('One Hundred Years of Solitude', 'Magical Realism', 4);
GO

SELECT
    books.title AS book_title,
    authors.author_name,
    authors.nationality
FROM dbo.Books AS books
INNER JOIN dbo.Authors AS authors
    ON authors.author_id = books.author_id
WHERE authors.nationality IN ('Japanese', 'British');
