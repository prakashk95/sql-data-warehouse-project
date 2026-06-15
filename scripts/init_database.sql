/*
=======================================
CREATE DATABASE AND SCHEMAS
=======================================
Script Purpose: 
This script create a new database named 'DataWarehouse' after checking if it already exist.
If database exist, it will drop and recreate it. Additionally, the script sets up three schemas 
within database: 'Bronze', 'Silver' and 'Gold'.

WARNING:
Running this script will drop the entire 'DataWarehouse' database if exists.
All data in the database will be permanently deleted. Proceed with 
caution and ensure you have a proper backup of Database before running this script.
*/

use master;

IF EXISTS(SELECT 1 FROM sys.database WHERE name= 'DataWareouse')
  BEGIN
       ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
       DROP DATABASE DataWarehouse;
END;
GO;

--Creating a New Database
CREATE DATABASE DataWarehouse;

USE DataWarehouse;

--CREATE SCHEMA
CREATE SCHEMA Bronze;
GO
  
CREATE SCHEMA Silver;
GO
  
CREATE SCHEMA Gold;
GO

