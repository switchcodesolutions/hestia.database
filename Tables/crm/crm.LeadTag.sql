CREATE TABLE [crm].[LeadTag]
(
    [Id]            UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_crm_LeadTag_Id          DEFAULT (NEWSEQUENTIALID()),
    [Index]         BIGINT              NOT NULL    IDENTITY(1,1),
    [AgentUserId]   UNIQUEIDENTIFIER    NOT NULL,
    [TagName]       NVARCHAR(100)       NOT NULL,
    [DateCreated]   DATETIME2(3)        NOT NULL    CONSTRAINT DF_crm_LeadTag_DateCreated DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_crm_LeadTag PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_crm_LeadTag_Index UNIQUE CLUSTERED ([Index]),
    CONSTRAINT UX_crm_LeadTag_AgentTag UNIQUE ([AgentUserId], [TagName]),
    CONSTRAINT FK_crm_LeadTag_AgentUser FOREIGN KEY ([AgentUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE CASCADE
);
