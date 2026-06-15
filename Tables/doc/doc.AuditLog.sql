-- APPEND-ONLY: Grant INSERT and SELECT only. No UPDATE or DELETE permissions.
CREATE TABLE [doc].[AuditLog]
(
    [Id]                UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_doc_AuditLog_Id          DEFAULT (NEWSEQUENTIALID()),
    [Index]             BIGINT              NOT NULL    IDENTITY(1,1),
    [DocumentId]        UNIQUEIDENTIFIER    NOT NULL,
    -- NULL for document-level events not tied to a specific version
    [DocumentVersionId] UNIQUEIDENTIFIER    NULL,
    -- NULL for system-generated events (e.g., provider webhook callbacks)
    [UserId]            UNIQUEIDENTIFIER    NULL,
    [EventType]         NVARCHAR(100)       NOT NULL,
    [Description]       NVARCHAR(500)       NULL,
    [IpAddress]         NVARCHAR(50)        NULL,
    [DateCreated]       DATETIME2(3)        NOT NULL    CONSTRAINT DF_doc_AuditLog_DateCreated DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_doc_AuditLog PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_doc_AuditLog_Index UNIQUE CLUSTERED ([Index]),
    INDEX IX_doc_AuditLog_DocumentId ([DocumentId], [DateCreated]),
    CONSTRAINT FK_doc_AuditLog_Document FOREIGN KEY ([DocumentId])
        REFERENCES [doc].[Document] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_doc_AuditLog_DocumentVersion FOREIGN KEY ([DocumentVersionId])
        REFERENCES [doc].[DocumentVersion] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_doc_AuditLog_User FOREIGN KEY ([UserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE NO ACTION
);
