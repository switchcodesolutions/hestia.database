CREATE TABLE [txn].[FinancingType]
(
    [Id]    INT             NOT NULL,
    [Name]  NVARCHAR(50)    NOT NULL,

    CONSTRAINT PK_txn_FinancingType PRIMARY KEY CLUSTERED ([Id])
);
