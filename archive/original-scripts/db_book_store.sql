
/* PROJECT REQUIREMENTS */

/* 
1.Create a database that consists of two tables .

2.Assign primary keys to each table (note: the primary keys are different for each table).

3.Assign a foreign key to one table (i.e. the primary key from one table is the foreign key in the other).

4.Create at least two columns (in addition to the primary key and foreign key columns) in each table.

Add values to your database (at least five rows per table). Ensure that at least one of these values match up between both databases. 

NOTE: the foreign key values in a child table must match existing primary key values in the parent table.

5.Create a statement that queries data from both tables. Ensure this query includes two records (rows) that share an attribute (column) 
in common.

IMPLEMENTATION
-Let’s build a Bookstore database with two tables:
- Authors: stores information about book authors.
- Books: stores information about books written by those authors.
-The Authors table will have a primary key author_id, 
-and the Books table will have its own primary key book_id, 
-plus a foreign key that references author_id.
*/

-- Step 1: Create database BookStoreDB
CREATE DATABASE BookstoreDB;
GO

USE BookstoreDB;

--Step 2: Create the tables
CREATE TABLE Authors (
    author_id INT PRIMARY KEY IDENTITY(1,1),
    author_name VARCHAR(100) NOT NULL,
    nationality VARCHAR(50)
);

CREATE TABLE Books (
    book_id INT PRIMARY KEY IDENTITY(1,1),
    title VARCHAR(100) NOT NULL,
    genre VARCHAR(50),
    author_id INT,
    CONSTRAINT fk_author FOREIGN KEY (author_id)
        REFERENCES Authors(author_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);



--Step 3: Insert sample data
INSERT INTO Authors (author_name, nationality)
VALUES 
('Chimamanda Ngozi Adichie', 'Nigerian'),
('Haruki Murakami', 'Japanese'),
('Toni Morrison', 'American'),
('Gabriel García Márquez', 'Colombian'),
('Kazuo Ishiguro', 'British');

INSERT INTO Books (title, genre, author_id)
VALUES 
('Norwegian Wood', 'Fiction', 2),
('Beloved', 'Historical Fiction', 3),
('Purple Hibiscus', 'Coming-of-age', 1),
('The Remains of the Day', 'Drama', 5),
('One Hundred Years of Solitude', 'Magical Realism', 4);



--Step 4: Query data from both tables
--Let's say we want to list all book titles alongside their authors’ names for books written by Japanese and British authors.
--This will return at least two records with a shared nationality attribute.
SELECT 
    b.title AS [Book Title], 
    a.author_name AS [Author Name], 
    a.nationality
FROM Books b
INNER JOIN Authors a ON b.author_id = a.author_id
WHERE a.nationality IN ('Japanese', 'British');






