-- APPEND-ONLY: Grant INSERT and SELECT only. No UPDATE or DELETE permissions.
CREATE TABLE [crm].[LeadNote]
(
    [Id]            UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_crm_LeadNote_Id          DEFAULT (NEWSEQUENTIALID()),
    [Index]         BIGINT              NOT NULL    IDENTITY(1,1),
    [LeadId]        UNIQUEIDENTIFIER    NOT NULL,
    [AuthorUserId]  UNIQUEIDENTIFIER    NOT NULL,
    [NoteText]      NVARCHAR(MAX)       NOT NULL,
    [DateCreated]   DATETIME2(3)        NOT NULL    CONSTRAINT DF_crm_LeadNote_DateCreated DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_crm_LeadNote PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_crm_LeadNote_Index UNIQUE CLUSTERED ([Index]),
    INDEX IX_crm_LeadNote_LeadId ([LeadId], [DateCreated]),
    CONSTRAINT FK_crm_LeadNote_Lead FOREIGN KEY ([LeadId])
        REFERENCES [crm].[Lead] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_crm_LeadNote_AuthorUser FOREIGN KEY ([AuthorUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE NO ACTION
);
