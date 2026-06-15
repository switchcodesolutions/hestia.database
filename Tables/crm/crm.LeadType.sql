CREATE TABLE [crm].[LeadType]
(
    [Id]    INT             NOT NULL,
    [Name]  NVARCHAR(50)    NOT NULL,

    CONSTRAINT PK_crm_LeadType PRIMARY KEY CLUSTERED ([Id])
);
