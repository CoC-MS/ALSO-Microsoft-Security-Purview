# 🚀 How to Run

Complete the [before-deployment checks](before-deployment.md) before running the toolkit.

> [!IMPORTANT]
> Always start with `-WhatIf`. Review every proposed change before running a real deployment in a production tenant.

## 🎥 Video tutorial

Watch the step-by-step walkthrough to prepare and deploy the Microsoft Purview baseline.

https://github.com/user-attachments/assets/6a3bb611-f90c-4152-a070-5c58ed5e53c0

## 📖 Written deployment guide

### 1. Open the deployment folder

Open PowerShell 7 as an administrator and navigate to the `Purview` folder in your local repository.

Replace the example path with your actual local path:

```powershell
Set-Location "C:\Path\To\ALSO-Microsoft-Security-Purview\Purview"
```

If script execution is blocked for the current PowerShell process:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

### 2. Review the configuration

Before deployment, review:

```text
Config\PurviewConfig.psd1
```

Confirm that the configured tenant settings, sensitivity labels, DLP policies, retention settings, and AI governance controls match the customer requirements.

> [!WARNING]
> Test in a pilot tenant before deploying to production. Do not assume that the baseline is suitable for every customer without reviewing the configuration.

### 3. Validate with WhatIf

Replace the example administrator UPN with your tenant administrator UPN:

```powershell
.\Deploy-PurviewBestPractice.ps1 `
    -TenantAdminUpn "admin@contoso.com" `
    -AutoInstallModules `
    -WhatIf
```

Review the complete console output and every proposed change before continuing.

Confirm that no unexpected objects, assignments, or settings are included.

### 4. Run the deployment

After reviewing the WhatIf output, run the same command without `-WhatIf`:

```powershell
.\Deploy-PurviewBestPractice.ps1 `
    -TenantAdminUpn "admin@contoso.com" `
    -AutoInstallModules
```

> [!WARNING]
> This command runs the actual deployment. Confirm the destination tenant, permissions, and configuration before proceeding.

### 5. Review the deployment summary

At the end of the run, the script reports the status of the deployment stages.

Example:

```text
Deployment summary
  Tenant settings        OK
  Sensitivity labels     OK
  Label DLP policies     OK
  SIT DLP policies       OK
  Retention              Skipped
  AI governance          OK
```

| Status | Meaning |
|---|---|
| `OK` | The stage completed without a terminating error. |
| `Skipped` | The stage was excluded by the selected parameters or was not explicitly enabled. |

Retention is skipped in this example because `-ApplyRetention` was not used.

> [!IMPORTANT]
> Review the complete console output and generated HTML report. The summary alone does not replace tenant validation.

### 6. Review the deployment report

Unless `-NoReport` is specified, the toolkit attempts to generate an HTML report with a timestamped name similar to:

```text
Deploy-PurviewBestPractice-Report-YYYYMMDD-HHMMSS.html
```

To specify a custom report path:

```powershell
.\Deploy-PurviewBestPractice.ps1 `
    -TenantAdminUpn "admin@contoso.com" `
    -SharePointAdminUrl "https://contoso-admin.sharepoint.com" `
    -ReportPath ".\Reports\Purview-Deployment.html"
```

Replace the example administrator UPN and SharePoint admin URL with the values for the destination tenant.

### 7. Validate in Microsoft Purview

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

> [!WARNING]
> Keep DLP in simulation until alerts and possible false positives have been reviewed. The baseline configuration starts DLP policies in simulation when `DlpStartInSimulation` is set to `$true`.

## Optional retention deployment

Retention is not deployed by default. It requires `-ApplyRetention`.

The configured policy retains Exchange content for 2,555 days from creation and then deletes it.

> [!WARNING]
> Do not enable retention without gal, regulatory, and business requirements. Review both the retention duration and deletion behavior before deployment.

## Re-running the toolkit

Always use `-WhatIf` before every rerun, especially after editing `PurviewConfig.psd1` or when the tenant already contains Purview configurations managed outside this toolkit.

Review existing object names, settings, assignments, and customer-owned policies before proceeding.

> [!WARNING]
> Do not assume that every existing tenant object belongs to this toolkit. Review matching objects before using `-AdoptExisting`.

---

../../README.md