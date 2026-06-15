<#
.SYNOPSIS
    Creates the Hestia database on (localdb)\MSSQLLocalDB and deploys the full schema.

.DESCRIPTION
    Run from any directory — the script resolves all paths relative to its own location.
    Safe to re-run: all objects are created only if they don't already exist.

.PARAMETER Database
    Target database name. Defaults to "Hestia".

.PARAMETER Server
    SQL Server instance. Defaults to "(localdb)\MSSQLLocalDB".

.EXAMPLE
    .\Scripts\Setup-LocalDb.ps1
    .\Scripts\Setup-LocalDb.ps1 -Database Hestia_Test
#>
param(
    [string]$Database = "Hestia",
    [string]$Server   = "(localdb)\MSSQLLocalDB",
    [switch]$Force    # Drop and recreate the database (WARNING: destroys all data)
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot  # Hestia/ folder

function Invoke-Sql {
    param([string]$Sql, [string]$Db = "master")
    # -I  = QUOTED_IDENTIFIER ON  (required for filtered indexes and indexed views)
    sqlcmd -S $Server -d $Db -E -I -Q $Sql -b
    if ($LASTEXITCODE -ne 0) { throw "sqlcmd failed (exit $LASTEXITCODE)" }
}

function Invoke-SqlFile {
    param(
        [string]$RelPath,
        [string]$Db = $Database,
        [switch]$IgnoreExisting  # Silently skip Msg 2714 "object already exists" errors
    )
    $file = Join-Path $root $RelPath
    Write-Host "  → $RelPath"
    $output = sqlcmd -S $Server -d $Db -E -I -i $file -b 2>&1
    if ($LASTEXITCODE -ne 0) {
        # Msg 2714 = "There is already an object named '...' in the database."
        if ($IgnoreExisting -and ($output -match "Msg 2714")) {
            Write-Host "     (already exists, skipped)"
            return
        }
        Write-Host $output
        throw "sqlcmd failed on $RelPath (exit $LASTEXITCODE)"
    }
}

# ── 1. Create database ────────────────────────────────────────────────────
if ($Force) {
    Write-Host "`n[1/4] Dropping and recreating database '$Database' (-Force)..."
    Invoke-Sql "IF EXISTS (SELECT 1 FROM sys.databases WHERE name = N'$Database') BEGIN ALTER DATABASE [$Database] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [$Database]; END"
} else {
    Write-Host "`n[1/4] Ensuring database '$Database' exists..."
}
Invoke-Sql "IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = N'$Database') CREATE DATABASE [$Database];"
Write-Host "      OK"

# ── 2. Schemas ────────────────────────────────────────────────────────────
Write-Host "`n[2/4] Creating schemas..."
foreach ($schema in @("auth","crm","listing","search","txn","doc","comms")) {
    Invoke-SqlFile "Schemas\$schema.sql"
}

# ── 3. Tables (dependency order) ─────────────────────────────────────────
Write-Host "`n[3/4] Creating tables..."

# auth — lookup + base (no deps)
Invoke-SqlFile -IgnoreExisting "Tables\\auth\auth.Role.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\auth\auth.Brokerage.sql"

# crm lookups — must precede auth.User creation because listing.Listing → crm.Lead → auth.User
Invoke-SqlFile -IgnoreExisting "Tables\\crm\crm.LeadSource.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\crm\crm.LeadType.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\crm\crm.PipelineStage.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\crm\crm.TaskPriority.sql"

# auth.User (depends on auth.Role, auth.Brokerage)
Invoke-SqlFile -IgnoreExisting "Tables\\auth\auth.User.sql"

# crm.Lead (depends on auth.User)
Invoke-SqlFile -IgnoreExisting "Tables\\crm\crm.Lead.sql"

# listing (Listing depends on crm.Lead + auth.User)
Invoke-SqlFile -IgnoreExisting "Tables\\listing\listing.PropertyType.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\listing\listing.ListingStatus.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\listing\listing.Listing.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\listing\listing.ListingPhoto.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\listing\listing.ListingHistory.sql"

# crm remaining (LeadPropertyInterest depends on listing.Listing)
Invoke-SqlFile -IgnoreExisting "Tables\\crm\crm.LeadStageHistory.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\crm\crm.LeadNote.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\crm\crm.LeadTask.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\crm\crm.LeadTag.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\crm\crm.LeadTagAssignment.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\crm\crm.LeadPropertyInterest.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\crm\crm.LeadWebhookIngest.sql"

# auth remaining (UserInvitation depends on auth.User; RefreshToken too)
Invoke-SqlFile -IgnoreExisting "Tables\\auth\auth.UserInvitation.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\auth\auth.AuditLog.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\auth\auth.BrokerageFeatureFlag.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\auth\auth.UserRefreshToken.sql"

# search (depends on auth.User + listing.Listing)
Invoke-SqlFile -IgnoreExisting "Tables\\search\search.AlertFrequency.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\search\search.SavedSearch.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\search\search.SavedSearchAlert.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\search\search.SavedListing.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\search\search.ListingViewEvent.sql"

# txn (Transaction depends on listing.Listing + crm.Lead + auth.User)
Invoke-SqlFile -IgnoreExisting "Tables\\txn\txn.TransactionType.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\txn\txn.TransactionStatus.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\txn\txn.FinancingType.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\txn\txn.OfferStatus.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\txn\txn.TerminationReason.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\txn\txn.MilestoneTemplate.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\txn\txn.Transaction.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\txn\txn.Offer.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\txn\txn.Milestone.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\txn\txn.DualAgencyAcknowledgment.sql"

# doc (Document depends on txn.Transaction)
Invoke-SqlFile -IgnoreExisting "Tables\\doc\doc.AccessLevel.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\doc\doc.SignatureStatus.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\doc\doc.Document.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\doc\doc.DocumentVersion.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\doc\doc.SignatureRequest.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\doc\doc.SignatureRequestSigner.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\doc\doc.AuditLog.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\doc\doc.DocumentTemplate.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\doc\doc.TemplateField.sql"

# comms (TransactionMessage depends on txn.Transaction)
Invoke-SqlFile -IgnoreExisting "Tables\\comms\comms.NotificationType.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\comms\comms.DeliveryChannel.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\comms\comms.ShowingRequestStatus.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\comms\comms.NotificationPreference.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\comms\comms.TransactionMessage.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\comms\comms.NotificationEvent.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\comms\comms.NotificationDelivery.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\comms\comms.ShowingRequest.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\comms\comms.ShowingResponse.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\comms\comms.EmailCampaign.sql"
Invoke-SqlFile -IgnoreExisting "Tables\\comms\comms.EmailCampaignRecipient.sql"

# ── ASP.NET Core Identity shadow tables ──────────────────────────────────
# These tables are never written to by our code, but EF Core maps to them.
# Creating minimal stubs prevents errors if Identity ever resolves these.
Write-Host "  → Identity shadow tables"
$identityShadow = @"
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE schema_id = SCHEMA_ID('auth') AND name = '_IdentityRole')
BEGIN
    CREATE TABLE [auth].[_IdentityRole] (
        [Id]   UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        [Name] NVARCHAR(256)    NULL
    );
END

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE schema_id = SCHEMA_ID('auth') AND name = '_UserRole')
BEGIN
    CREATE TABLE [auth].[_UserRole] (
        [UserId] UNIQUEIDENTIFIER NOT NULL,
        [RoleId] UNIQUEIDENTIFIER NOT NULL,
        PRIMARY KEY ([UserId], [RoleId])
    );
END

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE schema_id = SCHEMA_ID('auth') AND name = '_UserClaim')
BEGIN
    CREATE TABLE [auth].[_UserClaim] (
        [Id]         INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [UserId]     UNIQUEIDENTIFIER  NOT NULL,
        [ClaimType]  NVARCHAR(MAX)     NULL,
        [ClaimValue] NVARCHAR(MAX)     NULL
    );
END

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE schema_id = SCHEMA_ID('auth') AND name = '_UserLogin')
BEGIN
    CREATE TABLE [auth].[_UserLogin] (
        [LoginProvider]       NVARCHAR(128) NOT NULL,
        [ProviderKey]         NVARCHAR(128) NOT NULL,
        [ProviderDisplayName] NVARCHAR(MAX) NULL,
        [UserId]              UNIQUEIDENTIFIER NOT NULL,
        PRIMARY KEY ([LoginProvider], [ProviderKey])
    );
END

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE schema_id = SCHEMA_ID('auth') AND name = '_RoleClaim')
BEGIN
    CREATE TABLE [auth].[_RoleClaim] (
        [Id]         INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [RoleId]     UNIQUEIDENTIFIER  NOT NULL,
        [ClaimType]  NVARCHAR(MAX)     NULL,
        [ClaimValue] NVARCHAR(MAX)     NULL
    );
END

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE schema_id = SCHEMA_ID('auth') AND name = '_UserToken')
BEGIN
    CREATE TABLE [auth].[_UserToken] (
        [UserId]        UNIQUEIDENTIFIER NOT NULL,
        [LoginProvider] NVARCHAR(128)    NOT NULL,
        [Name]          NVARCHAR(128)    NOT NULL,
        [Value]         NVARCHAR(MAX)    NULL,
        PRIMARY KEY ([UserId], [LoginProvider], [Name])
    );
END
"@
Invoke-Sql $identityShadow $Database

# ── 4. Seed data ─────────────────────────────────────────────────────────
Write-Host "`n[4/4] Running seed script..."
Invoke-SqlFile "Scripts\Script.PostDeployment.sql"

Write-Host "`nDone. Database '$Database' on $Server is ready.`n"
