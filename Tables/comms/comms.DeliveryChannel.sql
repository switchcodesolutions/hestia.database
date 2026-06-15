CREATE TABLE [comms].[DeliveryChannel]
(
    [Id]    INT             NOT NULL,
    [Name]  NVARCHAR(50)    NOT NULL,

    CONSTRAINT PK_comms_DeliveryChannel PRIMARY KEY CLUSTERED ([Id])
);
