CREATE TABLE [auth].[BrokerageFeatureFlag]
(
    [BrokerageId]   UNIQUEIDENTIFIER    NOT NULL,
    [FeatureKey]    NVARCHAR(100)       NOT NULL,
    [IsEnabled]     BIT                 NOT NULL    CONSTRAINT DF_auth_BrokerageFeatureFlag_IsEnabled     DEFAULT (1),
    [DateModified]  DATETIME2(3)        NOT NULL    CONSTRAINT DF_auth_BrokerageFeatureFlag_DateModified  DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_auth_BrokerageFeatureFlag PRIMARY KEY CLUSTERED ([BrokerageId], [FeatureKey]),
    CONSTRAINT FK_auth_BrokerageFeatureFlag_Brokerage FOREIGN KEY ([BrokerageId])
        REFERENCES [auth].[Brokerage] ([Id]) ON DELETE CASCADE
);
