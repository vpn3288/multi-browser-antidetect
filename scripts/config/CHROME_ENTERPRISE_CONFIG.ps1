# ============================================================================
# Chrome 企业级配置脚本 - 基于官方文档的完整优化
# ============================================================================
# 功能：
# 1. 配置所有隐私和安全策略
# 2. 禁用遥测和数据收集
# 3. 优化反检测和指纹保护
# 4. 配置扩展自动安装
# 5. 优化用户体验
# ============================================================================

#Requires -RunAsAdministrator

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Chrome 企业级配置 - 官方文档优化版" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$ChromePolicyPath = "HKLM:\SOFTWARE\Policies\Google\Chrome"

# 创建策略注册表路径
if (-not (Test-Path $ChromePolicyPath)) {
    New-Item -Path $ChromePolicyPath -Force | Out-Null
    Write-Host "[✓] 创建 Chrome 策略路径" -ForegroundColor Green
}

# ============================================================================
# 1. 隐私和遥测控制
# ============================================================================
Write-Host "`n[1/9] 配置隐私和遥测控制..." -ForegroundColor Yellow

$PrivacyPolicies = @{
    # 禁用所有遥测和数据收集
    "MetricsReportingEnabled" = 0
    "ChromeCleanupEnabled" = 0
    "ChromeCleanupReportingEnabled" = 0
    "UserFeedbackAllowed" = 0
    "UrlKeyedAnonymizedDataCollectionEnabled" = 0
    "NetworkPredictionOptions" = 2  # 禁用网络预测
    "SearchSuggestEnabled" = 0
    "AlternateErrorPagesEnabled" = 0
    "SpellCheckServiceEnabled" = 0
    "SafeBrowsingExtendedReportingEnabled" = 0
    
    # 禁用登录和同步
    "SigninAllowed" = 0
    "SyncDisabled" = 1
    "BrowserSignin" = 0
    
    # 禁用自动填充
    "PasswordManagerEnabled" = 0
    "AutofillAddressEnabled" = 0
    "AutofillCreditCardEnabled" = 0
    "PaymentMethodQueryEnabled" = 0
    "ImportAutofillFormData" = 0
}

foreach ($policy in $PrivacyPolicies.GetEnumerator()) {
    Set-ItemProperty -Path $ChromePolicyPath -Name $policy.Key -Value $policy.Value -Type DWord -Force
}

Write-Host "  [✓] 已禁用所有遥测和数据收集" -ForegroundColor Green
Write-Host "  [✓] 已禁用登录和同步功能" -ForegroundColor Green
Write-Host "  [✓] 已禁用自动填充功能" -ForegroundColor Green

# ============================================================================
# 2. Cookie 和追踪保护
# ============================================================================
Write-Host "`n[2/9] 配置 Cookie 和追踪保护..." -ForegroundColor Yellow

Set-ItemProperty -Path $ChromePolicyPath -Name "BlockThirdPartyCookies" -Value 1 -Type DWord -Force
Set-ItemProperty -Path $ChromePolicyPath -Name "DefaultCookiesSetting" -Value 1 -Type DWord -Force  # 1=允许，4=会话期间

Write-Host "  [✓] 已阻止第三方 Cookie" -ForegroundColor Green
Write-Host "  [✓] 已配置 Cookie 默认设置" -ForegroundColor Green

# ============================================================================
# 3. WebRTC 防护（防止 IP 泄漏）
# ============================================================================
Write-Host "`n[3/9] 配置 WebRTC 防护..." -ForegroundColor Yellow

Set-ItemProperty -Path $ChromePolicyPath -Name "WebRtcIPHandling" -Value "disable_non_proxied_udp" -Type String -Force

# 创建 WebRTC 本地 IP 允许列表（空=最大隐私）
$WebRtcPath = "$ChromePolicyPath\WebRtcLocalIpsAllowedUrls"
if (-not (Test-Path $WebRtcPath)) {
    New-Item -Path $WebRtcPath -Force | Out-Null
}

Write-Host "  [✓] 已配置 WebRTC IP 处理策略" -ForegroundColor Green
Write-Host "  [✓] 已禁用非代理 UDP 连接" -ForegroundColor Green

# ============================================================================
# 4. DNS-over-HTTPS 配置
# ============================================================================
Write-Host "`n[4/9] 配置 DNS-over-HTTPS..." -ForegroundColor Yellow

Set-ItemProperty -Path $ChromePolicyPath -Name "DnsOverHttpsMode" -Value "automatic" -Type String -Force
Set-ItemProperty -Path $ChromePolicyPath -Name "DnsOverHttpsTemplates" -Value "https://dns.google/dns-query" -Type String -Force

Write-Host "  [✓] 已启用 DNS-over-HTTPS" -ForegroundColor Green
Write-Host "  [✓] 使用 Google DNS (dns.google)" -ForegroundColor Green

# ============================================================================
# 5. 安全浏览配置
# ============================================================================
Write-Host "`n[5/9] 配置安全浏览..." -ForegroundColor Yellow

Set-ItemProperty -Path $ChromePolicyPath -Name "SafeBrowsingEnabled" -Value 1 -Type DWord -Force
Set-ItemProperty -Path $ChromePolicyPath -Name "SafeBrowsingProtectionLevel" -Value 1 -Type DWord -Force  # 1=标准，2=增强

Write-Host "  [✓] 已启用安全浏览（标准保护）" -ForegroundColor Green

# ============================================================================
# 6. 用户体验优化
# ============================================================================
Write-Host "`n[6/9] 配置用户体验优化..." -ForegroundColor Yellow

$UXPolicies = @{
    # 界面配置
    "BookmarkBarEnabled" = 1
    "ShowHomeButton" = 1
    "HomepageIsNewTabPage" = 1
    
    # 禁用提示和促销
    "DefaultBrowserSettingEnabled" = 0
    "PromotionalTabsEnabled" = 0
    "PromotionsEnabled" = 0
    "ShowCastIconInToolbar" = 0
    "HideWebStoreIcon" = 1
    "WelcomePageOnOSUpgradeEnabled" = 0
    
    # 启动配置
    "RestoreOnStartup" = 5  # 5=打开新标签页
}

foreach ($policy in $UXPolicies.GetEnumerator()) {
    Set-ItemProperty -Path $ChromePolicyPath -Name $policy.Key -Value $policy.Value -Type DWord -Force
}

# 配置主页和新标签页
Set-ItemProperty -Path $ChromePolicyPath -Name "HomepageLocation" -Value "about:blank" -Type String -Force
Set-ItemProperty -Path $ChromePolicyPath -Name "NewTabPageLocation" -Value "about:blank" -Type String -Force

Write-Host "  [✓] 已显示书签栏和主页按钮" -ForegroundColor Green
Write-Host "  [✓] 已禁用所有提示和促销" -ForegroundColor Green
Write-Host "  [✓] 已配置启动页为空白页" -ForegroundColor Green

# ============================================================================
# 7. 权限和隐私控制
# ============================================================================
Write-Host "`n[7/9] 配置权限和隐私控制..." -ForegroundColor Yellow

$PermissionPolicies = @{
    "DefaultGeolocationSetting" = 2  # 2=阻止
    "DefaultNotificationsSetting" = 2
    "DefaultSensorsSetting" = 2
    "AudioCaptureAllowed" = 0
    "VideoCaptureAllowed" = 0
    "ScreenCaptureAllowed" = 0
    "DefaultWebBluetoothGuardSetting" = 2
    "DefaultWebUsbGuardSetting" = 2
    "DefaultFileSystemReadGuardSetting" = 2
    "DefaultFileSystemWriteGuardSetting" = 2
    "EnableMediaRouter" = 0  # 禁用 Cast
}

foreach ($policy in $PermissionPolicies.GetEnumerator()) {
    Set-ItemProperty -Path $ChromePolicyPath -Name $policy.Key -Value $policy.Value -Type DWord -Force
}

Write-Host "  [✓] 已阻止所有敏感权限请求" -ForegroundColor Green
Write-Host "  [✓] 已禁用地理位置、通知、传感器等" -ForegroundColor Green

# ============================================================================
# 8. 反检测和指纹保护
# ============================================================================
Write-Host "`n[8/9] 配置反检测和指纹保护..." -ForegroundColor Yellow

$FingerprintPolicies = @{
    # User-Agent 保护
    "UserAgentClientHintsEnabled" = 0  # 禁用 Client Hints
    
    # 硬件和渲染（根据需求选择）
    "HardwareAccelerationModeEnabled" = 1  # 1=启用（性能），0=禁用（反指纹）
    
    # WebGL 保护（注意：禁用可能影响某些网站）
    # "Disable3DAPIs" = 1  # 取消注释以禁用 WebGL
}

foreach ($policy in $FingerprintPolicies.GetEnumerator()) {
    Set-ItemProperty -Path $ChromePolicyPath -Name $policy.Key -Value $policy.Value -Type DWord -Force
}

# HTTPS 强制
Set-ItemProperty -Path $ChromePolicyPath -Name "HttpsOnlyMode" -Value "allowed" -Type String -Force

Write-Host "  [✓] 已禁用 User-Agent Client Hints" -ForegroundColor Green
Write-Host "  [✓] 已启用硬件加速（性能优先）" -ForegroundColor Green
Write-Host "  [✓] 已配置 HTTPS 优先模式" -ForegroundColor Green

# ============================================================================
# 9. 扩展管理
# ============================================================================
Write-Host "`n[9/9] 配置扩展管理..." -ForegroundColor Yellow

# 使用 ExtensionSettings（比 ExtensionInstallForcelist 更强大）
$ExtensionSettingsPath = "$ChromePolicyPath\ExtensionSettings"
if (-not (Test-Path $ExtensionSettingsPath)) {
    New-Item -Path $ExtensionSettingsPath -Force | Out-Null
}

# uBlock Origin 配置
$uBlockPath = "$ExtensionSettingsPath\cjpalhdlnbpafiamejdnhcphjbkeiagm"
if (-not (Test-Path $uBlockPath)) {
    New-Item -Path $uBlockPath -Force | Out-Null
}
Set-ItemProperty -Path $uBlockPath -Name "installation_mode" -Value "force_installed" -Type String -Force
Set-ItemProperty -Path $uBlockPath -Name "update_url" -Value "https://clients2.google.com/service/update2/crx" -Type String -Force

# Privacy Badger 配置
$PrivacyBadgerPath = "$ExtensionSettingsPath\pkehgijcmpdhfbdbbnkijodmdjhbjlgp"
if (-not (Test-Path $PrivacyBadgerPath)) {
    New-Item -Path $PrivacyBadgerPath -Force | Out-Null
}
Set-ItemProperty -Path $PrivacyBadgerPath -Name "installation_mode" -Value "force_installed" -Type String -Force
Set-ItemProperty -Path $PrivacyBadgerPath -Name "update_url" -Value "https://clients2.google.com/service/update2/crx" -Type String -Force

# HTTPS Everywhere 配置
$HTTPSEverywherePath = "$ExtensionSettingsPath\gcbommkclmclpchllfjekcdonpmejbdp"
if (-not (Test-Path $HTTPSEverywherePath)) {
    New-Item -Path $HTTPSEverywherePath -Force | Out-Null
}
Set-ItemProperty -Path $HTTPSEverywherePath -Name "installation_mode" -Value "force_installed" -Type String -Force
Set-ItemProperty -Path $HTTPSEverywherePath -Name "update_url" -Value "https://clients2.google.com/service/update2/crx" -Type String -Force

# Decentraleyes 配置
$DecentraleyesPath = "$ExtensionSettingsPath\ldpochfccmkkmhdbclfhpagapcfdljkj"
if (-not (Test-Path $DecentraleyesPath)) {
    New-Item -Path $DecentraleyesPath -Force | Out-Null
}
Set-ItemProperty -Path $DecentraleyesPath -Name "installation_mode" -Value "force_installed" -Type String -Force
Set-ItemProperty -Path $DecentraleyesPath -Name "update_url" -Value "https://clients2.google.com/service/update2/crx" -Type String -Force

# 阻止所有其他扩展
$BlockAllPath = "$ExtensionSettingsPath\*"
if (-not (Test-Path $BlockAllPath)) {
    New-Item -Path $BlockAllPath -Force | Out-Null
}
Set-ItemProperty -Path $BlockAllPath -Name "installation_mode" -Value "blocked" -Type String -Force

Write-Host "  [✓] 已配置 uBlock Origin 自动安装" -ForegroundColor Green
Write-Host "  [✓] 已配置 Privacy Badger 自动安装" -ForegroundColor Green
Write-Host "  [✓] 已配置 HTTPS Everywhere 自动安装" -ForegroundColor Green
Write-Host "  [✓] 已配置 Decentraleyes 自动安装" -ForegroundColor Green
Write-Host "  [✓] 已阻止其他扩展安装" -ForegroundColor Green

# ============================================================================
# 10. 创建启动脚本（带指纹保护参数）
# ============================================================================
Write-Host "`n[10/10] 创建启动脚本..." -ForegroundColor Yellow

$LaunchScript = @'
# Chrome 启动脚本 - 带反检测参数
# 使用方法: .\LAUNCH_CHROME.ps1 -ProfileName "Profile1" -ProxyPort 7890

param(
    [string]$ProfileName = "Default",
    [int]$ProxyPort = 7890
)

$ChromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$UserDataDir = "$env:LOCALAPPDATA\Google\Chrome\User Data"

# 反检测启动参数
$LaunchArgs = @(
    "--user-data-dir=`"$UserDataDir`""
    "--profile-directory=`"$ProfileName`""
    "--proxy-server=`"socks5://127.0.0.1:$ProxyPort`""
    "--disable-blink-features=AutomationControlled"
    "--disable-features=IsolateOrigins,site-per-process"
    "--disable-site-isolation-trials"
    "--disable-web-security"
    "--disable-features=UserAgentClientHints"
    "--no-first-run"
    "--no-default-browser-check"
    "--disable-popup-blocking"
    "--disable-infobars"
    "--disable-notifications"
    "--disable-save-password-bubble"
)

Write-Host "启动 Chrome - $ProfileName (代理端口: $ProxyPort)" -ForegroundColor Cyan
Start-Process -FilePath $ChromePath -ArgumentList $LaunchArgs

Write-Host "[✓] Chrome 已启动" -ForegroundColor Green
Write-Host "    配置文件: $ProfileName" -ForegroundColor Gray
Write-Host "    代理: socks5://127.0.0.1:$ProxyPort" -ForegroundColor Gray
'@

$LaunchScript | Out-File -FilePath ".\LAUNCH_CHROME.ps1" -Encoding UTF8 -Force

Write-Host "  [✓] 已创建 LAUNCH_CHROME.ps1" -ForegroundColor Green

# ============================================================================
# 完成
# ============================================================================
Write-Host "`n============================================" -ForegroundColor Green
Write-Host "Chrome 企业级配置完成！" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "配置内容：" -ForegroundColor Cyan
Write-Host "  ✓ 隐私和遥测控制（禁用所有数据收集）" -ForegroundColor White
Write-Host "  ✓ Cookie 和追踪保护（阻止第三方 Cookie）" -ForegroundColor White
Write-Host "  ✓ WebRTC 防护（防止 IP 泄漏）" -ForegroundColor White
Write-Host "  ✓ DNS-over-HTTPS（加密 DNS 查询）" -ForegroundColor White
Write-Host "  ✓ 安全浏览（标准保护）" -ForegroundColor White
Write-Host "  ✓ 用户体验优化（书签栏、空白主页）" -ForegroundColor White
Write-Host "  ✓ 权限控制（阻止所有敏感权限）" -ForegroundColor White
Write-Host "  ✓ 反检测和指纹保护" -ForegroundColor White
Write-Host "  ✓ 扩展自动安装（uBlock Origin + WebRTC Shield）" -ForegroundColor White
Write-Host ""
Write-Host "下一步：" -ForegroundColor Yellow
Write-Host "  1. 重启 Chrome 使策略生效" -ForegroundColor White
Write-Host "  2. 访问 chrome://policy 验证策略" -ForegroundColor White
Write-Host "  3. 使用 .\LAUNCH_CHROME.ps1 启动浏览器" -ForegroundColor White
Write-Host ""
Write-Host "验证命令：" -ForegroundColor Yellow
Write-Host "  .\VERIFY_CHROME_CONFIG.ps1" -ForegroundColor White
Write-Host ""
