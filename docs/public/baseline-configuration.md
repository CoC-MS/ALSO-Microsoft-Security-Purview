# ⚙️ Baseline Configuration

This page describes the baseline documented in this repository.

Review the actual configuration before deployment:

`Purview/Config/PurviewConfig.psd1`

> [!IMPORTANT]
> Review settings, assignments, licensing, and customer requirements before deployment. Always start with `-WhatIf`.

## 1. Tenant settings

The baseline configuration includes:

- Unified Audit Log
- Sensitivity labels for PDF files
- Azure Information Protection integration in SharePoint
- Optional sensitivity label co-authoring
- Optional Premium Audit configuration

## 2. Sensitivity labels

### Public

Business data approved for public consumption. No encryption or content marking is applied.

### General

Business data not intended for public consumption but shareable externally when appropriate.

| Sublabel | Description |
|---|---|
| Anyone (unrestricted) | General business data that may be shared externally. |
| All Employees (unrestricted) | General business data intended for employees. |

### Confidential

Sensitive business data that could cause damage if shared with unauthorized people.

| Sublabel | Description |
|---|---|
| All Employees | Internal confidential data. A footer can be applied when content marking is enabled. |
| Trusted People | Protected content for trusted internal or external recipients. User-defined encryption is used. |

### Highly Confidential

Very sensitive business data requiring the highest protection.

| Sublabel | Description |
|---|---|
| All Employees | Tenant-scoped template encryption is applied. |
| Specific People | Explicitly selected recipients receive access. Do Not Forward behavior is configured for Outlook. |

## 3. Label publishing policy

**Policy name:** `BP-ALSO - Default Label Policy`

The policy publishes the configured baseline labels to users and includes:

- Mandatory labeling
- Justification when lowering a label
- Automatic attachment labeling behavior
- Default document label: `AllEmployees`
- Default email label: `GeneralAnyone`

## 4. Label-based DLP policies

### BP-ALSO - DLP - Confidential and HC external (EXO)

Configured to block Exchange messages labeled Confidential or Highly Confidential from being sent outside the organization when enforcement is enabled.

### BP-ALSO - DLP - Confidential and HC external (SPO+ODB)

Configured to block external sharing of SharePoint and OneDrive content labeled Confidential or Highly Confidential when enforcement is enabled.

### E5-PS-ALSO - DLP - Endpoint Confidential and HC

Configured to audit the following activities for labeled content on supported endpoints:

- Copy and paste
- Printing
- Copying to removable media
- Copying to a network share

> [!NOTE]
> The baseline starts DLP policies in simulation when `DlpStartInSimulation` is set to `$true`. Do not interpret simulation as active blocking. Review results before moving policies to enforcement.

## 5. Sensitive information type DLP policies

The toolkit includes Exchange DLP policies for external messages containing:

| Policy | Sensitive information detected |
|---|---|
| `BP-ALSO - DLP - Credit Card Numbers (EXO)` | Credit card numbers |
| `BP-ALSO - DLP - IBAN and Bank Account Numbers (EXO)` | International Bank Account Numbers |
| `BP-ALSO - DLP - EU Social Security Numbers (EXO)` | EU social security numbers |
| `BP-ALSO - DLP - Swiss AHV Numbers (EXO)` | Swiss AHV numbers |
| `BP-ALSO - DLP - Passport Numbers DACH-EU (EXO)` | Selected EU, German, and Swiss passport numbers |
| `BP-ALSO - DLP - Tax ID and VAT DACH (EXO)` | Selected German, Austrian, and Swiss tax or VAT numbers |

### Detection settings

| Setting | Value |
|---|---|
| Minimum count | `1` |
| Maximum count | `500` |
| Minimum confidence level | `85` |

## 6. Retention

**Policy name:** `BP-ALSO - Exchange 7-year retention`

The configured policy retains Exchange content for 2,555 days from creation and then deletes it.

Retention is not deployed by default and requires `-ApplyRetention`.

> [!WARNING]
> Review the retention duration and deletion behavior with the customer before deployment. Do not enable retention without confirming legal, regulatory, and business requirements.

## 7. AI governance

**Policy name:** `E5-PS-ALSO - AI - Block Copilot for Highly Confidential`

The baseline includes a Microsoft 365 Copilot DLP control intended to prevent processing of content labeled Highly Confidential.

> [!NOTE]
> Confirm the policy's actual scope, supported experiences, licensing, and enforcement status before relying on this control. Policy changes can take time before enforcement begins.

## Deployment guidance

- [Before deployment](before-deployment.md)
- [How to run and video tutorial](how-to-run.md)
- [Deployment coverage](deployment-coverage.md)

---

[Back to main README](../../README.md)