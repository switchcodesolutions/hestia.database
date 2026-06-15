CREATE TABLE [crm].[LeadTagAssignment]
(
    [LeadId]        UNIQUEIDENTIFIER    NOT NULL,
    [LeadTagId]     UNIQUEIDENTIFIER    NOT NULL,
    [DateAssigned]  DATETIME2(3)        NOT NULL    CONSTRAINT DF_crm_LeadTagAssignment_DateAssigned DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_crm_LeadTagAssignment PRIMARY KEY CLUSTERED ([LeadId], [LeadTagId]),
    CONSTRAINT FK_crm_LeadTagAssignment_Lead FOREIGN KEY ([LeadId])
        REFERENCES [crm].[Lead] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_crm_LeadTagAssignment_LeadTag FOREIGN KEY ([LeadTagId])
        REFERENCES [crm].[LeadTag] ([Id]) ON DELETE CASCADE
);
