CREATE TABLE [txn].[TerminationReason]
(
    [Id]    INT             NOT NULL,
    [Name]  NVARCHAR(200)   NOT NULL,

    CONSTRAINT PK_txn_TerminationReason PRIMARY KEY CLUSTERED ([Id])
);
