-- APPEND-ONLY: Grant INSERT and SELECT only. No UPDATE or DELETE permissions.
CREATE TABLE [crm].[LeadStageHistory]
(
    [Id]                UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_crm_LeadStageHistory_Id          DEFAULT (NEWSEQUENTIALID()),
    [Index]             BIGINT              NOT NULL    IDENTITY(1,1),
    [LeadId]            UNIQUEIDENTIFIER    NOT NULL,
    -- NULL on first assignment (no prior stage)
    [FromStageId]       INT                 NULL,
    [ToStageId]         INT                 NOT NULL,
    [ChangedByUserId]   UNIQUEIDENTIFIER    NOT NULL,
    [DateCreated]       DATETIME2(3)        NOT NULL    CONSTRAINT DF_crm_LeadStageHistory_DateCreated DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_crm_LeadStageHistory PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_crm_LeadStageHistory_Index UNIQUE CLUSTERED ([Index]),
    INDEX IX_crm_LeadStageHistory_LeadId ([LeadId], [DateCreated]),
    CONSTRAINT FK_crm_LeadStageHistory_Lead FOREIGN KEY ([LeadId])
        REFERENCES [crm].[Lead] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_crm_LeadStageHistory_FromStage FOREIGN KEY ([FromStageId])
        REFERENCES [crm].[PipelineStage] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_crm_LeadStageHistory_ToStage FOREIGN KEY ([ToStageId])
        REFERENCES [crm].[PipelineStage] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_crm_LeadStageHistory_ChangedByUser FOREIGN KEY ([ChangedByUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE NO ACTION
);
