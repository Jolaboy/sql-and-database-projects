-- Let's create database LibraryDB
CREATE DATABASE LibraryDB;
GO
USE LibraryDB;
GO

--Next let's create tables for database LibraryDB
CREATE TABLE LIBRARY_BRANCH (
    BranchID INT PRIMARY KEY IDENTITY(1,1),
    BranchName VARCHAR(100) NOT NULL,
    BranchAddress VARCHAR(255) NOT NULL
);

CREATE TABLE BORROWER (
    CardNo INT PRIMARY KEY,
    BorrowerName VARCHAR(100) NOT NULL,
    BorrowerAddress VARCHAR(255),
    Phone VARCHAR(50)
);

CREATE TABLE PUBLISHER (
    PublisherName VARCHAR(100) PRIMARY KEY,
    PublisherAddress VARCHAR(255),
    Phone VARCHAR(50)
);

CREATE TABLE BOOKS (
    BookID INT PRIMARY KEY IDENTITY(1,1),
    Title VARCHAR(255) NOT NULL,
    PublisherName VARCHAR(100),
    FOREIGN KEY (PublisherName) REFERENCES PUBLISHER(PublisherName)
);

CREATE TABLE BOOK_AUTHORS (
    BookID INT,
    AuthorName VARCHAR(100),
    PRIMARY KEY (BookID, AuthorName),
    FOREIGN KEY (BookID) REFERENCES BOOKS(BookID)
);

CREATE TABLE BOOK_COPIES (
    BookID INT,
    BranchID INT,
    Number_of_Copies INT CHECK (Number_of_Copies >= 2),
    PRIMARY KEY (BookID, BranchID),
    FOREIGN KEY (BookID) REFERENCES BOOKS(BookID),
    FOREIGN KEY (BranchID) REFERENCES LIBRARY_BRANCH(BranchID)
);

CREATE TABLE BOOK_LOANS (
    BookID INT,
    BranchID INT,
    CardNo INT,
    DateOut DATE,
    DateDue DATE,
    PRIMARY KEY (BookID, BranchID, CardNo),
    FOREIGN KEY (BookID) REFERENCES BOOKS(BookID),
    FOREIGN KEY (BranchID) REFERENCES LIBRARY_BRANCH(BranchID),
    FOREIGN KEY (CardNo) REFERENCES BORROWER(CardNo)
);

--Next Let's populate tables of LibraryDB

-- Populate the PUBLISHER table
INSERT INTO PUBLISHER (PublisherName, PublisherAddress, Phone) VALUES
('Penguin Books', 'London, UK', '123-1111'),
('Vintage', 'Chicago, US', '123-2222'),
('Macmillan', 'Boston, US', '123-3333'),
('HarperCollins', 'New York, US', '123-4444'),
('Tor Books', 'San Francisco, US', '123-5555'),
('Knopf', 'Toronto, CA', '123-6666'),
('Oxford Press', 'Oxford, UK', '123-7777'),
('Houghton Mifflin', 'Houston, US', '123-8888'),
('Simon & Schuster', 'Los Angeles, US', '123-9999'),
('Random House', 'Berlin, DE', '123-0000');

-- Populate the LIBRARY_BRANCH table
INSERT INTO LIBRARY_BRANCH (BranchName, BranchAddress) VALUES
('Sharpstown', '22 Elm St'),
('Midtown', '98 Oak Ave'),
('Downtown', '12 Main Rd'),
('Riverbend', '31 Willow Ln'),
('Hillside', '77 Mountain Pkwy'),
('Lakeside', '5 Shore Blvd');

-- Populate the BORROWER table
INSERT INTO BORROWER (CardNo, BorrowerName, BorrowerAddress, Phone) VALUES
(1001, 'Lena Duke', '101 Fox Run', '555-1101'),
(1002, 'Samir Singh', '42 Moss Hill', '555-2102'),
(1003, 'Alma Lopez', '24 Garden Way', '555-3103'),
(1004, 'Reza Habib', '8 Crescent Ct', '555-4104'),
(1005, 'Ada Kinte', '72 Rainier Rd', '555-5105'),
(1006, 'Daryl Cho', '39 Birch Circle', '555-6106'),
(1007, 'Nia Holloway', '15 Pine Loop', '555-7107'),
(1008, 'Tomas Varga', '88 Sunset Blvd', '555-8108');

--Populate the BOOKS table
INSERT INTO BOOKS (Title, PublisherName) VALUES
('The Lost Tribe', 'Penguin Books'),
('1984', 'Vintage'),
('To Kill a Mockingbird', 'HarperCollins'),
('Pride and Prejudice', 'Macmillan'),
('War and Peace', 'Random House'),
('The Hobbit', 'Houghton Mifflin'),
('Beloved', 'Knopf'),
('Jane Eyre', 'Macmillan'),
('One Hundred Years of Solitude', 'Penguin Books'),
('Crime and Punishment', 'Oxford Press'),
('Moby Dick', 'HarperCollins'),
('The Odyssey', 'Tor Books'),
('The Divine Comedy', 'Simon & Schuster'),
('The Catcher in the Rye', 'Vintage'),
('Wuthering Heights', 'Oxford Press'),
('Anna Karenina', 'Penguin Books'),
('The Brothers Karamazov', 'Knopf'),
('Slaughterhouse-Five', 'Tor Books'),
('Invisible Man', 'Vintage'),
('Frankenstein', 'Macmillan');

--Populate the BOOK_AUTHORS table
INSERT INTO BOOK_AUTHORS (BookID, AuthorName) VALUES
(1, 'Seth Conway'),
(2, 'George Orwell'),
(3, 'Harper Lee'),
(4, 'Jane Austen'),
(5, 'Leo Tolstoy'),
(6, 'J.R.R. Tolkien'),
(7, 'Toni Morrison'),
(8, 'Charlotte Brontë'),
(9, 'Gabriel García Márquez'),
(10, 'Fyodor Dostoevsky');

--Populate the BOOK_COPIES table
INSERT INTO BOOK_COPIES (BookID, BranchID, Number_of_Copies) VALUES
(1, 1, 13),
(2, 1, 12),
(3, 2, 24),
(4, 3, 15),
(5, 4, 22),
(6, 5, 26),
(7, 6, 12),
(8, 2, 13),
(9, 3, 12),
(10, 4, 14);

--Populate the BOOK_LOANS table
INSERT INTO BOOK_LOANS (BookID, BranchID, CardNo, DateOut, DateDue) VALUES
(1, 1, 1001, '2025-06-01', '2025-06-15'),
(2, 1, 1002, '2025-06-02', '2025-06-16'),
(3, 2, 1003, '2025-06-03', '2025-06-17'),
(4, 3, 1004, '2025-06-04', '2025-06-18'),
(5, 4, 1005, '2025-06-05', '2025-06-19'),
(6, 5, 1006, '2025-06-06', '2025-06-20'),
(7, 6, 1007, '2025-06-07', '2025-06-21'),
(8, 2, 1008, '2025-06-08', '2025-06-22'),
(1, 1, 1003, '2025-06-09', '2025-06-23'),
(2, 1, 1001, '2025-06-10', '2025-06-24');


--Now let’s see how each of these tables relate to each other using the Full Outer Join
SELECT 
    bl.BookID,
    bl.BranchID,
    br.CardNo,
    b.Title,
    p.PublisherName,
    bl.DateOut,
    bl.DateDue
FROM BOOK_LOANS bl
FULL OUTER JOIN BORROWER br ON bl.CardNo = br.CardNo
FULL OUTER JOIN BOOKS b ON bl.BookID = b.BookID
FULL OUTER JOIN PUBLISHER p ON b.PublisherName = p.PublisherName; 


--Next create a stored procedure for "The Lost Tribe" copies at Sharpstown
USE LibraryDB
GO
CREATE PROCEDURE usp_CopiesOfLostTribe_Sharpstown
AS
BEGIN
    SELECT SUM(bc.Number_of_Copies) AS TotalCopies
    FROM BOOK_COPIES bc
    INNER JOIN BOOKS b ON bc.BookID = b.BookID
    INNER JOIN LIBRARY_BRANCH lb ON bc.BranchID = lb.BranchID
    WHERE b.Title = 'The Lost Tribe' AND lb.BranchName = 'Sharpstown';
END;

-- To execute procedure, run this:
EXEC dbo.usp_CopiesOfLostTribe_Sharpstown;


--Next create a stored procedure for "The Lost Tribe" copies per branch
CREATE PROCEDURE usp_CopiesOfLostTribe_PerBranch
AS
BEGIN
    SELECT lb.BranchName, SUM(bc.Number_of_Copies) AS TotalCopies
    FROM BOOK_COPIES bc
    INNER JOIN BOOKS b ON bc.BookID = b.BookID
    INNER JOIN LIBRARY_BRANCH lb ON bc.BranchID = lb.BranchID
    WHERE b.Title = 'The Lost Tribe'
    GROUP BY lb.BranchName;
END;

--To execute procudere, run this:
EXEC dbo.usp_CopiesOfLostTribe_PerBranch;


--Finally create a stored procedure for Borrowers with no books checked out
CREATE PROCEDURE usp_BorrowersWithNoBooks
AS
BEGIN
    SELECT BorrowerName
    FROM BORROWER
    WHERE CardNo NOT IN (SELECT DISTINCT CardNo FROM BOOK_LOANS);
END;

--To execute procedure, run this:
EXEC dbo.usp_BorrowersWithNoBooks;


