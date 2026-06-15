CREATE TABLE [crm].[PipelineStage]
(
    [Id]        INT             NOT NULL,
    [Name]      NVARCHAR(100)   NOT NULL,
    [SortOrder] INT             NOT NULL,
    -- 1 = terminal stage (InactiveLost, Archived); agent must use explicit action to assign
    [IsTerminal] BIT            NOT NULL,

    CONSTRAINT PK_crm_PipelineStage PRIMARY KEY CLUSTERED ([Id])
);
