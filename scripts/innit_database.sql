/*
Script Purpose: The script creates a new database named 'DataWarehouse' after checking its existence.
If the database exists, it is going to get dropped and recreated after. In addition, the scripts sets up three schemas
within the database: 'bronze', 'silver', and 'gold'.

Warning: Running this script will drop the entire 'DataWarehouse' database if it exists.
All data in the database will be permanently deleted. Proceed with caution
and ensure you have proper backups before running this script
*/

USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE	DataWarehouse;
GO

USE DataWarehouse;

--Create schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
