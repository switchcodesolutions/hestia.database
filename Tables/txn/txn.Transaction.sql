CREATE TABLE [txn].[Transaction]
(
    [Id]                                        UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_txn_Transaction_Id                            DEFAULT (NEWSEQUENTIALID()),
    [Index]                                     BIGINT              NOT NULL    IDENTITY(1,1),
    [ListingId]                                 UNIQUEIDENTIFIER    NOT NULL,
    [BuyerLeadId]                               UNIQUEIDENTIFIER    NOT NULL,
    -- NULL when the listing agent also represents the seller (single-sided transaction)
    [SellerLeadId]                              UNIQUEIDENTIFIER    NULL,
    [BuyerAgentUserId]                          UNIQUEIDENTIFIER    NOT NULL,
    -- NULL when the same agent represents both sides
    [SellerAgentUserId]                         UNIQUEIDENTIFIER    NULL,
    [TransactionTypeId]                         INT                 NOT NULL,
    [TransactionStatusId]                       INT                 NOT NULL,
    -- Dual-agency flag: set by app when BuyerAgentUserId and SellerAgentUserId share a brokerage
    [IsDualAgency]                              BIT                 NOT NULL    CONSTRAINT DF_txn_Transaction_IsDualAgency                  DEFAULT (0),
    [DualAgencyAcknowledgedByBrokerUserId]      UNIQUEIDENTIFIER    NULL,
    [DualAgencyAcknowledgedDate]                DATETIME2(3)        NULL,
    [TerminationReasonId]                       INT                 NULL,
    [TerminationNotes]                          NVARCHAR(MAX)       NULL,
    [IsArchived]                                BIT                 NOT NULL    CONSTRAINT DF_txn_Transaction_IsArchived                    DEFAULT (0),
    [DateCreated]                               DATETIME2(3)        NOT NULL    CONSTRAINT DF_txn_Transaction_DateCreated                   DEFAULT (SYSUTCDATETIME()),
    [DateModified]                              DATETIME2(3)        NOT NULL    CONSTRAINT DF_txn_Transaction_DateModified                  DEFAULT (SYSUTCDATETIME()),
    [DateClosed]                                DATETIME2(3)        NULL,
    [DateTerminated]                            DATETIME2(3)        NULL,

    CONSTRAINT PK_txn_Transaction PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_txn_Transaction_Index UNIQUE CLUSTERED ([Index]),
    INDEX IX_txn_Transaction_BuyerAgentUserId ([BuyerAgentUserId], [IsArchived]),
    INDEX IX_txn_Transaction_ListingId ([ListingId]),
    CONSTRAINT FK_txn_Transaction_Listing FOREIGN KEY ([ListingId])
        REFERENCES [listing].[Listing] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_txn_Transaction_BuyerLead FOREIGN KEY ([BuyerLeadId])
        REFERENCES [crm].[Lead] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_txn_Transaction_SellerLead FOREIGN KEY ([SellerLeadId])
        REFERENCES [crm].[Lead] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_txn_Transaction_BuyerAgent FOREIGN KEY ([BuyerAgentUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_txn_Transaction_SellerAgent FOREIGN KEY ([SellerAgentUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_txn_Transaction_TransactionType FOREIGN KEY ([TransactionTypeId])
        REFERENCES [txn].[TransactionType] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_txn_Transaction_TransactionStatus FOREIGN KEY ([TransactionStatusId])
        REFERENCES [txn].[TransactionStatus] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_txn_Transaction_DualAgencyBroker FOREIGN KEY ([DualAgencyAcknowledgedByBrokerUserId])
        REFERENCES [auth].[User] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_txn_Transaction_TerminationReason FOREIGN KEY ([TerminationReasonId])
        REFERENCES [txn].[TerminationReason] ([Id]) ON DELETE NO ACTION
);
