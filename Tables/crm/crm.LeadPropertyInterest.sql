CREATE TABLE [crm].[LeadPropertyInterest]
(
    [Id]                UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_crm_LeadPropertyInterest_Id             DEFAULT (NEWSEQUENTIALID()),
    [Index]             BIGINT              NOT NULL    IDENTITY(1,1),
    [LeadId]            UNIQUEIDENTIFIER    NOT NULL,
    -- NULL when interest is in an external property (not yet a platform listing)
    [ListingId]         UNIQUEIDENTIFIER    NULL,
    -- Populated for external addresses not in the platform
    [ExternalAddress]   NVARCHAR(500)       NULL,
    [Notes]             NVARCHAR(MAX)       NULL,
    [DateCreated]       DATETIME2(3)        NOT NULL    CONSTRAINT DF_crm_LeadPropertyInterest_DateCreated    DEFAULT (SYSUTCDATETIME()),
    [DateModified]      DATETIME2(3)        NOT NULL    CONSTRAINT DF_crm_LeadPropertyInterest_DateModified   DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_crm_LeadPropertyInterest PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_crm_LeadPropertyInterest_Index UNIQUE CLUSTERED ([Index]),
    CONSTRAINT FK_crm_LeadPropertyInterest_Lead FOREIGN KEY ([LeadId])
        REFERENCES [crm].[Lead] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_crm_LeadPropertyInterest_Listing FOREIGN KEY ([ListingId])
        REFERENCES [listing].[Listing] ([Id]) ON DELETE SET NULL
);
