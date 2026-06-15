CREATE TABLE [doc].[DocumentVersion]
(
    [Id]                UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_doc_DocumentVersion_Id            DEFAULT (NEWSEQUENTIALID()),
    [Index]             BIGINT              NOT NULL    IDENTITY(1,1),
    [DocumentId]        UNIQUEIDENTIFIER    NOT NULL,
    -- App-managed sequential version number per document (1, 2, 3…)
    [VersionNumber]     INT                 NOT NULL,
    [FileName]          NVARCHAR(500)       NOT NULL,
    [ContentType]       NVARCHAR(200)       NOT NULL,
    [FileSizeBytes]     BIGINT              NOT NULL,
    -- Azure Blob Storage URL; binary is never stored in SQL
    [BlobUrl]           NVARCHAR(2000)      NOT NULL,
    [UploadedByUserId]  UNIQUEIDENTIFIER    NOT NULL,
    [DateCreated]       DATETIME2(3)        NOT NULL    CONSTRAINT DF_doc_DocumentVersion_DateCreated   DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_doc_DocumentVersion PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_doc_DocumentVersion_Index UNIQUE CLUSTERED ([Index]),
    CONSTRAINT UX_doc_DocumentVersion_DocumentVersion UNIQUE ([DocumentId], [VersionNumber]),
    CONSTRAINT FK_doc_DocumentVersion_Document FOREIGN KEY ([DocumentId])
        REFERENCES [doc].[Document] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_doc_DocumentVersion_UploadedByUser FOREIGN KEY ([UploadedByUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE NO ACTION
);
