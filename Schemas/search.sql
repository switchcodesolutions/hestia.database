IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'search')
    EXEC(N'CREATE SCHEMA [search]');

