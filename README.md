# 🛡️ ALSO Microsoft Purview Best Practice Deployment Toolkit

A PowerShell-based deployment toolkit that helps organizations deploy a reusable Microsoft Purview security and compliance baseline.

The toolkit automates tenant settings, sensitivity labels, label publishing, Data Loss Prevention policies, sensitive information type policies, optional retention, and AI governance controls.

> [!IMPORTANT]
> Always run the toolkit with `-WhatIf` first. Review every proposed change before running a real deployment in a production tenant.

## 📋 Overview

| Resource | Description |
|---|---|
| 🛡️ Tenant settings | Enables the configured Microsoft Purview tenant-level settings. |
| 🏷️ Sensitivity labels | Creates or updates the configured sensitivity label taxonomy. |
| 📢 Label publishing policy | Publishes selected labels and configures default labeling behavior. |
| 🚫 Label-based DLP | Protects labeled content across Exchange, SharePoint, OneDrive, and supported endpoints. |
| 🔎 SIT-based DLP | Detects configured sensitive information types in external Exchange messages. |
| 🗃️ Retention | Optionally deploys the configured Exchange retention policy. |
| 🤖 AI governance | Deploys the configured Microsoft 365 Copilot DLP control. |
| 📄 Reporting | Generates an HTML deployment report unless reporting is disabled. |

## 📂 Repository Structure

```text
/
├── Deploy-PurviewBestPractice.ps1
├── Config/
│   └── PurviewConfig.psd1
├── Modules/
│   ├── Connect-PurviewServices.ps1
│   ├── Setup-TenantSettings.ps1
│   ├── Setup-SensitivityLabels.ps1
│   ├── Setup-DLP.ps1
│   ├── Setup-Retention.ps1
│   ├── Setup-AIGovernance.ps1
│   ├── PurviewRunLog.ps1
│   └── Write-PurviewHtmlReport.ps1
|
└── README.md
```

> [!NOTE]
> The main script expects the configuration file at `Config\PurviewConfig.psd1` and the required deployment modules inside the `Modules` folder.

## ⚙️ What the Toolkit Deploys

### 1. Tenant Settings

The baseline configuration includes:

- Unified Audit Log
- Sensitivity labels for PDF files
- Azure Information Protection integration in SharePoint
- Optional sensitivity label co-authoring
- Optional Premium Audit configuration

### 2. Sensitivity Labels

#### Public

Business data approved for public consumption. No encryption or content marking is applied.

#### General

Business data not intended for public consumption but shareable externally when appropriate.

- **Anyone (unrestricted):** General business data that may be shared externally.
- **All Employees (unrestricted):** General business data intended for employees.

#### Confidential

Sensitive business data that could cause damage if shared with unauthorized people.

- **All Employees:** Internal confidential data. A footer can be applied when content marking is enabled.
- **Trusted People:** Protected content for trusted internal or external recipients. User-defined encryption is used.

#### Highly Confidential

Very sensitive business data requiring the highest protection.

- **All Employees:** Tenant-scoped template encryption is applied.
- **Specific People:** Explicitly selected recipients receive access. Do Not Forward behavior is configured for Outlook.

### 3. Label Publishing Policy

**Policy name:** `BP-ALSO - Default Label Policy`

The policy publishes the configured baseline labels to users and includes:

- Mandatory labeling
- Justification when lowering a label
- Automatic attachment labeling behavior
- Default document label: `AllEmployees`
- Default email label: `GeneralAnyone`

### 4. Label-based DLP Policies

#### BP-ALSO - DLP - Confidential and HC external (EXO)

Blocks Exchange messages labeled Confidential or Highly Confidential from being sent outside the organization.

#### BP-ALSO - DLP - Confidential and HC external (SPO+ODB)

Blocks external sharing of SharePoint and OneDrive content labeled Confidential or Highly Confidential.

#### E5-PS-ALSO - DLP - Endpoint Confidential and HC

Audits the following activities for labeled content on supported endpoints:

- Copy and paste
- Printing
- Copying to removable media
- Copying to a network share

### 5. Sensitive Information Type DLP Policies

The toolkit includes Exchange DLP policies for external messages containing:

| Policy | Sensitive information detected |
|---|---|
| `BP-ALSO - DLP - Credit Card Numbers (EXO)` | Credit card numbers |
| `BP-ALSO - DLP - IBAN and Bank Account Numbers (EXO)` | International Bank Account Numbers |
| `BP-ALSO - DLP - EU Social Security Numbers (EXO)` | EU social security numbers |
| `BP-ALSO - DLP - Swiss AHV Numbers (EXO)` | Swiss AHV numbers |
| `BP-ALSO - DLP - Passport Numbers DACH-EU (EXO)` | Selected EU, German, and Swiss passport numbers |
| `BP-ALSO - DLP - Tax ID and VAT DACH (EXO)` | Selected German, Austrian, and Swiss tax or VAT numbers |

The configuration uses a minimum count of `1`, a maximum count of `500`, and a minimum confidence level of `85`.

> [!NOTE]
> The baseline starts DLP policies in simulation mode because `DlpStartInSimulation` is set to `$true`. Review simulation results before moving policies to enforcement.

### 6. Retention

**Policy name:** `BP-ALSO - Exchange 7-year retention`

The configured policy retains Exchange content for 2,555 days from creation and then deletes it. Retention is not deployed by default and requires `-ApplyRetention`.

> [!WARNING]
> Review the retention duration and deletion behavior with the customer before deployment. Do not enable retention without confirming legal, regulatory, and business requirements.

### 7. AI Governance

**Policy name:** `E5-PS-ALSO - AI - Block Copilot for Highly Confidential`

The policy prevents Microsoft 365 Copilot experiences from processing content labeled Highly Confidential.

> [!NOTE]
> Microsoft 365 Copilot DLP enforcement requires appropriate per-user licensing. Policy changes can take time before enforcement begins.

## 🔐 Required Administrator Roles

To run the Microsoft Purview Best Practice deployment, the deployment account must have one of the following permission options:

### Option 1: Global Administrator

Assign the **Global Administrator** role to the deployment account.

### Option 2: Least-Privilege Role Combination

Instead of Global Administrator, assign all of the following roles:

- **Compliance Administrator**
- **SharePoint Administrator**
- **Exchange Administrator**
- **Cloud Application Administrator**
- **Groups Administrator**

> [!IMPORTANT]
> If you use the least-privilege option, all roles listed above must be assigned to the same deployment account before running the script.

> [!TIP]
> If your organization uses Microsoft Entra Privileged Identity Management (PIM), activate all required roles before starting the `-WhatIf` validation or the production deployment.

## ✅ Before Deployment

Complete the following checks before running the toolkit:

1. Use PowerShell 7.0 or later.
2. Download or clone the complete repository.
3. Keep the original folder structure unchanged.
4. Review `Config\PurviewConfig.psd1`.
5. Confirm the sensitivity labels, DLP rules, retention settings, and AI controls match the customer requirements.
6. Use an account with the required permissions for the selected Purview workloads.
7. Test in a pilot tenant before deploying to production.
8. Run `-WhatIf` before the real deployment.



## 🚀 How to Run

Open PowerShell 7 as a Administrator and navigate to the repository folder:

```powershell
Set-Location "C:\Path\To\ALSO-Microsoft-Security-Purview"
```

If script execution is blocked for the current PowerShell process:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

### Step 1: Validate with WhatIf

Replace the example values with the tenant administrator UPN and SharePoint admin URL.

```powershell
.\Deploy-PurviewBestPractice.ps1 `
    -TenantAdminUpn "admin@contoso.com" `
    -SharePointAdminUrl "https://contoso-admin.sharepoint.com" `
    -AutoInstallModules `
    -WhatIf
```

`-WhatIf` previews the operations without intentionally applying the deployment changes. Review the complete console output and confirm that no unexpected objects or settings are included.

A successful validation should end with a deployment summary similar to the following:

![Successful WhatIf validation](Images/WhatIf-Success.png)

> [!IMPORTANT]
> `OK` in a WhatIf summary means the corresponding stage completed its preview path. It does not mean that the configuration was deployed.

### Step 2: Run the Deployment

After reviewing the WhatIf output, run the same command without `-WhatIf`:

```powershell
.\Deploy-PurviewBestPractice.ps1 `
    -TenantAdminUpn "admin@contoso.com" `
    -SharePointAdminUrl "https://contoso-admin.sharepoint.com" `
    -AutoInstallModules
```

A successful deployment should end with a summary similar to the following:

![Successful Purview deployment](Images/Deployment-Success.png)

In the example output, retention is shown as `Skipped` because `-ApplyRetention` was not used.

### Deploy with Retention

```powershell
.\Deploy-PurviewBestPractice.ps1 `
    -TenantAdminUpn "admin@contoso.com" `
    -SharePointAdminUrl "https://contoso-admin.sharepoint.com" `
    -AutoInstallModules `
    -ApplyRetention
```

### Adopt Existing Objects

Use this option only after reviewing the existing tenant configuration:

```powershell
.\Deploy-PurviewBestPractice.ps1 `
    -TenantAdminUpn "admin@contoso.com" `
    -SharePointAdminUrl "https://contoso-admin.sharepoint.com" `
    -AutoInstallModules `
    -AdoptExisting
```

### Deploy Only the Business Premium Scope

```powershell
.\Deploy-PurviewBestPractice.ps1 `
    -TenantAdminUpn "admin@contoso.com" `
    -SharePointAdminUrl "https://contoso-admin.sharepoint.com" `
    -AutoInstallModules `
    -BPOnly
```

## 🧩 Main Parameters

| Parameter | Purpose |
|---|---|
| `-TenantAdminUpn` | Mandatory administrator UPN used for the deployment connection. |
| `-SharePointAdminUrl` | SharePoint Online administration URL. |
| `-DelegatedOrganization` | Specifies a delegated organization when applicable. |
| `-ConfigPath` | Uses an alternative configuration file. |
| `-AutoInstallModules` | Allows the connection module to install required PowerShell modules. |
| `-WhatIf` | Previews supported changes before deployment. |
| `-AdoptExisting` | Allows supported modules to adopt matching existing objects. |
| `-SkipTenantSettings` | Skips tenant settings. |
| `-SkipLabels` | Skips sensitivity labels and label publishing. |
| `-SkipDLP` | Skips label-based and SIT-based DLP deployment. |
| `-ApplyRetention` | Deploys the configured retention policy. |
| `-SkipAIControls` | Skips AI governance controls. |
| `-SkipContainerLabels` | Prevents container label settings from being applied. |
| `-EnableLabelCoAuthoring` | Enables label co-authoring in the runtime configuration. |
| `-EnablePremiumAudit` | Enables the optional Premium Audit configuration path. |
| `-PremiumAuditMailbox` | Supplies mailboxes for the Premium Audit option. |
| `-BPOnly` | Skips the AI governance deployment path and passes Business Premium-only scope to DLP deployment. |
| `-NoLicenseAutoDetect` | Prevents the script from connecting to Microsoft Graph for automatic license detection. |
| `-NonInteractive` | Passes non-interactive behavior to the connection module. |
| `-ReportPath` | Sets a custom HTML report path. |
| `-NoReport` | Disables HTML report generation. |

## 📊 Deployment Summary

At the end of the run, the script reports the status of:

```text
Deployment summary
  Tenant settings        OK
  Sensitivity labels     OK
  Label DLP policies     OK
  SIT DLP policies       OK
  Retention              Skipped
  AI governance          OK
```

Possible values include:

- `OK`: The stage completed without a terminating error.
- `Skipped`: The stage was excluded by the selected parameters or was not explicitly enabled.

Always review the complete console output and the generated HTML report. The summary alone does not replace tenant validation.

## 📄 Deployment Report

Unless `-NoReport` is specified, the toolkit attempts to generate an HTML report with a timestamped name similar to:

```text
Deploy-PurviewBestPractice-Report-YYYYMMDD-HHMMSS.html
```

A custom path can be supplied with `-ReportPath`:

```powershell
.\Deploy-PurviewBestPractice.ps1 `
    -TenantAdminUpn "admin@contoso.com" `
    -SharePointAdminUrl "https://contoso-admin.sharepoint.com" `
    -ReportPath ".\Reports\Purview-Deployment.html"
```

## 🔁 Re-running the Toolkit

The scripts check for existing supported policies and rules before creating or updating them. Even so, always use `-WhatIf` before every rerun, especially after editing `PurviewConfig.psd1` or when the tenant already contains Purview configurations managed outside this toolkit.

> [!WARNING]
> Do not assume that every existing tenant object belongs to this toolkit. Review matching names, settings, assignments, and customer-owned policies before using `-AdoptExisting`.

## 🔍 Post-Deployment Validation

After deployment, verify the created or updated configuration in the Microsoft Purview portal:

- Tenant settings
- Sensitivity labels and label order
- Label publishing policy and assignments
- Exchange, SharePoint, OneDrive, and Endpoint DLP policies
- Sensitive information type DLP rules
- DLP simulation status
- Retention policy, if enabled
- AI governance policy
- Generated deployment report

Allow Microsoft 365 services time to process policy changes before completing functional tests.

## 🔐 Security Guidance

- Never store administrator passwords, secrets, certificates, or access tokens in the repository.
- Do not upload customer-specific reports or tenant information to a public repository.
- Use least-privileged administrative access whenever possible.
- Review all configuration values before deployment.
- Pilot tenant-wide controls before production rollout.
- Keep DLP in simulation until alerts and possible false positives have been reviewed.
- Confirm retention and deletion requirements with the responsible customer stakeholders.

## ⚠️ Disclaimer

This toolkit provides a reusable baseline and must be reviewed before use. Every organization has different licensing, regulatory requirements, data classifications, user populations, and risk tolerances.

The deploying organization remains responsible for validating the configuration, testing the user impact, obtaining the required approvals, and confirming that the deployed controls meet its legal and business requirements.

## 👤 Author

**Oualid EL Bakkari**  
Microsoft Security Technical Presales  
ALSO
