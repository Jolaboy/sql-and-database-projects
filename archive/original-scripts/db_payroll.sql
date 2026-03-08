--Creating Payroll Management System Database

CREATE DATABASE db_payroll;

USE db_payroll;
GO

--Lets create tables for db_payroll
CREATE TABLE employee (
	employee_id INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
	job_id INT NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	date_of_hire DATE
);

CREATE TABLE job (
	job_id INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
	job_title VARCHAR(50) NOT NULL,
	job_dept VARCHAR(50)NOT NULL,
	salary_id INT NOT NULL
);

CREATE TABLE salary (
	salary_id INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
	hourly_rate MONEY NOT NULL
);

CREATE TABLE payroll (
	payroll_date DATE NOT NULL,
	employee_id INT NOT NULL,
	hours_worked INT NOT NULL
);

-- Lets add the foreign key relationship to the employee, payroll and job tables
ALTER TABLE employee
ADD FOREIGN KEY (job_id) REFERENCES job(job_id);

ALTER TABLE payroll
ADD FOREIGN KEY (employee_id) REFERENCES employee(employee_id);

ALTER TABLE job
ADD FOREIGN KEY (salary_id) REFERENCES salary(salary_id);

--Now let''s populate the tables starting the salary table
--Notice that we only added data for the “hourly_rate” column. 
--This is because the salary_id has the IDENTITY property which will automatically assign the value. 
--We don’t have to provide the column names after the VALUES statement since we are providing data for all expected columns.
INSERT INTO salary VALUES
(11.50),
(13.00),
(13.00),
(15.00),
(15.00);

--Let’s print all data from the salary table so that we can see the primary key values for each hourly_rate.
SELECT * FROM salary;

--Next let's add data to the job table
/* Once again, we do not have to provide the job_id values because the IDENTITY property 
will assign the values and we don’t have to provide the column names since we are providing 
data for each expected column. Note that the data we provide for the foreign key (salary_id column)
must match a value in the salary_id column of the salary table. If we were to try to input a row with
a salary_id of 6, an error would be thrown because of the foreign key constraint.*/
INSERT INTO job VALUES
('Finance Manager', 'Finance', 2),
('HR Manager', 'Human Resources', 4),
('Developer', 'IT', 5),
('Operations Manager', 'Operations', 3),
('Sales Manager', 'Sales and Marketing', 1);

--Now, let’s print the contents of the job table so we can see the job_ids which we will need to populate our employee table
SELECT * FROM job;

--Next let's add data to employee table using the job_ids from the job table
/*Remember that the first integer we are providing for this table is a foreign key
and not the primary key as that will be automatically generated.*/
INSERT INTO employee VALUES
(1, 'Amadou', 'Jarju', '2018-10-11'),
(4, 'Buba', 'Touray', '2020-01-13'),
(3, 'Fatou', 'Njie', '2021-12-11'),
(2, 'Lamin', 'Ceesay', '2015-07-21'),
(5, 'James', 'Mendy', '2019-02-02');

--Let’s print the data of the employee table so we can see the employee_ids to populate the payroll table
SELECT * FROM employee;

-- Now let's populate the payroll table
/*Now we can add the data to our payroll table. The payroll table is set up so that the payroll manager
can simply insert the payroll date, the employee id and the total hours worked.
Add this code to your query then highlight and execute it:*/
INSERT INTO payroll VALUES
('2025-06-20', 1, 40),
('2025-06-20', 2, 25),
('2025-06-20', 3, 38),
('2025-06-20', 4, 22),
('2025-06-20', 5, 34);

SELECT * FROM payroll;

--Let's create the deduction table of db_payroll
CREATE TABLE Deductions (
    deduction_id INT PRIMARY KEY IDENTITY(1,1),
    employee_id INT NOT NULL,
    deduction_type VARCHAR(50) NOT NULL,  -- e.g. 'Income Tax', 'National Insurance', etc.
    deduction_amount MONEY NOT NULL,
    CONSTRAINT fk_employee_id FOREIGN KEY (employee_id)
        REFERENCES employee(employee_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
DROP TABLE IF EXISTS dbo.Deductions;

-- Let's populate the deduction table
INSERT INTO Deductions (employee_id, deduction_type, deduction_amount)
VALUES 
(1, 'Income Tax', 300.00),
(1, 'National Insurance', 150.00),
(2, 'Pensions Contribution', 280.00),
(2, 'Medical Insurance', 100.00),
(3, 'Student Finance', 45.00);

-- Total Deductions Per Employee with cleaner formatting and aliasing
SELECT  
    e.employee_id,
    e.first_name,
    ISNULL(SUM(d.deduction_amount), 0) AS total_deductions
FROM dbo.employee e
LEFT JOIN dbo.Deductions d ON e.employee_id = d.employee_id
GROUP BY e.employee_id, e.first_name
ORDER BY e.employee_id;

--Total Deductions Per Employee
SELECT 
    e.employee_id,
    e.first_name,
    SUM(d.deduction_amount) AS total_deductions
FROM employee e
INNER JOIN Deductions d ON e.employee_id = d.employee_id
GROUP BY e.employee_id, e.first_name;

-- Let’s write a query to see all of the data in the database together
SELECT * FROM employee
	INNER JOIN payroll ON employee.employee_id = payroll.employee_id
	INNER JOIN job ON employee.job_id = job.job_id
	INNER JOIN salary ON job.salary_id = salary.salary_id;


/*We can use the tables and columns within the database to determine the total pay for each employee
in a payroll period. We will use aliases to make the data easier to read when it is returned.*/
SELECT 
	employee.first_name AS 'First Name:',
	employee.last_name AS 'Last Name:',
	payroll.hours_worked AS 'Hours:',
	salary.hourly_rate AS 'Rate:',
	payroll.hours_worked * salary.hourly_rate AS 'Total Pay:'
	FROM employee
	INNER JOIN payroll ON employee.employee_id = payroll.employee_id
	INNER JOIN job ON employee.job_id = job.job_id
	INNER JOIN salary ON job.salary_id = salary.salary_id;

