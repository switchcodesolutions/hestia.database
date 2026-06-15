CREATE TABLE [doc].[SignatureRequest]
(
    [Id]                            UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_doc_SignatureRequest_Id                           DEFAULT (NEWSEQUENTIALID()),
    [Index]                         BIGINT              NOT NULL    IDENTITY(1,1),
    [DocumentVersionId]             UNIQUEIDENTIFIER    NOT NULL,
    [RequestedByUserId]             UNIQUEIDENTIFIER    NOT NULL,
    -- Envelope ID returned by DocuSign (or equivalent provider) after sending
    [ProviderEnvelopeId]            NVARCHAR(500)       NULL,
    -- True when agent attests to an offline (wet) signature in lieu of e-signature
    [IsOfflineSigned]               BIT                 NOT NULL    CONSTRAINT DF_doc_SignatureRequest_IsOfflineSigned              DEFAULT (0),
    -- True when broker has acknowledged the offline signing exception
    [IsOfflineAcknowledgedByBroker] BIT                 NOT NULL    CONSTRAINT DF_doc_SignatureRequest_IsOfflineAcknowledgedByBroker DEFAULT (0),
    [DateRequested]                 DATETIME2(3)        NOT NULL    CONSTRAINT DF_doc_SignatureRequest_DateRequested                DEFAULT (SYSUTCDATETIME()),
    [DateCompleted]                 DATETIME2(3)        NULL,

    CONSTRAINT PK_doc_SignatureRequest PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_doc_SignatureRequest_Index UNIQUE CLUSTERED ([Index]),
    CONSTRAINT FK_doc_SignatureRequest_DocumentVersion FOREIGN KEY ([DocumentVersionId])
        REFERENCES [doc].[DocumentVersion] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_doc_SignatureRequest_RequestedByUser FOREIGN KEY ([RequestedByUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE NO ACTION
);
