
CREATE DATABASE db_zoo;

USE db_zoo;

CREATE TABLE tbl_animalia (
    animalia_id INT PRIMARY KEY NOT NULL IDENTITY (1,1),
	animalia_type VARCHAR(30) NOT NULL
);

INSERT INTO tbl_animalia
    (animalia_type)
	VALUES
	('vertebrate'),
	('invertebrate')
;

SELECT * FROM tbl_animalia;

CREATE TABLE tbl_class (
    class_id INT PRIMARY KEY NOT NULL IDENTITY (100,1),
	class_type VARCHAR(50) NOT NULL
);

INSERT INTO tbl_class
    (class_type)
	VALUES
	('bird'),
	('reptiles'),
	('fish'),
	('mammals'),
	('echinoderm'),
	('worm'),
	('arthropod'),
	('cnidaria')
;

SELECT * FROM tbl_class;

UPDATE tbl_class SET class_type = 'birds' WHERE class_type = 'bird';

SELECT REPLACE(class_type, 'bird', 'birds') FROM tbl_class;

SELECT class_type FROM tbl_class WHERE class_type = 'birds';

SELECT UPPER(class_type) FROM tbl_class WHERE class_type = 'birds';

SELECT COUNT(class_type) FROM tbl_class WHERE class_type = 'birds';

-- create tables for te db_zoo
 CREATE TABLE tbl_order (
    order_id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	order_type VARCHAR(50) NOT NULL
);

CREATE TABLE tbl_care (
    care_id VARCHAR(50) PRIMARY KEY NOT NULL,
	care_type VARCHAR(50) NOT NULL,
	care_specialist INT NOT NULL
);

CREATE TABLE tbl_nutrition (
    nutrition_id INT PRIMARY KEY NOT NULL IDENTITY(2200,1),
	nutrition_type VARCHAR(50) NOT NULL,
	nutrition_cost MONEY NOT NULL
);

CREATE TABLE tbl_habitat (
    habitat_id INT PRIMARY KEY NOT NULL IDENTITY(5000,1),
	habitat_type VARCHAR(50) NOT NULL,
	habitat_cost MONEY NOT NULL
);

CREATE TABLE tbl_specialist (
    specialist_id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	specialist_fname VARCHAR(50) NOT NULL,
	specialist_lname VARCHAR(50) NOT NULL,
	specialist_contact VARCHAR(50) NOT NULL,
);



INSERT INTO tbl_order
    (order_type)
	VALUES
	('carnivore'),
	('herbivore'),
	('omnivore')
;

SELECT * FROM tbl_order;

INSERT INTO tbl_care
    (care_id, care_type, care_specialist)
	VALUES
	('care_0', 'replace the straw', 1),
	('care_1', 'repair or replace broken toys', 4),
	('care_2', 'boottle feed vitamins', 1),
	('care_3', 'human contact_pet subject', 2),
	('care_4', 'clean up animal waste', 1),
	('care_5', 'move subject to exercise pen', 3),
	('care_6', 'drain and refill aquarium', 1),
	('care_7', 'extensive dental work', 3)
;

SELECT * FROM tbl_care;

INSERT INTO tbl_nutrition
    (nutrition_type, nutrition_cost)
	VALUES
	('raw fish', 1500),
	('living rodents', 600),
	('mixture of fruit and rice', 800),
	('warm bottle of milk', 600),
	('lard and seed mix', 300),
	('syringe fed broth', 600),
	('aphids', 150),
	('vitamins and marrow', 3500)
;

SELECT * FROM tbl_nutrition;

INSERT INTO tbl_habitat
    (habitat_type, habitat_cost)
	VALUES
	('tundra', 40000),
	('grassy knoll with trees', 12000),
	('10ft pond and rocks', 30000),
	('icy aquarium with snowy facade', 50000),
	('short grass, shade and moat', 50000),
	('netted forest atrium', 10000),
	('jungle vines and winding branches', 15000),
	('cliff with shaded cave', 15000)
;

SELECT * FROM tbl_habitat;

INSERT INTO tbl_specialist
    (specialist_fname, specialist_lname, specialist_contact)
	VALUES
	('lamin', 'badjie', '220-999-1111'),
	('buba', 'jammeh', '220-999-2223'),
	('fatou', 'colley', '220-999-6789'),
	('mai', 'tamba', '220-999-8733'),
	('banna', 'sanneh', '220-999-4695')
;

SELECT * FROM tbl_specialist;

USE db_zoo;
 
CREATE TABLE tbl_species (
    species_id INT PRIMARY KEY NOT NULL IDENTITY(1, 1),
	species_name VARCHAR(50) NOT NULL,
	species_animalia INT NOT NULL CONSTRAINT fk_animalia_id FOREIGN KEY REFERENCES tbl_animalia(animalia_id) ON UPDATE CASCADE ON DELETE CASCADE,
	species_class INT NOT NULL CONSTRAINT fk_class_id FOREIGN KEY REFERENCES tbl_class(class_id) ON UPDATE CASCADE ON DELETE CASCADE,
	species_order INT NOT NULL CONSTRAINT fk_order_id FOREIGN KEY REFERENCES tbl_order(order_id) ON UPDATE CASCADE ON DELETE CASCADE,
	species_habitat INT NOT NULL CONSTRAINT fk_habitat_id FOREIGN KEY REFERENCES tbl_habitat(habitat_id) ON UPDATE CASCADE ON DELETE CASCADE,
	species_nutrition INT NOT NULL CONSTRAINT fk_nutrition_id FOREIGN KEY REFERENCES tbl_nutrition(nutrition_id) ON UPDATE CASCADE ON DELETE CASCADE,
	species_care VARCHAR(50) NOT NULL CONSTRAINT fk_care_id FOREIGN KEY REFERENCES tbl_care(care_id) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO tbl_species
    (species_name, species_animalia, species_class, species_order, species_habitat, species_nutrition, species_care)
	VALUES
	('brown bear', 1, 102, 3, 5007, 2200, 'care_1'),
	('jaguar', 1, 102, 3, 5007, 2200, 'care_4'),
	('penguin', 1, 100, 1, 5003, 2200, 'care_6'),
	('ghost bat', 1, 102, 1, 5007, 2204, 'care_2'),
	('chicken', 1, 100, 3, 5001, 2205, 'care_0'),
	('panda', 1, 102, 3, 5006, 2202, 'care_4'),
	('bobcat', 1, 102, 1, 5001, 2204, 'care_5'),
	('grey wolf', 1, 102, 1, 5000, 2201, 'care_4')
;

SELECT * FROM tbl_species;


-- created backupin order to fine 
BACKUP DATABASE db_zoo TO DISK = 'C:\Backup\db_zoo.bak';

DROP TABLE IF EXISTS tbl_specialist, tbl_care, tbl_species;

CREATE TABLE tbl_specialist (
    specialist_id INT PRIMARY KEY IDENTITY(1,1),
    specialist_fname VARCHAR(50) NOT NULL,
    specialist_lname VARCHAR(50) NOT NULL,
    specialist_contact VARCHAR(20) NOT NULL
);

CREATE TABLE tbl_care (
    care_id INT PRIMARY KEY IDENTITY(1,1),
    care_type VARCHAR(100) NOT NULL,
    care_specialist INT NOT NULL CONSTRAINT fk_specialist_id FOREIGN KEY REFERENCES tbl_specialist(specialist_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE tbl_species (
    species_id INT PRIMARY KEY IDENTITY(1,1),
    species_name VARCHAR(100) NOT NULL,
    species_animalia INT NOT NULL CONSTRAINT fk_animalia_id FOREIGN KEY REFERENCES tbl_animalia(animalia_id) ON UPDATE CASCADE ON DELETE CASCADE,
    species_class INT NOT NULL CONSTRAINT fk_class_id FOREIGN KEY REFERENCES tbl_class(class_id) ON UPDATE CASCADE ON DELETE CASCADE,
    species_order INT NOT NULL CONSTRAINT fk_order_id FOREIGN KEY REFERENCES tbl_order(order_id) ON UPDATE CASCADE ON DELETE CASCADE,
    species_habitat INT NOT NULL CONSTRAINT fk_habitat_id FOREIGN KEY REFERENCES tbl_habitat(habitat_id) ON UPDATE CASCADE ON DELETE CASCADE,
    species_nutrition INT NOT NULL CONSTRAINT fk_nutrition_id FOREIGN KEY REFERENCES tbl_nutrition(nutrition_id) ON UPDATE CASCADE ON DELETE CASCADE,
    species_care INT NOT NULL CONSTRAINT fk_care_id FOREIGN KEY REFERENCES tbl_care(care_id) ON UPDATE CASCADE ON DELETE CASCADE
);




EXEC sp_help 'tbl_species';  

EXEC sp_help 'tbl_care';  



-- Pre-Insert Foreign Key Validation Script

-- Check if animalia_id = 1 exists
SELECT animalia_id FROM tbl_animalia WHERE animalia_id = 1;

-- Check if class_id = 100 and 102 exist
SELECT class_id FROM tbl_class WHERE class_id IN (100, 102);

-- Check if order_id = 1 and 3 exist
SELECT order_id FROM tbl_order WHERE order_id IN (1, 3);

-- Check if habitat_id = 5003 and 5007 exist
SELECT habitat_id FROM tbl_habitat WHERE habitat_id IN (5003, 5007);

-- Check if nutrition_id = 2200 exists
SELECT nutrition_id FROM tbl_nutrition WHERE nutrition_id = 2200;

-- Check if care_id = 2 and 3 exist
SELECT care_id FROM tbl_care WHERE care_id IN (2, 3);

SELECT * FROM tbl_species WHERE species_name = 'chicken';

SELECT
a1.species_name, a2.animalia_type,
a3.class_type, a4.order_type, a5.habitat_type,
a6.nutrition_type, a7.care_type
FROM tbl_species a1
INNER JOIN tbl_animalia a2 ON a2.animalia_id = a1.species_animalia
INNER JOIN tbl_class a3 ON a3.class_id = a1.species_class
INNER JOIN tbl_order a4 ON a4.order_id = a1.species_order
INNER JOIN tbl_habitat a5 ON a5.habitat_id = a1.species_habitat
INNER JOIN tbl_nutrition a6 ON a6.nutrition_id = a1.species_nutrition
INNER JOIN tbl_care a7 ON a7.care_id = a1.species_care
WHERE species_name = 'brown bear'
;

SELECT
a1.species_name, a2.habitat_type, a2.habitat_cost,
a3.nutrition_type, a3.nutrition_cost
FROM tbl_species a1
INNER JOIN tbl_habitat a2 ON a2.habitat_id = a1.species_habitat
INNER JOIN tbl_nutrition a3 ON a3.nutrition_id = a1.species_nutrition
WHERE species_name = 'ghost bat'
;

--Great! I'll create an automated validation script that checks all foreign key dependencies before attempting inserts. 
--This way, you'll catch missing values in related tables early, avoiding frustrating errors. ??
--? Stored Procedure for Foreign Key Validation
--This procedure will:
-- Check if species_animalia, species_class, species_order, species_habitat, species_nutrition, and species_care exist in their respective tables.
-- Return results indicating missing references.
-- Prevent failed inserts due to foreign key violations.
CREATE PROCEDURE ValidateSpeciesInsert
    @species_animalia INT,
    @species_class INT,
    @species_order INT,
    @species_habitat INT,
    @species_nutrition INT,
    @species_care INT
AS
BEGIN
    -- Check missing foreign key values
    IF NOT EXISTS (SELECT 1 FROM tbl_animalia WHERE animalia_id = @species_animalia)
        PRINT 'ERROR: species_animalia ID does not exist in tbl_animalia';

    IF NOT EXISTS (SELECT 1 FROM tbl_class WHERE class_id = @species_class)
        PRINT 'ERROR: species_class ID does not exist in tbl_class';

    IF NOT EXISTS (SELECT 1 FROM tbl_order WHERE order_id = @species_order)
        PRINT 'ERROR: species_order ID does not exist in tbl_order';

    IF NOT EXISTS (SELECT 1 FROM tbl_habitat WHERE habitat_id = @species_habitat)
        PRINT 'ERROR: species_habitat ID does not exist in tbl_habitat';

    IF NOT EXISTS (SELECT 1 FROM tbl_nutrition WHERE nutrition_id = @species_nutrition)
        PRINT 'ERROR: species_nutrition ID does not exist in tbl_nutrition';

    IF NOT EXISTS (SELECT 1 FROM tbl_care WHERE care_id = @species_care)
        PRINT 'ERROR: species_care ID does not exist in tbl_care';

    PRINT 'Validation Complete';
END;



PRINT 'Hello World'

/* printing with quotes */
PRINT '"Hello, World!"'
PRINT 'He said, "Hello, World!"'


DECLARE @myVariable INT
SET @myVariable = 6
PRINT @myVariable

DECLARE @var1 INT, @var2 INT
SET @var1 = 3
SET @var2 = 5

PRINT 'Having fun with ' + 'TSQL and MS SQL SERVER!'

PRINT 'I have ' + CONVERT(VARCHAR(50), @var1 + ' dollars...'

DECLARE @var1 INT, @var2 INT
SET @var1 = 3
SET @var2 = 5

PRINT CHAR(9) + 'I have ' + CONVERT(VARCHAR(50), @var1) + CHAR(13) +' dollars...'

PRINT 'Variable 1 = ' + CONVERT(VARCHAR(5), @var1) + CHAR(13) + 'Variable 2 = ' + CONVERT(VARCHAR(5), @var2)

PRINT 'Variable 1 = ' + CONVERT(VARCHAR(5), @var1) + CHAR(13) + 'Variable 2 = ' + CONVERT(VARCHAR(5), @var2) + CHAR(13) + 'Total: '
PRINT @var1 + @var2

IF @var1 <= 3
    BEGIN
	    PRINT 'Variable 1 <= ' + CONVERT(VARCHAR(5), @var1) + CHAR(13)
	END
ELSE
    BEGIN
	    PRINT 'Variable 1 is not < ' +CONVERT(VARCHAR(5), @var1) + CHAR(13)
	END

IF @var1 != 3
   BEGIN
       PRINT 'Variable 1 is NOT ' + CONVERT(VARCHAR(5), @var1) + CHAR(13)
	END
ELSE
    BEGIN
	    PRINT 'Variable 1 is not < ' +CONVERT(VARCHAR(5), @var1) + CHAR(13)
	END


USE db_zoo
GO

/* CONVERT(VARCHAR(50), @totalHab) = This is converting the data from MONEY to VARCHAR
 * CHAR(13) = Line Break
 * CHAR(9) = Tab Key */

DECLARE @totalHab MONEY;
DECLARE @totalNut MONEY;
DECLARE @results MONEY;

SET @totalHab = (SELECT SUM(habitat_cost) FROM tbl_habitat);
SET @totalNut = (SELECT SUM(nutrition_cost) FROM tbl_nutrition);
SET @results = (@totalHab + @totalNut);

PRINT (
CONVERT(VARCHAR(50), @totalHab) + CHAR(9) + ' - The Total Habitat Cost' + CHAR(13) +
CONVERT(VARCHAR(50), @totalNut) + CHAR(9) + CHAR(9) + ' - The Total Nutrition Cost' + CHAR(13) + '-------------' +CHAR(13) +
CONVERT(VARCHAR(50), @results)
);

