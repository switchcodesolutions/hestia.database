CREATE TABLE [comms].[NotificationDelivery]
(
    [Id]                    UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_comms_NotificationDelivery_Id              DEFAULT (NEWSEQUENTIALID()),
    [Index]                 BIGINT              NOT NULL    IDENTITY(1,1),
    [NotificationEventId]   UNIQUEIDENTIFIER    NOT NULL,
    [RecipientUserId]       UNIQUEIDENTIFIER    NOT NULL,
    [ChannelId]             INT                 NOT NULL,
    -- Queued, Sent, Delivered, Failed, Bounced
    [DeliveryStatus]        NVARCHAR(50)        NOT NULL    CONSTRAINT DF_comms_NotificationDelivery_DeliveryStatus  DEFAULT (N'Queued'),
    -- Message ID returned by email/SMS provider; used for status webhook correlation
    [ProviderMessageId]     NVARCHAR(500)       NULL,
    [DateQueued]            DATETIME2(3)        NOT NULL    CONSTRAINT DF_comms_NotificationDelivery_DateQueued      DEFAULT (SYSUTCDATETIME()),
    [DateSent]              DATETIME2(3)        NULL,
    [DateDelivered]         DATETIME2(3)        NULL,

    CONSTRAINT PK_comms_NotificationDelivery PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_comms_NotificationDelivery_Index UNIQUE CLUSTERED ([Index]),
    INDEX IX_comms_NotificationDelivery_RecipientUserId ([RecipientUserId], [DeliveryStatus]),
    CONSTRAINT FK_comms_NotificationDelivery_NotificationEvent FOREIGN KEY ([NotificationEventId])
        REFERENCES [comms].[NotificationEvent] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_comms_NotificationDelivery_RecipientUser FOREIGN KEY ([RecipientUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_comms_NotificationDelivery_Channel FOREIGN KEY ([ChannelId])
        REFERENCES [comms].[DeliveryChannel] ([Id]) ON DELETE NO ACTION
);
