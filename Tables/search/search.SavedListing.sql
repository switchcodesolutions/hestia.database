CREATE TABLE [search].[SavedListing]
(
    [UserId]        UNIQUEIDENTIFIER    NOT NULL,
    [ListingId]     UNIQUEIDENTIFIER    NOT NULL,
    [DateSaved]     DATETIME2(3)        NOT NULL    CONSTRAINT DF_search_SavedListing_DateSaved DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_search_SavedListing PRIMARY KEY CLUSTERED ([UserId], [ListingId]),
    CONSTRAINT FK_search_SavedListing_User FOREIGN KEY ([UserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_search_SavedListing_Listing FOREIGN KEY ([ListingId])
        REFERENCES [listing].[Listing] ([Id]) ON DELETE CASCADE
);
