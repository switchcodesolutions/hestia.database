-- APPEND-ONLY: Grant INSERT and SELECT only. No UPDATE or DELETE permissions.
CREATE TABLE [txn].[DualAgencyAcknowledgment]
(
    [Id]                            UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_txn_DualAgencyAcknowledgment_Id                DEFAULT (NEWSEQUENTIALID()),
    [Index]                         BIGINT              NOT NULL    IDENTITY(1,1),
    [TransactionId]                 UNIQUEIDENTIFIER    NOT NULL,
    [AcknowledgedByBrokerUserId]    UNIQUEIDENTIFIER    NOT NULL,
    [Notes]                         NVARCHAR(MAX)       NULL,
    [DateAcknowledged]              DATETIME2(3)        NOT NULL    CONSTRAINT DF_txn_DualAgencyAcknowledgment_DateAcknowledged  DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_txn_DualAgencyAcknowledgment PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_txn_DualAgencyAcknowledgment_Index UNIQUE CLUSTERED ([Index]),
    CONSTRAINT FK_txn_DualAgencyAcknowledgment_Transaction FOREIGN KEY ([TransactionId])
        REFERENCES [txn].[Transaction] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_txn_DualAgencyAcknowledgment_BrokerUser FOREIGN KEY ([AcknowledgedByBrokerUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE NO ACTION
);
