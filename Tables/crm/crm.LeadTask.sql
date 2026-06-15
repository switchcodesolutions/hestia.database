CREATE TABLE [crm].[LeadTask]
(
    [Id]                UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_crm_LeadTask_Id              DEFAULT (NEWSEQUENTIALID()),
    [Index]             BIGINT              NOT NULL    IDENTITY(1,1),
    [LeadId]            UNIQUEIDENTIFIER    NOT NULL,
    [CreatedByUserId]   UNIQUEIDENTIFIER    NOT NULL,
    [Title]             NVARCHAR(500)       NOT NULL,
    [DueDate]           DATETIME2(3)        NOT NULL,
    [PriorityId]        INT                 NOT NULL,
    [IsCompleted]       BIT                 NOT NULL    CONSTRAINT DF_crm_LeadTask_IsCompleted      DEFAULT (0),
    [DateCompleted]     DATETIME2(3)        NULL,
    [DateCreated]       DATETIME2(3)        NOT NULL    CONSTRAINT DF_crm_LeadTask_DateCreated      DEFAULT (SYSUTCDATETIME()),
    [DateModified]      DATETIME2(3)        NOT NULL    CONSTRAINT DF_crm_LeadTask_DateModified     DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_crm_LeadTask PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_crm_LeadTask_Index UNIQUE CLUSTERED ([Index]),
    INDEX IX_crm_LeadTask_LeadId ([LeadId], [IsCompleted]),
    INDEX IX_crm_LeadTask_DueDate ([DueDate]) WHERE [IsCompleted] = 0,
    CONSTRAINT FK_crm_LeadTask_Lead FOREIGN KEY ([LeadId])
        REFERENCES [crm].[Lead] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_crm_LeadTask_CreatedByUser FOREIGN KEY ([CreatedByUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_crm_LeadTask_Priority FOREIGN KEY ([PriorityId])
        REFERENCES [crm].[TaskPriority] ([Id]) ON DELETE NO ACTION
);
