# 🛡️ ALSO Microsoft Purview Best Practice Deployment Toolkit

A PowerShell-based toolkit that helps organizations deploy a reusable Microsoft Purview security and compliance baseline.

The toolkit automates tenant settings, sensitivity labels, label publishing, Data Loss Prevention policies, optional retention, AI governance controls, and HTML deployment reporting.

> [!IMPORTANT]
> This baseline is a starting point, not a ready-made configuration for every tenant. Review licensing, permissions, settings, assignments, and customer requirements. Always start with `-WhatIf`, test in a pilot tenant, and review the proposed changes before deployment.

## 🚀 Getting started

1. Review [Deployment coverage](docs/public/deployment-coverage.md) and complete [Before deployment](docs/public/before-deployment.md).
2. Review the licensing considerations below and confirm the requirements for the selected workloads.
3. Review [Baseline configuration](docs/public/baseline-configuration.md) and adapt [PurviewConfig.psd1](Purview/Config/PurviewConfig.psd1) to the customer requirements.
4. Follow [How to run](docs/public/how-to-run.md), including the video tutorial, and start with `-WhatIf`.
5. Review the deployment output and HTML report, validate the resulting tenant configuration, and assess DLP simulation results before enabling enforcement.

### Quick navigation


| Section | What you will find |
|---|---|
| [Getting started](#-getting-started) | Preparation, configuration review, and deployment guidance. |
| [Licensing considerations](#-licensing-considerations) | Licensing checks before selecting workloads. |
| [Toolkit components](#-toolkit-components) | Main script, configuration, modules, and additional scripts. |
| [Deployment coverage](#-deployment-coverage) | Included workloads and protection scenarios. |
| [Notable capabilities](#-notable-capabilities) | Key baseline capabilities and deployment safeguards. |
| [Documentation](#-documentation) | Detailed guides, security information, and repository license. |

---



## 🔑 Licensing considerations

### Purview licensing guide

Match the configured workloads to the tenant's licensing. This toolkit uses one configuration, not separate license-specific packages.

### ✅ Advanced experience — E5 / PS policies

| License | Experience |
|---|---|
| Microsoft 365 E7 | Advanced Purview capabilities; verify selected workloads. |
| Microsoft 365 E5 | Advanced Purview capabilities; verify selected workloads. |
| Microsoft 365 E3 + Microsoft Purview Suite | Advanced Purview capabilities; verify add-on prerequisites. |
| Business Premium + Microsoft Purview Suite for Business Premium | Advanced capabilities with the Business Premium-specific add-on. |

### ⚠️ Limited experience — baseline capabilities

| License | Experience |
|---|---|
| Microsoft 365 Business Premium | Manual labeling and core Microsoft 365 DLP; advanced features require additional licensing. |
| Microsoft 365 E3 | Manual labeling and core Microsoft 365 DLP; advanced features require additional licensing. |
| Microsoft 365 F3 | Limited coverage; verify each selected workload. |
| Microsoft 365 F1 | Limited coverage; verify feature and workload availability. |

### 👷 Frontline licensing

| License | Experience |
|---|---|
| Microsoft 365 F1 + Purview Suite FLW | Verify FLW prerequisites and workload coverage. |
| Microsoft 365 F3 + Purview Suite FLW | Verify FLW prerequisites and workload coverage. |

> [!IMPORTANT]
> Policy prefixes do not automatically select or exclude workloads. Review the configuration before deployment. Copilot controls, Endpoint DLP, and other advanced features require feature-specific licensing and prerequisites.

**Disclaimer:** Licensing and feature availability can change. Verify current Microsoft licensing documentation before purchasing or deploying.

**Enterprise licenses:** [Microsoft Enterprise Plan Comparison](https://cdn-dynmedia-1.microsoft.com/is/content/microsoftcorp/microsoft/bade/documents/products-and-services/en-us/education/Modern-Work-Plan-Comparison-Enterprise.pdf)
**SMB licenses:** [Microsoft SMB Plan Comparison](https://cdn-dynmedia-1.microsoft.com/is/content/microsoftcorp/microsoft/bade/documents/products-and-services/en-us/education/Modern-Work-Plan-Comparison-Enterprise.pdf)
---




## 📦 Toolkit components

This repository contains one configurable deployment toolkit, rather than separate license-specific export packages.

| Component | Location | Purpose |
|---|---|---|
| Main deployment script | [Deploy-PurviewBestPractice.ps1](Purview/Deploy-PurviewBestPractice.ps1) | Entry point for the deployment workflow. |
| Baseline configuration | [PurviewConfig.psd1](Purview/Config/PurviewConfig.psd1) | Central configuration to review and adapt before deployment. |
| Deployment modules | [Modules](Purview/Modules/) | Connection, workload configuration, logging, and reporting components. |
| Additional scripts | [AdHoc](Purview/AdHoc/) | Scripts for specific tasks outside the main deployment entry point. |
| Public documentation | [docs/public](docs/public/) | Preparation, configuration, and deployment guides. |

> [!WARNING]
> Keep the deployment folder structure unchanged. Do not move configuration files or deployment modules into the documentation folder.

## 🌐 Deployment coverage

| Area | Included configuration |
|---|---|
| 🛡️ **Tenant settings** | Configured audit, labeling, and SharePoint integration settings, with optional co-authoring and Premium Audit settings. |
| 🏷️ **Sensitivity labels** | Public, General, Confidential, and Highly Confidential label hierarchy, including the configured sublabels and protection settings. |
| 📢 **Label publishing** | Label publication, mandatory labeling, downgrade justification, and default labeling behavior. |
| 🚫 **Label-based DLP** | Policies for labeled content across Exchange, SharePoint, OneDrive, and supported endpoints. |
| 🔎 **SIT-based DLP** | Exchange policies for selected financial, identity, social security, passport, and tax information types. |
| 🗃️ **Retention** | Optional Exchange retention configuration, requiring explicit deployment selection. |
| 🤖 **AI governance** | A Microsoft 365 Copilot DLP control targeting Highly Confidential content. |
| 📄 **Reporting** | Deployment stage summary and HTML deployment report. |

For policy names, detection settings, label descriptions, and retention behavior, see [Baseline configuration](docs/public/baseline-configuration.md).

### ✨ Notable capabilities

- **Reusable configuration:** Review and adapt a central configuration file for the destination tenant.
- **Structured information protection:** Deploy a documented sensitivity label hierarchy and publishing configuration.
- **Complementary DLP controls:** Configure policies based on sensitivity labels and selected sensitive information types.
- **Review before enforcement:** Start with `-WhatIf` and review DLP simulation results before enabling blocking.
- **Optional retention:** Retention is not deployed by default and requires `-ApplyRetention`.
- **Deployment visibility:** Review console output, stage status, and the generated HTML report.

> [!WARNING]
> Policy names describe intent, but configuration and enforcement state determine behavior. DLP simulation does not mean active blocking. Review the actual policies and validate their behavior in the destination tenant.

> [!WARNING]
> The documented optional Exchange retention policy retains content for 2,555 days from creation and then deletes it. Do not enable it without confirming the customer's legal, regulatory, and business requirements.

---

## 📚 Documentation

| Resource | Description |
|---|---|
| ✅ **[Before deployment](docs/public/before-deployment.md)** | Review preparation checks, configuration, permissions, and pilot requirements. |
| 🚀 **[How to run](docs/public/how-to-run.md)** | Watch the video tutorial and follow WhatIf validation, deployment, reporting, and verification steps. |
| 🛡️ **[Deployment coverage](docs/public/deployment-coverage.md)** | Review the workloads and controls included in the toolkit. |
| ⚙️ **[Baseline configuration](docs/public/baseline-configuration.md)** | Understand tenant settings, labels, publishing, DLP, retention, and AI governance. |
| 📂 **[Repository structure](docs/public/repository-structure.md)** | Find the deployment files and understand the role of each folder. |
| 🐛 **[Reporting issues](reporting-issues.md)** | Report problems without disclosing tenant information. |
| 🔐 **[Security guidance](SECURITY.md)** | Review security precautions and reporting information. |
| 📜 **[License](LICENSE.md)** | Read the repository license. |

## ⚠️ Disclaimer

This toolkit provides a reusable starting point. It does not replace a customer-specific security assessment, licensing review, or deployment approval.

Review all selected settings before use. Test in a pilot tenant, maintain an appropriate recovery plan, and validate the resulting configuration after deployment.

Deploying this baseline does not by itself establish regulatory compliance.
