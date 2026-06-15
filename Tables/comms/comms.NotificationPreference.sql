CREATE TABLE [comms].[NotificationPreference]
(
    [UserId]                UNIQUEIDENTIFIER    NOT NULL,
    [NotificationTypeId]    INT                 NOT NULL,
    [IsEmailEnabled]        BIT                 NOT NULL    CONSTRAINT DF_comms_NotificationPreference_IsEmailEnabled DEFAULT (1),
    [IsSmsEnabled]          BIT                 NOT NULL    CONSTRAINT DF_comms_NotificationPreference_IsSmsEnabled   DEFAULT (0),
    [DateModified]          DATETIME2(3)        NOT NULL    CONSTRAINT DF_comms_NotificationPreference_DateModified   DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_comms_NotificationPreference PRIMARY KEY CLUSTERED ([UserId], [NotificationTypeId]),
    CONSTRAINT FK_comms_NotificationPreference_User FOREIGN KEY ([UserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_comms_NotificationPreference_NotificationType FOREIGN KEY ([NotificationTypeId])
        REFERENCES [comms].[NotificationType] ([Id]) ON DELETE NO ACTION
);
