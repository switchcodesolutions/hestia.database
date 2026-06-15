-- APPEND-ONLY: Grant INSERT and SELECT only. No UPDATE or DELETE permissions.
-- Channel is locked (no new inserts accepted) when the transaction is Terminated.
-- Enforce the lock at the application layer, not via a DB constraint.
CREATE TABLE [comms].[TransactionMessage]
(
    [Id]            UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_comms_TransactionMessage_Id           DEFAULT (NEWSEQUENTIALID()),
    [Index]         BIGINT              NOT NULL    IDENTITY(1,1),
    [TransactionId] UNIQUEIDENTIFIER    NOT NULL,
    [SenderUserId]  UNIQUEIDENTIFIER    NOT NULL,
    [MessageText]   NVARCHAR(MAX)       NOT NULL,
    -- IsArchived supports retention-period archiving; does not mean the message was deleted
    [IsArchived]    BIT                 NOT NULL    CONSTRAINT DF_comms_TransactionMessage_IsArchived    DEFAULT (0),
    [DateArchived]  DATETIME2(3)        NULL,
    [DateCreated]   DATETIME2(3)        NOT NULL    CONSTRAINT DF_comms_TransactionMessage_DateCreated   DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_comms_TransactionMessage PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_comms_TransactionMessage_Index UNIQUE CLUSTERED ([Index]),
    INDEX IX_comms_TransactionMessage_TransactionId ([TransactionId], [DateCreated]),
    CONSTRAINT FK_comms_TransactionMessage_Transaction FOREIGN KEY ([TransactionId])
        REFERENCES [txn].[Transaction] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_comms_TransactionMessage_SenderUser FOREIGN KEY ([SenderUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE NO ACTION
);
