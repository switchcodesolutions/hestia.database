CREATE TABLE [comms].[NotificationEvent]
(
    [Id]                    UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_comms_NotificationEvent_Id        DEFAULT (NEWSEQUENTIALID()),
    [Index]                 BIGINT              NOT NULL    IDENTITY(1,1),
    [NotificationTypeId]    INT                 NOT NULL,
    -- The type name of the related entity (e.g., 'Transaction', 'Listing', 'Document')
    [RelatedEntityType]     NVARCHAR(100)       NULL,
    -- The GUID of the related entity; no FK enforced as the entity may be in any schema
    [RelatedEntityId]       UNIQUEIDENTIFIER    NULL,
    [DateCreated]           DATETIME2(3)        NOT NULL    CONSTRAINT DF_comms_NotificationEvent_DateCreated DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_comms_NotificationEvent PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_comms_NotificationEvent_Index UNIQUE CLUSTERED ([Index]),
    CONSTRAINT FK_comms_NotificationEvent_NotificationType FOREIGN KEY ([NotificationTypeId])
        REFERENCES [comms].[NotificationType] ([Id]) ON DELETE NO ACTION
);
