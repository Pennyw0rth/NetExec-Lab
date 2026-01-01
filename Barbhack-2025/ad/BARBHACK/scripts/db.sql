-- db.sql - MSSQL database setup for SECRET_GOLD
-- Run this on QUEENREV (srv02) in SQL Server Management Studio or via sqlcmd

-- Create the database if it does not exist
IF DB_ID('SECRET_GOLD') IS NULL
BEGIN
    CREATE DATABASE SECRET_GOLD;
END
GO

-- Switch to the SECRET_GOLD database
USE SECRET_GOLD;
GO

-- Create the pirate-themed island table
CREATE TABLE [island] (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    comment NVARCHAR(255) NULL
);
GO

-- Insert pirate islands with Flag 6 hidden in the last entry
INSERT INTO [island] (name, comment) VALUES
('Tortuga', 'Famous pirate hideout in the Caribbean'),
('Isla de Muerta', 'Mysterious island shrouded in legend'),
('Shipwreck Cove', 'Where many pirate ships met their end'),
('Skull Island', 'Dangerous island with hidden treasure'),
('Blackbeard''s Haven', 'Haven for Blackbeard''s crew'),
('Dead Man''s Cay', 'Haunted by ghostly pirates'),
('Redbeard Reef', 'Treacherous reefs claimed many ships'),
('Cutthroat Isle', 'Home to the fiercest pirate crews'),
('Rumrunner''s Bay', 'Pirates loved their rum here'),
('Golden Skull Atoll', 'brb{c37c5303024c911bb23a759d0f4cad75}');
GO

-- Verify table creation
SELECT TABLE_SCHEMA, TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME = 'island';

-- Grant gMSA-shipping$ permission to impersonate sa
-- This needs to be done after the gMSA is created and added to the SQL Server
-- USE master;
-- CREATE LOGIN [PIRATES\gMSA-shipping$] FROM WINDOWS;
-- GRANT IMPERSONATE ON LOGIN::sa TO [PIRATES\gMSA-shipping$];
