#requires -Version 7.0
# =============================================================================
# Author: Oualid EL Bakkari
# Organization: ALSO
# Purpose: Microsoft Purview Best Practice Deployment Toolkit
# =============================================================================
[CmdletBinding(SupportsShouldProcess,ConfirmImpact='None')]
param(
 [Parameter(Mandatory)][string]$TenantAdminUpn,
 [string]$SharePointAdminUrl,[string]$DelegatedOrganization,[string]$ConfigPath,
 [switch]$SkipTenantSettings,[switch]$SkipLabels,[switch]$SkipDLP,[switch]$ApplyRetention,
 [switch]$SkipAIControls,[switch]$ApplyAIControls,[switch]$EnableContainerLabels,
 [switch]$SkipContainerLabels,[switch]$EnablePremiumAudit,[string[]]$PremiumAuditMailbox,
 [switch]$AdoptExisting,[switch]$EnableLabelCoAuthoring,[switch]$NonInteractive,
 [switch]$AutoInstallModules,[switch]$BPOnly,[switch]$NoLicenseAutoDetect,
 [string]$ReportPath,[switch]$NoReport
)
$ErrorActionPreference='Stop';$ConfirmPreference='None';$script:DeployVersion='1.3.0-ALSO';$script:StartTime=Get-Date;$script:RunId=[guid]::NewGuid()
$root=Split-Path -Parent $PSCommandPath
if(-not$ConfigPath){$ConfigPath=Join-Path $root 'Config\PurviewConfig.psd1'}
if(-not(Test-Path $ConfigPath)){throw "Config file not found: $ConfigPath"}
$config=Import-PowerShellDataFile $ConfigPath
if($EnableLabelCoAuthoring){$config.TenantSettings.EnableLabelCoAuth=$true}
$modules=Join-Path $root 'Modules';$connect=Join-Path $modules 'Connect-PurviewServices.ps1';$tenant=Join-Path $modules 'Setup-TenantSettings.ps1';$labels=Join-Path $modules 'Setup-SensitivityLabels.ps1';$dlp=Join-Path $modules 'Setup-DLP.ps1';$ret=Join-Path $modules 'Setup-Retention.ps1';$ai=Join-Path $modules 'Setup-AIGovernance.ps1'
foreach($p in @($connect,$tenant,$labels,$dlp,$ret,$ai)){if(-not(Test-Path $p)){throw "Required module missing: $p"}}
. (Join-Path $modules 'PurviewRunLog.ps1');Initialize-PurviewRunLog

function Invoke-AlsoSitDlp{
 [CmdletBinding(SupportsShouldProcess=$true)]param([Parameter(Mandatory)][object]$Config)
 function V($o,$n){if($o-is[System.Collections.IDictionary]){$o[$n]}else{$o.$n}}
 $mode=if($Config.DlpStartInSimulation){'TestWithoutNotifications'}else{'Enable'}
 $available=@(Get-DlpSensitiveInformationType);$policies=@(Get-DlpCompliancePolicy);$rules=@(Get-DlpComplianceRule)
 foreach($pc in @($Config.SitDlpPolicies)){
  $pn=[string](V $pc 'Name');$rn=[string](V $pc 'RuleName');$conditions=@();$requiredMissing=$false
  Write-Host "`n      Policy: $pn" -ForegroundColor Yellow
  foreach($sc in @(V $pc 'SensitiveInformationTypes')){
   $sn=[string](V $sc 'Name');$ov=V $sc 'Optional';$optional=if($null-eq$ov){$false}else{[bool]$ov}
   if(-not($available|Where-Object Name -eq $sn|Select-Object -First 1)){if($optional){Write-Warning "SIT not found: $sn (optional)";continue};$requiredMissing=$true;Write-Warning "SIT not found: $sn (required)";break}
   $c=@{Name=$sn};foreach($k in 'MinCount','MaxCount','MinConfidence'){$x=V $sc $k;if($null-ne$x){$c[$k]=[string]$x}};$conditions+=$c
  }
  if($requiredMissing-or$conditions.Count-eq 0){Write-Warning "Skipped '$pn': no valid SIT condition.";continue}
  $comment=("{0} {1}"-f([string](V $pc 'Comment')),$Config.ManagedByTag).Trim();$p=$policies|Where-Object Name -eq $pn|Select-Object -First 1
  if(-not$p){if($PSCmdlet.ShouldProcess($pn,'Create SIT DLP policy')){New-DlpCompliancePolicy -Name $pn -Comment $comment -ExchangeLocation All -Mode $mode|Out-Null}}elseif($PSCmdlet.ShouldProcess($pn,'Update SIT DLP policy')){Set-DlpCompliancePolicy -Identity $p.Identity -Comment $comment -Mode $mode|Out-Null}
  $r=$rules|Where-Object Name -eq $rn|Select-Object -First 1;$rp=@{ContentContainsSensitiveInformation=$conditions;AccessScope=[string](V $pc 'AccessScope');BlockAccess=[bool](V $pc 'BlockAccess');BlockAccessScope=[string](V $pc 'BlockAccessScope')}
  if(-not$r){if($PSCmdlet.ShouldProcess($rn,'Create SIT DLP rule')){New-DlpComplianceRule -Name $rn -Policy $pn @rp|Out-Null}}elseif($PSCmdlet.ShouldProcess($rn,'Update SIT DLP rule')){Set-DlpComplianceRule -Identity $r.Identity @rp|Out-Null}
 }
}

$needsSpo=-not$SkipTenantSettings-or-not$SkipLabels
Write-Host "`nMicrosoft Purview Best Practice Deployment v$script:DeployVersion" -ForegroundColor Cyan
Write-Host "Config: $ConfigPath" -ForegroundColor Cyan
$cargs=@{TenantAdminUpn=$TenantAdminUpn};if($needsSpo){$cargs.NeedsSharePoint=$true};if($SharePointAdminUrl){$cargs.SharePointAdminUrl=$SharePointAdminUrl};if($DelegatedOrganization){$cargs.DelegatedOrganization=$DelegatedOrganization};if($AutoInstallModules){$cargs.AutoInstallModules=$true};if($NonInteractive){$cargs.NonInteractive=$true};if(-not$NoLicenseAutoDetect){$cargs.ConnectGraph=$true;$cargs.GraphScopes=@('Organization.Read.All','Directory.ReadWrite.All')}
& $connect @cargs|Out-Null

# Resolve the connected tenant identity for {TenantDomain} encryption.
$acceptedDomains = @(Get-AcceptedDomain -ErrorAction Stop)
$defaultDomain = $acceptedDomains | Where-Object { $_.Default } | Select-Object -First 1
$initialDomain = $acceptedDomains | Where-Object { $_.InitialDomain } | Select-Object -First 1
$tenantIdentity = [pscustomobject]@{
 DisplayName   = $null
 TenantId      = $null
 DefaultDomain = if($defaultDomain){[string]$defaultDomain.DomainName}else{$null}
 InitialDomain = if($initialDomain){[string]$initialDomain.DomainName}else{$null}
 AllDomains    = @($acceptedDomains | ForEach-Object {[string]$_.DomainName})
 Source        = 'Exchange Online Get-AcceptedDomain'
}
if([string]::IsNullOrWhiteSpace($tenantIdentity.DefaultDomain)-and[string]::IsNullOrWhiteSpace($tenantIdentity.InitialDomain)){throw 'Could not resolve the connected tenant domain required for {TenantDomain} encryption scope.'}
#--------

#-------

$summary=[ordered]@{}
try{
 if(-not$SkipTenantSettings){$a=@{Config=$config};if($SkipContainerLabels){$a.SkipContainerLabels=$true};if($EnablePremiumAudit){$a.EnablePremiumAudit=$true;$a.PremiumAuditMailbox=$PremiumAuditMailbox};&$tenant @a;$summary['Tenant settings']='OK'}else{$summary['Tenant settings']='Skipped'}
 if(-not$SkipLabels){$a=@{Config=$config;TenantIdentity=$tenantIdentity};if($AdoptExisting){$a.AdoptExisting=$true};if($SkipContainerLabels){$a.SkipContainerLabels=$true};&$labels @a;$summary['Sensitivity labels']='OK'}else{$summary['Sensitivity labels']='Skipped'}
 if(-not$SkipDLP){$a=@{Config=$config};if($AdoptExisting){$a.AdoptExisting=$true};if($BPOnly){$a.BPOnly=$true};&$dlp @a;$summary['Label DLP policies']='OK';Write-Host "`n--- [3b/5] ALSO SIT-based Exchange DLP ---" -ForegroundColor White;Invoke-AlsoSitDlp -Config $config -WhatIf:$WhatIfPreference;$summary['SIT DLP policies']='OK'}else{$summary['Label DLP policies']='Skipped';$summary['SIT DLP policies']='Skipped'}
 if($ApplyRetention){$a=@{Config=$config};if($AdoptExisting){$a.AdoptExisting=$true};&$ret @a;$summary['Retention']='OK'}else{$summary['Retention']='Skipped'}
 if(-not$SkipAIControls-and-not$BPOnly){$a=@{Config=$config};if($AdoptExisting){$a.AdoptExisting=$true};&$ai @a;$summary['AI governance']='OK'}else{$summary['AI governance']='Skipped'}
}finally{
 Write-Host "`nDeployment summary" -ForegroundColor Cyan;$summary.GetEnumerator()|ForEach-Object{Write-Host("  {0,-22} {1}"-f$_.Key,$_.Value)}
 if(-not$NoReport-and(Test-Path(Join-Path $modules 'Write-PurviewHtmlReport.ps1'))){try{. (Join-Path $modules 'Write-PurviewHtmlReport.ps1');if(-not$ReportPath){$ReportPath=Join-Path -Path (Get-Location).Path -ChildPath ("Deploy-PurviewBestPractice-Report-{0}.html"-f(Get-Date -Format 'yyyyMMdd-HHmmss'))};Write-PurviewHtmlReport -Summary $summary -OutputPath $ReportPath -StartTime $script:StartTime -EndTime(Get-Date)-RunId $script:RunId -Parameters $PSBoundParameters -ScriptVersion $script:DeployVersion|Out-Null}catch{Write-Warning $_}}
}
