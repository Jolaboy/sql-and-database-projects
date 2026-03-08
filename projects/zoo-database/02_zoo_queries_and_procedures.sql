USE db_ZooTest;
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetAnimalInfo
    @animalName VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.tbl_species
        WHERE species_name = @animalName
    )
    BEGIN
        RAISERROR('The requested animal was not found in this zoo database.', 16, 1);
        RETURN;
    END;

    SELECT
        species.species_name,
        animalia.animalia_type,
        class.class_type,
        species_order.order_type,
        habitat.habitat_type,
        nutrition.nutrition_type,
        nutrition.nutrition_cost,
        care.care_type,
        specialist.specialist_fname,
        specialist.specialist_lname
    FROM dbo.tbl_species AS species
    INNER JOIN dbo.tbl_animalia AS animalia
        ON animalia.animalia_id = species.species_animalia
    INNER JOIN dbo.tbl_class AS class
        ON class.class_id = species.species_class
    INNER JOIN dbo.tbl_order AS species_order
        ON species_order.order_id = species.species_order
    INNER JOIN dbo.tbl_habitat AS habitat
        ON habitat.habitat_id = species.species_habitat
    INNER JOIN dbo.tbl_nutrition AS nutrition
        ON nutrition.nutrition_id = species.species_nutrition
    INNER JOIN dbo.tbl_care AS care
        ON care.care_id = species.species_care
    INNER JOIN dbo.tbl_specialist AS specialist
        ON specialist.specialist_id = care.care_specialist
    WHERE species.species_name = @animalName;
END;
GO

SELECT
    species.species_name,
    animalia.animalia_type,
    class.class_type,
    species_order.order_type,
    habitat.habitat_type,
    nutrition.nutrition_type,
    care.care_type
FROM dbo.tbl_species AS species
INNER JOIN dbo.tbl_animalia AS animalia
    ON animalia.animalia_id = species.species_animalia
INNER JOIN dbo.tbl_class AS class
    ON class.class_id = species.species_class
INNER JOIN dbo.tbl_order AS species_order
    ON species_order.order_id = species.species_order
INNER JOIN dbo.tbl_habitat AS habitat
    ON habitat.habitat_id = species.species_habitat
INNER JOIN dbo.tbl_nutrition AS nutrition
    ON nutrition.nutrition_id = species.species_nutrition
INNER JOIN dbo.tbl_care AS care
    ON care.care_id = species.species_care
WHERE species.species_name = 'brown bear';

SELECT
    species.species_name,
    habitat.habitat_type,
    habitat.habitat_cost,
    nutrition.nutrition_type,
    nutrition.nutrition_cost
FROM dbo.tbl_species AS species
INNER JOIN dbo.tbl_habitat AS habitat
    ON habitat.habitat_id = species.species_habitat
INNER JOIN dbo.tbl_nutrition AS nutrition
    ON nutrition.nutrition_id = species.species_nutrition
WHERE species.species_name = 'ghost bat';

SELECT
    habitat_totals.total_habitat_cost,
    nutrition_totals.total_nutrition_cost,
    habitat_totals.total_habitat_cost + nutrition_totals.total_nutrition_cost AS total_operating_cost
FROM (
    SELECT SUM(habitat_cost) AS total_habitat_cost
    FROM dbo.tbl_habitat
) AS habitat_totals
CROSS JOIN (
    SELECT SUM(nutrition_cost) AS total_nutrition_cost
    FROM dbo.tbl_nutrition
) AS nutrition_totals;
GO

EXEC dbo.usp_GetAnimalInfo @animalName = 'jaguar';
GO

