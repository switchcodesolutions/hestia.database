IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'comms')
    EXEC(N'CREATE SCHEMA [comms]');

