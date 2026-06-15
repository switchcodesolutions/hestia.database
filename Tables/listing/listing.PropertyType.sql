-- Values seeded in multiples of 1000. 1000-4000 = residential (v1). 5000+ reserved for commercial.
CREATE TABLE [listing].[PropertyType]
(
    [Id]        INT             NOT NULL,
    [Name]      NVARCHAR(100)   NOT NULL,
    -- 'Residential' or 'Commercial' — used to gate commercial features in future versions
    [Category]  NVARCHAR(50)    NOT NULL,

    CONSTRAINT PK_listing_PropertyType PRIMARY KEY CLUSTERED ([Id])
);
