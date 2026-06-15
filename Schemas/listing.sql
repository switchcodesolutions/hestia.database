IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'listing')
    EXEC(N'CREATE SCHEMA [listing]');

