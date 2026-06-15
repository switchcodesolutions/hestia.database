CREATE TABLE [auth].[Brokerage]
(
    [Id]            UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_auth_Brokerage_Id          DEFAULT (NEWSEQUENTIALID()),
    [Index]         BIGINT              NOT NULL    IDENTITY(1,1),
    [Name]          NVARCHAR(200)       NOT NULL,
    [IsActive]      BIT                 NOT NULL    CONSTRAINT DF_auth_Brokerage_IsActive     DEFAULT (1),
    [DateCreated]   DATETIME2(3)        NOT NULL    CONSTRAINT DF_auth_Brokerage_DateCreated  DEFAULT (SYSUTCDATETIME()),
    [DateModified]  DATETIME2(3)        NOT NULL    CONSTRAINT DF_auth_Brokerage_DateModified DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_auth_Brokerage PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_auth_Brokerage_Index UNIQUE CLUSTERED ([Index])
);
