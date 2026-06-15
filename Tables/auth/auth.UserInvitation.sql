CREATE TABLE [auth].[UserInvitation]
(
    [Id]                UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_auth_UserInvitation_Id          DEFAULT (NEWSEQUENTIALID()),
    [Index]             BIGINT              NOT NULL    IDENTITY(1,1),
    -- SHA-256 hash of the actual token sent in the invitation URL parameter
    [TokenHash]         NVARCHAR(500)       NOT NULL,
    [InvitedByUserId]   UNIQUEIDENTIFIER    NOT NULL,
    [IntendedRoleId]    INT                 NOT NULL,
    -- BrokerageId scopes brokerage-level invitations (agents/brokers)
    [BrokerageId]       UNIQUEIDENTIFIER    NULL,
    -- TransactionId scopes client invitations (buyers/sellers) — cross-schema, no FK enforced here
    [TransactionId]     UNIQUEIDENTIFIER    NULL,
    [IsUsed]            BIT                 NOT NULL    CONSTRAINT DF_auth_UserInvitation_IsUsed      DEFAULT (0),
    [DateExpires]       DATETIME2(3)        NOT NULL,
    [DateCreated]       DATETIME2(3)        NOT NULL    CONSTRAINT DF_auth_UserInvitation_DateCreated  DEFAULT (SYSUTCDATETIME()),
    [DateUsed]          DATETIME2(3)        NULL,

    CONSTRAINT PK_auth_UserInvitation PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_auth_UserInvitation_Index UNIQUE CLUSTERED ([Index]),
    CONSTRAINT UX_auth_UserInvitation_TokenHash UNIQUE ([TokenHash]),
    CONSTRAINT FK_auth_UserInvitation_InvitedByUser FOREIGN KEY ([InvitedByUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_auth_UserInvitation_Role FOREIGN KEY ([IntendedRoleId])
        REFERENCES [auth].[Role] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_auth_UserInvitation_Brokerage FOREIGN KEY ([BrokerageId])
        REFERENCES [auth].[Brokerage] ([Id]) ON DELETE SET NULL
);
