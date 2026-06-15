CREATE TABLE [search].[SavedSearch]
(
    [Id]                    UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_search_SavedSearch_Id                  DEFAULT (NEWSEQUENTIALID()),
    [Index]                 BIGINT              NOT NULL    IDENTITY(1,1),
    [UserId]                UNIQUEIDENTIFIER    NOT NULL,
    [Label]                 NVARCHAR(200)       NULL,
    -- Full filter state stored as JSON: { city, state, zip, minPrice, maxPrice, ... }
    [FilterJson]            NVARCHAR(MAX)       NOT NULL,
    [AlertFrequencyId]      INT                 NOT NULL,
    -- Tracks when the last alert batch was sent to prevent duplicate notifications
    [LastAlertSentDate]     DATETIME2(3)        NULL,
    [DateCreated]           DATETIME2(3)        NOT NULL    CONSTRAINT DF_search_SavedSearch_DateCreated         DEFAULT (SYSUTCDATETIME()),
    [DateModified]          DATETIME2(3)        NOT NULL    CONSTRAINT DF_search_SavedSearch_DateModified        DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_search_SavedSearch PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_search_SavedSearch_Index UNIQUE CLUSTERED ([Index]),
    INDEX IX_search_SavedSearch_UserId ([UserId]),
    CONSTRAINT FK_search_SavedSearch_User FOREIGN KEY ([UserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_search_SavedSearch_AlertFrequency FOREIGN KEY ([AlertFrequencyId])
        REFERENCES [search].[AlertFrequency] ([Id]) ON DELETE NO ACTION
);
