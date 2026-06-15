-- APPEND-ONLY: Grant INSERT and SELECT only. No UPDATE or DELETE permissions.
-- High-volume table. Consider monthly partitioning and archiving rows older than 1 year.
CREATE TABLE [search].[ListingViewEvent]
(
    [Id]            UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_search_ListingViewEvent_Id          DEFAULT (NEWSEQUENTIALID()),
    [Index]         BIGINT              NOT NULL    IDENTITY(1,1),
    [UserId]        UNIQUEIDENTIFIER    NOT NULL,
    [ListingId]     UNIQUEIDENTIFIER    NOT NULL,
    [DateViewed]    DATETIME2(3)        NOT NULL    CONSTRAINT DF_search_ListingViewEvent_DateViewed  DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_search_ListingViewEvent PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_search_ListingViewEvent_Index UNIQUE CLUSTERED ([Index]),
    INDEX IX_search_ListingViewEvent_ListingId ([ListingId], [DateViewed]),
    CONSTRAINT FK_search_ListingViewEvent_User FOREIGN KEY ([UserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_search_ListingViewEvent_Listing FOREIGN KEY ([ListingId])
        REFERENCES [listing].[Listing] ([Id]) ON DELETE NO ACTION
);
