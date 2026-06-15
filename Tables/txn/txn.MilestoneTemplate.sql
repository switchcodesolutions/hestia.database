-- Seeded with 9 default milestones. DefaultSortOrder drives the pre-population order on new transactions.
CREATE TABLE [txn].[MilestoneTemplate]
(
    [Id]                INT             NOT NULL,
    [Name]              NVARCHAR(200)   NOT NULL,
    [DefaultSortOrder]  INT             NOT NULL,

    CONSTRAINT PK_txn_MilestoneTemplate PRIMARY KEY CLUSTERED ([Id])
);
