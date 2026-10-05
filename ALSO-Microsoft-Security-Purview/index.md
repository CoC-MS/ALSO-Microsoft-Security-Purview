---
title: Home
layout: home
nav_order: 1
description: "Microsoft Purview best-practice deployment toolkit for Microsoft 365 environments."
permalink: /
---

# 🛡️ ALSO Microsoft Purview Best Practice Tool

Deploy Microsoft Purview security and compliance configurations using a standardized and repeatable PowerShell deployment framework.

This toolkit helps organizations accelerate Microsoft Purview adoption by automatically deploying recommended configurations for:

- Sensitivity Labels
- Label Policies
- Data Loss Prevention (DLP)
- Endpoint DLP
- Microsoft 365 Copilot Protection
- AI Data Protection Controls
- Exchange Online Protection Policies
- SharePoint and OneDrive Protection
- Teams Data Protection Controls

> ⚠️ Always validate configurations in a test tenant before deploying to production environments.

---

## 📦 Included Components

| Component | Included |
|------------|------------|
| Sensitivity Labels | ✅ |
| Label Policies | ✅ |
| Microsoft 365 DLP | ✅ |
| Exchange DLP | ✅ |
| SharePoint DLP | ✅ |
| OneDrive DLP | ✅ |
| Teams DLP | ✅ |
| Endpoint DLP | ✅ |
| Microsoft 365 Copilot Protection | ✅ |
| AI Website Protection | ✅ |
| Compliance Baseline Configuration | ✅ |

---

## 🚀 Quick Start

Clone the repository:

```powershell
git clone https://github.com/CoC-MS/ALSO-Microsoft-Purview-BestPractice-Tool.git
```

Navigate to the Purview deployment directory:

```powershell
cd Products\Purview
```

Run a simulation:

```powershell
.\Deploy-PurviewBestPractice.ps1 `
-TenantAdminUpn admin@contoso.onmicrosoft.com `
-WhatIf
```

Deploy recommended settings:

```powershell
.\Deploy-PurviewBestPractice.ps1 `
-TenantAdminUpn admin@contoso.onmicrosoft.com
```

---

## 📋 Prerequisites

Before deployment verify that:

- PowerShell 7 or later is installed
- Microsoft Graph PowerShell SDK is available
- Exchange Online PowerShell module is available
- You have Global Administrator or Purview Administrator permissions
- Required Microsoft Purview licensing is assigned

Supported licensing:

| License | Supported |
|----------|----------|
| Microsoft 365 Business Premium | ✅ |
| Microsoft 365 E3 | ✅ |
| Microsoft 365 E5 | ✅ |
| Microsoft Purview Suite | ✅ |

---

## 🏗️ Deployment Framework

The deployment framework follows a controlled process:

```text
Assessment
     ↓
Prerequisite Validation
     ↓
Policy Creation
     ↓
Label Deployment
     ↓
DLP Deployment
     ↓
Endpoint DLP Deployment
     ↓
Copilot Protection Deployment
     ↓
Validation
     ↓
Production Rollout
```

The framework is designed to be idempotent and can be executed multiple times without creating duplicate configurations.

---

## 📚 Documentation

The repository documentation contains:

- Deployment Guide
- Prerequisites
- Naming Convention
- Policy Descriptions
- Copilot Protection Guide
- Troubleshooting Guide
- Release Notes

Select a section from the navigation menu to get started.

---

## 🔐 Security Notice

Review all deployed policies before enabling them in production.

Certain controls may:

- Restrict user access
- Block data sharing
- Prevent Copilot access to protected content
- Block uploads to unsupported AI services
- Enforce Endpoint DLP restrictions

Always use a phased deployment approach.

---

## 📄 Disclaimer

This project is provided as a community and partner sample.

The toolkit is provided **AS IS** without warranty of any kind.

Microsoft and ALSO do not provide standard product support for custom deployments performed using this toolkit.

Use at your own responsibility.