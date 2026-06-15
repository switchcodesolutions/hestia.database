CREATE TABLE [comms].[ShowingRequest]
(
    [Id]                        UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_comms_ShowingRequest_Id                  DEFAULT (NEWSEQUENTIALID()),
    [Index]                     BIGINT              NOT NULL    IDENTITY(1,1),
    [ListingId]                 UNIQUEIDENTIFIER    NOT NULL,
    -- NULL when submitted via the public (unauthenticated) showing request link
    [RequestedByUserId]         UNIQUEIDENTIFIER    NULL,
    -- Populated for public requests (no platform account)
    [RequesterName]             NVARCHAR(200)       NULL,
    [RequesterEmail]            NVARCHAR(320)       NULL,
    [ProposedDateTime]          DATETIME2(3)        NOT NULL,
    [ShowingRequestStatusId]    INT                 NOT NULL,
    [DateCreated]               DATETIME2(3)        NOT NULL    CONSTRAINT DF_comms_ShowingRequest_DateCreated          DEFAULT (SYSUTCDATETIME()),
    [DateModified]              DATETIME2(3)        NOT NULL    CONSTRAINT DF_comms_ShowingRequest_DateModified         DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_comms_ShowingRequest PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_comms_ShowingRequest_Index UNIQUE CLUSTERED ([Index]),
    INDEX IX_comms_ShowingRequest_ListingId ([ListingId], [ShowingRequestStatusId]),
    CONSTRAINT FK_comms_ShowingRequest_Listing FOREIGN KEY ([ListingId])
        REFERENCES [listing].[Listing] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_comms_ShowingRequest_RequestedByUser FOREIGN KEY ([RequestedByUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE SET NULL,
    CONSTRAINT FK_comms_ShowingRequest_ShowingRequestStatus FOREIGN KEY ([ShowingRequestStatusId])
        REFERENCES [comms].[ShowingRequestStatus] ([Id]) ON DELETE NO ACTION
);
