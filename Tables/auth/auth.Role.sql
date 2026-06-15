CREATE TABLE [auth].[Role]
(
    [Id]    INT             NOT NULL,
    [Name]  NVARCHAR(100)   NOT NULL,

    CONSTRAINT PK_auth_Role PRIMARY KEY CLUSTERED ([Id])
);
