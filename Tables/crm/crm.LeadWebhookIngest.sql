-- APPEND-ONLY: Grant INSERT and SELECT only. No UPDATE or DELETE permissions.
-- Stores the raw payload of every inbound webhook lead request for debugging and reprocessing.
CREATE TABLE [crm].[LeadWebhookIngest]
(
    [Id]                UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_crm_LeadWebhookIngest_Id             DEFAULT (NEWSEQUENTIALID()),
    [Index]             BIGINT              NOT NULL    IDENTITY(1,1),
    [AgentUserId]       UNIQUEIDENTIFIER    NOT NULL,
    -- Populated after successful processing; SET NULL if the lead is later archived/deleted
    [LeadId]            UNIQUEIDENTIFIER    NULL,
    [RawPayload]        NVARCHAR(MAX)       NOT NULL,
    [IsProcessed]       BIT                 NOT NULL    CONSTRAINT DF_crm_LeadWebhookIngest_IsProcessed    DEFAULT (0),
    [ProcessingError]   NVARCHAR(MAX)       NULL,
    [DateReceived]      DATETIME2(3)        NOT NULL    CONSTRAINT DF_crm_LeadWebhookIngest_DateReceived   DEFAULT (SYSUTCDATETIME()),
    [DateProcessed]     DATETIME2(3)        NULL,

    CONSTRAINT PK_crm_LeadWebhookIngest PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_crm_LeadWebhookIngest_Index UNIQUE CLUSTERED ([Index]),
    CONSTRAINT FK_crm_LeadWebhookIngest_AgentUser FOREIGN KEY ([AgentUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_crm_LeadWebhookIngest_Lead FOREIGN KEY ([LeadId])
        REFERENCES [crm].[Lead] ([Id]) ON DELETE SET NULL
);
