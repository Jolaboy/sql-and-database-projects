
CREATE PROCEDURE dbo.ZooDB
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Drop existing tables if they exist (drop in reverse order of FK dependencies)
        IF OBJECT_ID('dbo.tbl_species', 'U') IS NOT NULL DROP TABLE dbo.tbl_species;
        IF OBJECT_ID('dbo.tbl_care', 'U') IS NOT NULL DROP TABLE dbo.tbl_care;
        IF OBJECT_ID('dbo.tbl_nutrition', 'U') IS NOT NULL DROP TABLE dbo.tbl_nutrition;
        IF OBJECT_ID('dbo.tbl_habitat', 'U') IS NOT NULL DROP TABLE dbo.tbl_habitat;
        IF OBJECT_ID('dbo.tbl_specialist', 'U') IS NOT NULL DROP TABLE dbo.tbl_specialist;
        IF OBJECT_ID('dbo.tbl_order', 'U') IS NOT NULL DROP TABLE dbo.tbl_order;
        IF OBJECT_ID('dbo.tbl_class', 'U') IS NOT NULL DROP TABLE dbo.tbl_class;
        IF OBJECT_ID('dbo.tbl_animalia', 'U') IS NOT NULL DROP TABLE dbo.tbl_animalia;

        -- Now re-create all tables
        CREATE TABLE dbo.tbl_animalia (
            animalia_id INT PRIMARY KEY NOT NULL IDENTITY (1,1),
            animalia_type VARCHAR(30) NOT NULL
        );

        CREATE TABLE dbo.tbl_class (
            class_id INT PRIMARY KEY NOT NULL IDENTITY (100,1),
            class_type VARCHAR(50) NOT NULL
        );

        CREATE TABLE dbo.tbl_order (
            order_id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
            order_type VARCHAR(50) NOT NULL
        );

        CREATE TABLE dbo.tbl_care (
            care_id VARCHAR(50) PRIMARY KEY NOT NULL,
            care_type VARCHAR(50) NOT NULL,
            care_specialist INT NOT NULL
        );

        CREATE TABLE dbo.tbl_nutrition (
            nutrition_id INT PRIMARY KEY NOT NULL IDENTITY(2200,1),
            nutrition_type VARCHAR(50) NOT NULL,
            nutrition_cost MONEY NOT NULL
        );

        CREATE TABLE dbo.tbl_habitat (
            habitat_id INT PRIMARY KEY NOT NULL IDENTITY(5000,1),
            habitat_type VARCHAR(50) NOT NULL,
            habitat_cost MONEY NOT NULL
        );

        CREATE TABLE dbo.tbl_specialist (
            specialist_id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
            specialist_fname VARCHAR(50) NOT NULL,
            specialist_lname VARCHAR(50) NOT NULL,
            specialist_contact VARCHAR(50) NOT NULL
        );

        CREATE TABLE dbo.tbl_species (
            species_id INT PRIMARY KEY NOT NULL IDENTITY(1, 1),
            species_name VARCHAR(50) NOT NULL,
            species_animalia INT NOT NULL CONSTRAINT fk_animalia_id FOREIGN KEY REFERENCES dbo.tbl_animalia(animalia_id) ON UPDATE CASCADE ON DELETE CASCADE,
            species_class INT NOT NULL CONSTRAINT fk_class_id FOREIGN KEY REFERENCES dbo.tbl_class(class_id) ON UPDATE CASCADE ON DELETE CASCADE,
            species_order INT NOT NULL CONSTRAINT fk_order_id FOREIGN KEY REFERENCES dbo.tbl_order(order_id) ON UPDATE CASCADE ON DELETE CASCADE,
            species_habitat INT NOT NULL CONSTRAINT fk_habitat_id FOREIGN KEY REFERENCES dbo.tbl_habitat(habitat_id) ON UPDATE CASCADE ON DELETE CASCADE,
            species_nutrition INT NOT NULL CONSTRAINT fk_nutrition_id FOREIGN KEY REFERENCES dbo.tbl_nutrition(nutrition_id) ON UPDATE CASCADE ON DELETE CASCADE,
            species_care VARCHAR(50) NOT NULL CONSTRAINT fk_care_id FOREIGN KEY REFERENCES dbo.tbl_care(care_id) ON UPDATE CASCADE ON DELETE CASCADE
        );

        -- Insert sample data (unchanged from yours)
        INSERT INTO dbo.tbl_animalia (animalia_type)
        VALUES ('vertebrate'), ('invertebrate');

        INSERT INTO dbo.tbl_class (class_type)
        VALUES ('bird'), ('reptiles'), ('fish'), ('mammals'),
               ('echinoderm'), ('worm'), ('arthropod'), ('cnidaria');

        INSERT INTO dbo.tbl_order (order_type)
        VALUES ('carnivore'), ('herbivore'), ('omnivore');

        INSERT INTO dbo.tbl_care (care_id, care_type, care_specialist)
        VALUES 
            ('care_0', 'replace the straw', 1),
            ('care_1', 'repair or replace broken toys', 4),
            ('care_2', 'boottle feed vitamins', 1),
            ('care_3', 'human contact_pet subject', 2),
            ('care_4', 'clean up animal waste', 1),
            ('care_5', 'move subject to exercise pen', 3),
            ('care_6', 'drain and refill aquarium', 1),
            ('care_7', 'extensive dental work', 3);

        INSERT INTO dbo.tbl_nutrition (nutrition_type, nutrition_cost)
        VALUES 
            ('raw fish', 1500), ('living rodents', 600), ('mixture of fruit and rice', 800),
            ('warm bottle of milk', 600), ('lard and seed mix', 300),
            ('syringe fed broth', 600), ('aphids', 150), ('vitamins and marrow', 3500);

        INSERT INTO dbo.tbl_habitat (habitat_type, habitat_cost)
        VALUES 
            ('tundra', 40000), ('grassy knoll with trees', 12000),
            ('10ft pond and rocks', 30000), ('icy aquarium with snowy facade', 50000),
            ('short grass, shade and moat', 50000), ('netted forest atrium', 10000),
            ('jungle vines and winding branches', 15000), ('cliff with shaded cave', 15000);

        INSERT INTO dbo.tbl_specialist (specialist_fname, specialist_lname, specialist_contact)
        VALUES 
            ('lamin', 'badjie', '220-999-1111'),
            ('buba', 'jammeh', '220-999-2223'),
            ('fatou', 'colley', '220-999-6789'),
            ('mai', 'tamba', '220-999-8733'),
            ('banna', 'sanneh', '220-999-4695');

        INSERT INTO dbo.tbl_species (species_name, species_animalia, species_class, species_order, species_habitat, species_nutrition, species_care)
        VALUES
            ('brown bear', 1, 102, 3, 5007, 2200, 'care_1'),
            ('jaguar', 1, 102, 3, 5007, 2200, 'care_4'),
            ('penguin', 1, 100, 1, 5003, 2200, 'care_6'),
            ('ghost bat', 1, 102, 1, 5007, 2204, 'care_2'),
            ('chicken', 1, 100, 3, 5001, 2205, 'care_0'),
            ('panda', 1, 102, 3, 5006, 2202, 'care_4'),
            ('bobcat', 1, 102, 1, 5001, 2204, 'care_5'),
            ('grey wolf', 1, 102, 1, 5000, 2201, 'care_4');

		/* The following queries database using INNER JOINS. */

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
		WHERE species_name = 'ghost bat'
	;

	SELECT
		a1.species_name, a2.habitat_type, a2.habitat_cost,
		a3.nutrition_type, a3.nutrition_cost
		FROM tbl_species a1
		INNER JOIN tbl_habitat a2 ON a2.habitat_id = a1.species_habitat
		INNER JOIN tbl_nutrition a3 ON a3.nutrition_id = a1.species_nutrition
		WHERE species_name = 'ghost bat'
	;
        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;

EXECUTE [dbo].[ZooDB]

/* Use the db_ZooTest to create stored procedure */
USE db_ZooTest

/* Create store procedure getANIMAL_INFO */
CREATE PROC getANIMAL_INFO

@animalName VARCHAR(50)
AS
BEGIN
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
		WHERE species_name = @animalName
   ;
END

/* Execute our stored procedure getANIMAL_INFO */
EXECUTE [dbo].[getANIMAL_INFO] 'brown bear'

EXEC [dbo].[getANIMAL_INFO] 'chicken'

EXEC [dbo].[getANIMAL_INFO] 'jaguar'

USE [db_ZooTest]
GO

DECLARE @animalName VARCHAR(50)
DECLARE @errorString VARCHAR(100)
DECLARE @results AS VARCHAR(5)

SET @animalName = 'jaguar'
SET @errorString = 'There are no ' + @animalName + '''s found at this zoo.'

/* Try block */
BEGIN TRY
	SET @results = (SELECT COUNT(tbl_species.species_name) FROM tbl_species WHERE species_name = @animalName)
	IF @results = 0
		BEGIN  /* logic to follow if this condition is true */
			RAISERROR(@errorString, 16, 1)
			RETURN
		END
	ELSE IF @results = 1
		BEGIN
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
			WHERE species_name = @animalName
			;
        END
END TRY

BEGIN CATCH   /* Catch block sets logic to follow if any errors occur */
	SELECT @errorString = ERROR_MESSAGE()
	RAISERROR (@errorString, 10, 1)
END CATCH

USE [db_ZooTest]
GO
/****** Object: StoredProcedure [dbo].[getANIMAL_INFO] Script Date: 19/06/2025 17:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[getANIMAL_INFO]

@animalName VARCHAR(50)
AS
BEGIN
	DECLARE @errorString VARCHAR(100)
	DECLARE @results AS VARCHAR(5)
	SET @errorString = 'There are no ' + @animalName + '''s found at this zoo.'

	BEGIN TRY
		SET @results = (SELECT COUNT(tbl_species.species_name) FROM tbl_species WHERE species_name = @animalName)
		IF @results = 0
			BEGIN
				RAISERROR(@errorString, 16, 1)
				RETURN
			END
		ELSE IF @results = 1
			BEGIN
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
				WHERE species_name = @animalName
				;
			END
	END TRY

	BEGIN CATCH
		SELECT @errorString = ERROR_MESSAGE()
		RAISERROR (@errorString, 10, 1)
	END CATCH
END

USE [db_ZooTest]
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








