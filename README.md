# 🛡️ ALSO Microsoft Purview Best Practice Tool

> A collection of Microsoft Purview best practice configurations, sensitivity labels, label policies, data loss prevention policies, endpoint protection controls and AI security policies designed to help organizations accelerate Microsoft Purview deployments and implement Microsoft Security best practices.
>
> **Works with Microsoft 365 Business Premium, Microsoft 365 E3, Microsoft 365 E5 and Microsoft Purview Suite.**

---

> [!IMPORTANT]
> ⚠️ IMPORTANT: Read this before deploying any configurations.

| Resource | Description |
|-----------|-------------|
| 🛡️ **Security Information** | View Security Policy |
| 📖 **Policy Descriptions** | View Policy Description |
| 🚀 **Before Deployment** | Read Before Deploying Policies |

---

# 📂 File Structure

```text
/
├── .git/
├── .github/
│   └── copilot-instructions.md
│
├── Products/
│   └── Purview/
│       ├── Deploy-PurviewBestPractice.ps1
│       ├── PurviewConfig.psd1
│       └── Templates/
│
├── LICENSE
├── SECURITY.md
├── README.md
├── .gitignore
├── _config.yml
├── CHANGELOG.md
├── Gemfile
└── index.md
```

---

# 📄 License Requirements

| Tag | Required License |
|------|------|
| **BP** | Microsoft 365 Business Premium |
| **E3** | Microsoft 365 E3 |
| **E5** | Microsoft 365 E5 |
| **PS** | Microsoft Purview Suite |
| **SP** | Microsoft Defender Suite |

---

# 📖 Naming Convention

All templates follow the naming format below:

```text
<License>-ALSO-<Technology>-<Policy Name>
```

## Examples

```text
BP-ALSO-DLP-IBAN-and-Bank-Account-Numbers

BP-ALSO-DLP-Credit-Card-Numbers

E5-PS-ALSO-DLP-Endpoint-Confidential-and-HC

E5-SP-ALSO-AI-Block-Copilot-Highly-Confidential
```

---

# 🧩 Naming Components

| Component | Description |
|------------|------------|
| License | Required Microsoft License |
| ALSO | Organization Identifier |
| Technology | DLP, Label, AI, Endpoint |
| Policy Name | Policy Description |

---

# 🔐 Included Components

## 🏷️ Sensitivity Labels

The tool deploys a standardized Microsoft Purview sensitivity labeling framework.

### Implemented Labels

```text
Public
General
Confidential
Highly Confidential
```

### Public

Content intended for unrestricted use.

### General

Internal business information.

### Confidential

Business sensitive information requiring protection.

### Highly Confidential

Critical business information requiring the highest protection level.

---

## 📚 Label Policies

### BP-ALSO-Label-Publishing-Policy

Publishes sensitivity labels to users and Microsoft 365 applications.

---

# 🚫 Data Loss Prevention Policies

### BP-ALSO-DLP-IBAN-and-Bank-Account-Numbers

Detects and protects IBAN and bank account information across Microsoft 365 workloads.

---

### BP-ALSO-DLP-Credit-Card-Numbers

Protects payment card information using Microsoft built-in Sensitive Information Types.

---

### BP-ALSO-DLP-Personal-Data

Protects personally identifiable information such as national IDs, passports and tax identifiers.

---

# ☁️ Exchange Online Protection

### BP-ALSO-DLP-Exchange-Confidential-Data

Protects sensitive information shared through Exchange Online.

---

# 📁 SharePoint and OneDrive Protection

### BP-ALSO-DLP-SharePoint-OneDrive-Confidential-Data

Protects confidential information stored in SharePoint Online and OneDrive for Business.

---

# 💬 Microsoft Teams Protection

### BP-ALSO-DLP-Teams-Confidential-Data

Protects confidential information shared through Microsoft Teams chats and channels.

---

# 💻 Endpoint DLP Policies

### E5-PS-ALSO-DLP-Endpoint-Confidential-and-HC

Blocks unauthorized actions involving Confidential and Highly Confidential files on managed devices.

#### Protected Activities

```text
USB Copy
Print
Clipboard Copy
Browser Upload
Remote Session
Network Share Copy
```

---

# 🤖 AI Protection Policies

### E5-SP-ALSO-AI-Block-Copilot-Highly-Confidential

Prevents Microsoft 365 Copilot from accessing Highly Confidential content.

---

### E5-SP-ALSO-AI-Block-M365Chat-Highly-Confidential

Prevents Microsoft 365 Chat from processing Highly Confidential information.

---

### E5-SP-ALSO-AI-Block-External-AI-Websites

Blocks access to unauthorized AI services according to organizational security requirements.

Examples include:

```text
ChatGPT
Google Gemini
Claude
Perplexity
DeepSeek
```

---

# 🚀 Before Deployment

> [!IMPORTANT]
> PLEASE ENSURE ALL REQUIREMENTS ARE COMPLETED BEFORE DEPLOYMENT.

## Required Roles

- Global Administrator
- Purview Administrator
- Compliance Administrator

## Required Modules

```powershell
Microsoft.Graph
ExchangeOnlineManagement
```

## Required Licensing

```text
Microsoft 365 Business Premium
Microsoft 365 E3
Microsoft 365 E5
Microsoft Purview Suite
```

## Supported Workloads

```text
Exchange Online
SharePoint Online
OneDrive for Business
Microsoft Teams
Microsoft 365 Copilot
Endpoint DLP
```

---

# 🔧 Deployment

> [!IMPORTANT]
> Always run the deployment first with -WhatIf before making changes to a production tenant.

## Preview Deployment

```powershell
Set-ExecutionPolicy `
    -Scope Process `
    -ExecutionPolicy Bypass `
    -Force

.\Deploy-PurviewBestPractice.ps1 `
    -TenantAdminUpn "admin@contoso.com" `
    -AutoInstallModules `
    -WhatIf
```

## Production Deployment

```powershell
.\Deploy-PurviewBestPractice.ps1 `
    -TenantAdminUpn "admin@contoso.com" `
    -AutoInstallDependencies
```

---

# ✅ Validation

Verify that the following components are successfully deployed:

- Sensitivity Labels
- Label Policies
- DLP Policies
- Endpoint DLP Policies
- AI Protection Policies
- Exchange Online Policies
- SharePoint Policies
- OneDrive Policies
- Teams Policies

## Verification Locations

```text
Microsoft Purview Portal
Microsoft Defender Portal
Microsoft 365 Admin Center
```

---

# 🖼️ Screenshots

## Sensitivity Labels

[Screenshot Placeholder]

## DLP Policies

[Screenshot Placeholder]

## Endpoint DLP

[Screenshot Placeholder]

## AI Protection Policies

[Screenshot Placeholder]

---

# 🐞 Issues

Open an issue in this repository if you encounter deployment problems or discover bugs.

---

# 🤝 Contributors

Created and maintained by:

- Oualid EL Bakkari
- Vlad Johansen
- Magnus Mikkelsen

ALSO Microsoft Security Center of Competence

---

# 📜 License

Licensed under Apache License 2.0.
