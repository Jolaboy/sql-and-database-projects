
-- Lets create new schema [ACADEMY_HR]
CREATE SCHEMA [ACADEMY_HR] AUTHORIZATION [dbo]

-- To delete schema [ACADEMY_HR] execute code below:
DROP SCHEMA IF EXISTS [ACADEMY_HR]

--Try/Catch block implementation
BEGIN TRY
SELECT 35/0 AS Result;
END TRY

BEGIN CATCH
SELECT
ERROR_NUMBER() AS [Error_Code],
ERROR_PROCEDURE() AS [Invalid_Proc],
ERROR_MESSAGE() AS [Error_Details];
END CATCH