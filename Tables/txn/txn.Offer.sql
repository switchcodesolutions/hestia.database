CREATE TABLE [txn].[Offer]
(
    [Id]                        UNIQUEIDENTIFIER    NOT NULL    CONSTRAINT DF_txn_Offer_Id                          DEFAULT (NEWSEQUENTIALID()),
    [Index]                     BIGINT              NOT NULL    IDENTITY(1,1),
    [TransactionId]             UNIQUEIDENTIFIER    NOT NULL,
    -- Self-referencing FK for counter-offer chains. NULL = original offer.
    [ParentOfferId]             UNIQUEIDENTIFIER    NULL,
    [OfferPrice]                DECIMAL(18, 2)      NOT NULL,
    [EarnestMoney]              DECIMAL(18, 2)      NOT NULL,
    [DownPaymentAmount]         DECIMAL(18, 2)      NULL,
    [FinancingTypeId]           INT                 NOT NULL,
    [HasInspectionContingency]  BIT                 NOT NULL    CONSTRAINT DF_txn_Offer_HasInspectionContingency    DEFAULT (0),
    [HasFinancingContingency]   BIT                 NOT NULL    CONSTRAINT DF_txn_Offer_HasFinancingContingency     DEFAULT (0),
    [HasAppraisalContingency]   BIT                 NOT NULL    CONSTRAINT DF_txn_Offer_HasAppraisalContingency     DEFAULT (0),
    [OfferStatusId]             INT                 NOT NULL,
    [DateExpires]               DATETIME2(3)        NOT NULL,
    [DateCreated]               DATETIME2(3)        NOT NULL    CONSTRAINT DF_txn_Offer_DateCreated                 DEFAULT (SYSUTCDATETIME()),
    [DateModified]              DATETIME2(3)        NOT NULL    CONSTRAINT DF_txn_Offer_DateModified                DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_txn_Offer PRIMARY KEY NONCLUSTERED ([Id]),
    INDEX CX_txn_Offer_Index UNIQUE CLUSTERED ([Index]),
    INDEX IX_txn_Offer_TransactionId ([TransactionId], [DateCreated]),
    CONSTRAINT FK_txn_Offer_Transaction FOREIGN KEY ([TransactionId])
        REFERENCES [txn].[Transaction] ([Id]) ON DELETE CASCADE,
    CONSTRAINT FK_txn_Offer_ParentOffer FOREIGN KEY ([ParentOfferId])
        REFERENCES [txn].[Offer] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_txn_Offer_FinancingType FOREIGN KEY ([FinancingTypeId])
        REFERENCES [txn].[FinancingType] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT FK_txn_Offer_OfferStatus FOREIGN KEY ([OfferStatusId])
        REFERENCES [txn].[OfferStatus] ([Id]) ON DELETE NO ACTION
);
