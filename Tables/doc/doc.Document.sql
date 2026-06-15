CREATE TABLE [doc].[Document]
(
    [Id]                UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_doc_Document_Id               DEFAULT (NEWSEQUENTIALID()),
    [Index]             BIGINT              NOT NULL    IDENTITY(1,1),
    [TransactionId]     UNIQUEIDENTIFIER    NOT NULL,
    [UploadedByUserId]  UNIQUEIDENTIFIER    NOT NULL,
    [DisplayName]       NVARCHAR(500)       NOT NULL,
    [AccessLevelId]     INT                 NOT NULL,
    -- Brokers always bypass AccessLevel and can view any document
    [IsArchived]        BIT                 NOT NULL    CONSTRAINT DF_doc_Document_IsArchived        DEFAULT (0),
    [DateCreated]       DATETIME2(3)        NOT NULL    CONSTRAINT DF_doc_Document_DateCreated       DEFAULT (SYSUTCDATETIME()),
    [DateModified]      DATETIME2(3)        NOT NULL    CONSTRAINT DF_doc_Document_DateModified      DEFAULT (SYSUTCDATETIME()),
    [DateArchived]      DATETIME2(3)        NULL,

    CONSTRAINT PK_doc_Document PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_doc_Document_Index UNIQUE CLUSTERED ([Index]),
    INDEX IX_doc_Document_TransactionId ([TransactionId], [IsArchived]),
    CONSTRAINT FK_doc_Document_Transaction FOREIGN KEY ([TransactionId])
        REFERENCES [txn].[Transaction] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_doc_Document_UploadedByUser FOREIGN KEY ([UploadedByUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_doc_Document_AccessLevel FOREIGN KEY ([AccessLevelId])
        REFERENCES [doc].[AccessLevel] ([Id]) ON DELETE NO ACTION
);
