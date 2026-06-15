CREATE TABLE [txn].[Milestone]
(
    [Id]                    UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_txn_Milestone_Id                  DEFAULT (NEWSEQUENTIALID()),
    [Index]                 BIGINT              NOT NULL    IDENTITY(1,1),
    [TransactionId]         UNIQUEIDENTIFIER    NOT NULL,
    -- NULL for custom (non-template) milestones added by the agent
    [MilestoneTemplateId]   INT                 NULL,
    [Name]                  NVARCHAR(200)       NOT NULL,
    [SortOrder]             INT                 NOT NULL,
    [IsCustom]              BIT                 NOT NULL    CONSTRAINT DF_txn_Milestone_IsCustom            DEFAULT (0),
    -- Updated by background job when TargetDate < SYSUTCDATETIME() and DateCompleted IS NULL
    [IsOverdue]             BIT                 NOT NULL    CONSTRAINT DF_txn_Milestone_IsOverdue           DEFAULT (0),
    [TargetDate]            DATETIME2(3)        NULL,
    [DateCompleted]         DATETIME2(3)        NULL,
    [CompletedByUserId]     UNIQUEIDENTIFIER    NULL,
    [DateCreated]           DATETIME2(3)        NOT NULL    CONSTRAINT DF_txn_Milestone_DateCreated         DEFAULT (SYSUTCDATETIME()),
    [DateModified]          DATETIME2(3)        NOT NULL    CONSTRAINT DF_txn_Milestone_DateModified        DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_txn_Milestone PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_txn_Milestone_Index UNIQUE CLUSTERED ([Index]),
    INDEX IX_txn_Milestone_TransactionId ([TransactionId], [SortOrder]),
    INDEX IX_txn_Milestone_TargetDate ([TargetDate]) WHERE [DateCompleted] IS NULL AND [TargetDate] IS NOT NULL,
    CONSTRAINT FK_txn_Milestone_Transaction FOREIGN KEY ([TransactionId])
        REFERENCES [txn].[Transaction] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_txn_Milestone_MilestoneTemplate FOREIGN KEY ([MilestoneTemplateId])
        REFERENCES [txn].[MilestoneTemplate] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_txn_Milestone_CompletedByUser FOREIGN KEY ([CompletedByUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE SET NULL
);
