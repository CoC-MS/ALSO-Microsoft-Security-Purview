# Purview Policies: Purpose, Configuration & Impact

Configuration summary from the supplied guide, not a script or deployment verification. DLP starts in simulation where the global flag applies. AI explicitly uses Mode=Enable. Marking and module-dependent behavior require verification.

## 1. Tenant settings

### Unified audit logging

**Scope:** Tenant-level audit configuration.

**Explanation:** The toolkit requests audit logging so that supported activities can be available for administrative review. This setting is separate from retaining Exchange messages.

**Setting:** EnableUnifiedAuditLog = True

**Effect:** This is a supporting administrative setting, not a label-selection prompt or a content-blocking rule.

### Sensitivity-label support for PDF

**Scope:** Tenant-level support requested for PDF labeling scenarios.

**Explanation:** The toolkit requests the PDF-related labeling capability. It does not define a rule that automatically assigns a label to every PDF.

**Setting:** EnableSensitivityLabelForPDF = True

**Effect:** The intended benefit is support for labeled PDFs in the applicable supported scenario.

### SharePoint and OneDrive label integration

**Scope:** Tenant-level integration for SharePoint and OneDrive file processing.

**Explanation:** The toolkit requests integration between sensitivity labels and the SharePoint/OneDrive services. This supports the labeled-file environment; it is not itself the external-sharing DLP policy described in Chapter 4.

**Setting:** EnableAIPIntegrationInSPO = True

**Effect:** Users work with labeled files in the supported service experience.

### Encrypted-document coauthoring

**Scope:** Tenant-level encrypted-document collaboration setting.

**Explanation:** The configuration does not request enabling encrypted-document coauthoring. The module must be checked to determine whether false means leave unchanged or actively disable.

**Setting:** EnableLabelCoAuth = False

**Effect:** If the deployment actually disables this feature, supported encrypted-document collaboration behavior can change.

## 2. Sensitivity labels

### Public

**Scope:** No explicit ContentType; Public is included in PublishedLabels.

**Explanation:** For business data approved for public consumption.

**Setting:** Encrypt = $false; ContentMark = $false

**Effect:** Classification without label-configured encryption.

### General

**Scope:** Parent label; no explicit ContentType.

**Explanation:** Business data not intended for public consumption, but shareable externally when appropriate. Contains two sublabels.

**Setting:** Encrypt / ContentMark = $false / $false; SubLabels = GeneralAnyone, GeneralAllEmployees

**Effect:** A classification hierarchy, not a general external-sharing authorization.

### General / Anyone (unrestricted)

**Scope:** File, Email, Site, UnifiedGroup; explicitly published. Referenced as the default email label.

**Explanation:** General business data that can be shared externally when appropriate.

**Setting:** Encrypt / ContentMark = $false / $false

**Effect:** Intended default classification for email.

### General / All Employees (unrestricted)

**Scope:** No explicit ContentType; not explicitly included in PublishedLabels.

**Explanation:** General business data intended for employees.

**Setting:** Encrypt / ContentMark = $false / $false

**Effect:** The employee audience is descriptive, not an enforced encryption boundary.

### Confidential

**Scope:** Parent label; no explicit ContentType.

**Explanation:** Sensitive business data that could cause damage if shared with unauthorized people.

**Setting:** Encrypt / ContentMark = $false / $false; SubLabels = AllEmployees, TrustedPeople

**Effect:** Protection differs by child label.

### Confidential / All Employees

**Scope:** File, Email, Site, UnifiedGroup; explicitly published and referenced as DefaultLabel.

**Explanation:** Confidential data intended to be shared internally with all employees.

**Setting:** Encrypt = $false; ContentMark = $true; FooterText = Classified as Confidential

**Effect:** Intended default classification for supported non-email labeling behavior.

### Confidential / Trusted People

**Scope:** No explicit ContentType; not explicitly published. Referenced by label-based DLP.

**Explanation:** Confidential data shared with trusted internal or external recipients.

**Setting:** Encrypt = $true; ProtectionType = UserDefined; UserDefinedOutlookBehavior = EncryptOnly; ContentMark = $true; FooterText = Classified as Confidential

**Effect:** Intended protected collaboration with selected recipients.

### Highly Confidential

**Scope:** Parent label; no explicit ContentType. Referenced directly by the AI governance policy.

**Explanation:** Very sensitive business data requiring the highest protection in this taxonomy.

**Setting:** Encrypt = $false; ContentMark = $true; WatermarkText = HIGHLY CONFIDENTIAL; SubLabels = HCAllEmps, HCSpecificPeople

**Effect:** The parent is not equivalent to either encrypted child.

### Highly Confidential / All Employees

**Scope:** File, Email, Site, UnifiedGroup; explicitly published. Referenced by label-based DLP.

**Explanation:** Highly confidential data intended for users in this tenant only.

**Setting:** Encrypt = $true; ProtectionType = Template; EncryptionRightsDefinitions = {TenantDomain}:VIEW,VIEWRIGHTSDATA,EDIT,DOCEDIT,EXTRACT,PRINT,OBJMODEL,REPLY,REPLYALL,FORWARD; ContentMark = $true; FooterText = Classified as Highly Confidential

**Effect:** Intended tenant-domain protection with substantial usage rights for authorized users.

### Highly Confidential / Specific People

**Scope:** No explicit ContentType; not explicitly published. Referenced by label-based DLP.

**Explanation:** Highly confidential data intended to be viewable only by explicitly selected people.

**Setting:** Encrypt = $true; ProtectionType = UserDefined; UserDefinedOutlookBehavior = DoNotForward; ContentMark = $true; FooterText = Classified as Highly Confidential

**Effect:** Intended recipient-restricted protection.

## 4. Label-based DLP

### BP-ALSO - DLP - Confidential and HC external (EXO)

**Scope:** Workload='Exchange'. Mailbox inclusions and exclusions are not specified.

**Explanation:** The comment expresses an intent to block externally sent Exchange messages labeled Confidential or Highly Confidential.

**Setting:** LabelPaths = Confidential/AllEmployees; Confidential/TrustedPeople; HighlyConfidential/HCAllEmps; HighlyConfidential/HCSpecificPeople; BlockAccess = $true; BlockAccessScope = PerUser; NotifyUser = SiteAdmin, LastModifier, Owner; GenerateIncidentReport = SiteAdmin; External condition = Not explicitly present; Initial mode = Global simulation flag is true

**Effect:** Intended external blocking only when enforced. External condition is not explicit; module translation must supply it. Simulation does not block.

### BP-ALSO - DLP - Confidential and HC external (SPO+ODB)

**Scope:** Workload='SharePointOneDrive'. Specific sites, accounts, and exclusions are not supplied.

**Explanation:** Intended to restrict external access to matching labeled files in SharePoint and OneDrive.

**Setting:** LabelPaths = Confidential/AllEmployees; Confidential/TrustedPeople; HighlyConfidential/HCAllEmps; HighlyConfidential/HCSpecificPeople; BlockAccess = $true; BlockAccessScope = PerUser; NotifyUser = SiteAdmin, LastModifier, Owner; GenerateIncidentReport = SiteAdmin; External condition = Not explicitly present; Initial mode = Global simulation flag is true

**Effect:** Intended external access restriction when enforced. External condition is not explicit. Simulation does not block.

### E5-PS-ALSO - DLP - Endpoint Confidential and HC

**Scope:** Workload='Endpoint'. User/device inclusions and exclusions are not supplied. Endpoint DLP requires supported onboarded devices and effective user/device targeting.

**Explanation:** Audits selected handling activities for content with one of the four target labels.

**Setting:** LabelPaths = Confidential/AllEmployees; Confidential/TrustedPeople; HighlyConfidential/HCAllEmps; HighlyConfidential/HCSpecificPeople; CopyPaste = Audit; Print = Audit; RemovableMedia = Audit; NetworkShare = Audit; EnforcePortalAccess = $true; ReportSeverityLevel = Medium; GenerateAlert = $true; NotifyUser = Empty array; GenerateIncidentReport = Empty array

**Effect:** Audits the four configured activities; these actions do not block. Medium-severity alerts requested.

## 5. SIT-based DLP

### Shared scope, settings, and effects

**Scope:** Every entry sets Workload='Exchange' and AccessScope='NotInOrganization'. No explicit mailbox inclusion/exclusion list is supplied.

**Explanation:** These rules detect configured sensitive information types (SITs), rather than requiring a sensitivity label.

**Setting:** MinCount = 1; MaxCount = 500; MinConfidence = 85; AccessScope = NotInOrganization; BlockAccess = $true; BlockAccessScope = PerUser; Initial mode = DlpStartInSimulation=$true globally

**Effect:** Requests blocking when enforced Supplied action-scope value; verify the Exchange implementation

### BP-ALSO - DLP - Credit Card Numbers (EXO)

**Scope:** External Exchange messages; effective mailbox scope requires verification.

**Explanation:** Detects the configured credit-card SIT in external messages.

**Setting:** SIT name = Credit Card Number; Count / confidence = 1–500 / minimum 85; Optional = $false; External / action = NotInOrganization / block requested

**Effect:** Matching external messages are intended to be blocked only when the rule is effectively enforced.

### BP-ALSO - DLP - IBAN and Bank Account Numbers (EXO)

**Scope:** External Exchange messages; effective mailbox scope requires verification.

**Explanation:** Detects IBANs. Despite the broader policy name, no separate generic or country-specific bank-account-number SIT is configured.

**Setting:** SIT name = International Banking Account Number (IBAN); Count / confidence = 1–500 / minimum 85; Optional = $false; External / action = NotInOrganization / block requested

**Effect:** Intended protection for detected IBANs, not every possible bank account format.

### BP-ALSO - DLP - EU Social Security Numbers (EXO)

**Scope:** External Exchange messages; effective mailbox scope requires verification.

**Explanation:** Requests detection using the configured EU social-security SIT name.

**Setting:** SIT name = EU Social Security Number (SSN); Count / confidence = 1–500 / minimum 85; Optional = $false; External / action = NotInOrganization / block requested

**Effect:** Coverage is limited to the resolved detector and its documented patterns, not every national identifier.

### BP-ALSO - DLP - Swiss AHV Numbers (EXO)

**Scope:** External Exchange messages; effective mailbox scope requires verification.

**Explanation:** Requests detection of Swiss AHV social-security numbers.

**Setting:** SIT name = Switzerland Social Security Number AHV; Count / confidence = 1–500 / minimum 85; Optional = $false; External / action = NotInOrganization / block requested

**Effect:** Intended external-message protection for matching AHV data, subject to detector resolution and enforcement.

### BP-ALSO - DLP - Passport Numbers DACH-EU (EXO)

**Scope:** External Exchange messages; effective mailbox scope requires verification.

**Explanation:** Requests matching of at least one of three configured passport detectors.

**Setting:** EU Passport Number = 1–500; Germany Passport Number = 1–500; Switzerland Passport Number = 1–500; RequireAtLeastOneSensitiveInformationType = $true; AccessScope / BlockAccess / BlockAccessScope = NotInOrganization / $true / PerUser

**Effect:** Intended protection for detected passport information.

### BP-ALSO - DLP - Tax ID and VAT DACH (EXO)

**Scope:** External Exchange messages; effective mailbox scope requires verification.

**Explanation:** Requests matching of at least one of five configured tax/VAT detectors.

**Setting:** Germany Tax Identification Number = 1–500; Germany Value Added Tax (VAT) Number = 1–500; Austria Tax Identification Number = 1–500; Austria Value Added Tax (VAT) Number = 1–500; Switzerland Value Added Tax (VAT) Number = 1–500; RequireAtLeastOneSensitiveInformationType = $true; AccessScope / BlockAccess / BlockAccessScope = NotInOrganization / $true / PerUser

**Effect:** Intended protection for the listed tax/VAT identifiers.

## 6. Optional retention

### BP-ALSO - Exchange 7-year retention

**Scope:** Locations=@('Exchange'). The configuration does not explicitly list included or excluded mailboxes.

**Explanation:** Requests retention of Exchange content for the configured period followed by deletion. This is content lifecycle management, not sensitivity labeling or DLP.

**Setting:** DurationDays = 2555; Action = KeepAndDelete; ExpirationDateOption = CreationAgeInDays; Locations = Exchange

**Effect:** Retains content for 2555 days, then deletes, subject to holds and applicable retention rules.

## 7. AI governance

### E5-PS-ALSO - AI - Block Copilot for Highly Confidential

**Scope:** Application location with a tenant-wide inclusion in the supplied location object. Effective supported Copilot experiences and content types must be verified against current Microsoft documentation and the generated policy.

**Explanation:** Intended to prevent supported Copilot experiences from processing content matching the configured sensitivity-label condition. It is not a blanket disablement of Copilot for users.

**Setting:** Mode = Enable; EnforcementPlanes = CopilotExperiences; Locations.Workload = Applications; Locations.Location = 470f2276-e011-4e9d-a6ec-20768be3a4b0; Locations.Inclusions = Type='Tenant'; Identity='All'; LabelPaths = HighlyConfidential; RestrictAccess.setting = ExcludeContentProcessing; RestrictAccess.value = Block

**Effect:** Requests blocking of matching content processing, not all Copilot use. Parent-to-child label expansion and supported mapping are unverified.
