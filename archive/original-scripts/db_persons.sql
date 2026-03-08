-- Create a table tbl_persons
CREATE TABLE tbl_persons (
    persons_id INT PRIMARY KEY NOT NULL IDENTITY (1,1),
	persons_fname VARCHAR(50) NOT NULL,
	persons_lname VARCHAR(50) NOT NULL,
	persons_contact VARCHAR(50) NOT NULL
);

-- Add some data to the table
INSERT INTO tbl_persons
    (persons_fname, persons_lname, persons_contact)
	VALUES
	('ami', 'keita', '220-999-1234'),
	('ous', 'jarju', '220-999-1235'),
	('tom', 'kent', '220-999-1236'),
	('ed', 'ceesay', '220-999-1237'),
	('jim', 'jarju', '220-999-1238'),
	('fatou', 'njie', '220-999-1239')
;

--Select all
SELECT * FROM tbl_persons;

-- Return indices from 2 to 5
SELECT persons_fname, persons_lname, persons_contact FROM tbl_persons WHERE persons_id BETWEEN 2 AND 5;

--Use wildcat to return lname LIKE 'ja%'
SELECT persons_fname, persons_lname, persons_contact FROM tbl_persons WHERE persons_lname LIKE 'ja%';

SELECT persons_fname, persons_lname, persons_contact FROM tbl_persons WHERE persons_lname LIKE 'ce%';

UPDATE tbl_persons SET persons_fname = 'ansu' WHERE persons_fname = 'jim';

SELECT persons_fname, persons_lname, persons_contact FROM tbl_persons WHERE persons_fname LIKE 'f%' ORDER BY persons_lname;

SELECT persons_fname AS 'First Name', persons_lname AS 'Last Name', persons_contact AS 'phone:'
    FROM tbl_persons WHERE persons_fname LIKE 'a%' ORDER BY persons_lname;

DELETE FROM tbl_persons WHERE persons_lname = 'kent';

DROP TABLE tbl_persons;