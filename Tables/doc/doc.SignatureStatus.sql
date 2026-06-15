CREATE TABLE [doc].[SignatureStatus]
(
    [Id]    INT             NOT NULL,
    [Name]  NVARCHAR(50)    NOT NULL,

    CONSTRAINT PK_doc_SignatureStatus PRIMARY KEY CLUSTERED ([Id])
);
