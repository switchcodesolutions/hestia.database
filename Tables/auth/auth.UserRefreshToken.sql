CREATE TABLE [auth].[UserRefreshToken]
(
    [Id]            UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_auth_UserRefreshToken_Id           DEFAULT (NEWSEQUENTIALID()),
    [Index]         BIGINT              NOT NULL    IDENTITY(1,1),
    [UserId]        UNIQUEIDENTIFIER    NOT NULL,
    -- SHA-256 hash of the opaque token sent to the client
    [TokenHash]     NVARCHAR(500)       NOT NULL,
    [IsRevoked]     BIT                 NOT NULL    CONSTRAINT DF_auth_UserRefreshToken_IsRevoked    DEFAULT (0),
    [DateExpires]   DATETIME2(3)        NOT NULL,
    [DateCreated]   DATETIME2(3)        NOT NULL    CONSTRAINT DF_auth_UserRefreshToken_DateCreated  DEFAULT (SYSUTCDATETIME()),
    [DateRevoked]   DATETIME2(3)        NULL,

    CONSTRAINT PK_auth_UserRefreshToken PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_auth_UserRefreshToken_Index UNIQUE CLUSTERED ([Index]),
    CONSTRAINT UX_auth_UserRefreshToken_TokenHash UNIQUE ([TokenHash]),
    INDEX IX_auth_UserRefreshToken_UserId ([UserId]),
    CONSTRAINT FK_auth_UserRefreshToken_User FOREIGN KEY ([UserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE CASCADE
);
