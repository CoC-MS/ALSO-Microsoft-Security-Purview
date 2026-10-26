# Before You Configure Purview: Readiness & Preparation

**Technical prerequisites, classification decisions, and role readiness**

| Document information | Details |
| :--- | :--- |
| Audience | IT administrators, security engineers, endpoint and client management teams |
| Author | Oualid EL Bakkari |
| Source version | 1.1 · 2026 |
| Scope | Data sources, classification, identity and tenant, Endpoint DLP / Intune, network readiness |
| Out of scope | Budget and licensing planning |

> **Read before configuration**
> Use this guide to identify prerequisites and agree the classification model, responsibilities, pilot scope, and required preparation before configuring Purview.
>
> **Source note:** Converted from the supplied preparation guide. Technical statements and platform requirements have not been independently revalidated. Confirm applicable requirements against current Microsoft documentation before implementation.

## Contents

- [1. Introduction](#1-introduction)
- [2. Data Source Inventory](#2-data-source-inventory)
- [3. Classification Schema - Technical Structure](#3-classification-schema---technical-structure)
- [4. Identity & Tenant Readiness](#4-identity--tenant-readiness)
- [5. Endpoint Protection: Endpoint DLP, Defender for Endpoint & Intune](#5-endpoint-protection-endpoint-dlp-defender-for-endpoint--intune)
- [6. Network and On-Premises Considerations](#6-network-and-on-premises-considerations)
- [7. Common Technical Pitfalls](#7-common-technical-pitfalls)
- [8. Technical Go/No-Go Checklist](#8-technical-gono-go-checklist)
- [9. Glossary of Key Terms](#9-glossary-of-key-terms)
- [10. Further Resources](#10-further-resources)

---

## 1. Introduction

Microsoft reference: Microsoft Purview overview: [Microsoft reference](https://learn.microsoft.com/en-us/purview/) This guide covers the technical groundwork for a Microsoft Purview rollout - the state your data sources,

tenant, identity layer, and endpoints need to be in before configuration starts in the portal. It deliberately leaves

out governance, stakeholder management, and licensing decisions; those belong in a separate discussion. What

follows is aimed squarely at the people who will actually touch the tenant, the devices, and the infrastructure.

### 1.1 What Microsoft Purview Actually Is

Microsoft reference: Microsoft Purview overview: [Microsoft reference](https://learn.microsoft.com/en-us/purview/) Microsoft Purview is a set of data governance, data security, and compliance solutions in one portal.

| Product Group | Description |
| :--- | :--- |
| Microsoft Purview Governance | Data Map, Data Catalog, and Data Insights - visibility into where organizational data actually lives |
| Microsoft Purview Compliance | Information Protection, Data Loss Prevention (DLP), Insider Risk Management, eDiscovery, Audit, Communication Compliance |
| Microsoft Purview Risk and Compliance solutions | Compliance Manager, Audit, eDiscovery, Insider Risk Management, and Communication Compliance |

Most rollouts start on the compliance side, since sensitivity labels and DLP touch the widest set of data sources

and endpoints first.

### 1.2 What This Guide Does Not Cover

This guide is mainly a readiness checklist. It now includes the role model and the data classification approach that

should be agreed before configuration starts. Budget and licensing planning are not covered in this document.

## 2. Data Source Inventory

Microsoft reference: Data Map scans and ingestion: [Microsoft reference](https://learn.microsoft.com/en-us/purview/data-map-scan-ingestion) Purview can only classify, scan, and protect data sources it knows about and can reach. Before any label or policy

gets created, the technical inventory below needs to exist.

### 2.1 Sources to Inventory

- Microsoft 365: Exchange Online, SharePoint Online, OneDrive, Teams

- Azure: Azure SQL, Azure Data Lake, Azure Blob Storage

- On-premises: file servers, SQL servers, SAP systems

- Third-party SaaS: Salesforce, ServiceNow, and any other platform in active use

### 2.2 Metadata to Record per Source

- Data type and format (structured/unstructured, file types in use)

- Location and connectivity method (cloud-native API, on-prem scanner, gateway)

- Current authentication and access model

- Approximate volume and growth rate

- A technical contact who can answer questions about the source's content and access controls

### 2.3 Detecting Shadow IT

Unofficial cloud services rarely show up in a first-pass inventory. A few technical ways to surface them: pull the

list of OAuth apps with delegated permissions from Entra ID's enterprise applications view, review Defender for

Cloud Apps discovery logs if it's already deployed (it profiles SaaS usage from firewall/proxy logs), or check DNS

and proxy logs for traffic to known SaaS domains that aren't on the approved list. None of these is complete on

its own - combining two or three gives a reasonably accurate picture.

A pattern worth watching for

Configuration management databases are notoriously out of date. Treat any existing inventory as a starting point rather than ground truth, and spot-check a sample of it against reality before building anything on top of it.

### 2.7 Data Owner Interview Questions

Microsoft reference: Sensitivity labels: [Microsoft reference](https://learn.microsoft.com/en-us/purview/sensitivity-labels) Use these questions in short workshops with HR, Finance, Legal, Sales, Operations, and IT. The goal is to collect real business examples before labels and DLP policies are created.

- Which data do you create, receive, or store every week?

- Which data must stay internal only?

- Which data can be shared with partners or customers?

- Which data would create business, legal, or reputation risk if shared incorrectly?

- Which users or groups should be allowed to access this data?

- Which activities should be blocked, warned, or only audited? Examples: external sharing, USB copy, print, browser

upload, or email to external recipients.

### 2.6 How to Map Data to Labels

Microsoft reference: Use sensitivity labels as DLP conditions: [Microsoft reference](https://learn.microsoft.com/en-us/purview/dlp-sensitivity-) label-as-condition After the customer identifies important data types, map each data type to a label. The mapping should be simple enough that users can understand it and technical teams can enforce it with labels, DLP rules, and endpoint controls.

| Example data | Recommended label | Reason | Typical control |
| :--- | :--- | :--- | :--- |
| Marketing brochure | Public | Can be shared externally | No encryption; monitor only if needed |
| Internal process document | Internal | Company-only information | Internal sharing allowed; external sharing reviewed |
| Customer contract | Confidential | Contains business and customer information | Restrict external sharing; use DLP alerts |
| Salary report | Highly Confidential | Contains HR and personal data | Limit access, audit use, and block risky sharing |
| M&A or legal investigation file | Restricted | Very high business/legal impact | Very limited access; strong DLP controls |

### 2.5 Data Classification Decision Matrix

Microsoft reference: Sensitivity labels: [Microsoft reference](https://learn.microsoft.com/en-us/purview/sensitivity-labels) Use this matrix to decide which classification level is correct for a data type. The customer should agree this before creating labels in the Purview portal.

| Question | Public | Internal | Confidential | Highly Confidential / Restricted |
| :--- | :--- | :--- | :--- | :--- |
| Who may access it? | Anyone | Employees | Specific teams or approved partners | Named users or very small groups |
| Can it be shared externally? | Yes | Usually no | Only with approval | No, or only by exception |
| Does it contain personal/sensitive data? | No | Low | Often yes | Yes, high impact |
| Business impact if leaked? | Low | Medium | High | Very high |
| Typical Purview action | Label only | Default/internal label | DLP alert or warning | Block/restrict and audit |

### 2.4 Data Classification Workshop

Microsoft reference: Learn about sensitivity labels: [Microsoft reference](https://learn.microsoft.com/en-us/purview/sensitivity-labels) Before configuring Purview, run a short classification workshop. The output should be a first label model, a list of sensitive data types, and examples that can be tested later in Microsoft Purview.

- Step 1 - Identify business data domains: HR, Finance, Legal, Sales, Operations, IT, Customer Data, and Project Data.

- Step 2 - Collect real examples of sensitive files, emails, SharePoint sites, and Teams locations.

- Step 3 - Decide the impact level if the data is shared with the wrong person.

- Step 4 - Map each data type to a simple classification level such as Public, Internal, Confidential, Highly Confidential,

or Restricted.

- Step 5 - Define the expected control: audit only, warn user, block action, encrypt, or limit access.

- Step 6 - Test the model with real sample files before using it in production policies.

## 3. Classification Schema - Technical Structure

Microsoft reference: Sensitivity labels: [Microsoft reference](https://learn.microsoft.com/en-us/purview/sensitivity-labels) The classification schema is the label hierarchy every sensitivity label and DLP policy will reference. Getting its

technical structure right early avoids rebuilding auto-labeling and DLP conditions later.

### 3.1 Structural Principles

- Keep the label structure simple and easy to understand. Use sub-labels only when they add clear value.

- Every label should map to at least one detectable condition (a Sensitive Information Type, a keyword set,

or a manual-only designation) so auto-labeling has something concrete to key off

- Leave the label set extensible - adding a sub-label later is far less disruptive than renaming or splitting

an existing one

### 3.2 Baseline Label Structure

| Classification Level | Typical Detection Basis |
| :--- | :--- |
| Public | No SIT match required - manual or default label |
| Internal | Default label; no automatic trigger in most configurations |
| Confidential | SIT matches: financial identifiers, HR-related keywords, customer data patterns |
| Highly Confidential | SIT matches: credentials, M&A keyword sets, special category personal data |
| Regulated / Compliance | SIT matches: health data patterns (GDPR Art. 9), payment card data (PCI-DSS) |

### 3.3 Sensitive Information Types (SITs)

Microsoft reference: Sensitive information types: [Microsoft reference](https://learn.microsoft.com/en-us/purview/sensitive-information-type-) learn-about Sensitive Information Types (SITs) are detection patterns used by Microsoft Purview to identify sensitive content.

Microsoft provides hundreds of built-in SITs, and organizations can also create custom SITs by using patterns such

as regular expressions or keyword lists. Labels that should be applied automatically need a clear detection

condition, such as a SIT or a trainable classifier.

### 3.4 Common Technical Pitfalls

Too many levels, too soon

Too many classification levels can confuse users and make automated rules harder to maintain. In most projects, a simple label model works better.

- Labels with no SIT or classifier mapped to them - they end up manual-only by default, which

undermines any auto-labeling plan

- No exception-handling logic defined for content that matches multiple SITs at different sensitivity levels

- Schema never tested against a real content sample before rollout - theoretical categories rarely survive

contact with actual files

## 4. Identity & Tenant Readiness

Microsoft reference: Permissions in Microsoft Purview: [Microsoft reference](https://learn.microsoft.com/en-us/purview/purview-permissions)

### 4.1 Directory Hygiene

Purview leans heavily on Entra ID. Before anything else, confirm directory sync is complete and error-free, that

stale or duplicate accounts have been cleaned up, and that security groups exist along clean, documented lines

rather than being created ad hoc during rollout. A consistent naming convention for those groups (e.g., a fixed

prefix and a clear purpose suffix) avoids ambiguity months later.

### 4.2 Admin Role Groups

Purview-specific role groups - Compliance Administrator, Compliance Data Administrator, Information

Protection Administrator, eDiscovery Manager, Security Reader, and so on - should be provisioned using

security groups rather than individual user accounts, so membership changes don't require touching the role

assignment itself. At least two members per critical role group avoids a single point of failure.

### 4.3 Tenant and Security Settings

- Global Admin access confirmed and MFA enforced for all admin accounts

- Unified Audit Log switched on well ahead of go-live - it cannot log retroactively, so waiting until launch

day means losing weeks of history

- Conditional access policies reviewed for any impact on the service accounts and sensors Purview will rely

on

### 4.7 Governance Go/No-Go Checks

Microsoft reference: Permissions in Microsoft Purview: [Microsoft reference](https://learn.microsoft.com/en-us/purview/purview-permissions) Do not start portal configuration until the customer can answer these questions clearly.

- [ ] Data owners are named for the main data domains.

- [ ] A deputy is named for each critical role.

- [ ] The first classification model is approved by business and IT stakeholders.

- [ ] The first DLP use cases are agreed and prioritized.

- [ ] The pilot users and pilot data locations are identified.

- [ ] The person who can approve exceptions is defined.

### 4.6 RACI Matrix for Purview Preparation

Microsoft reference: Purview RBAC and role groups: [Microsoft reference](https://learn.microsoft.com/en-us/purview/purview-permissions) Use this RACI model as a starting point. Adjust it to the customer organization, but avoid unclear ownership.

| Task | Data Owner | Compliance / Legal | Security Team | M365 / Purview Admin | Endpoint / Intune Team |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Define data categories | A/R | C | C | C | I |
| Approve label names and meaning | A/R | C | C | R | I |
| Create sensitivity labels | C | C | C | A/R | I |
| Define DLP use cases | C | C | A/R | R | C |
| Configure DLP policies | I | C | A | R | C |
| Endpoint DLP pilot | I | I | C | C | A/R |
| Review alerts and false positives | C | C | A/R | R | C |
| Approve policy enforcement | A/R | C | A/R | R | C |

R = Responsible, A = Accountable, C = Consulted, I = Informed

### 4.5 Recommended Responsibility Model

Microsoft reference: Permissions in Microsoft Purview portal: [Microsoft reference](https://learn.microsoft.com/en-us/purview/purview-) permissions Purview projects fail when everyone assumes someone else owns the classification decisions. Define these roles before implementation starts.

| Role | Main responsibility | Example owner |
| :--- | :--- | :--- |
| Data Owner | Decides how business data should be classified and protected | HR Lead, Finance Lead, Legal Lead, Sales Lead |
| Compliance / Legal Stakeholder | Validates regulatory, legal, and retention-related requirements | Compliance Officer, Legal Counsel |
| Security Team | Defines DLP risk scenarios and reviews alerts and risky behavior | Security Operations, Information Security |
| M365 / Purview Administrator | Configures labels, policies, role groups, and Purview settings | Microsoft 365 Admin, Compliance Admin |
| Endpoint / Intune Team | Prepares devices, onboarding, Intune deployment, and endpoint requirements | Endpoint Admin, Intune Admin |
| Business Approver | Approves final policy enforcement and exception process | Business Process Owner |

### 4.4 Governance and Role Readiness

Microsoft reference: Purview permissions: [Microsoft reference](https://learn.microsoft.com/en-us/purview/purview-permissions) Microsoft Purview is not only a technical configuration. The customer must define who owns the data, who approves the classification model, who configures controls, and who reviews alerts. This section does not cover budget or licensing.

## 5. Endpoint Protection: Endpoint DLP, Defender for Endpoint & Intune

Microsoft reference: Endpoint DLP overview: [Microsoft reference](https://learn.microsoft.com/en-us/purview/endpoint-dlp-learn-about) This is usually the least well understood part of technical readiness, because it touches three products at once -

Purview, Microsoft Defender for Endpoint, and Intune - and the dependency chain between them isn't obvious

from the Purview portal alone.

### 5.1 What Endpoint DLP Actually Does

Endpoint DLP extends Purview's DLP policy enforcement - the same conditions and rules used for Exchange,

SharePoint, and OneDrive - down to activity happening physically on a device: copying a sensitive file to USB,

uploading it through a browser, printing it, or pasting its contents into an unapproved app. Cloud and email DLP

can't see any of that once a file has been downloaded to a device; Endpoint DLP is what closes that specific gap.

### 5.2 Supported Operating Systems and Coverage Gaps

| Platform | Support Status |
| :--- | :--- |
| Windows 10 / 11 | Fully supported - the primary platform Endpoint DLP was built for |
| Windows Server 2019 and later | Supported, but disabled by default even after the server is onboarded - must be explicitly turned on |
| macOS (three latest major releases, minimum Catalina 10.15) | Supported, with functional gaps - see 5.5 |
| Linux, iOS, Android | Native Endpoint DLP enforcement is focused on Windows and macOS. For other platforms, plan additional controls such as Conditional Access, Intune App Protection Policies, and Defender for Cloud Apps. |

### 5.3 The Onboarding Mechanism

Endpoint DLP is not a separate agent. It uses the Microsoft Defender for Endpoint sensor on the device. A device

must be onboarded before it can be used as a device location in a DLP policy. Confirm that device monitoring is

enabled and that the required endpoint components are reporting correctly before creating blocking policies.

- If devices are already onboarded to MDE, no separate onboarding step is needed - they simply appear

in the Purview device list once device monitoring is turned on

- If MDE runs alongside a third-party antivirus product, Defender switches to passive mode automatically

- but real-time protection still needs to stay enabled, since several Endpoint DLP actions depend on it to scan content as it's created or modified

- MpDlpService.exe needs an explicit allow rule in the firewall, any third-party antivirus, and application

control policies, or onboarded devices won't report reliably

- Devices need outbound connectivity to the cloud DLP classification service; where a proxy is in use, its

configuration needs to explicitly allow that traffic

### 5.4 Deploying via Intune - Windows

Intune doesn't run Endpoint DLP itself - it's the delivery mechanism that pushes the Defender for Endpoint

onboarding configuration to devices. In practice: create a configuration profile in Intune using the Microsoft

Defender for Endpoint template (or a custom profile using the downloaded onboarding package from the

Purview device onboarding settings), assign it to the target Entra ID security group, and confirm the connection

between Defender for Endpoint and Intune is enabled in Defender's advanced features settings - without that

connector, Intune-deployed profiles won't onboard devices correctly.

### 5.5 Deploying via Intune - macOS

macOS onboarding has an extra step that's easy to miss if MDE was deployed to Mac devices before Endpoint

DLP was in scope. MDE on macOS already requires a Full Disk Access (FDA) configuration profile; Endpoint DLP

adds its own background component and needs an additional, separate FDA permission granted to it specifically.

If that permission isn't added to the existing FDA profile, the device shows as onboarded but Endpoint DLP won't

actually see file activity.

- Confirm the existing FDA configuration profile includes an entry for the DLP daemon, not just the core

Defender component

- Deploy through Intune's macOS configuration profiles, referencing the updated mobileconfig file rather

than assuming the original MDE profile already covers it

macOS functional gaps to plan around

macOS support is not always identical to Windows support. Validate supported DLP actions, labeling behavior, and permission requirements for macOS before using the same policy design as Windows.

### 5.6 Windows Server Considerations

Endpoint DLP support for Windows Server 2019 and later exists, but stays off by default even once a server is

onboarded through the same mechanism as workstations. It has to be switched on explicitly, per the fleet, in the

Purview DLP endpoint settings - an easy step to forget since it isn't part of the standard workstation onboarding

flow.

### 5.7 When to Turn It On

A simple pilot approach is recommended. In customer deployments, it is better to start with visibility before

blocking users:

1. Onboard a small device pilot group and confirm they report correctly in Activity Explorer before touching

policy

2. Start new policies in audit mode first and collect enough activity data before enforcing block actions

3. Review false positives and tune SIT confidence levels or exceptions before considering enforcement

4. Move to block or restrict only once the audit data supports it - and only for the specific device/user scope

that's actually ready

## 6. Network and On-Premises Considerations

Microsoft reference: Information protection scanner: [Microsoft reference](https://learn.microsoft.com/en-us/purview/deploy-scanner) If any on-premises sources are in scope - file servers, SQL, SAP - plan for Information Protection Scanner

deployment and firewall rules well in advance; this is typically the slowest-moving item on the entire checklist

because it needs sign-off from a network team sitting outside the project. Firewall rules for Purview cloud

endpoints need to be verified for both the scanner and any onboarded endpoint devices, and any proxy in the

path needs to be configured to allow that traffic rather than silently dropping it.

### 6.1 Readiness Checklist

| Area | Requirement | Status / Recommendation |
| :--- | :--- | :--- |
| Azure AD / Entra ID | Synchronization of all users and groups completed | Verify before starting |
| Microsoft 365 Tenant | Global Admin access available, MFA enabled | Mandatory requirement |
| Audit Log | Microsoft 365 Unified Audit Log must be active | Activate before starting |
| Defender for Endpoint | Sensor deployed and reporting on target Windows/macOS devices | Prerequisite for Endpoint DLP |
| Intune ↔ Defender Connector | Connection enabled in Defender advanced features | Required for Intune-based onboarding |
| macOS FDA Profile | Updated to include the DLP daemon permission | Verify before enabling Mac policies |
| Windows Servers | Endpoint DLP explicitly enabled per server after onboarding | Off by default - confirm setting |
| Network Connectivity | Firewall/proxy rules for Purview endpoints and MpDlpService.exe verified | Critical for on-prem scanners and endpoint devices |

## 7. Common Technical Pitfalls

| Pitfall | Recommendation |
| :--- | :--- |
| Treating the existing inventory or CMDB as complete | Validate a sample against reality before building a classification plan on top of it. |
| Labels with no SIT or classifier behind them | Auto-labeling needs a concrete detection condition - map every automated label to one before rollout. |
| Assuming MDE onboarding alone means Endpoint DLP is working | Confirm real-time protection is enabled and MpDlpService.exe is allowed through the firewall and any third-party AV. |
| Forgetting the additional FDA permission for the DLP daemon on macOS | The existing Defender FDA profile does not automatically cover Endpoint DLP - it needs its own entry. |
| Leaving Windows Servers unconfigured after onboarding | Endpoint DLP is off by default on servers even once onboarded - enable it explicitly. |
| Going straight to a blocking DLP policy | Always start in audit-only mode and validate the false-positive rate before enforcing anything. |

## 8. Technical Go/No-Go Checklist

Microsoft reference: Microsoft Purview documentation: [Microsoft reference](https://learn.microsoft.com/en-us/purview/) A reasonable gate before moving into portal configuration. If most of these aren't yet checked, that's simply a

sign of where to focus next.

Data

- [ ] Data owners have confirmed the most important business data domains

- [ ] Sample files and business examples have been collected for classification testing

- [ ] A data source inventory exists, covering Microsoft 365, Azure, on-premises, and third-party systems

- [ ] A first pass has been made at identifying shadow IT

Classification

- [ ] A classification workshop has been completed with key business owners

- [ ] Data types are mapped to labels and expected protection actions

- [ ] A simple baseline classification schema has been drafted

- [ ] Every automated label has at least one SIT or classifier mapped to it

Identity & Tenant

- [ ] Purview responsibilities and deputies are defined

- [ ] RACI model is agreed before portal configuration starts

- [ ] Directory sync is complete and clean, with security groups mapped to Purview role groups

- [ ] MFA is enforced for admin accounts and the Unified Audit Log has been activated

Endpoint

- [ ] Defender for Endpoint sensor is deployed to the target Windows and macOS device pilot group

- [ ] The Intune-Defender connector is enabled

- [ ] The macOS FDA profile includes the DLP daemon permission

- [ ] Windows Server Endpoint DLP has been explicitly enabled where needed

Network

- [ ] Firewall/proxy rules for Purview endpoints and MpDlpService.exe have been verified

- [ ] On-premises scanner network requirements (if applicable) have been scoped with the relevant team

## 9. Glossary of Key Terms

| Term | Explanation |
| :--- | :--- |
| Sensitivity Label | A tag that identifies the confidentiality level of a document or email and optionally applies protection measures |
| DLP (Data Loss Prevention) | Policies that detect and prevent the unintentional sharing of sensitive data |
| Endpoint DLP | The part of Purview DLP that extends monitoring and enforcement to activity happening on a physical device (USB, print, browser upload) |

| Term | Explanation |
| :--- | :--- |
| SIT (Sensitive Information Type) | Detection patterns (e.g., credit card numbers, national ID numbers) used to automatically identify sensitive content |
| Auto-Labeling | Automatic application of sensitivity labels based on detected SITs, without user interaction |
| MDE (Microsoft Defender for Endpoint) | The endpoint sensor platform that Endpoint DLP is built on top of; a device must be onboarded to MDE before it can be a location in a DLP policy |
| Onboarding | The process of registering a device with MDE/Purview so it reports telemetry and can be targeted by policy |
| FDA (Full Disk Access) | A macOS permission required by Defender and, separately, by the Endpoint DLP component, for full visibility into file activity |
| Data Map | Mapping of all data sources and data flows within and outside the organization |
| eDiscovery | Electronic collection and analysis of data for legal investigations or requests |

## 10. Further Resources

| Resource | Description and Access |
| :--- | :--- |
| Microsoft Purview Portal | [Microsoft reference](https://purview.microsoft.com) - main portal for all configurations, once preparation is complete |
| Learn about Endpoint DLP | [Microsoft reference](https://learn.microsoft.com/en-us/purview/endpoint-dlp-learn-about) - capabilities, supported file types, and platform coverage |
| Get Started with Endpoint DLP | [Microsoft reference](https://learn.microsoft.com/en-us/purview/endpoint-dlp-getting-started) - onboarding walkthrough |
| Device Onboarding Overview | [Microsoft reference](https://learn.microsoft.com/en-us/purview/device-onboarding-overview) - onboarding methods including Intune and Group Policy |
| macOS Onboarding via Intune | [Microsoft reference](https://learn.microsoft.com/en-us/purview/device-onboarding-offboarding-) macos-intune - FDA profile and DLP daemon configuration |
| Configure Endpoint DLP Settings | [Microsoft reference](https://learn.microsoft.com/en-us/purview/dlp-configure-endpoint-settings) - server enablement, path exclusions, browser controls |
| Microsoft Entra Admin Center | [Microsoft reference](https://entra.microsoft.com) - identity and access management |

Microsoft Purview Technical Readiness Guide | Version 1.1 | 2026

Prepared as a technical foundation for a well-planned Purview rollout - adapt freely to your environment.
