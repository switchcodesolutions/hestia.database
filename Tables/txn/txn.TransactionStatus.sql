CREATE TABLE [txn].[TransactionStatus]
(
    [Id]    INT             NOT NULL,
    [Name]  NVARCHAR(50)    NOT NULL,

    CONSTRAINT PK_txn_TransactionStatus PRIMARY KEY CLUSTERED ([Id])
);
