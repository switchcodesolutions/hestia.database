CREATE TABLE [doc].[SignatureRequestSigner]
(
    [Id]                    UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_doc_SignatureRequestSigner_Id              DEFAULT (NEWSEQUENTIALID()),
    [Index]                 BIGINT              NOT NULL    IDENTITY(1,1),
    [SignatureRequestId]    UNIQUEIDENTIFIER    NOT NULL,
    -- NULL for guest signers who do not have a platform account
    [SignerUserId]          UNIQUEIDENTIFIER    NULL,
    [SignerEmail]           NVARCHAR(320)       NOT NULL,
    [SignerName]            NVARCHAR(200)       NOT NULL,
    -- Lower SortOrder signs first in sequential signing workflows
    [SortOrder]             INT                 NOT NULL    CONSTRAINT DF_doc_SignatureRequestSigner_SortOrder       DEFAULT (0),
    [SignatureStatusId]     INT                 NOT NULL,
    [SignedIpAddress]       NVARCHAR(50)        NULL,
    [DateSigned]            DATETIME2(3)        NULL,

    CONSTRAINT PK_doc_SignatureRequestSigner PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_doc_SignatureRequestSigner_Index UNIQUE CLUSTERED ([Index]),
    CONSTRAINT FK_doc_SignatureRequestSigner_SignatureRequest FOREIGN KEY ([SignatureRequestId])
        REFERENCES [doc].[SignatureRequest] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_doc_SignatureRequestSigner_SignerUser FOREIGN KEY ([SignerUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE SET NULL,
    CONSTRAINT FK_doc_SignatureRequestSigner_SignatureStatus FOREIGN KEY ([SignatureStatusId])
        REFERENCES [doc].[SignatureStatus] ([Id]) ON DELETE NO ACTION
);
