-- APPEND-ONLY: Grant INSERT and SELECT only. No UPDATE or DELETE permissions.
CREATE TABLE [auth].[AuditLog]
(
    [Id]            UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_auth_AuditLog_Id          DEFAULT (NEWSEQUENTIALID()),
    [Index]         BIGINT              NOT NULL    IDENTITY(1,1),
    -- NULL for system-generated events (e.g., automated account lock)
    [UserId]        UNIQUEIDENTIFIER    NULL,
    [EventType]     NVARCHAR(100)       NOT NULL,
    [EntityType]    NVARCHAR(100)       NULL,
    [EntityId]      NVARCHAR(200)       NULL,
    [OldValues]     NVARCHAR(MAX)       NULL,
    [NewValues]     NVARCHAR(MAX)       NULL,
    [IpAddress]     NVARCHAR(50)        NULL,
    [UserAgent]     NVARCHAR(1000)      NULL,
    [DateCreated]   DATETIME2(3)        NOT NULL    CONSTRAINT DF_auth_AuditLog_DateCreated DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_auth_AuditLog PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_auth_AuditLog_Index UNIQUE CLUSTERED ([Index]),
    INDEX IX_auth_AuditLog_UserId ([UserId]) WHERE [UserId] IS NOT NULL,
    INDEX IX_auth_AuditLog_DateCreated ([DateCreated]),
    CONSTRAINT FK_auth_AuditLog_User FOREIGN KEY ([UserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE SET NULL
);
