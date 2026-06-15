CREATE TABLE [txn].[OfferStatus]
(
    [Id]    INT             NOT NULL,
    [Name]  NVARCHAR(50)    NOT NULL,

    CONSTRAINT PK_txn_OfferStatus PRIMARY KEY CLUSTERED ([Id])
);
