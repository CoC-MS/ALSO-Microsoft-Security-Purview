# 🛡️ ALSO Microsoft Purview Best Practice Deployment Toolkit

A PowerShell-based deployment toolkit that helps organizations deploy a reusable Microsoft Purview security and compliance baseline.

The toolkit automates tenant settings, sensitivity labels, label publishing, Data Loss Prevention policies, sensitive information type policies, optional retention, and AI governance controls.

> [!IMPORTANT]
> Always run the toolkit with `-WhatIf` first. Review every proposed change before running a real deployment in a production tenant.

## Purview Licensing Guide

Choose one standalone package. 

### ✅  (Full Experience)

Package: [`ALSO_MACOS_E5`](ALSO_MACOS_E5)

| License | Supported |
|----------|----------|
| Microsoft 365 E7 | ✅ Full support | All policy types 
| Microsoft 365 E5 | ✅ Full support | All policy types 
| Microsoft 365 E3 + Purview Suite | ✅ Full support | All policy types 
| Business Premium + Purview Suite | ✅ Full support | All policy types 
| Microsoft 365 F3 + Purview Suite | ✅ Full support | All policy types 
| Microsoft 365 F1 + Purview Suite | ✅ Full support | All policy types 

### ⚠️ BP Folder (Limited Experience)

Package: [`ALSO_MACOS_BP`](ALSO_MACOS_BP)

The **BP folder** is designed for organizations using Microsoft 365 Business Premium and other licenses with partial feature compatibility.

| License | Supported Features |
|----------|----------|
| Microsoft 365 Business Premium | ⚠️ Supported with limitations (without full Defender for Cloud Apps experience) |
| Microsoft 365 E3 | ⚠️ Supported with limitations (without full Defender for Cloud Apps experience) |
| Microsoft 365 F3 | ⚠️ Supported with limitations (without full Defender for Cloud Apps experience) |
| Microsoft 365 F1 | ⚠️ Intune settings only. Defender settings are not supported. |


> **Important:** Microsoft 365 F1 supports deployment of Intune configuration settings only. Microsoft Defender security policy settings included in this repository are not supported with F1 licensing.

## 📖 Documentation and Resources

| Resource | Description |
|---|---|
| 📋 [Deployment coverage](#deployment-coverage) | Review the workloads and controls included in the toolkit. |
| ⚙️ [Baseline configuration](#baseline-configuration) | Review tenant settings, labels, DLP policies, retention, and AI governance. |
| 🔐 [Required administrator roles](#required-administrator-roles) | Review the deployment account permission options. |
| ✅ [Before deployment](#before-deployment) | Check PowerShell, configuration, permissions, and pilot preparation. |
| 📂 [Repository structure](#repository-structure) | Find the main script, configuration file, and deployment modules. |
| 🚀 [How to run](#how-to-run) | Validate with WhatIf and run the reviewed deployment. |
| 🧩 [Main parameters](#main-parameters) | Review deployment options and workload switches. |
| 📊 [Deployment summary](#deployment-summary) | Understand the stage status shown at the end of a run. |
| 📄 [Deployment report](#deployment-report) | Review HTML reporting and custom report paths. |
| 🔁 [Re-running the toolkit](#re-running-the-toolkit) | Review existing objects before repeating a deployment. |
| 🔍 [Post-deployment validation](#post-deployment-validation) | Validate the configuration in the Microsoft Purview portal. |
| 🔐 [Security guidance](#security-guidance) | Review credential handling, customer data, and deployment precautions. |
| ⚠️ [Disclaimer](#disclaimer) | Review deployment responsibilities and the usage notice. |

## Deployment Coverage

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

## 🚀 Getting Started

1. Review the [Baseline configuration](#baseline-configuration) and `Config\PurviewConfig.psd1`.
2. Complete the [Before deployment](#before-deployment) checks and review the [Required administrator roles](#required-administrator-roles).
3. Follow [How to run](#how-to-run), starting with `-WhatIf`.
4. Review the proposed changes before running the real deployment.
5. Complete [Post-deployment validation](#post-deployment-validation) and review the generated report.

> [!WARNING]
> Keep DLP in simulation until alerts and possible false positives have been reviewed. Retention is optional and must not be enabled without confirming the customer's legal, regulatory, and business requirements.

## Repository Structure

```text
/Purview
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
├── AdHoc/
│   └── Enable-DefaultLabelForSPOLibrary.ps1
└── README.md
```

> [!NOTE]
> The main script expects the configuration file at `Config\PurviewConfig.psd1` and the required deployment modules inside the `Modules` folder.

## Baseline Configuration

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

| Sublabel | Description |
|---|---|
| **Anyone (unrestricted)** | General business data that may be shared externally. |
| **All Employees (unrestricted)** | General business data intended for employees. |

#### Confidential

Sensitive business data that could cause damage if shared with unauthorized people.

| Sublabel | Description |
|---|---|
| **All Employees** | Internal confidential data. A footer can be applied when content marking is enabled. |
| **Trusted People** | Protected content for trusted internal or external recipients. User-defined encryption is used. |

#### Highly Confidential

Very sensitive business data requiring the highest protection.

| Sublabel | Description |
|---|---|
| **All Employees** | Tenant-scoped template encryption is applied. |
| **Specific People** | Explicitly selected recipients receive access. Do Not Forward behavior is configured for Outlook. |

### 3. Label Publishing Policy

**Policy name:** `BP-ALSO - Default Label Policy`

| Tag | Required License |
|---|---|
| BP | Microsoft 365 Business Premium |
| E3 | Microsoft 365 E3 |
| E5 | Microsoft 365 E5 |
| PS | Microsoft Purview Suite |

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

The configuration uses:

| Setting | Value |
|---|---|
| Minimum count | `1` |
| Maximum count | `500` |
| Minimum confidence level | `85` |

> [!NOTE]
> The baseline starts DLP policies in simulation mode because `DlpStartInSimulation` is set to `$true`. Review simulation results before moving policies to enforcement.

### 6. Retention

**Policy name:** `BP-ALSO - Exchange 7-year retention`

The configured policy retains Exchange content for 2,555 days from creation and then deletes it.

Retention is not deployed by default and requires `-ApplyRetention`.

> [!WARNING]
> Review the retention duration and deletion behavior with the customer before deployment. Do not enable retention without confirming legal, regulatory, and business requirements.

### 7. AI Governance

**Policy name:** `E5-PS-ALSO - AI - Block Copilot for Highly Confidential`

The policy prevents Microsoft 365 Copilot experiences from processing content labeled Highly Confidential.

> [!NOTE]
> Microsoft 365 Copilot DLP enforcement requires appropriate per-user licensing. Policy changes can take time before enforcement begins.

## Required Administrator Roles

To run the Microsoft Purview Best Practice deployment, the deployment account must have one of the following permission options.

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

## Before Deployment

Complete the following checks before running the toolkit:

1. Use PowerShell 7.0 or later.
2. Download or clone the complete repository.
3. Keep the original folder structure unchanged.
4. Review `Config\PurviewConfig.psd1`.
5. Confirm the sensitivity labels, DLP rules, retention settings, and AI controls match the customer requirements.
6. Use an account with the required permissions for the selected Purview workloads.
7. Test in a pilot tenant before deploying to production.
8. Run `-WhatIf` before the real deployment.

## How to Run

Open PowerShell 7 as an administrator and navigate to the repository folder:

```powershell
Set-Location "C:\Path\To\ALSO-Microsoft-Security-Purview\Purview"
```

If script execution is blocked for the current PowerShell process:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

### Step 1: Validate with WhatIf

Replace the example administrator UPN with the tenant administrator UPN. When supplying `-SharePointAdminUrl`, use the tenant's SharePoint admin URL.

```powershell
.\Deploy-PurviewBestPractice.ps1 `
    -TenantAdminUpn "admin@contoso.com" `
    -AutoInstallModules `
    -WhatIf
```

`-WhatIf` previews the operations without intentionally applying the deployment changes.

Review the complete console output and confirm that no unexpected objects or settings are included.

A successful validation should end with a deployment summary similar to the following:


### Step 2: Run the Deployment

After reviewing the WhatIf output, run the same command without `-WhatIf`:

```powershell
.\Deploy-PurviewBestPractice.ps1 `
    -TenantAdminUpn "admin@contoso.com" `
    -AutoInstallModules
```

A successful deployment should end with a summary similar to the following:


In the example output, retention is shown as `Skipped` because `-ApplyRetention` was not used.


## Deployment Summary

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

| Status | Meaning |
|---|---|
| `OK` | The stage completed without a terminating error. |
| `Skipped` | The stage was excluded by the selected parameters or was not explicitly enabled. |

> [!IMPORTANT]
> Always review the complete console output and the generated HTML report. The summary alone does not replace tenant validation.

## Deployment Report

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

## Re-running the Toolkit

The scripts check for existing supported policies and rules before creating or updating them.

Even so, always use `-WhatIf` before every rerun, especially after editing `PurviewConfig.psd1` or when the tenant already contains Purview configurations managed outside this toolkit.

> [!WARNING]
> Do not assume that every existing tenant object belongs to this toolkit. Review matching names, settings, assignments, and customer-owned policies before using `-AdoptExisting`.

## Post-Deployment Validation

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

## Security Guidance

- Never store administrator passwords, secrets, certificates, or access tokens in the repository.
- Do not upload customer-specific reports or tenant information to a public repository.
- Use least-privileged administrative access whenever possible.
- Review all configuration values before deployment.
- Pilot tenant-wide controls before production rollout.
- Keep DLP in simulation until alerts and possible false positives have been reviewed.
- Confirm retention and deletion requirements with the responsible customer stakeholders.

## Disclaimer

This toolkit provides a reusable baseline and must be reviewed before use.

Every organization has different licensing, regulatory requirements, data classifications, user populations, and risk tolerances.

The deploying organization remains responsible for validating the configuration, testing the user impact, obtaining the required approvals, and confirming that the deployed controls meet its legal and business requirements.

## 👤 Author

**Oualid EL Bakkari**  
Microsoft Security Technical Presales  
ALSO
