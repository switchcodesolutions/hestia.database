/*
    Post-Deployment Script — Hestia.Database
    Idempotent MERGE statements for all lookup tables.
    Run after every publish. Safe to run multiple times.
*/

-- ============================================================
-- auth schema
-- ============================================================

MERGE [auth].[Role] AS target
USING (VALUES
    (1000, N'Agent'),
    (2000, N'Broker'),
    (3000, N'Buyer'),
    (4000, N'Seller')
) AS source ([Id], [Name])
ON target.[Id] = source.[Id]
WHEN MATCHED THEN
    UPDATE SET target.[Name] = source.[Name]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], [Name]) VALUES (source.[Id], source.[Name]);

-- ============================================================
-- listing schema
-- ============================================================

MERGE [listing].[PropertyType] AS target
USING (VALUES
    -- Residential (v1)
    (1000, N'Single-Family',    N'Residential'),
    (2000, N'Condo',            N'Residential'),
    (3000, N'Townhome',         N'Residential'),
    (4000, N'Multi-Family',     N'Residential')
    -- 5000+ reserved for Commercial (future)
) AS source ([Id], [Name], [Category])
ON target.[Id] = source.[Id]
WHEN MATCHED THEN
    UPDATE SET target.[Name] = source.[Name], target.[Category] = source.[Category]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], [Name], [Category]) VALUES (source.[Id], source.[Name], source.[Category]);

MERGE [listing].[ListingStatus] AS target
USING (VALUES
    (1000, N'Draft',        0),
    (2000, N'Active',       0),
    (3000, N'Pending',      0),
    (4000, N'Sold',         1),
    (5000, N'Expired',      1),
    (6000, N'Withdrawn',    1)
) AS source ([Id], [Name], [IsTerminalState])
ON target.[Id] = source.[Id]
WHEN MATCHED THEN
    UPDATE SET target.[Name] = source.[Name], target.[IsTerminalState] = source.[IsTerminalState]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], [Name], [IsTerminalState]) VALUES (source.[Id], source.[Name], source.[IsTerminalState]);

-- ============================================================
-- crm schema
-- ============================================================

MERGE [crm].[LeadSource] AS target
USING (VALUES
    (1000, N'Website'),
    (2000, N'Referral'),
    (3000, N'Open House'),
    (4000, N'Social Media'),
    (5000, N'Zillow'),
    (6000, N'Realtor.com'),
    (7000, N'Other')
) AS source ([Id], [Name])
ON target.[Id] = source.[Id]
WHEN MATCHED THEN
    UPDATE SET target.[Name] = source.[Name]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], [Name]) VALUES (source.[Id], source.[Name]);

MERGE [crm].[LeadType] AS target
USING (VALUES
    (1000, N'Buyer'),
    (2000, N'Seller')
) AS source ([Id], [Name])
ON target.[Id] = source.[Id]
WHEN MATCHED THEN
    UPDATE SET target.[Name] = source.[Name]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], [Name]) VALUES (source.[Id], source.[Name]);

MERGE [crm].[PipelineStage] AS target
USING (VALUES
    (1000, N'New',              1,  0),
    (2000, N'Contacted',        2,  0),
    (3000, N'Qualified',        3,  0),
    (4000, N'Active Client',    4,  0),
    (5000, N'Under Contract',   5,  0),
    (6000, N'Closed',           6,  0),
    (7000, N'Inactive / Lost',  7,  1),
    (8000, N'Archived',         8,  1)
) AS source ([Id], [Name], [SortOrder], [IsTerminal])
ON target.[Id] = source.[Id]
WHEN MATCHED THEN
    UPDATE SET
        target.[Name]       = source.[Name],
        target.[SortOrder]  = source.[SortOrder],
        target.[IsTerminal] = source.[IsTerminal]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], [Name], [SortOrder], [IsTerminal])
    VALUES (source.[Id], source.[Name], source.[SortOrder], source.[IsTerminal]);

MERGE [crm].[TaskPriority] AS target
USING (VALUES
    (1000, N'Low'),
    (2000, N'Medium'),
    (3000, N'High')
) AS source ([Id], [Name])
ON target.[Id] = source.[Id]
WHEN MATCHED THEN
    UPDATE SET target.[Name] = source.[Name]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], [Name]) VALUES (source.[Id], source.[Name]);

-- ============================================================
-- search schema
-- ============================================================

MERGE [search].[AlertFrequency] AS target
USING (VALUES
    (1000, N'Immediately'),
    (2000, N'Daily Digest'),
    (3000, N'Weekly Digest')
) AS source ([Id], [Name])
ON target.[Id] = source.[Id]
WHEN MATCHED THEN
    UPDATE SET target.[Name] = source.[Name]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], [Name]) VALUES (source.[Id], source.[Name]);

-- ============================================================
-- txn schema
-- ============================================================

MERGE [txn].[TransactionType] AS target
USING (VALUES
    (1000, N'Purchase'),
    (2000, N'Lease')    -- Reserved for commercial real estate (future)
) AS source ([Id], [Name])
ON target.[Id] = source.[Id]
WHEN MATCHED THEN
    UPDATE SET target.[Name] = source.[Name]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], [Name]) VALUES (source.[Id], source.[Name]);

MERGE [txn].[TransactionStatus] AS target
USING (VALUES
    (1000, N'Active'),
    (2000, N'Under Contract'),
    (3000, N'Closed'),
    (4000, N'Terminated')
) AS source ([Id], [Name])
ON target.[Id] = source.[Id]
WHEN MATCHED THEN
    UPDATE SET target.[Name] = source.[Name]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], [Name]) VALUES (source.[Id], source.[Name]);

MERGE [txn].[FinancingType] AS target
USING (VALUES
    (1000, N'Cash'),
    (2000, N'Conventional'),
    (3000, N'FHA'),
    (4000, N'VA'),
    (5000, N'Other')
) AS source ([Id], [Name])
ON target.[Id] = source.[Id]
WHEN MATCHED THEN
    UPDATE SET target.[Name] = source.[Name]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], [Name]) VALUES (source.[Id], source.[Name]);

MERGE [txn].[OfferStatus] AS target
USING (VALUES
    (1000, N'Pending Response'),
    (2000, N'Accepted'),
    (3000, N'Countered'),
    (4000, N'Rejected'),
    (5000, N'Expired')
) AS source ([Id], [Name])
ON target.[Id] = source.[Id]
WHEN MATCHED THEN
    UPDATE SET target.[Name] = source.[Name]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], [Name]) VALUES (source.[Id], source.[Name]);

MERGE [txn].[TerminationReason] AS target
USING (VALUES
    (1000, N'Financing Fell Through'),
    (2000, N'Inspection Contingency'),
    (3000, N'Appraisal Contingency'),
    (4000, N'Buyer Withdrew'),
    (5000, N'Seller Withdrew'),
    (6000, N'Other')
) AS source ([Id], [Name])
ON target.[Id] = source.[Id]
WHEN MATCHED THEN
    UPDATE SET target.[Name] = source.[Name]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], [Name]) VALUES (source.[Id], source.[Name]);

-- DefaultSortOrder matches the expected progression of a residential purchase transaction
MERGE [txn].[MilestoneTemplate] AS target
USING (VALUES
    (1000, N'Offer Accepted',           1),
    (2000, N'Inspection Ordered',       2),
    (3000, N'Inspection Completed',     3),
    (4000, N'Appraisal Ordered',        4),
    (5000, N'Appraisal Completed',      5),
    (6000, N'Clear to Close',           6),
    (7000, N'Closing Disclosure Sent',  7),
    (8000, N'Closing Scheduled',        8),
    (9000, N'Closed',                   9)
) AS source ([Id], [Name], [DefaultSortOrder])
ON target.[Id] = source.[Id]
WHEN MATCHED THEN
    UPDATE SET
        target.[Name]               = source.[Name],
        target.[DefaultSortOrder]   = source.[DefaultSortOrder]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], [Name], [DefaultSortOrder])
    VALUES (source.[Id], source.[Name], source.[DefaultSortOrder]);

-- ============================================================
-- doc schema
-- ============================================================

MERGE [doc].[AccessLevel] AS target
USING (VALUES
    (1000, N'Agent Only'),
    (2000, N'Agent + Buyer'),
    (3000, N'Agent + Seller'),
    (4000, N'Agent + Buyer + Seller'),
    (5000, N'All Parties')
) AS source ([Id], [Name])
ON target.[Id] = source.[Id]
WHEN MATCHED THEN
    UPDATE SET target.[Name] = source.[Name]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], [Name]) VALUES (source.[Id], source.[Name]);

MERGE [doc].[SignatureStatus] AS target
USING (VALUES
    (1000, N'Pending'),
    (2000, N'Signed'),
    (3000, N'Declined')
) AS source ([Id], [Name])
ON target.[Id] = source.[Id]
WHEN MATCHED THEN
    UPDATE SET target.[Name] = source.[Name]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], [Name]) VALUES (source.[Id], source.[Name]);

-- ============================================================
-- comms schema
-- ============================================================

MERGE [comms].[NotificationType] AS target
USING (VALUES
    (1000, N'NewMessage',           N'A new message was posted in a transaction channel'),
    (2000, N'DocumentUploaded',     N'A document was uploaded to a transaction'),
    (3000, N'SignatureRequested',   N'A document signature was requested'),
    (4000, N'DocumentSigned',       N'All parties have signed a document'),
    (5000, N'MilestoneCompleted',   N'A transaction milestone was marked complete'),
    (6000, N'MilestoneOverdue',     N'A transaction milestone target date has passed'),
    (7000, N'OfferSubmitted',       N'A new offer was submitted on a listing'),
    (8000, N'OfferAccepted',        N'An offer was accepted')
) AS source ([Id], [Name], [Description])
ON target.[Id] = source.[Id]
WHEN MATCHED THEN
    UPDATE SET target.[Name] = source.[Name], target.[Description] = source.[Description]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], [Name], [Description]) VALUES (source.[Id], source.[Name], source.[Description]);

MERGE [comms].[DeliveryChannel] AS target
USING (VALUES
    (1000, N'InApp'),
    (2000, N'Email'),
    (3000, N'SMS')
) AS source ([Id], [Name])
ON target.[Id] = source.[Id]
WHEN MATCHED THEN
    UPDATE SET target.[Name] = source.[Name]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], [Name]) VALUES (source.[Id], source.[Name]);

MERGE [comms].[ShowingRequestStatus] AS target
USING (VALUES
    (1000, N'Pending'),
    (2000, N'Confirmed'),
    (3000, N'Declined'),
    (4000, N'Alternative Proposed'),
    (5000, N'Cancelled')
) AS source ([Id], [Name])
ON target.[Id] = source.[Id]
WHEN MATCHED THEN
    UPDATE SET target.[Name] = source.[Name]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], [Name]) VALUES (source.[Id], source.[Name]);
