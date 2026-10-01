# ALSO-Microsoft-Security-Purview

# 🛡️ ALSO Microsoft Purview Best Practice Tool

> A collection of Microsoft Purview best practice configurations, sensitivity labels, label policies, data loss prevention policies, endpoint protection controls and AI security policies designed to help organizations accelerate Microsoft Purview deployments and implement Microsoft Security best practices.
>
> **Works with Microsoft 365 Business Premium, Microsoft 365 E3, Microsoft 365 E5 and Microsoft Purview Suite.**

---

> [!IMPORTANT]
> **⚠️ IMPORTANT: Read this before deploying any configurations.**

| Resource | Description |
|-----------|-------------|
| 🛡️ **Security Information** | View Security Policy |
| 📖 **Policy Descriptions** | View Policy Description |
| 🚀 **Before Deployment** | Read Before Deploying Policies |

---

## 📂 File Structure

```text
/
├── Documentation/
│   ├── DeploymentGuide.md
│   ├── PolicyDescriptions.md
│   └── Screenshots/
│
├── Products/
│   └── Purview/
│       ├── Deploy-PurviewBestPractice.ps1
│       ├── PurviewConfig.psd1
│       └── Templates/
│
├── LICENSE
├── Security.md
└── README.md
```

---

## 📄 License Tag Description

| Tag | Required License |
|------|------|
| **BP** | Microsoft 365 Business Premium |
| **E3** | Microsoft 365 E3 |
| **E5** | Microsoft 365 E5 |
| **PS** | Microsoft Purview Suite |


---

## 📖 Naming Convention

All templates follow the naming format below:

```text
<License>-ALSO-<Technology>-<Policy Name>
```

### Examples

```text
BP-ALSO-DLP-IBAN-and-Bank-Account-Numbers

BP-ALSO-DLP-Credit-Card-Numbers

E5-PS-ALSO-DLP-Endpoint-Confidential-and-HC

E5-SP-ALSO-AI-Block-Copilot-Highly-Confidential
```

---

## 🧩 Naming Components

| Component | Description |
|------------|------------|
| License | Required Microsoft License |
| ALSO | Organization Identifier |
| Technology | DLP, Label, AI, Endpoint |
| Policy Name | Policy Description |

---

# 🔐 Included Components

## 🏷️ Sensitivity Labels

The tool deploys a standardized sensitivity labeling framework.

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

Publishes sensitivity labels to users and applications.

---

## 🚫 Data Loss Prevention Policies

### BP-ALSO-DLP-IBAN-and-Bank-Account-Numbers

Detects and protects IBAN and bank account information across Microsoft 365 workloads.

---

### BP-ALSO-DLP-Credit-Card-Numbers

Protects payment card information using Microsoft built-in Sensitive Information Types.

---

### BP-ALSO-DLP-Personal-Data

Protects personally identifiable information such as national IDs, passports and tax identifiers.

---

## 💻 Endpoint DLP Policies

### E5-PS-ALSO-DLP-Endpoint-Confidential-and-HC

Blocks unauthorized actions involving Confidential and Highly Confidential files on managed devices.

#### Protected Activities

```text
USB Copy
Print
Remote Session
Browser Upload
Clipboard Copy
```

---

## 🤖 AI Protection Policies

### E5-SP-ALSO-AI-Block-Copilot-Highly-Confidential

Prevents Microsoft 365 Copilot from accessing Highly Confidential content.

---

### E5-SP-ALSO-AI-Block-M365Chat-Highly-Confidential

Prevents Microsoft 365 Chat from processing Highly Confidential information.

---

## ☁️ Exchange Online Protection

### BP-ALSO-DLP-Exchange-Confidential-Data

Protects sensitive information shared through Exchange Online.

---

## 📁 SharePoint and OneDrive Protection

### BP-ALSO-DLP-SharePoint-OneDrive-Confidential-Data

Protects confidential information stored in SharePoint Online and OneDrive.

---

# 🚀 Before Deployment

> [!IMPORTANT]
> PLEASE ENSURE ALL REQUIREMENTS ARE COMPLETED BEFORE DEPLOYMENT.

### Required Roles

- Global Administrator
- Purview Administrator
- Compliance Administrator

### Required Modules

```powershell
Microsoft.Graph
ExchangeOnlineManagement
```

### Required Licensing

```text
Microsoft 365 Business Premium
Microsoft 365 E3
Microsoft 365 E5
Microsoft Purview Suite
```

---

# 🔧 Deployment

Run deployment:

```powershell7
```Set-ExecutionPolicy `
	-Scope Process `
	-ExecutionPolicy Bypass `
	-Force
  ```
  ```powershell 7
```.\Deploy-PurviewBestPractice.ps1 `
	-TenantAdminUpn "admin@contoso.com" `
	-AutoInstallModules `
	-WhatIf
```

```powershell 7
.\Deploy-PurviewBestPractice.ps1 `
-TenantAdminUpn admin@contoso.com `
-AutoInstallDependencies
```

---

# ✅ Validation

Verify that the following components are created:

- Sensitivity Labels
- Label Policies
- DLP Policies
- Endpoint DLP Policies
- AI Protection Policies
- Exchange Online Policies
- SharePoint Policies
- OneDrive Policies

---

## 🖼️ Screenshots

### Sensitivity Labels

[Screenshot Placeholder]

### DLP Policies

[Screenshot Placeholder]

### Endpoint DLP

[Screenshot Placeholder]

### AI Protection Policies

[Screenshot Placeholder]

---

## 🐞 Issues

Open an issue in the repository if you encounter deployment problems.

---

## 🤝 Contributors

- Oualid EL Bakkari
- Vlad Johansen
- Magnus Mikkelsen

---

## 📜 License

Licensed under Apache License 2.0.
