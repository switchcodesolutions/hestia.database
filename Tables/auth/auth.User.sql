CREATE TABLE [auth].[User]
(
    [Id]                    UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_auth_User_Id                  DEFAULT (NEWSEQUENTIALID()),
    [Index]                 BIGINT              NOT NULL    IDENTITY(1,1),
    [RoleId]                INT                 NOT NULL,
    [BrokerageId]           UNIQUEIDENTIFIER    NULL,
    [Email]                 NVARCHAR(320)       NOT NULL,
    [EmailVerified]         BIT                 NOT NULL    CONSTRAINT DF_auth_User_EmailVerified        DEFAULT (0),
    [PasswordHash]          NVARCHAR(500)       NULL,
    [FirstName]             NVARCHAR(100)       NOT NULL,
    [LastName]              NVARCHAR(100)       NOT NULL,
    [Phone]                 NVARCHAR(50)        NULL,
    [HeadshotBlobUrl]       NVARCHAR(2000)      NULL,
    [LicenseNumber]         NVARCHAR(100)       NULL,
    [LicenseState]          NCHAR(2)            NULL,
    [WebhookToken]          UNIQUEIDENTIFIER    NULL,
    [IsActive]              BIT                 NOT NULL    CONSTRAINT DF_auth_User_IsActive             DEFAULT (1),
    [IsLocked]              BIT                 NOT NULL    CONSTRAINT DF_auth_User_IsLocked             DEFAULT (0),
    [FailedLoginAttempts]   INT                 NOT NULL    CONSTRAINT DF_auth_User_FailedLoginAttempts  DEFAULT (0),
    [MfaEnabled]            BIT                 NOT NULL    CONSTRAINT DF_auth_User_MfaEnabled           DEFAULT (0),
    [MfaSecret]             NVARCHAR(500)       NULL,
    -- ASP.NET Core Identity required columns
    [NormalizedEmail]       NVARCHAR(320)       NULL,
    [SecurityStamp]         NVARCHAR(500)       NULL,
    [LockoutEnabled]        BIT                 NOT NULL    CONSTRAINT DF_auth_User_LockoutEnabled       DEFAULT (1),
    [LockoutEnd]            DATETIMEOFFSET(3)   NULL,
    [DateCreated]           DATETIME2(3)        NOT NULL    CONSTRAINT DF_auth_User_DateCreated          DEFAULT (SYSUTCDATETIME()),
    [DateModified]          DATETIME2(3)        NOT NULL    CONSTRAINT DF_auth_User_DateModified         DEFAULT (SYSUTCDATETIME()),
    [DateEmailVerified]     DATETIME2(3)        NULL,
    [DateLastLogin]         DATETIME2(3)        NULL,

    CONSTRAINT PK_auth_User PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_auth_User_Index UNIQUE CLUSTERED ([Index]),
    CONSTRAINT UX_auth_User_Email UNIQUE ([Email]),
    CONSTRAINT FK_auth_User_Role FOREIGN KEY ([RoleId])
        REFERENCES [auth].[Role] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_auth_User_Brokerage FOREIGN KEY ([BrokerageId])
        REFERENCES [auth].[Brokerage] ([Id]) ON DELETE SET NULL
);
