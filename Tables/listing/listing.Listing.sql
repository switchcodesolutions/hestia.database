CREATE TABLE [listing].[Listing]
(
    [Id]                UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_listing_Listing_Id                DEFAULT (NEWSEQUENTIALID()),
    [Index]             BIGINT              NOT NULL    IDENTITY(1,1),
    [AgentUserId]       UNIQUEIDENTIFIER    NOT NULL,
    -- Nullable: assigned when a seller lead is linked to the listing
    [SellerLeadId]      UNIQUEIDENTIFIER    NULL,
    [PropertyTypeId]    INT                 NOT NULL,
    [ListingStatusId]   INT                 NOT NULL,
    -- Address
    [Street]            NVARCHAR(300)       NOT NULL,
    [City]              NVARCHAR(100)       NOT NULL,
    [State]             NCHAR(2)            NOT NULL,
    [Zip]               NVARCHAR(20)        NOT NULL,
    -- Property details
    [ListingPrice]      DECIMAL(18, 2)      NOT NULL,
    [Bedrooms]          TINYINT             NOT NULL,
    [Bathrooms]         DECIMAL(4, 1)       NOT NULL,
    [SquareFootage]     INT                 NOT NULL,
    [LotSize]           DECIMAL(10, 4)      NULL,
    [YearBuilt]         SMALLINT            NULL,
    -- Optional details
    [HoaFee]            DECIMAL(10, 2)      NULL,
    [GarageSpaces]      TINYINT             NULL,
    [HasBasement]       BIT                 NOT NULL    CONSTRAINT DF_listing_Listing_HasBasement        DEFAULT (0),
    [HasPool]           BIT                 NOT NULL    CONSTRAINT DF_listing_Listing_HasPool            DEFAULT (0),
    [SchoolDistrict]    NVARCHAR(200)       NULL,
    [Description]       NVARCHAR(MAX)       NULL,
    [MlsNumber]         NVARCHAR(100)       NULL,
    [VirtualTourUrl]    NVARCHAR(2000)      NULL,
    -- State
    [IsArchived]        BIT                 NOT NULL    CONSTRAINT DF_listing_Listing_IsArchived         DEFAULT (0),
    [DateCreated]       DATETIME2(3)        NOT NULL    CONSTRAINT DF_listing_Listing_DateCreated        DEFAULT (SYSUTCDATETIME()),
    [DateModified]      DATETIME2(3)        NOT NULL    CONSTRAINT DF_listing_Listing_DateModified       DEFAULT (SYSUTCDATETIME()),
    [DateActivated]     DATETIME2(3)        NULL,
    [DateArchived]      DATETIME2(3)        NULL,

    CONSTRAINT PK_listing_Listing PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_listing_Listing_Index UNIQUE CLUSTERED ([Index]),
    INDEX IX_listing_Listing_AgentUserId ([AgentUserId]),
    INDEX IX_listing_Listing_ListingStatusId ([ListingStatusId]),
    CONSTRAINT FK_listing_Listing_AgentUser FOREIGN KEY ([AgentUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_listing_Listing_SellerLead FOREIGN KEY ([SellerLeadId])
        REFERENCES [crm].[Lead] ([Id]) ON DELETE SET NULL,
    CONSTRAINT FK_listing_Listing_PropertyType FOREIGN KEY ([PropertyTypeId])
        REFERENCES [listing].[PropertyType] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_listing_Listing_ListingStatus FOREIGN KEY ([ListingStatusId])
        REFERENCES [listing].[ListingStatus] ([Id]) ON DELETE NO ACTION
);
