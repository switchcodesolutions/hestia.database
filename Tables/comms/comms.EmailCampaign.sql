CREATE TABLE [comms].[EmailCampaign]
(
    [Id]                UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_comms_EmailCampaign_Id                DEFAULT (NEWSEQUENTIALID()),
    [Index]             BIGINT              NOT NULL    IDENTITY(1,1),
    [AgentUserId]       UNIQUEIDENTIFIER    NOT NULL,
    [Subject]           NVARCHAR(500)       NOT NULL,
    [HtmlBody]          NVARCHAR(MAX)       NOT NULL,
    -- JSON filter criteria used to build the recipient list (lead type, stage, tags)
    [FilterJson]        NVARCHAR(MAX)       NULL,
    [TotalRecipients]   INT                 NOT NULL    CONSTRAINT DF_comms_EmailCampaign_TotalRecipients   DEFAULT (0),
    -- Draft, Sending, Completed, Failed
    [CampaignStatus]    NVARCHAR(50)        NOT NULL    CONSTRAINT DF_comms_EmailCampaign_CampaignStatus    DEFAULT (N'Draft'),
    [DateCreated]       DATETIME2(3)        NOT NULL    CONSTRAINT DF_comms_EmailCampaign_DateCreated       DEFAULT (SYSUTCDATETIME()),
    [DateModified]      DATETIME2(3)        NOT NULL    CONSTRAINT DF_comms_EmailCampaign_DateModified      DEFAULT (SYSUTCDATETIME()),
    [DateCompleted]     DATETIME2(3)        NULL,

    CONSTRAINT PK_comms_EmailCampaign PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_comms_EmailCampaign_Index UNIQUE CLUSTERED ([Index]),
    INDEX IX_comms_EmailCampaign_AgentUserId ([AgentUserId]),
    CONSTRAINT FK_comms_EmailCampaign_AgentUser FOREIGN KEY ([AgentUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE NO ACTION
);
