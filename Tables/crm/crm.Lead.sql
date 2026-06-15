CREATE TABLE [crm].[Lead]
(
    [Id]                UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_crm_Lead_Id                   DEFAULT (NEWSEQUENTIALID()),
    [Index]             BIGINT              NOT NULL    IDENTITY(1,1),
    [AgentUserId]       UNIQUEIDENTIFIER    NOT NULL,
    [FirstName]         NVARCHAR(100)       NOT NULL,
    [LastName]          NVARCHAR(100)       NOT NULL,
    [Email]             NVARCHAR(320)       NOT NULL,
    [Phone]             NVARCHAR(50)        NULL,
    [LeadSourceId]      INT                 NOT NULL,
    [LeadTypeId]        INT                 NOT NULL,
    -- Denormalized: updated by app on any activity (note, task, stage change, message)
    -- Used by "Needs Attention" queries without aggregating the full activity log
    [LastActivityDate]  DATETIME2(3)        NOT NULL    CONSTRAINT DF_crm_Lead_LastActivityDate      DEFAULT (SYSUTCDATETIME()),
    [IsArchived]        BIT                 NOT NULL    CONSTRAINT DF_crm_Lead_IsArchived            DEFAULT (0),
    [DateCreated]       DATETIME2(3)        NOT NULL    CONSTRAINT DF_crm_Lead_DateCreated           DEFAULT (SYSUTCDATETIME()),
    [DateModified]      DATETIME2(3)        NOT NULL    CONSTRAINT DF_crm_Lead_DateModified          DEFAULT (SYSUTCDATETIME()),
    [DateArchived]      DATETIME2(3)        NULL,

    CONSTRAINT PK_crm_Lead PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_crm_Lead_Index UNIQUE CLUSTERED ([Index]),
    INDEX IX_crm_Lead_AgentUserId ([AgentUserId], [IsArchived]),
    INDEX IX_crm_Lead_LastActivityDate ([AgentUserId], [LastActivityDate]) WHERE [IsArchived] = 0,
    CONSTRAINT FK_crm_Lead_AgentUser FOREIGN KEY ([AgentUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_crm_Lead_LeadSource FOREIGN KEY ([LeadSourceId])
        REFERENCES [crm].[LeadSource] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_crm_Lead_LeadType FOREIGN KEY ([LeadTypeId])
        REFERENCES [crm].[LeadType] ([Id]) ON DELETE NO ACTION
);
