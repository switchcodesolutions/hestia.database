CREATE TABLE [crm].[LeadSource]
(
    [Id]    INT             NOT NULL,
    [Name]  NVARCHAR(100)   NOT NULL,

    CONSTRAINT PK_crm_LeadSource PRIMARY KEY CLUSTERED ([Id])
);
