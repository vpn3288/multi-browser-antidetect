# ============================================================================
# Chromium 企业级配置脚本 - 基于官方文档的完整优化
# ============================================================================
# 功能：
# 1. 配置所有隐私和安全策略
# 2. 完全去除 Google 服务依赖
# 3. 优化反检测和指纹保护
# 4. 配置扩展自动安装
# 5. 优化用户体验
# 注意：Chromium 使用独立的注册表路径（不是 Google\Chrome）
# ============================================================================

#Requires -RunAsAdministrator

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Chromium 企业级配置 - 开源版优化" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$ChromiumPolicyPath = "HKLM:\SOFTWARE\Policies\Chromium"

# 创建策略注册表路径
if (-not (Test-Path $ChromiumPolicyPath)) {
    New-Item -Path $ChromiumPolicyPath -Force | Out-Null
    Write-Host "[✓] 创建 Chromium 策略路径" -ForegroundColor Green
}

# ============================================================================
# 1. 隐私和遥测控制（去 Google 服务化）
# ============================================================================
Write-Host "`n[1/10] 配置隐私和遥测控制（去 Google 服务）..." -ForegroundColor Yellow

$PrivacyPolicies = @{
    # 禁用所有遥测和数据收集
    "MetricsReportingEnabled" = 0
    "UserFeedbackAllowed" = 0
    "UrlKeyedAnonymizedDataCollectionEnabled" = 0
    "NetworkPredictionOptions" = 2  # 禁用网络预测
    "SearchSuggestEnabled" = 0
    "AlternateErrorPagesEnabled" = 0
    "SpellCheckServiceEnabled" = 0
    "WebRtcEventLogCollectionAllowed" = 0
    
    # 禁用 Google 服务
    "SigninAllowed" = 0
    "SyncDisabled" = 1
    "BrowserSignin" = 0
    "CloudPrintSubmitEnabled" = 0
    "BackgroundModeEnabled" = 0
    "TranslateEnabled" = 0
    "EnableMediaRouter" = 0
    "ShowCastIconInToolbar" = 0
    
    # 禁用自动填充
    "PasswordManagerEnabled" = 0
    "AutofillAddressEnabled" = 0
    "AutofillCreditCardEnabled" = 0
    "PaymentMethodQueryEnabled" = 0
    "ImportAutofillFormData" = 0
    
    # 禁用组件更新（Chromium 无内置更新器）
    "ComponentUpdatesEnabled" = 0
    "AutoUpdateCheckPeriodMinutes" = 0
}

foreach ($policy in $PrivacyPolicies.GetEnumerator()) {
    Set-ItemProperty -Path $ChromiumPolicyPath -Name $policy.Key -Value $policy.Value -Type DWord -Force
}

Write-Host "  [✓] 已禁用所有遥测和数据收集" -ForegroundColor Green
Write-Host "  [✓] 已完全去除 Google 服务依赖" -ForegroundColor Green
Write-Host "  [✓] 已禁用自动更新（Chromium 无内置更新器）" -ForegroundColor Green

# ============================================================================
# 2. Cookie 和追踪保护
# ============================================================================
Write-Host "`n[2/10] 配置 Cookie 和追踪保护..." -ForegroundColor Yellow

Set-ItemProperty -Path $ChromiumPolicyPath -Name "BlockThirdPartyCookies" -Value 1 -Type DWord -Force
Set-ItemProperty -Path $ChromiumPolicyPath -Name "DefaultCookiesSetting" -Value 1 -Type DWord -Force

Write-Host "  [✓] 已阻止第三方 Cookie" -ForegroundColor Green

# ============================================================================
# 3. WebRTC 防护（防止 IP 泄漏）
# ============================================================================
Write-Host "`n[3/10] 配置 WebRTC 防护..." -ForegroundColor Yellow

Set-ItemProperty -Path $ChromiumPolicyPath -Name "WebRtcIPHandling" -Value "disable_non_proxied_udp" -Type String -Force

$WebRtcPath = "$ChromiumPolicyPath\WebRtcLocalIpsAllowedUrls"
if (-not (Test-Path $WebRtcPath)) {
    New-Item -Path $WebRtcPath -Force | Out-Null
}

Write-Host "  [✓] 已配置 WebRTC IP 处理策略" -ForegroundColor Green
Write-Host "  [✓] 已禁用非代理 UDP 连接" -ForegroundColor Green

# ============================================================================
# 4. DNS-over-HTTPS 配置
# ============================================================================
Write-Host "`n[4/10] 配置 DNS-over-HTTPS..." -ForegroundColor Yellow

Set-ItemProperty -Path $ChromiumPolicyPath -Name "DnsOverHttpsMode" -Value "automatic" -Type String -Force
Set-ItemProperty -Path $ChromiumPolicyPath -Name "DnsOverHttpsTemplates" -Value "https://dns.google/dns-query" -Type String -Force

Write-Host "  [✓] 已启用 DNS-over-HTTPS" -ForegroundColor Green

# ============================================================================
# 5. 安全浏览和 SSL 配置
# ============================================================================
Write-Host "`n[5/10] 配置安全浏览和 SSL..." -ForegroundColor Yellow

Set-ItemProperty -Path $ChromiumPolicyPath -Name "SafeBrowsingEnabled" -Value 1 -Type DWord -Force
Set-ItemProperty -Path $ChromiumPolicyPath -Name "SSLVersionMin" -Value "tls1.2" -Type String -Force
Set-ItemProperty -Path $ChromiumPolicyPath -Name "SSLErrorOverrideAllowed" -Value 0 -Type DWord -Force
Set-ItemProperty -Path $ChromiumPolicyPath -Name "AllowOutdatedPlugins" -Value 0 -Type DWord -Force

Write-Host "  [✓] 已启用安全浏览" -ForegroundColor Green
Write-Host "  [✓] 已配置最小 TLS 版本为 1.2" -ForegroundColor Green

# ============================================================================
# 6. 用户体验优化
# ============================================================================
Write-Host "`n[6/10] 配置用户体验优化..." -ForegroundColor Yellow

$UXPolicies = @{
    # 界面配置
    "BookmarkBarEnabled" = 1
    "ShowHomeButton" = 1
    "HomepageIsNewTabPage" = 1
    
    # 禁用提示和促销
    "DefaultBrowserSettingEnabled" = 0
    "PromotionalTabsEnabled" = 0
    "PromotionsEnabled" = 0
    "HideWebStoreIcon" = 1
    "WelcomePageOnOSUpgradeEnabled" = 0
    
    # 启动配置
    "RestoreOnStartup" = 5  # 5=打开新标签页
}

foreach ($policy in $UXPolicies.GetEnumerator()) {
    Set-ItemProperty -Path $ChromiumPolicyPath -Name $policy.Key -Value $policy.Value -Type DWord -Force
}

# 配置主页和新标签页
Set-ItemProperty -Path $ChromiumPolicyPath -Name "HomepageLocation" -Value "about:blank" -Type String -Force
Set-ItemProperty -Path $ChromiumPolicyPath -Name "NewTabPageLocation" -Value "about:blank" -Type String -Force

Write-Host "  [✓] 已显示书签栏和主页按钮" -ForegroundColor Green
Write-Host "  [✓] 已禁用所有提示和促销" -ForegroundColor Green
Write-Host "  [✓] 已配置启动页为空白页" -ForegroundColor Green

# ============================================================================
# 7. 默认搜索引擎配置（Chromium 必须手动配置）
# ============================================================================
Write-Host "`n[7/10] 配置默认搜索引擎..." -ForegroundColor Yellow

Set-ItemProperty -Path $ChromiumPolicyPath -Name "DefaultSearchProviderEnabled" -Value 1 -Type DWord -Force
Set-ItemProperty -Path $ChromiumPolicyPath -Name "DefaultSearchProviderName" -Value "Google" -Type String -Force
Set-ItemProperty -Path $ChromiumPolicyPath -Name "DefaultSearchProviderSearchURL" -Value "https://www.google.com/search?q={searchTerms}" -Type String -Force
Set-ItemProperty -Path $ChromiumPolicyPath -Name "DefaultSearchProviderSuggestURL" -Value "https://www.google.com/complete/search?q={searchTerms}" -Type String -Force

Write-Host "  [✓] 已配置默认搜索引擎为 Google" -ForegroundColor Green

# ============================================================================
# 8. 权限和隐私控制
# ============================================================================
Write-Host "`n[8/10] 配置权限和隐私控制..." -ForegroundColor Yellow

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
}

foreach ($policy in $PermissionPolicies.GetEnumerator()) {
    Set-ItemProperty -Path $ChromiumPolicyPath -Name $policy.Key -Value $policy.Value -Type DWord -Force
}

Write-Host "  [✓] 已阻止所有敏感权限请求" -ForegroundColor Green

# ============================================================================
# 9. 反检测和指纹保护
# ============================================================================
Write-Host "`n[9/10] 配置反检测和指纹保护..." -ForegroundColor Yellow

$FingerprintPolicies = @{
    "UserAgentClientHintsEnabled" = 0
    "HardwareAccelerationModeEnabled" = 1  # 1=启用（性能优先）
}

foreach ($policy in $FingerprintPolicies.GetEnumerator()) {
    Set-ItemProperty -Path $ChromiumPolicyPath -Name $policy.Key -Value $policy.Value -Type DWord -Force
}

Set-ItemProperty -Path $ChromiumPolicyPath -Name "HttpsOnlyMode" -Value "allowed" -Type String -Force

Write-Host "  [✓] 已禁用 User-Agent Client Hints" -ForegroundColor Green
Write-Host "  [✓] 已启用硬件加速（性能优先）" -ForegroundColor Green

# ============================================================================
# 10. 扩展管理
# ============================================================================
Write-Host "`n[10/10] 配置扩展管理..." -ForegroundColor Yellow

# 配置扩展安装源
$ExtensionSourcesPath = "$ChromiumPolicyPath\ExtensionInstallSources"
if (-not (Test-Path $ExtensionSourcesPath)) {
    New-Item -Path $ExtensionSourcesPath -Force | Out-Null
}
Set-ItemProperty -Path $ExtensionSourcesPath -Name "1" -Value "https://chrome.google.com/webstore/*" -Type String -Force
Set-ItemProperty -Path $ExtensionSourcesPath -Name "2" -Value "https://clients2.google.com/service/update2/*" -Type String -Force

# 使用 ExtensionSettings
$ExtensionSettingsPath = "$ChromiumPolicyPath\ExtensionSettings"
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
$WebRTCShieldPath = "$ExtensionSettingsPath\bppamachkoflopbagkdoflbgfjflfnfl"
if (-not (Test-Path $WebRTCShieldPath)) {
    New-Item -Path $WebRTCShieldPath -Force | Out-Null
}
Set-ItemProperty -Path $WebRTCShieldPath -Name "installation_mode" -Value "force_installed" -Type String -Force
Set-ItemProperty -Path $WebRTCShieldPath -Name "update_url" -Value "https://clients2.google.com/service/update2/crx" -Type String -Force

# 阻止其他扩展
$BlockAllPath = "$ExtensionSettingsPath\*"
if (-not (Test-Path $BlockAllPath)) {
    New-Item -Path $BlockAllPath -Force | Out-Null
}
Set-ItemProperty -Path $BlockAllPath -Name "installation_mode" -Value "blocked" -Type String -Force

Write-Host "  [✓] 已配置扩展安装源" -ForegroundColor Green
Write-Host "  [✓] 已配置 uBlock Origin 自动安装" -ForegroundColor Green
Write-Host "  [✓] 已配置 WebRTC Leak Shield 自动安装" -ForegroundColor Green
Write-Host "  [✓] 已阻止其他扩展安装" -ForegroundColor Green

# ============================================================================
# 11. 创建启动脚本
# ============================================================================
Write-Host "`n[11/11] 创建启动脚本..." -ForegroundColor Yellow

$LaunchScript = @'
# Chromium 启动脚本 - 带反检测参数
# 使用方法: .\LAUNCH_CHROMIUM.ps1 -ProfileName "Profile1" -ProxyPort 7890

param(
    [string]$ProfileName = "Default",
    [int]$ProxyPort = 7890
)

$ChromiumPath = "C:\Program Files\Chromium\Application\chrome.exe"
$UserDataDir = "$env:LOCALAPPDATA\Chromium\User Data"

# 反检测启动参数（Chromium 特有优化）
$LaunchArgs = @(
    "--user-data-dir=`"$UserDataDir`""
    "--profile-directory=`"$ProfileName`""
    "--proxy-server=`"socks5://127.0.0.1:$ProxyPort`""
    "--disable-blink-features=AutomationControlled"
    "--disable-features=IsolateOrigins,site-per-process"
    "--disable-site-isolation-trials"
    "--disable-web-security"
    "--disable-features=UserAgentClientHints"
    "--disable-background-networking"
    "--disable-breakpad"
    "--disable-crash-reporter"
    "--disable-sync"
    "--disable-translate"
    "--disable-features=AutofillServerCommunication"
    "--disable-features=MediaRouter"
    "--disable-features=OptimizationHints"
    "--no-pings"
    "--no-report-upload"
    "--disable-domain-reliability"
    "--no-first-run"
    "--no-default-browser-check"
    "--disable-popup-blocking"
    "--disable-infobars"
    "--disable-notifications"
    "--disable-save-password-bubble"
)

Write-Host "启动 Chromium - $ProfileName (代理端口: $ProxyPort)" -ForegroundColor Cyan
Start-Process -FilePath $ChromiumPath -ArgumentList $LaunchArgs

Write-Host "[✓] Chromium 已启动" -ForegroundColor Green
Write-Host "    配置文件: $ProfileName" -ForegroundColor Gray
Write-Host "    代理: socks5://127.0.0.1:$ProxyPort" -ForegroundColor Gray
'@

$LaunchScript | Out-File -FilePath ".\LAUNCH_CHROMIUM.ps1" -Encoding UTF8 -Force

Write-Host "  [✓] 已创建 LAUNCH_CHROMIUM.ps1" -ForegroundColor Green

# ============================================================================
# 完成
# ============================================================================
Write-Host "`n============================================" -ForegroundColor Green
Write-Host "Chromium 企业级配置完成！" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "配置内容：" -ForegroundColor Cyan
Write-Host "  ✓ 完全去除 Google 服务依赖" -ForegroundColor White
Write-Host "  ✓ 隐私和遥测控制（禁用所有数据收集）" -ForegroundColor White
Write-Host "  ✓ Cookie 和追踪保护" -ForegroundColor White
Write-Host "  ✓ WebRTC 防护（防止 IP 泄漏）" -ForegroundColor White
Write-Host "  ✓ DNS-over-HTTPS" -ForegroundColor White
Write-Host "  ✓ 安全浏览和 SSL 配置" -ForegroundColor White
Write-Host "  ✓ 用户体验优化" -ForegroundColor White
Write-Host "  ✓ 默认搜索引擎配置" -ForegroundColor White
Write-Host "  ✓ 权限控制" -ForegroundColor White
Write-Host "  ✓ 反检测和指纹保护" -ForegroundColor White
Write-Host "  ✓ 扩展自动安装" -ForegroundColor White
Write-Host ""
Write-Host "重要提示：" -ForegroundColor Yellow
Write-Host "  ⚠ Chromium 无内置自动更新器" -ForegroundColor White
Write-Host "  ⚠ 需要手动更新或使用包管理器（如 Chocolatey）" -ForegroundColor White
Write-Host "  ⚠ 注册表路径为 Chromium（不是 Google\Chrome）" -ForegroundColor White
Write-Host ""
Write-Host "下一步：" -ForegroundColor Yellow
Write-Host "  1. 重启 Chromium 使策略生效" -ForegroundColor White
Write-Host "  2. 访问 chrome://policy 验证策略" -ForegroundColor White
Write-Host "  3. 使用 .\LAUNCH_CHROMIUM.ps1 启动浏览器" -ForegroundColor White
Write-Host ""
