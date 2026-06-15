# Hestia — Database Design

**Version:** 1.0  
**Date:** 2026-06-07  
**Status:** Draft  
**Engine:** SQL Server (SSDT publish-to-sync model)

---

## Conventions

| Pattern | Rule |
|---|---|
| **Entity tables** | `[Id] UNIQUEIDENTIFIER NOT NULL` PK NONCLUSTERED (app-assigned) + `[Index] BIGINT IDENTITY(1,1)` unique clustered index |
| **Lookup tables** | `[Id] INT NOT NULL` PK CLUSTERED; values seeded in multiples of 1000 |
| **Junction tables** | Composite FK columns as PK CLUSTERED; no `[Index]`; one `Date<Verb>` membership column |
| **Append-only tables** | INSERT/SELECT grants only at DB level; no UPDATE or DELETE |
| **Dates** | `DATETIME2(3)` with `DEFAULT (SYSUTCDATETIME())`; named `Date<Verb>` |
| **Constraint names** | `PK_<schema>_<Table>`, `FK_<schema>_<Child>_<Parent>`, `DF_<schema>_<Table>_<Col>`, `UX_<schema>_<Table>_<Col>`, `IX_<schema>_<Table>_<Col>`, `CX_<schema>_<Table>_Index` |
| **Cascade rules** | Junction→parent: CASCADE both; owning parent→child: CASCADE; nullable FK: SET NULL; lookup FK: NO ACTION |

---

## Schemas

| Schema | Tables | Purpose |
|---|---|---|
| `auth` | 6 | Users, roles, brokerages, invitations, audit log |
| `listing` | 5 | Property listings, photos, edit history |
| `crm` | 12 | Lead pipeline, notes, tasks, tags, webhook ingest |
| `search` | 5 | Saved searches, alerts, favorites, view events |
| `txn` | 10 | Transactions, offers, milestones, termination |
| `doc` | 9 | Documents, versions, e-signatures, templates, audit |
| `comms` | 11 | Messages, notifications, showings, email campaigns |

---

## Cross-Schema Foreign Key Map

| Child Table | Column | References |
|---|---|---|
| `listing.Listing` | `AgentUserId` | `auth.User.Id` |
| `listing.Listing` | `SellerLeadId` | `crm.Lead.Id` (SET NULL) |
| `listing.ListingPhoto` | `ListingId` | `listing.Listing.Id` (CASCADE) |
| `listing.ListingHistory` | `ListingId` | `listing.Listing.Id` (CASCADE) |
| `listing.ListingHistory` | `ChangedByUserId` | `auth.User.Id` |
| `crm.Lead` | `AgentUserId` | `auth.User.Id` |
| `crm.LeadStageHistory` | `LeadId` | `crm.Lead.Id` (CASCADE) |
| `crm.LeadStageHistory` | `ChangedByUserId` | `auth.User.Id` |
| `crm.LeadNote` | `LeadId` | `crm.Lead.Id` (CASCADE) |
| `crm.LeadTask` | `LeadId` | `crm.Lead.Id` (CASCADE) |
| `crm.LeadPropertyInterest` | `ListingId` | `listing.Listing.Id` (SET NULL) |
| `crm.LeadWebhookIngest` | `LeadId` | `crm.Lead.Id` (SET NULL) |
| `search.SavedSearch` | `UserId` | `auth.User.Id` (CASCADE) |
| `search.SavedSearchAlert` | `SavedSearchId` | `search.SavedSearch.Id` (CASCADE) |
| `search.SavedSearchAlert` | `ListingId` | `listing.Listing.Id` (CASCADE) |
| `search.SavedListing` | `UserId` | `auth.User.Id` (CASCADE) |
| `search.SavedListing` | `ListingId` | `listing.Listing.Id` (CASCADE) |
| `search.ListingViewEvent` | `UserId` | `auth.User.Id` |
| `search.ListingViewEvent` | `ListingId` | `listing.Listing.Id` |
| `txn.Transaction` | `ListingId` | `listing.Listing.Id` |
| `txn.Transaction` | `BuyerLeadId` | `crm.Lead.Id` |
| `txn.Transaction` | `SellerLeadId` | `crm.Lead.Id` (SET NULL) |
| `txn.Transaction` | `BuyerAgentUserId` | `auth.User.Id` |
| `txn.Transaction` | `SellerAgentUserId` | `auth.User.Id` (SET NULL) |
| `txn.Offer` | `TransactionId` | `txn.Transaction.Id` (CASCADE) |
| `txn.Offer` | `ParentOfferId` | `txn.Offer.Id` (self-ref, NO ACTION) |
| `txn.Milestone` | `TransactionId` | `txn.Transaction.Id` (CASCADE) |
| `txn.Milestone` | `CompletedByUserId` | `auth.User.Id` (SET NULL) |
| `txn.DualAgencyAcknowledgment` | `TransactionId` | `txn.Transaction.Id` (CASCADE) |
| `txn.DualAgencyAcknowledgment` | `AcknowledgedByBrokerUserId` | `auth.User.Id` |
| `doc.Document` | `TransactionId` | `txn.Transaction.Id` (CASCADE) |
| `doc.Document` | `UploadedByUserId` | `auth.User.Id` |
| `doc.DocumentVersion` | `DocumentId` | `doc.Document.Id` (CASCADE) |
| `doc.DocumentVersion` | `UploadedByUserId` | `auth.User.Id` |
| `doc.SignatureRequest` | `DocumentVersionId` | `doc.DocumentVersion.Id` (CASCADE) |
| `doc.SignatureRequestSigner` | `SignatureRequestId` | `doc.SignatureRequest.Id` (CASCADE) |
| `doc.SignatureRequestSigner` | `SignerUserId` | `auth.User.Id` (SET NULL) |
| `doc.AuditLog` | `DocumentId` | `doc.Document.Id` (CASCADE) |
| `doc.DocumentTemplate` | `OwnerBrokerageId` | `auth.Brokerage.Id` (SET NULL) |
| `doc.DocumentTemplate` | `OwnerAgentUserId` | `auth.User.Id` (SET NULL) |
| `doc.TemplateField` | `DocumentTemplateId` | `doc.DocumentTemplate.Id` (CASCADE) |
| `comms.TransactionMessage` | `TransactionId` | `txn.Transaction.Id` (CASCADE) |
| `comms.TransactionMessage` | `SenderUserId` | `auth.User.Id` |
| `comms.NotificationPreference` | `UserId` | `auth.User.Id` (CASCADE) |
| `comms.NotificationDelivery` | `NotificationEventId` | `comms.NotificationEvent.Id` (CASCADE) |
| `comms.NotificationDelivery` | `RecipientUserId` | `auth.User.Id` |
| `comms.ShowingRequest` | `ListingId` | `listing.Listing.Id` (CASCADE) |
| `comms.ShowingRequest` | `RequestedByUserId` | `auth.User.Id` (SET NULL) |
| `comms.ShowingResponse` | `ShowingRequestId` | `comms.ShowingRequest.Id` (CASCADE) |
| `comms.ShowingResponse` | `RespondedByUserId` | `auth.User.Id` |
| `comms.EmailCampaign` | `AgentUserId` | `auth.User.Id` |
| `comms.EmailCampaignRecipient` | `EmailCampaignId` | `comms.EmailCampaign.Id` (CASCADE) |
| `comms.EmailCampaignRecipient` | `LeadId` | `crm.Lead.Id` (CASCADE) |

---

## Schema: auth

### ERD

```mermaid
erDiagram
    Role {
        int Id PK
        nvarchar Name
    }
    Brokerage {
        uniqueidentifier Id PK
        bigint Index UK
        nvarchar Name
        bit IsActive
        datetime2 DateCreated
        datetime2 DateModified
    }
    User {
        uniqueidentifier Id PK
        bigint Index UK
        int RoleId FK
        uniqueidentifier BrokerageId FK
        nvarchar Email
        bit EmailVerified
        nvarchar PasswordHash
        nvarchar FirstName
        nvarchar LastName
        nvarchar Phone
        nvarchar LicenseNumber
        nchar LicenseState
        uniqueidentifier WebhookToken
        bit IsActive
        bit IsLocked
        int FailedLoginAttempts
        bit MfaEnabled
        datetime2 DateCreated
        datetime2 DateModified
        datetime2 DateEmailVerified
        datetime2 DateLastLogin
    }
    UserInvitation {
        uniqueidentifier Id PK
        bigint Index UK
        nvarchar TokenHash
        uniqueidentifier InvitedByUserId FK
        int IntendedRoleId FK
        uniqueidentifier BrokerageId FK
        uniqueidentifier TransactionId
        bit IsUsed
        datetime2 DateExpires
        datetime2 DateCreated
        datetime2 DateUsed
    }
    AuditLog {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier UserId FK
        nvarchar EventType
        nvarchar EntityType
        nvarchar EntityId
        nvarchar OldValues
        nvarchar NewValues
        nvarchar IpAddress
        nvarchar UserAgent
        datetime2 DateCreated
    }
    BrokerageFeatureFlag {
        uniqueidentifier BrokerageId FK
        nvarchar FeatureKey
        bit IsEnabled
        datetime2 DateModified
    }
    Role ||--o{ User : "assigned to"
    Brokerage ||--o{ User : "employs"
    Brokerage ||--o{ UserInvitation : "scopes"
    Brokerage ||--o{ BrokerageFeatureFlag : "configures"
    User ||--o{ UserInvitation : "creates"
    User ||--o{ AuditLog : "generates"
```

### Table Inventory

| Table | Type | Notes |
|---|---|---|
| `auth.Role` | Lookup | Agent=1000, Broker=2000, Buyer=3000, Seller=4000 |
| `auth.Brokerage` | Entity | One per real estate firm |
| `auth.User` | Entity | All platform users; `WebhookToken` used for lead ingest |
| `auth.UserInvitation` | Entity | `TokenHash` is SHA-256 of the actual token URL param |
| `auth.AuditLog` | Entity (append-only) | Records all auth events immutably |
| `auth.BrokerageFeatureFlag` | Junction | Brokerage-level feature toggles |

---

## Schema: listing

### ERD

```mermaid
erDiagram
    PropertyType {
        int Id PK
        nvarchar Name
        nvarchar Category
    }
    ListingStatus {
        int Id PK
        nvarchar Name
        bit IsTerminalState
    }
    Listing {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier AgentUserId FK
        uniqueidentifier SellerLeadId FK
        int PropertyTypeId FK
        int ListingStatusId FK
        nvarchar Street
        nvarchar City
        nchar State
        nvarchar Zip
        decimal ListingPrice
        tinyint Bedrooms
        decimal Bathrooms
        int SquareFootage
        decimal LotSize
        smallint YearBuilt
        decimal HoaFee
        tinyint GarageSpaces
        bit HasBasement
        bit HasPool
        nvarchar SchoolDistrict
        nvarchar Description
        nvarchar MlsNumber
        nvarchar VirtualTourUrl
        bit IsArchived
        datetime2 DateCreated
        datetime2 DateModified
        datetime2 DateActivated
        datetime2 DateArchived
    }
    ListingPhoto {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier ListingId FK
        nvarchar BlobUrl
        nvarchar FileName
        int FileSizeBytes
        int SortOrder
        datetime2 DateCreated
    }
    ListingHistory {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier ListingId FK
        uniqueidentifier ChangedByUserId FK
        nvarchar FieldName
        nvarchar OldValue
        nvarchar NewValue
        datetime2 DateCreated
    }
    PropertyType ||--o{ Listing : "classifies"
    ListingStatus ||--o{ Listing : "tracks"
    Listing ||--o{ ListingPhoto : "has"
    Listing ||--o{ ListingHistory : "records"
```

### Table Inventory

| Table | Type | Notes |
|---|---|---|
| `listing.PropertyType` | Lookup | SingleFamily=1000, Condo=2000, Townhome=3000, MultiFamily=4000; 5000+ reserved for commercial |
| `listing.ListingStatus` | Lookup | Draft=1000, Active=2000, Pending=3000, Sold=4000, Expired=5000, Withdrawn=6000 |
| `listing.Listing` | Entity | Core listing record; `SellerLeadId` SET NULL on lead delete |
| `listing.ListingPhoto` | Entity | Blob metadata only; binary in Azure Blob Storage |
| `listing.ListingHistory` | Entity (append-only) | Full field-level audit trail for all listing edits |

---

## Schema: crm

### ERD

```mermaid
erDiagram
    LeadSource {
        int Id PK
        nvarchar Name
    }
    LeadType {
        int Id PK
        nvarchar Name
    }
    PipelineStage {
        int Id PK
        nvarchar Name
        int SortOrder
        bit IsTerminal
    }
    TaskPriority {
        int Id PK
        nvarchar Name
    }
    Lead {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier AgentUserId FK
        nvarchar FirstName
        nvarchar LastName
        nvarchar Email
        nvarchar Phone
        int LeadSourceId FK
        int LeadTypeId FK
        datetime2 LastActivityDate
        bit IsArchived
        datetime2 DateCreated
        datetime2 DateModified
    }
    LeadStageHistory {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier LeadId FK
        int FromStageId FK
        int ToStageId FK
        uniqueidentifier ChangedByUserId FK
        datetime2 DateCreated
    }
    LeadNote {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier LeadId FK
        uniqueidentifier AuthorUserId FK
        nvarchar NoteText
        datetime2 DateCreated
    }
    LeadTask {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier LeadId FK
        uniqueidentifier CreatedByUserId FK
        nvarchar Title
        datetime2 DueDate
        int PriorityId FK
        bit IsCompleted
        datetime2 DateCompleted
        datetime2 DateCreated
        datetime2 DateModified
    }
    LeadTag {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier AgentUserId FK
        nvarchar TagName
        datetime2 DateCreated
    }
    LeadTagAssignment {
        uniqueidentifier LeadId FK
        uniqueidentifier LeadTagId FK
        datetime2 DateAssigned
    }
    LeadPropertyInterest {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier LeadId FK
        uniqueidentifier ListingId FK
        nvarchar ExternalAddress
        nvarchar Notes
        datetime2 DateCreated
        datetime2 DateModified
    }
    LeadWebhookIngest {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier AgentUserId FK
        uniqueidentifier LeadId FK
        nvarchar RawPayload
        bit IsProcessed
        nvarchar ProcessingError
        datetime2 DateReceived
        datetime2 DateProcessed
    }
    Lead ||--o{ LeadStageHistory : "tracks"
    Lead ||--o{ LeadNote : "has"
    Lead ||--o{ LeadTask : "has"
    Lead ||--o{ LeadTagAssignment : "tagged by"
    Lead ||--o{ LeadPropertyInterest : "interested in"
    Lead ||--o{ LeadWebhookIngest : "sourced from"
    LeadTag ||--o{ LeadTagAssignment : "applied via"
    LeadSource ||--o{ Lead : "classifies"
    LeadType ||--o{ Lead : "classifies"
    PipelineStage ||--o{ LeadStageHistory : "from"
    PipelineStage ||--o{ LeadStageHistory : "to"
    TaskPriority ||--o{ LeadTask : "prioritizes"
```

### Table Inventory

| Table | Type | Notes |
|---|---|---|
| `crm.LeadSource` | Lookup | Website=1000, Referral=2000, OpenHouse=3000, SocialMedia=4000, Zillow=5000, RealtorCom=6000, Other=7000 |
| `crm.LeadType` | Lookup | Buyer=1000, Seller=2000 |
| `crm.PipelineStage` | Lookup | New=1000…Archived=8000; `IsTerminal=1` for InactiveLost and Archived |
| `crm.TaskPriority` | Lookup | Low=1000, Medium=2000, High=3000 |
| `crm.Lead` | Entity | `LastActivityDate` updated by app on any activity; `WebhookToken` on parent `auth.User` |
| `crm.LeadStageHistory` | Entity (append-only) | `FromStageId` nullable (NULL on first stage assignment) |
| `crm.LeadNote` | Entity (append-only) | No UPDATE or DELETE grants |
| `crm.LeadTask` | Entity | Mutable; `DateCompleted` set when `IsCompleted = 1` |
| `crm.LeadTag` | Entity | Unique per (AgentUserId, TagName) |
| `crm.LeadTagAssignment` | Junction | CASCADE both sides |
| `crm.LeadPropertyInterest` | Entity | `ListingId` nullable (external address supported) |
| `crm.LeadWebhookIngest` | Entity (append-only) | Raw payload archive; `LeadId` SET NULL if lead is later deleted |

---

## Schema: search

### ERD

```mermaid
erDiagram
    AlertFrequency {
        int Id PK
        nvarchar Name
    }
    SavedSearch {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier UserId FK
        nvarchar Label
        nvarchar FilterJson
        int AlertFrequencyId FK
        datetime2 LastAlertSentDate
        datetime2 DateCreated
        datetime2 DateModified
    }
    SavedSearchAlert {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier SavedSearchId FK
        uniqueidentifier ListingId FK
        datetime2 DateSent
    }
    SavedListing {
        uniqueidentifier UserId FK
        uniqueidentifier ListingId FK
        datetime2 DateSaved
    }
    ListingViewEvent {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier UserId FK
        uniqueidentifier ListingId FK
        datetime2 DateViewed
    }
    AlertFrequency ||--o{ SavedSearch : "configures"
    SavedSearch ||--o{ SavedSearchAlert : "generates"
    SavedListing }o--|| SavedSearch : "belongs to user"
```

### Table Inventory

| Table | Type | Notes |
|---|---|---|
| `search.AlertFrequency` | Lookup | Immediately=1000, DailyDigest=2000, WeeklyDigest=3000 |
| `search.SavedSearch` | Entity | `FilterJson` stores full filter state as JSON |
| `search.SavedSearchAlert` | Entity (append-only) | One row per listing per alert sent; prevents re-alerting |
| `search.SavedListing` | Junction | Buyer favorites; composite PK (UserId, ListingId) |
| `search.ListingViewEvent` | Entity (append-only) | High-volume; consider monthly partitioning in production |

---

## Schema: txn

### ERD

```mermaid
erDiagram
    TransactionType {
        int Id PK
        nvarchar Name
    }
    TransactionStatus {
        int Id PK
        nvarchar Name
    }
    FinancingType {
        int Id PK
        nvarchar Name
    }
    OfferStatus {
        int Id PK
        nvarchar Name
    }
    TerminationReason {
        int Id PK
        nvarchar Name
    }
    MilestoneTemplate {
        int Id PK
        nvarchar Name
        int DefaultSortOrder
    }
    Transaction {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier ListingId FK
        uniqueidentifier BuyerLeadId FK
        uniqueidentifier SellerLeadId FK
        uniqueidentifier BuyerAgentUserId FK
        uniqueidentifier SellerAgentUserId FK
        int TransactionTypeId FK
        int TransactionStatusId FK
        bit IsDualAgency
        uniqueidentifier DualAgencyAcknowledgedByBrokerUserId FK
        datetime2 DualAgencyAcknowledgedDate
        int TerminationReasonId FK
        nvarchar TerminationNotes
        bit IsArchived
        datetime2 DateCreated
        datetime2 DateModified
        datetime2 DateClosed
        datetime2 DateTerminated
    }
    Offer {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier TransactionId FK
        uniqueidentifier ParentOfferId FK
        decimal OfferPrice
        decimal EarnestMoney
        decimal DownPaymentAmount
        int FinancingTypeId FK
        bit HasInspectionContingency
        bit HasFinancingContingency
        bit HasAppraisalContingency
        int OfferStatusId FK
        datetime2 DateExpires
        datetime2 DateCreated
        datetime2 DateModified
    }
    Milestone {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier TransactionId FK
        int MilestoneTemplateId FK
        nvarchar Name
        int SortOrder
        bit IsCustom
        bit IsOverdue
        datetime2 TargetDate
        datetime2 DateCompleted
        uniqueidentifier CompletedByUserId FK
        datetime2 DateCreated
        datetime2 DateModified
    }
    DualAgencyAcknowledgment {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier TransactionId FK
        uniqueidentifier AcknowledgedByBrokerUserId FK
        nvarchar Notes
        datetime2 DateAcknowledged
    }
    TransactionType ||--o{ Transaction : "types"
    TransactionStatus ||--o{ Transaction : "tracks"
    TerminationReason ||--o{ Transaction : "explains"
    Transaction ||--o{ Offer : "receives"
    Offer ||--o| Offer : "counters"
    Transaction ||--o{ Milestone : "tracks"
    Transaction ||--o{ DualAgencyAcknowledgment : "requires"
    MilestoneTemplate ||--o{ Milestone : "templates"
    FinancingType ||--o{ Offer : "describes"
    OfferStatus ||--o{ Offer : "tracks"
```

### Table Inventory

| Table | Type | Notes |
|---|---|---|
| `txn.TransactionType` | Lookup | Purchase=1000, Lease=2000 (reserved for commercial v2) |
| `txn.TransactionStatus` | Lookup | Active=1000, UnderContract=2000, Closed=3000, Terminated=4000 |
| `txn.FinancingType` | Lookup | Cash=1000, Conventional=2000, FHA=3000, VA=4000, Other=5000 |
| `txn.OfferStatus` | Lookup | PendingResponse=1000, Accepted=2000, Countered=3000, Rejected=4000, Expired=5000 |
| `txn.TerminationReason` | Lookup | FinancingFellThrough=1000…Other=6000 |
| `txn.MilestoneTemplate` | Lookup | 9 default milestones seeded; `DefaultSortOrder` determines pre-population order |
| `txn.Transaction` | Entity | `SellerLeadId` SET NULL; dual-agency gate enforced at app layer |
| `txn.Offer` | Entity | `ParentOfferId` self-reference (NO ACTION) for counter-offer chains |
| `txn.Milestone` | Entity | `MilestoneTemplateId` nullable (NULL for custom milestones) |
| `txn.DualAgencyAcknowledgment` | Entity (append-only) | One row per broker acknowledgment; transaction may have multiple if re-acknowledged |

---

## Schema: doc

### ERD

```mermaid
erDiagram
    AccessLevel {
        int Id PK
        nvarchar Name
    }
    SignatureStatus {
        int Id PK
        nvarchar Name
    }
    Document {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier TransactionId FK
        uniqueidentifier UploadedByUserId FK
        nvarchar DisplayName
        int AccessLevelId FK
        bit IsArchived
        datetime2 DateCreated
        datetime2 DateModified
        datetime2 DateArchived
    }
    DocumentVersion {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier DocumentId FK
        int VersionNumber
        nvarchar FileName
        nvarchar ContentType
        bigint FileSizeBytes
        nvarchar BlobUrl
        uniqueidentifier UploadedByUserId FK
        datetime2 DateCreated
    }
    SignatureRequest {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier DocumentVersionId FK
        uniqueidentifier RequestedByUserId FK
        nvarchar ProviderEnvelopeId
        bit IsOfflineSigned
        bit IsOfflineAcknowledgedByBroker
        datetime2 DateRequested
        datetime2 DateCompleted
    }
    SignatureRequestSigner {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier SignatureRequestId FK
        uniqueidentifier SignerUserId FK
        nvarchar SignerEmail
        nvarchar SignerName
        int SortOrder
        int SignatureStatusId FK
        nvarchar SignedIpAddress
        datetime2 DateSigned
    }
    AuditLog {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier DocumentId FK
        uniqueidentifier DocumentVersionId FK
        uniqueidentifier UserId FK
        nvarchar EventType
        nvarchar Description
        nvarchar IpAddress
        datetime2 DateCreated
    }
    DocumentTemplate {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier OwnerBrokerageId FK
        uniqueidentifier OwnerAgentUserId FK
        nvarchar Name
        nvarchar Description
        nvarchar TemplateFileName
        nvarchar BlobUrl
        bit IsActive
        datetime2 DateCreated
        datetime2 DateModified
    }
    TemplateField {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier DocumentTemplateId FK
        nvarchar MergeToken
        nvarchar Description
        datetime2 DateCreated
    }
    AccessLevel ||--o{ Document : "controls"
    Document ||--o{ DocumentVersion : "versioned by"
    Document ||--o{ AuditLog : "audited in"
    DocumentVersion ||--o{ SignatureRequest : "sent for"
    SignatureRequest ||--o{ SignatureRequestSigner : "requires"
    SignatureStatus ||--o{ SignatureRequestSigner : "tracks"
    DocumentTemplate ||--o{ TemplateField : "defines"
```

### Table Inventory

| Table | Type | Notes |
|---|---|---|
| `doc.AccessLevel` | Lookup | AgentOnly=1000, AgentBuyer=2000, AgentSeller=3000, AgentBuyerSeller=4000, AllParties=5000 |
| `doc.SignatureStatus` | Lookup | Pending=1000, Signed=2000, Declined=3000 |
| `doc.Document` | Entity | Metadata only; binary in Azure Blob Storage |
| `doc.DocumentVersion` | Entity | `VersionNumber` auto-incremented by app per document |
| `doc.SignatureRequest` | Entity | `ProviderEnvelopeId` from DocuSign callback |
| `doc.SignatureRequestSigner` | Entity | `SignerUserId` nullable (guest signers have no account) |
| `doc.AuditLog` | Entity (append-only) | No UPDATE or DELETE grants; covers all document access events |
| `doc.DocumentTemplate` | Entity | Either brokerage-owned OR agent-owned (not both) |
| `doc.TemplateField` | Entity | Merge token map (e.g., `{{property.address}}`) |

---

## Schema: comms

### ERD

```mermaid
erDiagram
    NotificationType {
        int Id PK
        nvarchar Name
        nvarchar Description
    }
    DeliveryChannel {
        int Id PK
        nvarchar Name
    }
    ShowingRequestStatus {
        int Id PK
        nvarchar Name
    }
    NotificationPreference {
        uniqueidentifier UserId FK
        int NotificationTypeId FK
        bit IsEmailEnabled
        bit IsSmsEnabled
        datetime2 DateModified
    }
    TransactionMessage {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier TransactionId FK
        uniqueidentifier SenderUserId FK
        nvarchar MessageText
        bit IsArchived
        datetime2 DateArchived
        datetime2 DateCreated
    }
    NotificationEvent {
        uniqueidentifier Id PK
        bigint Index UK
        int NotificationTypeId FK
        nvarchar RelatedEntityType
        uniqueidentifier RelatedEntityId
        datetime2 DateCreated
    }
    NotificationDelivery {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier NotificationEventId FK
        uniqueidentifier RecipientUserId FK
        int ChannelId FK
        nvarchar DeliveryStatus
        nvarchar ProviderMessageId
        datetime2 DateQueued
        datetime2 DateSent
        datetime2 DateDelivered
    }
    ShowingRequest {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier ListingId FK
        uniqueidentifier RequestedByUserId FK
        nvarchar RequesterName
        nvarchar RequesterEmail
        datetime2 ProposedDateTime
        int ShowingRequestStatusId FK
        datetime2 DateCreated
        datetime2 DateModified
    }
    ShowingResponse {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier ShowingRequestId FK
        uniqueidentifier RespondedByUserId FK
        int ShowingRequestStatusId FK
        datetime2 AlternativeDateTime
        nvarchar Message
        datetime2 DateResponded
    }
    EmailCampaign {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier AgentUserId FK
        nvarchar Subject
        nvarchar HtmlBody
        nvarchar FilterJson
        int TotalRecipients
        nvarchar CampaignStatus
        datetime2 DateCreated
        datetime2 DateModified
        datetime2 DateCompleted
    }
    EmailCampaignRecipient {
        uniqueidentifier Id PK
        bigint Index UK
        uniqueidentifier EmailCampaignId FK
        uniqueidentifier LeadId FK
        nvarchar EmailAddress
        nvarchar DeliveryStatus
        nvarchar ProviderMessageId
        bit IsUnsubscribed
        datetime2 DateSent
        datetime2 DateDelivered
        datetime2 DateBounced
        datetime2 DateUnsubscribed
    }
    NotificationType ||--o{ NotificationPreference : "configured per"
    NotificationType ||--o{ NotificationEvent : "classifies"
    NotificationEvent ||--o{ NotificationDelivery : "dispatched as"
    DeliveryChannel ||--o{ NotificationDelivery : "via"
    ShowingRequest ||--o{ ShowingResponse : "answered by"
    ShowingRequestStatus ||--o{ ShowingRequest : "tracks"
    ShowingRequestStatus ||--o{ ShowingResponse : "results in"
    EmailCampaign ||--o{ EmailCampaignRecipient : "targets"
```

### Table Inventory

| Table | Type | Notes |
|---|---|---|
| `comms.NotificationType` | Lookup | NewMessage=1000, DocumentUploaded=2000, SignatureRequested=3000, DocumentSigned=4000, MilestoneCompleted=5000, MilestoneOverdue=6000, OfferSubmitted=7000, OfferAccepted=8000 |
| `comms.DeliveryChannel` | Lookup | InApp=1000, Email=2000, SMS=3000 |
| `comms.ShowingRequestStatus` | Lookup | Pending=1000, Confirmed=2000, Declined=3000, AlternativeProposed=4000, Cancelled=5000 |
| `comms.NotificationPreference` | Junction | Composite PK (UserId, NotificationTypeId); defaults all enabled |
| `comms.TransactionMessage` | Entity (append-only) | No UPDATE or DELETE grants; channel locked when transaction terminated |
| `comms.NotificationEvent` | Entity | `RelatedEntityId` is GUID of the triggering entity (listing, transaction, etc.) |
| `comms.NotificationDelivery` | Entity | Updated by email provider webhook callbacks |
| `comms.ShowingRequest` | Entity | `RequestedByUserId` nullable for public (unauthenticated) requests |
| `comms.ShowingResponse` | Entity | One response per state change; multiple responses possible (confirm → cancel) |
| `comms.EmailCampaign` | Entity | `CampaignStatus`: Draft, Sending, Completed, Failed |
| `comms.EmailCampaignRecipient` | Entity | High-volume on large sends; `IsUnsubscribed` honored for all future campaigns |
