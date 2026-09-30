/*
=====================================================
Create Database and Schemas
=====================================================
Script purpose
    This script creates a new database named 'Datawarehouse' after checking if it already exists.
    If the database exists, it is dropped and recreated. Additionally. the script sets up theree schemas 
    within the database: 'bronze', 'silver', 'gold'.

WARNING: 
	  Running this script will drop the entire 'Datawarehouse' database if it exists.
	  All data in the database will be permanently deleted. Proceed with caution.
	  and ensure you have backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'Datawarehouse' database
IF EXISTS(SELECT 1 sys.database WHERE name = 'Datawarehouse')
BEGIN
	ALTER DATABASE Datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE Datawarehouse;
END;
GO

-- Create the 'Datawarehouse' database
CREATE DATABASE Datawarehouse;
GO

USE Datawarehouse;
GO

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
