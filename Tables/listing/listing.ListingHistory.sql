-- APPEND-ONLY: Grant INSERT and SELECT only. No UPDATE or DELETE permissions.
CREATE TABLE [listing].[ListingHistory]
(
    [Id]                UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_listing_ListingHistory_Id          DEFAULT (NEWSEQUENTIALID()),
    [Index]             BIGINT              NOT NULL    IDENTITY(1,1),
    [ListingId]         UNIQUEIDENTIFIER    NOT NULL,
    [ChangedByUserId]   UNIQUEIDENTIFIER    NOT NULL,
    [FieldName]         NVARCHAR(200)       NOT NULL,
    [OldValue]          NVARCHAR(MAX)       NULL,
    [NewValue]          NVARCHAR(MAX)       NULL,
    [DateCreated]       DATETIME2(3)        NOT NULL    CONSTRAINT DF_listing_ListingHistory_DateCreated DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_listing_ListingHistory PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_listing_ListingHistory_Index UNIQUE CLUSTERED ([Index]),
    INDEX IX_listing_ListingHistory_ListingId ([ListingId], [DateCreated]),
    CONSTRAINT FK_listing_ListingHistory_Listing FOREIGN KEY ([ListingId])
        REFERENCES [listing].[Listing] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_listing_ListingHistory_ChangedByUser FOREIGN KEY ([ChangedByUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE NO ACTION
);
