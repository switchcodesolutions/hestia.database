CREATE TABLE [doc].[AccessLevel]
(
    [Id]    INT             NOT NULL,
    [Name]  NVARCHAR(100)   NOT NULL,

    CONSTRAINT PK_doc_AccessLevel PRIMARY KEY CLUSTERED ([Id])
);
