# 🛡️ Deployment Coverage

The toolkit deploys a reusable Microsoft Purview security and compliance baseline based on the selected configuration.

## Included workloads

| Resource | Description |
|---|---|
| 🛡️ Tenant settings | Enables the configured Microsoft Purview tenant-level settings. |
| 🏷️ Sensitivity labels | Creates or updates the configured sensitivity label taxonomy. |
| 📢 Label publishing policy | Publishes selected labels and configures default labeling behavior. |
| 🚫 Label-based DLP | Configures protection for labeled content across Exchange, SharePoint, OneDrive, and supported endpoints. |
| 🔎 SIT-based DLP | Detects configured sensitive information types in external Exchange messages. |
| 🗃️ Retention | Optionally deploys the configured Exchange retention policy. |
| 🤖 AI governance | Deploys the configured Microsoft 365 Copilot DLP control. |
| 📄 Reporting | Generates an HTML deployment report unless reporting is disabled. |

## Review before deployment

Review the configuration in:

`Purview/Config/PurviewConfig.psd1`

Confirm that the selected workloads and settings match the customer's requirements and licensing.

> [!IMPORTANT]
> Deployment coverage does not mean that every feature is included in every Microsoft 365 license. Verify the licensing requirements before deployment.

> [!WARNING]
> Start with `-WhatIf` and keep DLP in simulation until the results have been reviewed. Retention is optional and requires explicit approval of its duration and deletion behavior.

## Deployment guidance

1. Complete the [Before deployment checks](before-deployment.md).
2. Follow the [Deployment guide and video tutorial](how-to-run.md).

---

[← Back to the main README](../../README.md)