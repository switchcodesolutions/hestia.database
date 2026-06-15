CREATE TABLE [comms].[EmailCampaignRecipient]
(
    [Id]                UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_comms_EmailCampaignRecipient_Id              DEFAULT (NEWSEQUENTIALID()),
    [Index]             BIGINT              NOT NULL    IDENTITY(1,1),
    [EmailCampaignId]   UNIQUEIDENTIFIER    NOT NULL,
    [LeadId]            UNIQUEIDENTIFIER    NOT NULL,
    [EmailAddress]      NVARCHAR(320)       NOT NULL,
    -- Queued, Sent, Delivered, Bounced, Failed
    [DeliveryStatus]    NVARCHAR(50)        NOT NULL    CONSTRAINT DF_comms_EmailCampaignRecipient_DeliveryStatus  DEFAULT (N'Queued'),
    [ProviderMessageId] NVARCHAR(500)       NULL,
    -- CAN-SPAM: honored on all future campaigns for this lead
    [IsUnsubscribed]    BIT                 NOT NULL    CONSTRAINT DF_comms_EmailCampaignRecipient_IsUnsubscribed  DEFAULT (0),
    [DateSent]          DATETIME2(3)        NULL,
    [DateDelivered]     DATETIME2(3)        NULL,
    [DateBounced]       DATETIME2(3)        NULL,
    [DateUnsubscribed]  DATETIME2(3)        NULL,

    CONSTRAINT PK_comms_EmailCampaignRecipient PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_comms_EmailCampaignRecipient_Index UNIQUE CLUSTERED ([Index]),
    INDEX IX_comms_EmailCampaignRecipient_EmailCampaignId ([EmailCampaignId]),
    CONSTRAINT FK_comms_EmailCampaignRecipient_EmailCampaign FOREIGN KEY ([EmailCampaignId])
        REFERENCES [comms].[EmailCampaign] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_comms_EmailCampaignRecipient_Lead FOREIGN KEY ([LeadId])
        REFERENCES [crm].[Lead] ([Id]) ON DELETE CASCADE
);
