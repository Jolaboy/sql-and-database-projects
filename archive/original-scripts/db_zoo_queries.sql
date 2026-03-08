/* Zoo Database Assignment */

USE db_zoo
GO

--Assignment 1
-- Compose a SELECT statement that returns all data in the habitat table
SELECT * FROM dbo.tbl_habitat;

--Assignment 2
--Compose a SELECT statement that retrieves all the names from the species_name column
-- of the tbl_species table that have a species_order value of 3.
SELECT species_name 
FROM dbo.tbl_species
WHERE species_order = 3;

-- Assignment 3
--Compose a SELECT statement that retrieve only the types from the column nutrition_type
-- of the tbl_nutrition table that have a nutrition_cost of 600.00 or less.
SELECT nutrition_type
FROM dbo.tbl_nutrition
WHERE nutrition_cost <= 600.00;

--Assignment 4
--Compose a SELECT statement that retrieve all species_names from tbl_nutrition that have
--nutrition_id between 2202 and 2206
-- note an INNER JOIN tbl_species and tbl_nutrition is used to accomplish this task.
SELECT s.species_name
FROM dbo.tbl_species s
INNER JOIN dbo.tbl_nutrition n ON s.species_nutrition = n.nutrition_id
WHERE n.nutrition_id BETWEEN 2202 AND 2206;

--Assignment 5
--Compose a SELECT statement that accomplishes the following:
--Retrieve all names from the species_name column in the tbl_species table and 
--their corresponding nutrition_type from the tbl_nutrition table. 
--(Note: You will need to INNER JOIN tbl_species and tbl_nutrition to complete the assignment.)
--Ensure that the data is returned using these aliases: "Species Name: " 
--for the species_name column and "Nutrition Type: " for the nutrition_type column.
SELECT 
    s.species_name AS [Species Name:], 
    n.nutrition_type AS [Nutrition Type:]
FROM dbo.tbl_species s
INNER JOIN dbo.tbl_nutrition n ON s.species_nutrition = n.nutrition_id;

--Assignment 6
--Compose a SELECT statement that accomplishes the following:
--From the specialist table, retrieve the first name, last name and contact number for the people that provide care to penguins.
--You will need to use two INNER JOINs to connect the three tables needed: tbl_specialist, tbl_species, and tbl_care.
--To assist in clarifying what is being requested exactly, here are the assignment requirements diagrammed:
--It is recommended that you print the contents of the three tables so that you can identify the
--primary and foreign key relationships to use in the INNER JOINS.
SELECT 
    sp.specialist_fname, 
    sp.specialist_lname, 
    sp.specialist_contact
FROM dbo.tbl_specialist sp
INNER JOIN dbo.tbl_care c ON sp.specialist_id = c.care_specialist
INNER JOIN dbo.tbl_species s ON c.care_id = s.species_care
WHERE s.species_name = 'penguin';


