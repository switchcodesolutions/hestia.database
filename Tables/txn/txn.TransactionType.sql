-- Purchase=1000 (v1). Lease=2000 reserved for commercial real estate (future).
CREATE TABLE [txn].[TransactionType]
(
    [Id]    INT             NOT NULL,
    [Name]  NVARCHAR(50)    NOT NULL,

    CONSTRAINT PK_txn_TransactionType PRIMARY KEY CLUSTERED ([Id])
);
