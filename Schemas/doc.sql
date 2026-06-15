IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'doc')
    EXEC(N'CREATE SCHEMA [doc]');

