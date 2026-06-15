CREATE TABLE [doc].[TemplateField]
(
    [Id]                    UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_doc_TemplateField_Id          DEFAULT (NEWSEQUENTIALID()),
    [Index]                 BIGINT              NOT NULL    IDENTITY(1,1),
    [DocumentTemplateId]    UNIQUEIDENTIFIER    NOT NULL,
    -- The merge token used in the template file, e.g. {{property.address}}
    [MergeToken]            NVARCHAR(200)       NOT NULL,
    [Description]           NVARCHAR(500)       NULL,
    [DateCreated]           DATETIME2(3)        NOT NULL    CONSTRAINT DF_doc_TemplateField_DateCreated DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_doc_TemplateField PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_doc_TemplateField_Index UNIQUE CLUSTERED ([Index]),
    CONSTRAINT FK_doc_TemplateField_DocumentTemplate FOREIGN KEY ([DocumentTemplateId])
        REFERENCES [doc].[DocumentTemplate] ([Id]) ON DELETE CASCADE
);
