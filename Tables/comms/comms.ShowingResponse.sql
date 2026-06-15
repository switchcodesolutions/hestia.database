CREATE TABLE [comms].[ShowingResponse]
(
    [Id]                        UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_comms_ShowingResponse_Id              DEFAULT (NEWSEQUENTIALID()),
    [Index]                     BIGINT              NOT NULL    IDENTITY(1,1),
    [ShowingRequestId]          UNIQUEIDENTIFIER    NOT NULL,
    [RespondedByUserId]         UNIQUEIDENTIFIER    NOT NULL,
    -- The resulting status after this response (Confirmed, Declined, AlternativeProposed, Cancelled)
    [ShowingRequestStatusId]    INT                 NOT NULL,
    -- Populated when ShowingRequestStatusId = AlternativeProposed
    [AlternativeDateTime]       DATETIME2(3)        NULL,
    [Message]                   NVARCHAR(MAX)       NULL,
    [DateResponded]             DATETIME2(3)        NOT NULL    CONSTRAINT DF_comms_ShowingResponse_DateResponded    DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_comms_ShowingResponse PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_comms_ShowingResponse_Index UNIQUE CLUSTERED ([Index]),
    CONSTRAINT FK_comms_ShowingResponse_ShowingRequest FOREIGN KEY ([ShowingRequestId])
        REFERENCES [comms].[ShowingRequest] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_comms_ShowingResponse_RespondedByUser FOREIGN KEY ([RespondedByUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_comms_ShowingResponse_ShowingRequestStatus FOREIGN KEY ([ShowingRequestStatusId])
        REFERENCES [comms].[ShowingRequestStatus] ([Id]) ON DELETE NO ACTION
);
