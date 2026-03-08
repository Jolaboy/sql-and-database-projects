USE master;
GO

IF DB_ID('LibraryDB') IS NULL
BEGIN
    CREATE DATABASE LibraryDB;
END;
GO

USE LibraryDB;
GO

IF OBJECT_ID('dbo.usp_BorrowersWithNoBooks', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_BorrowersWithNoBooks;
IF OBJECT_ID('dbo.usp_CopiesOfLostTribe_PerBranch', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_CopiesOfLostTribe_PerBranch;
IF OBJECT_ID('dbo.usp_CopiesOfLostTribe_Sharpstown', 'P') IS NOT NULL DROP PROCEDURE dbo.usp_CopiesOfLostTribe_Sharpstown;
IF OBJECT_ID('dbo.BOOK_LOANS', 'U') IS NOT NULL DROP TABLE dbo.BOOK_LOANS;
IF OBJECT_ID('dbo.BOOK_COPIES', 'U') IS NOT NULL DROP TABLE dbo.BOOK_COPIES;
IF OBJECT_ID('dbo.BOOK_AUTHORS', 'U') IS NOT NULL DROP TABLE dbo.BOOK_AUTHORS;
IF OBJECT_ID('dbo.BOOKS', 'U') IS NOT NULL DROP TABLE dbo.BOOKS;
IF OBJECT_ID('dbo.PUBLISHER', 'U') IS NOT NULL DROP TABLE dbo.PUBLISHER;
IF OBJECT_ID('dbo.BORROWER', 'U') IS NOT NULL DROP TABLE dbo.BORROWER;
IF OBJECT_ID('dbo.LIBRARY_BRANCH', 'U') IS NOT NULL DROP TABLE dbo.LIBRARY_BRANCH;
GO

CREATE TABLE dbo.LIBRARY_BRANCH (
    BranchID INT IDENTITY(1,1) PRIMARY KEY,
    BranchName VARCHAR(100) NOT NULL,
    BranchAddress VARCHAR(255) NOT NULL
);

CREATE TABLE dbo.BORROWER (
    CardNo INT PRIMARY KEY,
    BorrowerName VARCHAR(100) NOT NULL,
    BorrowerAddress VARCHAR(255),
    Phone VARCHAR(50)
);

CREATE TABLE dbo.PUBLISHER (
    PublisherName VARCHAR(100) PRIMARY KEY,
    PublisherAddress VARCHAR(255),
    Phone VARCHAR(50)
);

CREATE TABLE dbo.BOOKS (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    PublisherName VARCHAR(100) NOT NULL,
    CONSTRAINT fk_books_publisher FOREIGN KEY (PublisherName)
        REFERENCES dbo.PUBLISHER(PublisherName)
);

CREATE TABLE dbo.BOOK_AUTHORS (
    BookID INT NOT NULL,
    AuthorName VARCHAR(100) NOT NULL,
    CONSTRAINT pk_book_authors PRIMARY KEY (BookID, AuthorName),
    CONSTRAINT fk_book_authors_book FOREIGN KEY (BookID)
        REFERENCES dbo.BOOKS(BookID)
);

CREATE TABLE dbo.BOOK_COPIES (
    BookID INT NOT NULL,
    BranchID INT NOT NULL,
    Number_of_Copies INT NOT NULL CHECK (Number_of_Copies >= 0),
    CONSTRAINT pk_book_copies PRIMARY KEY (BookID, BranchID),
    CONSTRAINT fk_book_copies_book FOREIGN KEY (BookID)
        REFERENCES dbo.BOOKS(BookID),
    CONSTRAINT fk_book_copies_branch FOREIGN KEY (BranchID)
        REFERENCES dbo.LIBRARY_BRANCH(BranchID)
);

CREATE TABLE dbo.BOOK_LOANS (
    BookID INT NOT NULL,
    BranchID INT NOT NULL,
    CardNo INT NOT NULL,
    DateOut DATE NOT NULL,
    DateDue DATE NOT NULL,
    CONSTRAINT pk_book_loans PRIMARY KEY (BookID, BranchID, CardNo),
    CONSTRAINT fk_book_loans_book FOREIGN KEY (BookID)
        REFERENCES dbo.BOOKS(BookID),
    CONSTRAINT fk_book_loans_branch FOREIGN KEY (BranchID)
        REFERENCES dbo.LIBRARY_BRANCH(BranchID),
    CONSTRAINT fk_book_loans_borrower FOREIGN KEY (CardNo)
        REFERENCES dbo.BORROWER(CardNo)
);
GO

INSERT INTO dbo.PUBLISHER (PublisherName, PublisherAddress, Phone)
VALUES ('Penguin Books', 'London, UK', '123-1111'),
       ('Vintage', 'Chicago, US', '123-2222'),
       ('Macmillan', 'Boston, US', '123-3333'),
       ('HarperCollins', 'New York, US', '123-4444'),
       ('Tor Books', 'San Francisco, US', '123-5555'),
       ('Knopf', 'Toronto, CA', '123-6666'),
       ('Oxford Press', 'Oxford, UK', '123-7777'),
       ('Houghton Mifflin', 'Houston, US', '123-8888'),
       ('Simon and Schuster', 'Los Angeles, US', '123-9999'),
       ('Random House', 'Berlin, DE', '123-0000');

INSERT INTO dbo.LIBRARY_BRANCH (BranchName, BranchAddress)
VALUES ('Sharpstown', '22 Elm St'),
       ('Midtown', '98 Oak Ave'),
       ('Downtown', '12 Main Rd'),
       ('Riverbend', '31 Willow Ln'),
       ('Hillside', '77 Mountain Pkwy'),
       ('Lakeside', '5 Shore Blvd');

INSERT INTO dbo.BORROWER (CardNo, BorrowerName, BorrowerAddress, Phone)
VALUES (1001, 'Lena Duke', '101 Fox Run', '555-1101'),
       (1002, 'Samir Singh', '42 Moss Hill', '555-2102'),
       (1003, 'Alma Lopez', '24 Garden Way', '555-3103'),
       (1004, 'Reza Habib', '8 Crescent Ct', '555-4104'),
       (1005, 'Ada Kinte', '72 Rainier Rd', '555-5105'),
       (1006, 'Daryl Cho', '39 Birch Circle', '555-6106'),
       (1007, 'Nia Holloway', '15 Pine Loop', '555-7107'),
       (1008, 'Tomas Varga', '88 Sunset Blvd', '555-8108');

INSERT INTO dbo.BOOKS (Title, PublisherName)
VALUES ('The Lost Tribe', 'Penguin Books'),
       ('1984', 'Vintage'),
       ('To Kill a Mockingbird', 'HarperCollins'),
       ('Pride and Prejudice', 'Macmillan'),
       ('War and Peace', 'Random House'),
       ('The Hobbit', 'Houghton Mifflin'),
       ('Beloved', 'Knopf'),
       ('Jane Eyre', 'Macmillan'),
       ('One Hundred Years of Solitude', 'Penguin Books'),
       ('Crime and Punishment', 'Oxford Press');

INSERT INTO dbo.BOOK_AUTHORS (BookID, AuthorName)
VALUES (1, 'Seth Conway'),
       (2, 'George Orwell'),
       (3, 'Harper Lee'),
       (4, 'Jane Austen'),
       (5, 'Leo Tolstoy'),
       (6, 'J.R.R. Tolkien'),
       (7, 'Toni Morrison'),
       (8, 'Charlotte Bronte'),
       (9, 'Gabriel Garcia Marquez'),
       (10, 'Fyodor Dostoevsky');

INSERT INTO dbo.BOOK_COPIES (BookID, BranchID, Number_of_Copies)
VALUES (1, 1, 13),
       (2, 1, 12),
       (3, 2, 24),
       (4, 3, 15),
       (5, 4, 22),
       (6, 5, 26),
       (7, 6, 12),
       (8, 2, 13),
       (9, 3, 12),
       (10, 4, 14);

INSERT INTO dbo.BOOK_LOANS (BookID, BranchID, CardNo, DateOut, DateDue)
VALUES (1, 1, 1001, '2025-06-01', '2025-06-15'),
       (2, 1, 1002, '2025-06-02', '2025-06-16'),
       (3, 2, 1003, '2025-06-03', '2025-06-17'),
       (4, 3, 1004, '2025-06-04', '2025-06-18'),
       (5, 4, 1005, '2025-06-05', '2025-06-19'),
       (6, 5, 1006, '2025-06-06', '2025-06-20'),
       (7, 6, 1007, '2025-06-07', '2025-06-21'),
       (8, 2, 1008, '2025-06-08', '2025-06-22'),
       (1, 1, 1003, '2025-06-09', '2025-06-23'),
       (2, 1, 1001, '2025-06-10', '2025-06-24');
GO

CREATE OR ALTER PROCEDURE dbo.usp_CopiesOfLostTribe_Sharpstown
AS
BEGIN
    SET NOCOUNT ON;

    SELECT SUM(copies.Number_of_Copies) AS TotalCopies
    FROM dbo.BOOK_COPIES AS copies
    INNER JOIN dbo.BOOKS AS books
        ON books.BookID = copies.BookID
    INNER JOIN dbo.LIBRARY_BRANCH AS branches
        ON branches.BranchID = copies.BranchID
    WHERE books.Title = 'The Lost Tribe'
      AND branches.BranchName = 'Sharpstown';
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_CopiesOfLostTribe_PerBranch
AS
BEGIN
    SET NOCOUNT ON;

    SELECT branches.BranchName, SUM(copies.Number_of_Copies) AS TotalCopies
    FROM dbo.BOOK_COPIES AS copies
    INNER JOIN dbo.BOOKS AS books
        ON books.BookID = copies.BookID
    INNER JOIN dbo.LIBRARY_BRANCH AS branches
        ON branches.BranchID = copies.BranchID
    WHERE books.Title = 'The Lost Tribe'
    GROUP BY branches.BranchName
    ORDER BY branches.BranchName;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_BorrowersWithNoBooks
AS
BEGIN
    SET NOCOUNT ON;

    SELECT borrower.BorrowerName
    FROM dbo.BORROWER AS borrower
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.BOOK_LOANS AS loans
        WHERE loans.CardNo = borrower.CardNo
    )
    ORDER BY borrower.BorrowerName;
END;
GO

SELECT
    loans.BookID,
    books.Title,
    branches.BranchName,
    borrower.BorrowerName,
    loans.DateOut,
    loans.DateDue
FROM dbo.BOOK_LOANS AS loans
INNER JOIN dbo.BOOKS AS books
    ON books.BookID = loans.BookID
INNER JOIN dbo.LIBRARY_BRANCH AS branches
    ON branches.BranchID = loans.BranchID
INNER JOIN dbo.BORROWER AS borrower
    ON borrower.CardNo = loans.CardNo
ORDER BY loans.DateOut;

EXEC dbo.usp_CopiesOfLostTribe_Sharpstown;
EXEC dbo.usp_CopiesOfLostTribe_PerBranch;
EXEC dbo.usp_BorrowersWithNoBooks;
GO