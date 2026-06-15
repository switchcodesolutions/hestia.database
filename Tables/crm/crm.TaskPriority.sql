CREATE TABLE [crm].[TaskPriority]
(
    [Id]    INT             NOT NULL,
    [Name]  NVARCHAR(50)    NOT NULL,

    CONSTRAINT PK_crm_TaskPriority PRIMARY KEY CLUSTERED ([Id])
);
