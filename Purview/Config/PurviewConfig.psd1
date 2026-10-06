# =============================================================================
# Author: Oualid EL Bakkari
# Organization: ALSO
# Purpose: Microsoft Purview Best Practice Deployment Toolkit
# =============================================================================
@{
    ManagedByTag = '[Managed by SMBTool Purview Toolkit]'
    DlpStartInSimulation = $true
    EnableContentMarking = $false

    Labels = @(
        @{ Name='Public'; DisplayName='Public'; BuiltInName='defa4170-0d19-0005-0001-bc88714345d2'; Tooltip='Business data approved for public consumption.'; Color='#13A10E'; Encrypt=$false; ContentMark=$false }
        @{ Name='General'; DisplayName='General'; BuiltInName='defa4170-0d19-0005-0002-bc88714345d2'; Tooltip='Business data not intended for public consumption but shareable externally when appropriate.'; Color='#3A96DD'; Encrypt=$false; ContentMark=$false; SubLabels=@(
            @{ Name='GeneralAnyone'; DisplayName='Anyone (unrestricted)'; BuiltInName='defa4170-0d19-0005-0003-bc88714345d2'; Tooltip='General business data that can be shared externally when appropriate.'; Color='#3A96DD'; Encrypt=$false; ContentMark=$false; ContentType='File, Email, Site, UnifiedGroup' }
            @{ Name='GeneralAllEmployees'; DisplayName='All Employees (unrestricted)'; BuiltInName='defa4170-0d19-0005-0004-bc88714345d2'; Tooltip='General business data intended for employees.'; Color='#3A96DD'; Encrypt=$false; ContentMark=$false }
        )}
        @{ Name='Confidential'; DisplayName='Confidential'; BuiltInName='defa4170-0d19-0005-0005-bc88714345d2'; Tooltip='Sensitive business data that could cause damage if shared with unauthorized people.'; Color='#EAA300'; Encrypt=$false; ContentMark=$false; SubLabels=@(
            @{ Name='AllEmployees'; DisplayName='All Employees'; BuiltInName='defa4170-0d19-0005-0007-bc88714345d2'; Tooltip='Confidential data shared internally with all employees.'; Color='#EAA300'; Encrypt=$false; ContentMark=$true; FooterText='Classified as Confidential'; ContentType='File, Email, Site, UnifiedGroup' }
            @{ Name='TrustedPeople'; DisplayName='Trusted People'; BuiltInName='defa4170-0d19-0005-0008-bc88714345d2'; Tooltip='Confidential data shared with trusted internal or external recipients.'; Color='#EAA300'; Encrypt=$true; ProtectionType='UserDefined'; UserDefinedOutlookBehavior='EncryptOnly'; ContentMark=$true; FooterText='Classified as Confidential' }
        )}
        @{ Name='HighlyConfidential'; DisplayName='Highly Confidential'; BuiltInName='defa4170-0d19-0005-0009-bc88714345d2'; Tooltip='Very sensitive business data requiring the highest protection.'; Color='#A4262C'; Encrypt=$false; ContentMark=$true; WatermarkText='HIGHLY CONFIDENTIAL'; SubLabels=@(
            @{ Name='HCAllEmps'; DisplayName='All Employees'; BuiltInName='defa4170-0d19-0005-000a-bc88714345d2'; Tooltip='Highly confidential data for users in this tenant only.'; Color='#A4262C'; Encrypt=$true; ProtectionType='Template'; EncryptionRightsDefinitions='{TenantDomain}:VIEW,VIEWRIGHTSDATA,EDIT,DOCEDIT,EXTRACT,PRINT,OBJMODEL,REPLY,REPLYALL,FORWARD'; ContentMark=$true; FooterText='Classified as Highly Confidential'; ContentType='File, Email, Site, UnifiedGroup' }
            @{ Name='HCSpecificPeople'; DisplayName='Specific People'; BuiltInName='defa4170-0d19-0005-000b-bc88714345d2'; Tooltip='Highly confidential data viewable only by explicitly selected people.'; Color='#A4262C'; Encrypt=$true; ProtectionType='UserDefined'; UserDefinedOutlookBehavior='DoNotForward'; ContentMark=$true; FooterText='Classified as Highly Confidential' }
        )}
    )

    EncryptionRightsDefinitions = '{TenantDomain}:VIEW,VIEWRIGHTSDATA,EDIT,DOCEDIT,REPLY,REPLYALL,FORWARD'
    EncryptionContentExpiredOnDateInDaysOrNever = 'Never'
    EncryptionOfflineAccessDays = 30

    LabelPolicy = @{
        Name='BP-ALSO - Default Label Policy'
        Comment='Publishes the ALSO baseline sensitivity labels to all users. Created by Oualid EL Bakkari.'
        DefaultLabel='AllEmployees'
        DefaultLabelForEmail='GeneralAnyone'
        PublishedLabels=@('Public','GeneralAnyone','AllEmployees','HCAllEmps')
        MandatoryLabelling=$true
        DowngradeJustification=$true
        AttachmentAction='Automatic'
    }

    DlpPolicies = @(
        @{ Name='BP-ALSO - DLP - Confidential and HC external (EXO)'; Comment='Blocks Exchange messages labelled Confidential or Highly Confidential from being sent outside the organisation.'; Workload='Exchange'; RuleName='BP-ALSO - DLP Rule - Confidential and HC - Exchange'; LabelPaths=@('Confidential/AllEmployees','Confidential/TrustedPeople','HighlyConfidential/HCAllEmps','HighlyConfidential/HCSpecificPeople'); BlockAccess=$true; BlockAccessScope='PerUser'; NotifyUser=@('SiteAdmin','LastModifier','Owner'); GenerateIncidentReport=@('SiteAdmin') }
        @{ Name='BP-ALSO - DLP - Confidential and HC external (SPO+ODB)'; Comment='Blocks external sharing of SharePoint and OneDrive files labelled Confidential or Highly Confidential.'; Workload='SharePointOneDrive'; RuleName='BP-ALSO - DLP Rule - Confidential and HC - SPO ODFB'; LabelPaths=@('Confidential/AllEmployees','Confidential/TrustedPeople','HighlyConfidential/HCAllEmps','HighlyConfidential/HCSpecificPeople'); BlockAccess=$true; BlockAccessScope='PerUser'; NotifyUser=@('SiteAdmin','LastModifier','Owner'); GenerateIncidentReport=@('SiteAdmin') }
        @{ Name='E5-PS-ALSO - DLP - Endpoint Confidential and HC'; Comment='Endpoint DLP audits copy, print, USB and network-share activity for labelled content.'; Workload='Endpoint'; RuleName='E5-PS-ALSO - DLP Rule - Endpoint Confidential and HC'; LabelPaths=@('Confidential/AllEmployees','Confidential/TrustedPeople','HighlyConfidential/HCAllEmps','HighlyConfidential/HCSpecificPeople'); EndpointDlpRestrictions=@(@{Setting='CopyPaste';Value='Audit'},@{Setting='Print';Value='Audit'},@{Setting='RemovableMedia';Value='Audit'},@{Setting='NetworkShare';Value='Audit'}); EnforcePortalAccess=$true; ReportSeverityLevel='Medium'; GenerateAlert=$true; NotifyUser=@(); GenerateIncidentReport=@() }
    )

    SitDlpPolicies = @(
        @{ Name='BP-ALSO - DLP - Credit Card Numbers (EXO)'; RuleName='BP-ALSO - DLP Rule - Credit Card Numbers - Exchange'; Comment='Detects credit card numbers in external Exchange messages. Created by Oualid EL Bakkari.'; Workload='Exchange'; SensitiveInformationTypes=@(@{Name='Credit Card Number';MinCount=1;MaxCount=500;MinConfidence=85;Optional=$false}); AccessScope='NotInOrganization';BlockAccess=$true;BlockAccessScope='PerUser' }
        @{ Name='BP-ALSO - DLP - IBAN and Bank Account Numbers (EXO)'; RuleName='BP-ALSO - DLP Rule - IBAN and Bank Account Numbers - Exchange'; Comment='Detects IBAN numbers in external Exchange messages. Created by Oualid EL Bakkari.'; Workload='Exchange'; SensitiveInformationTypes=@(@{Name='International Banking Account Number (IBAN)';MinCount=1;MaxCount=500;MinConfidence=85;Optional=$false}); AccessScope='NotInOrganization';BlockAccess=$true;BlockAccessScope='PerUser' }
        @{ Name='BP-ALSO - DLP - EU Social Security Numbers (EXO)'; RuleName='BP-ALSO - DLP Rule - EU Social Security Numbers - Exchange'; Comment='Detects EU social security numbers in external Exchange messages. Created by Oualid EL Bakkari.'; Workload='Exchange'; SensitiveInformationTypes=@(@{Name='EU Social Security Number (SSN)';MinCount=1;MaxCount=500;MinConfidence=85;Optional=$false}); AccessScope='NotInOrganization';BlockAccess=$true;BlockAccessScope='PerUser' }
        @{ Name='BP-ALSO - DLP - Swiss AHV Numbers (EXO)'; RuleName='BP-ALSO - DLP Rule - Swiss AHV Numbers - Exchange'; Comment='Detects Swiss AHV numbers in external Exchange messages. Created by Oualid EL Bakkari.'; Workload='Exchange'; SensitiveInformationTypes=@(@{Name='Switzerland Social Security Number AHV';MinCount=1;MaxCount=500;MinConfidence=85;Optional=$false}); AccessScope='NotInOrganization';BlockAccess=$true;BlockAccessScope='PerUser' }
        @{ Name='BP-ALSO - DLP - Passport Numbers DACH-EU (EXO)'; RuleName='BP-ALSO - DLP Rule - Passport Numbers DACH-EU - Exchange'; Comment='Detects DACH and EU passport numbers in external Exchange messages. Created by Oualid EL Bakkari.'; Workload='Exchange'; SensitiveInformationTypes=@(@{Name='EU Passport Number';MinCount=1;MaxCount=500;MinConfidence=85;Optional=$true},@{Name='Germany Passport Number';MinCount=1;MaxCount=500;MinConfidence=85;Optional=$true},@{Name='Switzerland Passport Number';MinCount=1;MaxCount=500;MinConfidence=85;Optional=$true}); RequireAtLeastOneSensitiveInformationType=$true;AccessScope='NotInOrganization';BlockAccess=$true;BlockAccessScope='PerUser' }
        @{ Name='BP-ALSO - DLP - Tax ID and VAT DACH (EXO)'; RuleName='BP-ALSO - DLP Rule - Tax ID and VAT DACH - Exchange'; Comment='Detects DACH tax and VAT numbers in external Exchange messages. Created by Oualid EL Bakkari.'; Workload='Exchange'; SensitiveInformationTypes=@(@{Name='Germany Tax Identification Number';MinCount=1;MaxCount=500;MinConfidence=85;Optional=$true},@{Name='Germany Value Added Tax (VAT) Number';MinCount=1;MaxCount=500;MinConfidence=85;Optional=$true},@{Name='Austria Tax Identification Number';MinCount=1;MaxCount=500;MinConfidence=85;Optional=$true},@{Name='Austria Value Added Tax (VAT) Number';MinCount=1;MaxCount=500;MinConfidence=85;Optional=$true},@{Name='Switzerland Value Added Tax (VAT) Number';MinCount=1;MaxCount=500;MinConfidence=85;Optional=$true}); RequireAtLeastOneSensitiveInformationType=$true;AccessScope='NotInOrganization';BlockAccess=$true;BlockAccessScope='PerUser' }
    )

    Retention=@{ Name='BP-ALSO - Exchange 7-year retention'; Comment='Retains Exchange content for seven years from creation, then deletes.'; RuleName='BP-ALSO - Exchange 7yr Rule'; DurationDays=2555; DurationDisplayHint='Years'; Action='KeepAndDelete'; ExpirationDateOption='CreationAgeInDays'; Locations=@('Exchange') }

    AIGovernance=@{ DlpPolicies=@(
        @{ Name='E5-PS-ALSO - AI - Block Copilot for Highly Confidential'; RuleName='E5-PS-ALSO - AI Rule - Block Copilot Highly Confidential'; Comment='Prevents Microsoft 365 Copilot from processing content labelled Highly Confidential.'; Mode='Enable'; EnforcementPlanes=@('CopilotExperiences'); Locations=@(@{Workload='Applications';Location='470f2276-e011-4e9d-a6ec-20768be3a4b0';Inclusions=@(@{Type='Tenant';Identity='All'})}); LabelPaths=@('HighlyConfidential'); RestrictAccess=@(@{setting='ExcludeContentProcessing';value='Block'}) }
    )}

    TenantSettings=@{ EnableUnifiedAuditLog=$true; EnableSensitivityLabelForPDF=$true; EnableAIPIntegrationInSPO=$true; EnableLabelCoAuth=$false }
}
