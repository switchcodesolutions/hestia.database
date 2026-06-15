CREATE TABLE [comms].[NotificationType]
(
    [Id]            INT             NOT NULL,
    [Name]          NVARCHAR(100)   NOT NULL,
    [Description]   NVARCHAR(500)   NULL,

    CONSTRAINT PK_comms_NotificationType PRIMARY KEY CLUSTERED ([Id])
);
