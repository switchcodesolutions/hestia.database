IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'crm')
    EXEC(N'CREATE SCHEMA [crm]');

