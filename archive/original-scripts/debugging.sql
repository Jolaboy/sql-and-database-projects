-- created backup to start debugging 
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

INSERT INTO tbl_specialist (specialist_fname, specialist_lname, specialist_contact)
VALUES ('lamin', 'badjie', '220-999-1111'),
       ('buba', 'jammeh', '220-999-2223'),
       ('fatou', 'colley', '220-999-6789');

INSERT INTO tbl_care (care_type, care_specialist)
VALUES ('replace the straw', 1),
       ('repair or replace broken toys', 2),
       ('bottle feed vitamins', 1);

INSERT INTO tbl_species (species_name, species_animalia, species_class, species_order, species_habitat, species_nutrition, species_care)
VALUES ('brown bear', 1, 102, 3, 5007, 2200, 2),
       ('penguin', 1, 100, 1, 5003, 2200, 3);

SELECT * FROM tbl_order;

INSERT INTO tbl_order (order_type)
VALUES ('carnivore'), ('herbivore'), ('omnivore');

SELECT * FROM tbl_order;

SELECT * FROM tbl_habitat;

INSERT INTO tbl_habitat (habitat_type, habitat_cost)
VALUES ('large forest enclosure', 50000), -- Assign appropriate habitat types
       ('polar aquatic exhibit', 60000);

INSERT INTO tbl_species (species_name, species_animalia, species_class, species_order, species_habitat, species_nutrition, species_care)
VALUES ('brown bear', 1, 102, 3, 5007, 2200, 2),
       ('penguin', 1, 100, 1, 5003, 2200, 3);

SELECT * FROM tbl_nutrition;

SELECT * FROM tbl_care;

INSERT INTO tbl_care (care_type, care_specialist)
VALUES ('replace the straw', 1),
       ('repair or replace broken toys', 4),
       ('bottle feed vitamins', 1),
       ('human contact_pet subject', 2),
       ('clean up animal waste', 1),
       ('move subject to exercise pen', 3),
       ('drain and refill aquarium', 1),
       ('extensive dental work', 3);

EXEC sp_help 'tbl_species';  

EXEC sp_help 'tbl_care';  

ALTER TABLE tbl_species ALTER COLUMN species_care INT;

INSERT INTO tbl_species (species_name, species_animalia, species_class, species_order, species_habitat, species_nutrition, species_care)
VALUES ('brown bear', 1, 102, 3, 5007, 2200, 2),
       ('penguin', 1, 100, 1, 5003, 2200, 3);


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
--This way, you'll catch missing values in related tables early, avoiding frustrating errors. 
--✅ Stored Procedure for Foreign Key Validation
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

--💡 How to Use the Procedure
--Before inserting a new species, run:
EXEC ValidateSpeciesInsert @species_animalia = 1, @species_class = 102, @species_order = 3, 
                           @species_habitat = 5007, @species_nutrition = 2200, @species_care = 2;

SELECT * FROM tbl_nutrition;
SELECT * FROM tbl_species;

SELECT * FROM tbl_nutrition
INNER JOIN tbl_species ON tbl_species.species_nutrition = tbl_nutrition.nutrition_id;


DROP TABLE tbl_species, tbl_animalia, tbl_care, tbl_class, tbl_habitat, tbl_nutrition, tbl_order, tbl_specialist;

--You're encountering SQL Server error Msg 3701, which means that the table either doesn't exist or you lack permission to drop it.
--Let's go step by step to troubleshoot:
-- 1. Check if the tables exist: Run this query to verify their presence:

SELECT name FROM sys.tables WHERE name IN 
('tbl_species', 'tbl_animalia', 'tbl_care', 'tbl_class', 
 'tbl_habitat', 'tbl_nutrition', 'tbl_order', 'tbl_specialist');

-- If the query returns no results, the tables don’t exist.
-- Check your permissions: Ensure you have the correct privileges:
SELECT * FROM fn_my_permissions(NULL, 'DATABASE') WHERE permission LIKE '%DROP%';

-- If you don’t see DROP TABLE, you might need admin privileges.
-- Use IF EXISTS before dropping: To prevent errors when dropping non-existent tables:
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'tbl_species')
DROP TABLE tbl_species;

-- Repeat this for each table.
-- Database context: If you're working in a specific schema, make sure you’re referencing the correct schema:
DROP TABLE schema_name.tbl_species;

-- Check your schema with:
SELECT TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tbl_species';

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tbl_species)
    DROP TABLE tbl_species, tbl_animalia, tbl_care, tbl_class, tbl_habitat, tbl_nutrition, tbl_order, tbl_specialist;

