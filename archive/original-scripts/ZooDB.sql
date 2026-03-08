-- Create the database and use it
CREATE DATABASE Zoo_DB;
USE Zoo_DB;

-- Create animal classification table
CREATE TABLE tbl_animalia (
    animalia_id INT PRIMARY KEY IDENTITY(1,1),
    animalia_type VARCHAR(30) NOT NULL
);

INSERT INTO tbl_animalia (animalia_type)
VALUES ('vertebrate'), ('invertebrate');

SELECT * FROM tbl_animalia;

-- Create class table
CREATE TABLE tbl_class (
    class_id INT PRIMARY KEY IDENTITY(100,1),
    class_type VARCHAR(50) NOT NULL
);

INSERT INTO tbl_class (class_type)
VALUES ('birds'), ('reptiles'), ('fish'), ('mammals'),
       ('echinoderm'), ('worm'), ('arthropod'), ('cnidaria');

SELECT * FROM tbl_class;

-- Update and check values in tbl_class
UPDATE tbl_class SET class_type = 'bird' WHERE class_type = 'birds';
SELECT REPLACE(class_type, 'bird', 'birds') FROM tbl_class;
SELECT class_type FROM tbl_class WHERE class_type = 'bird';
SELECT UPPER(class_type) FROM tbl_class WHERE class_type = 'bird';
SELECT COUNT(class_type) FROM tbl_class WHERE class_type = 'bird';

-- Create order classification table
CREATE TABLE tbl_order (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    order_type VARCHAR(50) NOT NULL
);

-- Create care instructions table
CREATE TABLE tbl_care (
    care_id INT PRIMARY KEY IDENTITY(1,1),
    care_type VARCHAR(100) NOT NULL,
    care_specialist INT NOT NULL CONSTRAINT fk_specialist_id FOREIGN KEY REFERENCES tbl_specialist(specialist_id) ON UPDATE CASCADE ON DELETE SET NULL
);

-- Create nutrition table
CREATE TABLE tbl_nutrition (
    nutrition_id INT PRIMARY KEY IDENTITY(2200,1),
    nutrition_type VARCHAR(100) NOT NULL,
    nutrition_cost MONEY NOT NULL
);

-- Create habitat table
CREATE TABLE tbl_habitat (
    habitat_id INT PRIMARY KEY IDENTITY(5000,1),
    habitat_type VARCHAR(100) NOT NULL,
    habitat_cost MONEY NOT NULL
);

-- Create specialist table
CREATE TABLE tbl_specialist (
    specialist_id INT PRIMARY KEY IDENTITY(1,1),
    specialist_fname VARCHAR(50) NOT NULL,
    specialist_lname VARCHAR(50) NOT NULL,
    specialist_contact VARCHAR(20) NOT NULL
);

-- Insert data into tbl_order
INSERT INTO tbl_order (order_type)
VALUES ('carnivore'), ('herbivore'), ('omnivore');

SELECT * FROM tbl_order;

-- Insert data into tbl_care
INSERT INTO tbl_care (care_type, care_specialist)
VALUES ('replace the straw', 1),
       ('repair or replace broken toys', 4),
       ('bottle feed vitamins', 1),
       ('human contact_pet subject', 2),
       ('clean up animal waste', 1),
       ('move subject to exercise pen', 3),
       ('drain and refill aquarium', 1),
       ('extensive dental work', 3);

SELECT * FROM tbl_care;

-- Insert data into tbl_nutrition
INSERT INTO tbl_nutrition (nutrition_type, nutrition_cost)
VALUES ('raw fish', 1500),
       ('living rodents', 600),
       ('mixture of fruit and rice', 800),
       ('warm bottle of milk', 600),
       ('lard and seed mix', 300),
       ('syringe fed broth', 600),
       ('aphids', 150),
       ('vitamins and marrow', 3500);

SELECT * FROM tbl_nutrition;

-- Insert data into tbl_habitat
INSERT INTO tbl_habitat (habitat_type, habitat_cost)
VALUES ('tundra', 40000),
       ('grassy knoll with trees', 12000),
       ('10ft pond and rocks', 30000),
       ('icy aquarium with snowy facade', 50000),
       ('short grass, shade and moat', 50000),
       ('netted forest atrium', 10000),
       ('jungle vines and winding branches', 15000),
       ('cliff with shaded cave', 15000);

SELECT * FROM tbl_habitat;

-- Insert data into tbl_specialist
INSERT INTO tbl_specialist (specialist_fname, specialist_lname, specialist_contact)
VALUES ('lamin', 'badjie', '220-999-1111'),
       ('buba', 'jammeh', '220-999-2223'),
       ('fatou', 'colley', '220-999-6789'),
       ('mai', 'tamba', '220-999-8733'),
       ('banna', 'sanneh', '220-999-4695');

SELECT * FROM tbl_specialist;

-- Create species table with proper foreign keys
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

-- Insert data into tbl_species
INSERT INTO tbl_species (species_name, species_animalia, species_class, species_order, species_habitat, species_nutrition, species_care)
VALUES ('brown bear', 1, 102, 3, 5007, 2200, 2),
       ('jaguar', 1, 102, 3, 5007, 2200, 5),
       ('penguin', 1, 100, 1, 5003, 2200, 7),
       ('ghost bat', 1, 102, 1, 5007, 2204, 3),
       ('chicken', 1, 100, 3, 5001, 2205, 1),
       ('panda', 1, 102, 3, 5006, 2202, 5),
       ('bobcat', 1, 102, 1, 5001, 2204, 6),
       ('grey wolf', 1, 102, 1, 5000, 2201, 5);

SELECT * FROM tbl_species;