# 📂 Repository Structure

This guide explains how the repository is organized, where to find the deployment files, and which files to review before running the toolkit.

## Quick orientation

The repository has three main areas:

| Area | Purpose |
|---|---|
| `Purview/` | The deployment toolkit: main script, configuration, modules, and additional scripts. |
| `docs/public/` | Documentation explaining preparation, configuration, and deployment. |
| Repository root | The main README, security guidance, license, and issue-reporting instructions. |

> [!IMPORTANT]
> The deployment scripts are inside `Purview/`. The documentation is inside `docs/public/`. Keep these folders separate.

## 1. Complete folder layout

```text
ALSO-Microsoft-Security-Purview/
│
├── README.md
├── SECURITY.md
├── LICENSE.md
├── reporting-issues.md
│
├── .github/
│   └── ISSUE_TEMPLATE/
│       ├── bug_report.yml
│       ├── config.yml
│       ├── documentation_or_licensing_correction.yml
│       └── feature_or_policy_request.yml
│
├── Purview/
│   │
│   ├── Deploy-PurviewBestPractice.ps1
│   │
│   ├── Config/
│   │   └── PurviewConfig.psd1
│   │
│   ├── Modules/
│   │   ├── Connect-PurviewServices.ps1
│   │   ├── Setup-TenantSettings.ps1
│   │   ├── Setup-SensitivityLabels.ps1
│   │   ├── Setup-DLP.ps1
│   │   ├── Setup-Retention.ps1
│   │   ├── Setup-AIGovernance.ps1
│   │   ├── PurviewRunLog.ps1
│   │   └── Write-PurviewHtmlReport.ps1
│   │
│   └── AdHoc/
│       └── Enable-DefaultLabelForSPOLibrary.ps1
│
└── docs/
    └── public/
        ├── before-deployment.md
        ├── how-to-run.md
        ├── deployment-coverage.md
        ├── baseline-configuration.md
        └── repository-structure.md
```

The documentation list above reflects the pages created during this restructuring. Update it when additional documentation pages are added.

## 2. Deployment toolkit — `Purview/`

This folder contains the files used to deploy the baseline.

### Main deployment script

**File:** [Deploy-PurviewBestPractice.ps1](../../Purview/Deploy-PurviewBestPractice.ps1)

This is the main entry point for the deployment.

It uses the baseline configuration and deployment modules to run the selected deployment stages.

**Start deployments from this script**, following the [How to run guide](how-to-run.md).

### Configuration folder — `Purview/Config/`

**File:** [PurviewConfig.psd1](../../Purview/Config/PurviewConfig.psd1)

This is the central baseline configuration file.

Review it before deployment to understand the configured:

- Tenant settings
- Sensitivity labels
- Label publishing settings
- Label-based DLP policies
- Sensitive information type DLP policies
- Optional retention settings
- AI governance controls

For a readable overview, see [Baseline configuration](baseline-configuration.md).

> [!IMPORTANT]
> The documentation explains the baseline, but the actual configuration file must be reviewed before each deployment.

### Deployment modules — `Purview/Modules/`

The main script uses the modules in this folder for the different deployment areas.

| File | Area |
|---|---|
| `Connect-PurviewServices.ps1` | Connections to the services used by the toolkit. |
| `Setup-TenantSettings.ps1` | Tenant-level settings. |
| `Setup-SensitivityLabels.ps1` | Sensitivity labels and label publishing configuration. |
| `Setup-DLP.ps1` | Label-based and sensitive information type DLP configuration. |
| `Setup-Retention.ps1` | Optional retention configuration. |
| `Setup-AIGovernance.ps1` | AI governance configuration. |
| `PurviewRunLog.ps1` | Deployment logging support. |
| `Write-PurviewHtmlReport.ps1` | HTML deployment reporting. |

These files are implementation components. For normal deployment, follow the main deployment script workflow rather than treating each module as a separate installation step.

### Additional scripts — `Purview/AdHoc/`

This folder contains scripts for specific tasks outside the main deployment entry point.

| File | Task |
|---|---|
| `Enable-DefaultLabelForSPOLibrary.ps1` | Default sensitivity label configuration for a SharePoint Online library. |

Review the script's parameters, requirements, and scope before using it. Do not assume that additional scripts run automatically with the main deployment.

## 3. Public documentation — `docs/public/`

This folder contains the detailed guides linked from the main README.

| Page | What you will find |
|---|---|
| [Before deployment](before-deployment.md) | Preparation checks before running the toolkit. |
| [How to run](how-to-run.md) | Video tutorial, deployment commands, WhatIf validation, reporting, and post-deployment checks. |
| [Deployment coverage](deployment-coverage.md) | Overview of the workloads and controls included in the toolkit. |
| [Baseline configuration](baseline-configuration.md) | Details of the documented labels, publishing settings, DLP policies, retention, and AI governance. |
| [Repository structure](repository-structure.md) | This guide to the repository's folders and files. |

## 4. Repository information — root files

The repository root is the top-level folder containing both `Purview/` and `docs/`.

| File | Purpose |
|---|---|
| [README.md](../../README.md) | Main introduction and navigation to the repository documentation. |
| [SECURITY.md](../../SECURITY.md) | Security guidance and security-reporting information. |
| [LICENSE.md](../../LICENSE.md) | Terms governing use of the repository. |
| [reporting-issues.md](../../reporting-issues.md) | Instructions for reporting problems without disclosing tenant information. |

## 5. Issue templates — `.github/ISSUE_TEMPLATE/`

This folder contains the forms and configuration used for GitHub issues.

| File | Purpose |
|---|---|
| `bug_report.yml` | Report a reproducible problem. |
| `documentation_or_licensing_correction.yml` | Report documentation or licensing information that needs correction. |
| `feature_or_policy_request.yml` | Suggest a feature or policy. |
| `config.yml` | Configure the issue-template selection page. |

These files support repository maintenance. They are not part of the Purview deployment configuration.

## 6. Where should I start?

Follow this reading order:

1. Read [Deployment coverage](deployment-coverage.md) to understand what the toolkit includes.
2. Review [Baseline configuration](baseline-configuration.md) and `Purview/Config/PurviewConfig.psd1`.
3. Complete [Before deployment](before-deployment.md).
4. Follow [How to run](how-to-run.md), starting with `-WhatIf`.
5. Review the deployment output, HTML report, and resulting tenant configuration.

## 7. Keep the deployment structure unchanged

The main script expects these locations inside `Purview/`:

```text
Purview/
├── Deploy-PurviewBestPractice.ps1
├── Config/
│   └── PurviewConfig.psd1
└── Modules/
    └── Deployment modules
```

> [!WARNING]
> Do not move the configuration file or deployment modules into `docs/public/`. Documentation changes do not require moving or renaming the deployment files.

---

[← Back to the main README](../../README.md)
``