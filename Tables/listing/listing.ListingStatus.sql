CREATE TABLE [listing].[ListingStatus]
(
    [Id]                INT             NOT NULL,
    [Name]              NVARCHAR(50)    NOT NULL,
    -- 1 = listing is archived and excluded from public search results
    [IsTerminalState]   BIT             NOT NULL,

    CONSTRAINT PK_listing_ListingStatus PRIMARY KEY CLUSTERED ([Id])
);
