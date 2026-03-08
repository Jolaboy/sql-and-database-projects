USE master;
GO

IF DB_ID('db_ZooTest') IS NULL
BEGIN
    CREATE DATABASE db_ZooTest;
END;
GO

USE db_ZooTest;
GO

IF OBJECT_ID('dbo.usp_GetAnimalInfo', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.usp_GetAnimalInfo;
END;
GO

IF OBJECT_ID('dbo.tbl_species', 'U') IS NOT NULL DROP TABLE dbo.tbl_species;
IF OBJECT_ID('dbo.tbl_care', 'U') IS NOT NULL DROP TABLE dbo.tbl_care;
IF OBJECT_ID('dbo.tbl_specialist', 'U') IS NOT NULL DROP TABLE dbo.tbl_specialist;
IF OBJECT_ID('dbo.tbl_habitat', 'U') IS NOT NULL DROP TABLE dbo.tbl_habitat;
IF OBJECT_ID('dbo.tbl_nutrition', 'U') IS NOT NULL DROP TABLE dbo.tbl_nutrition;
IF OBJECT_ID('dbo.tbl_order', 'U') IS NOT NULL DROP TABLE dbo.tbl_order;
IF OBJECT_ID('dbo.tbl_class', 'U') IS NOT NULL DROP TABLE dbo.tbl_class;
IF OBJECT_ID('dbo.tbl_animalia', 'U') IS NOT NULL DROP TABLE dbo.tbl_animalia;
GO

CREATE TABLE dbo.tbl_animalia (
    animalia_id INT IDENTITY(1,1) PRIMARY KEY,
    animalia_type VARCHAR(30) NOT NULL
);

CREATE TABLE dbo.tbl_class (
    class_id INT IDENTITY(100,1) PRIMARY KEY,
    class_type VARCHAR(50) NOT NULL
);

CREATE TABLE dbo.tbl_order (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    order_type VARCHAR(50) NOT NULL
);

CREATE TABLE dbo.tbl_nutrition (
    nutrition_id INT IDENTITY(2200,1) PRIMARY KEY,
    nutrition_type VARCHAR(50) NOT NULL,
    nutrition_cost MONEY NOT NULL
);

CREATE TABLE dbo.tbl_habitat (
    habitat_id INT IDENTITY(5000,1) PRIMARY KEY,
    habitat_type VARCHAR(50) NOT NULL,
    habitat_cost MONEY NOT NULL
);

CREATE TABLE dbo.tbl_specialist (
    specialist_id INT IDENTITY(1,1) PRIMARY KEY,
    specialist_fname VARCHAR(50) NOT NULL,
    specialist_lname VARCHAR(50) NOT NULL,
    specialist_contact VARCHAR(50) NOT NULL
);

CREATE TABLE dbo.tbl_care (
    care_id VARCHAR(50) PRIMARY KEY,
    care_type VARCHAR(50) NOT NULL,
    care_specialist INT NOT NULL,
    CONSTRAINT fk_care_specialist FOREIGN KEY (care_specialist)
        REFERENCES dbo.tbl_specialist(specialist_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE dbo.tbl_species (
    species_id INT IDENTITY(1,1) PRIMARY KEY,
    species_name VARCHAR(50) NOT NULL,
    species_animalia INT NOT NULL,
    species_class INT NOT NULL,
    species_order INT NOT NULL,
    species_habitat INT NOT NULL,
    species_nutrition INT NOT NULL,
    species_care VARCHAR(50) NOT NULL,
    CONSTRAINT fk_species_animalia FOREIGN KEY (species_animalia)
        REFERENCES dbo.tbl_animalia(animalia_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_species_class FOREIGN KEY (species_class)
        REFERENCES dbo.tbl_class(class_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_species_order FOREIGN KEY (species_order)
        REFERENCES dbo.tbl_order(order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_species_habitat FOREIGN KEY (species_habitat)
        REFERENCES dbo.tbl_habitat(habitat_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_species_nutrition FOREIGN KEY (species_nutrition)
        REFERENCES dbo.tbl_nutrition(nutrition_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_species_care FOREIGN KEY (species_care)
        REFERENCES dbo.tbl_care(care_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
GO

INSERT INTO dbo.tbl_animalia (animalia_type)
VALUES ('vertebrate'), ('invertebrate');

INSERT INTO dbo.tbl_class (class_type)
VALUES ('bird'), ('reptile'), ('fish'), ('mammal'),
       ('echinoderm'), ('worm'), ('arthropod'), ('cnidaria');

INSERT INTO dbo.tbl_order (order_type)
VALUES ('carnivore'), ('herbivore'), ('omnivore');

INSERT INTO dbo.tbl_nutrition (nutrition_type, nutrition_cost)
VALUES ('raw fish', 1500),
       ('living rodents', 600),
       ('fruit and rice mix', 800),
       ('warm bottle of milk', 600),
       ('lard and seed mix', 300),
       ('syringe-fed broth', 600),
       ('aphids', 150),
       ('vitamins and marrow', 3500);

INSERT INTO dbo.tbl_habitat (habitat_type, habitat_cost)
VALUES ('tundra', 40000),
       ('grassy knoll with trees', 12000),
       ('pond with rocks', 30000),
       ('icy aquarium with snow facade', 50000),
       ('short grass with shade and moat', 50000),
       ('netted forest atrium', 10000),
       ('jungle vines and branches', 15000),
       ('cliff with shaded cave', 15000);

INSERT INTO dbo.tbl_specialist (specialist_fname, specialist_lname, specialist_contact)
VALUES ('Lamin', 'Badjie', '220-999-1111'),
       ('Buba', 'Jammeh', '220-999-2223'),
       ('Fatou', 'Colley', '220-999-6789'),
       ('Mai', 'Tamba', '220-999-8733'),
       ('Banna', 'Sanneh', '220-999-4695');

INSERT INTO dbo.tbl_care (care_id, care_type, care_specialist)
VALUES ('care_0', 'replace the straw', 1),
       ('care_1', 'repair or replace broken toys', 4),
       ('care_2', 'bottle feed vitamins', 1),
       ('care_3', 'human contact for pet subject', 2),
       ('care_4', 'clean up animal waste', 1),
       ('care_5', 'move subject to exercise pen', 3),
       ('care_6', 'drain and refill aquarium', 1),
       ('care_7', 'extensive dental work', 3);

INSERT INTO dbo.tbl_species (
    species_name,
    species_animalia,
    species_class,
    species_order,
    species_habitat,
    species_nutrition,
    species_care
)
VALUES ('brown bear', 1, 103, 1, 5007, 2200, 'care_1'),
       ('jaguar', 1, 103, 1, 5007, 2200, 'care_4'),
       ('penguin', 1, 100, 1, 5003, 2200, 'care_6'),
       ('ghost bat', 1, 103, 1, 5007, 2204, 'care_2'),
       ('chicken', 1, 100, 3, 5001, 2205, 'care_0'),
       ('panda', 1, 103, 3, 5006, 2202, 'care_4'),
       ('bobcat', 1, 103, 1, 5001, 2204, 'care_5'),
       ('grey wolf', 1, 103, 1, 5000, 2201, 'care_4');
GO

SELECT species_name, species_class, species_habitat, species_nutrition
FROM dbo.tbl_species
ORDER BY species_name;
