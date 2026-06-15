-- A template is owned by either a brokerage OR an agent, never both.
-- App layer must enforce the mutual-exclusivity of OwnerBrokerageId and OwnerAgentUserId.
CREATE TABLE [doc].[DocumentTemplate]
(
    [Id]                    UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_doc_DocumentTemplate_Id               DEFAULT (NEWSEQUENTIALID()),
    [Index]                 BIGINT              NOT NULL    IDENTITY(1,1),
    [OwnerBrokerageId]      UNIQUEIDENTIFIER    NULL,
    [OwnerAgentUserId]      UNIQUEIDENTIFIER    NULL,
    [Name]                  NVARCHAR(200)       NOT NULL,
    [Description]           NVARCHAR(1000)      NULL,
    [TemplateFileName]      NVARCHAR(500)       NOT NULL,
    -- Azure Blob Storage URL of the template file
    [BlobUrl]               NVARCHAR(2000)      NOT NULL,
    [IsActive]              BIT                 NOT NULL    CONSTRAINT DF_doc_DocumentTemplate_IsActive         DEFAULT (1),
    [DateCreated]           DATETIME2(3)        NOT NULL    CONSTRAINT DF_doc_DocumentTemplate_DateCreated      DEFAULT (SYSUTCDATETIME()),
    [DateModified]          DATETIME2(3)        NOT NULL    CONSTRAINT DF_doc_DocumentTemplate_DateModified     DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_doc_DocumentTemplate PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_doc_DocumentTemplate_Index UNIQUE CLUSTERED ([Index]),
    CONSTRAINT FK_doc_DocumentTemplate_OwnerBrokerage FOREIGN KEY ([OwnerBrokerageId])
        REFERENCES [auth].[Brokerage] ([Id]) ON DELETE SET NULL,
    CONSTRAINT FK_doc_DocumentTemplate_OwnerAgent FOREIGN KEY ([OwnerAgentUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE SET NULL
);
