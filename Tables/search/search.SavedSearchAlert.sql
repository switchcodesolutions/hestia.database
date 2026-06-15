-- APPEND-ONLY: Grant INSERT and SELECT only. No UPDATE or DELETE permissions.
-- One row per (SavedSearch, Listing) per alert send. Prevents re-alerting on the same listing.
CREATE TABLE [search].[SavedSearchAlert]
(
    [Id]            UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_search_SavedSearchAlert_Id        DEFAULT (NEWSEQUENTIALID()),
    [Index]         BIGINT              NOT NULL    IDENTITY(1,1),
    [SavedSearchId] UNIQUEIDENTIFIER    NOT NULL,
    [ListingId]     UNIQUEIDENTIFIER    NOT NULL,
    [DateSent]      DATETIME2(3)        NOT NULL    CONSTRAINT DF_search_SavedSearchAlert_DateSent  DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_search_SavedSearchAlert PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_search_SavedSearchAlert_Index UNIQUE CLUSTERED ([Index]),
    INDEX IX_search_SavedSearchAlert_SavedSearchId ([SavedSearchId], [DateSent]),
    CONSTRAINT FK_search_SavedSearchAlert_SavedSearch FOREIGN KEY ([SavedSearchId])
        REFERENCES [search].[SavedSearch] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_search_SavedSearchAlert_Listing FOREIGN KEY ([ListingId])
        REFERENCES [listing].[Listing] ([Id]) ON DELETE CASCADE
);
