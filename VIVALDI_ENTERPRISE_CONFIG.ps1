# ============================================================================
# Vivaldi 企业级配置脚本 - 基于 Chromium 策略优化
# ============================================================================
# Vivaldi 基于 Chromium，支持所有 Chrome 企业策略
# 注册表路径：HKLM:\SOFTWARE\Policies\Vivaldi
# ============================================================================

#Requires -RunAsAdministrator

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Vivaldi 企业级配置" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$VivaldiPolicyPath = "HKLM:\SOFTWARE\Policies\Vivaldi"

if (-not (Test-Path $VivaldiPolicyPath)) {
    New-Item -Path $VivaldiPolicyPath -Force | Out-Null
}

# 应用与 Chrome 相同的策略
$Policies = @{
    "MetricsReportingEnabled" = 0
    "BlockThirdPartyCookies" = 1
    "WebRtcIPHandling" = "disable_non_proxied_udp"
    "DnsOverHttpsMode" = "automatic"
    "SafeBrowsingEnabled" = 1
    "BookmarkBarEnabled" = 1
    "DefaultBrowserSettingEnabled" = 0
    "PasswordManagerEnabled" = 0
    "AutofillAddressEnabled" = 0
    "AutofillCreditCardEnabled" = 0
    "DefaultGeolocationSetting" = 2
    "DefaultNotificationsSetting" = 2
    "UserAgentClientHintsEnabled" = 0
    "HardwareAccelerationModeEnabled" = 1
}

foreach ($policy in $Policies.GetEnumerator()) {
    if ($policy.Value -is [string]) {
        Set-ItemProperty -Path $VivaldiPolicyPath -Name $policy.Key -Value $policy.Value -Type String -Force
    } else {
        Set-ItemProperty -Path $VivaldiPolicyPath -Name $policy.Key -Value $policy.Value -Type DWord -Force
    }
}

Set-ItemProperty -Path $VivaldiPolicyPath -Name "DnsOverHttpsTemplates" -Value "https://dns.google/dns-query" -Type String -Force
Set-ItemProperty -Path $VivaldiPolicyPath -Name "HomepageLocation" -Value "about:blank" -Type String -Force

# 扩展配置
$ExtensionSettingsPath = "$VivaldiPolicyPath\ExtensionSettings"
if (-not (Test-Path $ExtensionSettingsPath)) {
    New-Item -Path $ExtensionSettingsPath -Force | Out-Null
}

# uBlock Origin
$uBlockPath = "$ExtensionSettingsPath\cjpalhdlnbpafiamejdnhcphjbkeiagm"
if (-not (Test-Path $uBlockPath)) {
    New-Item -Path $uBlockPath -Force | Out-Null
}
Set-ItemProperty -Path $uBlockPath -Name "installation_mode" -Value "force_installed" -Type String -Force
Set-ItemProperty -Path $uBlockPath -Name "update_url" -Value "https://clients2.google.com/service/update2/crx" -Type String -Force

# WebRTC Leak Shield
$WebRTCPath = "$ExtensionSettingsPath\bppamachkoflopbagkdoflbgfjflfnfl"
if (-not (Test-Path $WebRTCPath)) {
    New-Item -Path $WebRTCPath -Force | Out-Null
}
Set-ItemProperty -Path $WebRTCPath -Name "installation_mode" -Value "force_installed" -Type String -Force
Set-ItemProperty -Path $WebRTCPath -Name "update_url" -Value "https://clients2.google.com/service/update2/crx" -Type String -Force

# Privacy Badger
$PrivacyBadgerPath = "$ExtensionSettingsPath\pkehgijcmpdhfbdbbnkijodmdjhbjlgp"
if (-not (Test-Path $PrivacyBadgerPath)) {
    New-Item -Path $PrivacyBadgerPath -Force | Out-Null
}
Set-ItemProperty -Path $PrivacyBadgerPath -Name "installation_mode" -Value "force_installed" -Type String -Force
Set-ItemProperty -Path $PrivacyBadgerPath -Name "update_url" -Value "https://clients2.google.com/service/update2/crx" -Type String -Force

# HTTPS Everywhere
$HTTPSPath = "$ExtensionSettingsPath\gcbommkclmclpchllfjekcdonpmejbdp"
if (-not (Test-Path $HTTPSPath)) {
    New-Item -Path $HTTPSPath -Force | Out-Null
}
Set-ItemProperty -Path $HTTPSPath -Name "installation_mode" -Value "force_installed" -Type String -Force
Set-ItemProperty -Path $HTTPSPath -Name "update_url" -Value "https://clients2.google.com/service/update2/crx" -Type String -Force

# 阻止其他扩展
$BlockAllPath = "$ExtensionSettingsPath\*"
if (-not (Test-Path $BlockAllPath)) {
    New-Item -Path $BlockAllPath -Force | Out-Null
}
Set-ItemProperty -Path $BlockAllPath -Name "installation_mode" -Value "blocked" -Type String -Force

# 创建启动脚本
$LaunchScript = @'
param([string]$ProfileName = "Default", [int]$ProxyPort = 7890)
$VivaldiPath = "C:\Program Files\Vivaldi\Application\vivaldi.exe"
$UserDataDir = "$env:LOCALAPPDATA\Vivaldi\User Data"
$LaunchArgs = @(
    "--user-data-dir=`"$UserDataDir`""
    "--profile-directory=`"$ProfileName`""
    "--proxy-server=`"socks5://127.0.0.1:$ProxyPort`""
    "--disable-blink-features=AutomationControlled"
    "--no-first-run"
)
Write-Host "启动 Vivaldi - $ProfileName (代理: $ProxyPort)" -ForegroundColor Cyan
Start-Process -FilePath $VivaldiPath -ArgumentList $LaunchArgs
Write-Host "[✓] Vivaldi 已启动" -ForegroundColor Green
'@
$LaunchScript | Out-File -FilePath ".\LAUNCH_VIVALDI.ps1" -Encoding UTF8 -Force

Write-Host "`n[✓] Vivaldi 配置完成！" -ForegroundColor Green
Write-Host "  ✓ 隐私和安全策略" -ForegroundColor White
Write-Host "  ✓ 4个扩展自动安装" -ForegroundColor White
Write-Host "  ✓ WebRTC 防护" -ForegroundColor White
Write-Host "  ✓ DNS-over-HTTPS" -ForegroundColor White
Write-Host ""
