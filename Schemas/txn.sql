IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'txn')
    EXEC(N'CREATE SCHEMA [txn]');

