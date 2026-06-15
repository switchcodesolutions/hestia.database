CREATE TABLE [listing].[ListingPhoto]
(
    [Id]            UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_listing_ListingPhoto_Id           DEFAULT (NEWSEQUENTIALID()),
    [Index]         BIGINT              NOT NULL    IDENTITY(1,1),
    [ListingId]     UNIQUEIDENTIFIER    NOT NULL,
    -- Azure Blob Storage URL; binary is never stored in SQL
    [BlobUrl]       NVARCHAR(2000)      NOT NULL,
    [FileName]      NVARCHAR(500)       NOT NULL,
    [FileSizeBytes] INT                 NOT NULL,
    -- 0-based; lower SortOrder = shown first; SortOrder 0 is the cover photo
    [SortOrder]     INT                 NOT NULL    CONSTRAINT DF_listing_ListingPhoto_SortOrder    DEFAULT (0),
    [DateCreated]   DATETIME2(3)        NOT NULL    CONSTRAINT DF_listing_ListingPhoto_DateCreated  DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_listing_ListingPhoto PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_listing_ListingPhoto_Index UNIQUE CLUSTERED ([Index]),
    INDEX IX_listing_ListingPhoto_ListingId ([ListingId], [SortOrder]),
    CONSTRAINT FK_listing_ListingPhoto_Listing FOREIGN KEY ([ListingId])
        REFERENCES [listing].[Listing] ([Id]) ON DELETE CASCADE
);
