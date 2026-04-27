# ============================================================================
# Microsoft Edge 企业级配置脚本 - 基于官方文档的完整优化
# ============================================================================
# 功能：
# 1. 禁用所有 Microsoft 服务集成（Bing, MSN, Rewards, Shopping）
# 2. 配置隐私和安全策略
# 3. 优化性能（睡眠标签页、效率模式、启动加速）
# 4. 配置扩展自动安装（支持 Edge Add-ons 和 Chrome Web Store）
# 5. 反检测和指纹保护
# ============================================================================

#Requires -RunAsAdministrator

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Microsoft Edge 企业级配置 - 官方文档优化版" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$EdgePolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"

# 创建策略注册表路径
if (-not (Test-Path $EdgePolicyPath)) {
    New-Item -Path $EdgePolicyPath -Force | Out-Null
    Write-Host "[✓] 创建 Edge 策略路径" -ForegroundColor Green
}

# ============================================================================
# 1. 隐私和遥测控制
# ============================================================================
Write-Host "`n[1/11] 配置隐私和遥测控制..." -ForegroundColor Yellow

$PrivacyPolicies = @{
    # 禁用所有遥测和数据收集
    "PersonalizationReportingEnabled" = 0
    "DiagnosticData" = 0
    "UserFeedbackAllowed" = 0
    "MetricsReportingEnabled" = 0
    "SendSiteInfoToImproveServices" = 0
    
    # Do Not Track
    "ConfigureDoNotTrack" = 1
    
    # 追踪防护（2=平衡，3=严格）
    "TrackingPrevention" = 2
    
    # Cookie 控制
    "BlockThirdPartyCookies" = 1
    
    # 禁用预加载
    "NetworkPredictionOptions" = 2
    "PreloadingEnabled" = 0
    
    # 搜索建议
    "SearchSuggestEnabled" = 0
    
    # 禁用同步
    "SyncDisabled" = 1
    
    # 禁用自动填充
    "AutofillAddressEnabled" = 0
    "AutofillCreditCardEnabled" = 0
    "PasswordManagerEnabled" = 0
}

foreach ($policy in $PrivacyPolicies.GetEnumerator()) {
    Set-ItemProperty -Path $EdgePolicyPath -Name $policy.Key -Value $policy.Value -Type DWord -Force
}

Write-Host "  [✓] 已禁用所有遥测和数据收集" -ForegroundColor Green
Write-Host "  [✓] 已启用追踪防护（平衡模式）" -ForegroundColor Green
Write-Host "  [✓] 已阻止第三方 Cookie" -ForegroundColor Green

# ============================================================================
# 2. 禁用 Microsoft 服务集成
# ============================================================================
Write-Host "`n[2/11] 禁用 Microsoft 服务集成..." -ForegroundColor Yellow

$MSServicesPolicies = @{
    # 购物和钱包
    "EdgeShoppingAssistantEnabled" = 0
    "EdgeWalletCheckoutEnabled" = 0
    
    # 生产力功能
    "EdgeCollectionsEnabled" = 0
    "EdgeWorkspacesEnabled" = 0
    "EdgeFollowEnabled" = 0
    
    # 侧边栏和增强功能
    "HubsSidebarEnabled" = 0
    "EdgeEnhanceImagesEnabled" = 0
    
    # Bing 集成
    "AddressBarMicrosoftSearchInBingProviderEnabled" = 0
    "BingAdsSuppression" = 1
    
    # Microsoft Rewards
    "ShowMicrosoftRewards" = 0
}

foreach ($policy in $MSServicesPolicies.GetEnumerator()) {
    Set-ItemProperty -Path $EdgePolicyPath -Name $policy.Key -Value $policy.Value -Type DWord -Force
}

Write-Host "  [✓] 已禁用购物助手和钱包" -ForegroundColor Green
Write-Host "  [✓] 已禁用集锦、工作区、关注功能" -ForegroundColor Green
Write-Host "  [✓] 已禁用侧边栏和图像增强" -ForegroundColor Green
Write-Host "  [✓] 已禁用 Bing 集成和广告" -ForegroundColor Green
Write-Host "  [✓] 已隐藏 Microsoft Rewards" -ForegroundColor Green

# ============================================================================
# 3. 新标签页配置（禁用新闻和内容推荐）
# ============================================================================
Write-Host "`n[3/11] 配置新标签页..." -ForegroundColor Yellow

$NewTabPolicies = @{
    "NewTabPageContentEnabled" = 0
    "NewTabPageQuickLinksEnabled" = 0
    "NewTabPageHideDefaultTopSites" = 1
    "NewTabPageAllowedBackgroundTypes" = 1  # 仅纯色背景
    "ShowRecommendationsEnabled" = 0
}

foreach ($policy in $NewTabPolicies.GetEnumerator()) {
    Set-ItemProperty -Path $EdgePolicyPath -Name $policy.Key -Value $policy.Value -Type DWord -Force
}

Write-Host "  [✓] 已禁用新标签页内容和推荐" -ForegroundColor Green
Write-Host "  [✓] 已隐藏快速链接和热门网站" -ForegroundColor Green

# ============================================================================
# 4. SmartScreen 和安全配置
# ============================================================================
Write-Host "`n[4/11] 配置 SmartScreen 和安全..." -ForegroundColor Yellow

$SecurityPolicies = @{
    # SmartScreen
    "SmartScreenEnabled" = 1
    "SmartScreenPuaEnabled" = 1
    "SmartScreenForTrustedDownloadsEnabled" = 0
    "PreventSmartScreenPromptOverride" = 1
    "PreventSmartScreenPromptOverrideForFiles" = 1
    
    # SSL 和安全
    "SSLErrorOverrideAllowed" = 0
    "SitePerProcess" = 1
}

foreach ($policy in $SecurityPolicies.GetEnumerator()) {
    Set-ItemProperty -Path $EdgePolicyPath -Name $policy.Key -Value $policy.Value -Type DWord -Force
}

# SSL 版本
Set-ItemProperty -Path $EdgePolicyPath -Name "SSLVersionMin" -Value "tls1.2" -Type String -Force

Write-Host "  [✓] 已启用 SmartScreen 和 PUA 保护" -ForegroundColor Green
Write-Host "  [✓] 已配置 SSL/TLS 安全策略" -ForegroundColor Green

# ============================================================================
# 5. WebRTC 防护
# ============================================================================
Write-Host "`n[5/11] 配置 WebRTC 防护..." -ForegroundColor Yellow

Set-ItemProperty -Path $EdgePolicyPath -Name "WebRtcIPHandling" -Value "disable_non_proxied_udp" -Type String -Force

$WebRtcPath = "$EdgePolicyPath\WebRtcLocalIpsAllowedUrls"
if (-not (Test-Path $WebRtcPath)) {
    New-Item -Path $WebRtcPath -Force | Out-Null
}

Write-Host "  [✓] 已配置 WebRTC IP 处理策略" -ForegroundColor Green

# ============================================================================
# 6. DNS-over-HTTPS 配置
# ============================================================================
Write-Host "`n[6/11] 配置 DNS-over-HTTPS..." -ForegroundColor Yellow

Set-ItemProperty -Path $EdgePolicyPath -Name "DnsOverHttpsMode" -Value "automatic" -Type String -Force
Set-ItemProperty -Path $EdgePolicyPath -Name "DnsOverHttpsTemplates" -Value "https://dns.google/dns-query" -Type String -Force

Write-Host "  [✓] 已启用 DNS-over-HTTPS" -ForegroundColor Green

# ============================================================================
# 7. 性能优化（Edge 特有）
# ============================================================================
Write-Host "`n[7/11] 配置性能优化..." -ForegroundColor Yellow

$PerformancePolicies = @{
    # 启动加速
    "StartupBoostEnabled" = 1
    
    # 睡眠标签页
    "SleepingTabsEnabled" = 1
    "SleepingTabsTimeout" = 7200000  # 2小时（毫秒）
    
    # 效率模式
    "EfficiencyModeEnabled" = 1
    "EfficiencyModeOnPowerEnabled" = 1
    
    # 硬件加速
    "HardwareAccelerationModeEnabled" = 1
    
    # 后台模式
    "BackgroundModeEnabled" = 0
    
    # 标签页冻结
    "TabFreezingEnabled" = 1
}

foreach ($policy in $PerformancePolicies.GetEnumerator()) {
    Set-ItemProperty -Path $EdgePolicyPath -Name $policy.Key -Value $policy.Value -Type DWord -Force
}

# 配置睡眠标签页排除列表
$SleepingTabsBlockedPath = "$EdgePolicyPath\SleepingTabsBlockedForUrls"
if (-not (Test-Path $SleepingTabsBlockedPath)) {
    New-Item -Path $SleepingTabsBlockedPath -Force | Out-Null
}
Set-ItemProperty -Path $SleepingTabsBlockedPath -Name "1" -Value "https://mail.google.com" -Type String -Force
Set-ItemProperty -Path $SleepingTabsBlockedPath -Name "2" -Value "https://outlook.office.com" -Type String -Force

Write-Host "  [✓] 已启用启动加速" -ForegroundColor Green
Write-Host "  [✓] 已启用睡眠标签页（2小时超时）" -ForegroundColor Green
Write-Host "  [✓] 已启用效率模式" -ForegroundColor Green
Write-Host "  [✓] 已启用硬件加速" -ForegroundColor Green

# ============================================================================
# 8. 用户体验优化
# ============================================================================
Write-Host "`n[8/11] 配置用户体验优化..." -ForegroundColor Yellow

$UXPolicies = @{
    # 界面配置
    "BookmarkBarEnabled" = 1
    "ShowHomeButton" = 1
    "HomepageIsNewTabPage" = 1
    
    # 禁用提示
    "DefaultBrowserSettingEnabled" = 0
    "PromotionalTabsEnabled" = 0
    "HideWebStoreIcon" = 1
    
    # 启动配置
    "RestoreOnStartup" = 5  # 5=打开新标签页
    
    # 禁用垂直标签页
    "VerticalTabsAllowed" = 0
}

foreach ($policy in $UXPolicies.GetEnumerator()) {
    Set-ItemProperty -Path $EdgePolicyPath -Name $policy.Key -Value $policy.Value -Type DWord -Force
}

# 配置主页
Set-ItemProperty -Path $EdgePolicyPath -Name "HomepageLocation" -Value "about:blank" -Type String -Force
Set-ItemProperty -Path $EdgePolicyPath -Name "NewTabPageLocation" -Value "about:blank" -Type String -Force

Write-Host "  [✓] 已显示书签栏和主页按钮" -ForegroundColor Green
Write-Host "  [✓] 已禁用所有提示和促销" -ForegroundColor Green
Write-Host "  [✓] 已配置启动页为空白页" -ForegroundColor Green

# ============================================================================
# 9. 权限控制
# ============================================================================
Write-Host "`n[9/11] 配置权限控制..." -ForegroundColor Yellow

$PermissionPolicies = @{
    "DefaultGeolocationSetting" = 2
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
    Set-ItemProperty -Path $EdgePolicyPath -Name $policy.Key -Value $policy.Value -Type DWord -Force
}

Write-Host "  [✓] 已阻止所有敏感权限请求" -ForegroundColor Green

# ============================================================================
# 10. 反检测和指纹保护
# ============================================================================
Write-Host "`n[10/11] 配置反检测和指纹保护..." -ForegroundColor Yellow

Set-ItemProperty -Path $EdgePolicyPath -Name "UserAgentClientHintsEnabled" -Value 0 -Type DWord -Force
Set-ItemProperty -Path $EdgePolicyPath -Name "HttpsOnlyMode" -Value "allowed" -Type String -Force

Write-Host "  [✓] 已禁用 User-Agent Client Hints" -ForegroundColor Green
Write-Host "  [✓] 已配置 HTTPS 优先模式" -ForegroundColor Green

# ============================================================================
# 11. 扩展管理（支持 Edge Add-ons 和 Chrome Web Store）
# ============================================================================
Write-Host "`n[11/11] 配置扩展管理..." -ForegroundColor Yellow

# 配置扩展安装源
Set-ItemProperty -Path $EdgePolicyPath -Name "ExtensionInstallSources" -Value "https://edge.microsoft.com/*,https://chrome.google.com/*" -Type String -Force
Set-ItemProperty -Path $EdgePolicyPath -Name "BlockExternalExtensions" -Value 0 -Type DWord -Force

# 使用 ExtensionSettings
$ExtensionSettingsPath = "$EdgePolicyPath\ExtensionSettings"
if (-not (Test-Path $ExtensionSettingsPath)) {
    New-Item -Path $ExtensionSettingsPath -Force | Out-Null
}

# uBlock Origin (Chrome Web Store)
$uBlockPath = "$ExtensionSettingsPath\cjpalhdlnbpafiamejdnhcphjbkeiagm"
if (-not (Test-Path $uBlockPath)) {
    New-Item -Path $uBlockPath -Force | Out-Null
}
Set-ItemProperty -Path $uBlockPath -Name "installation_mode" -Value "force_installed" -Type String -Force
Set-ItemProperty -Path $uBlockPath -Name "update_url" -Value "https://clients2.google.com/service/update2/crx" -Type String -Force

# Privacy Badger (Chrome Web Store)
$PrivacyBadgerPath = "$ExtensionSettingsPath\pkehgijcmpdhfbdbbnkijodmdjhbjlgp"
if (-not (Test-Path $PrivacyBadgerPath)) {
    New-Item -Path $PrivacyBadgerPath -Force | Out-Null
}
Set-ItemProperty -Path $PrivacyBadgerPath -Name "installation_mode" -Value "force_installed" -Type String -Force
Set-ItemProperty -Path $PrivacyBadgerPath -Name "update_url" -Value "https://clients2.google.com/service/update2/crx" -Type String -Force

# HTTPS Everywhere (Chrome Web Store)
$HTTPSEverywherePath = "$ExtensionSettingsPath\gcbommkclmclpchllfjekcdonpmejbdp"
if (-not (Test-Path $HTTPSEverywherePath)) {
    New-Item -Path $HTTPSEverywherePath -Force | Out-Null
}
Set-ItemProperty -Path $HTTPSEverywherePath -Name "installation_mode" -Value "force_installed" -Type String -Force
Set-ItemProperty -Path $HTTPSEverywherePath -Name "update_url" -Value "https://clients2.google.com/service/update2/crx" -Type String -Force

# Decentraleyes (Chrome Web Store)
$DecentraleyesPath = "$ExtensionSettingsPath\ldpochfccmkkmhdbclfhpagapcfdljkj"
if (-not (Test-Path $DecentraleyesPath)) {
    New-Item -Path $DecentraleyesPath -Force | Out-Null
}
Set-ItemProperty -Path $DecentraleyesPath -Name "installation_mode" -Value "force_installed" -Type String -Force
Set-ItemProperty -Path $DecentraleyesPath -Name "update_url" -Value "https://clients2.google.com/service/update2/crx" -Type String -Force

# 阻止其他扩展
$BlockAllPath = "$ExtensionSettingsPath\*"
if (-not (Test-Path $BlockAllPath)) {
    New-Item -Path $BlockAllPath -Force | Out-Null
}
Set-ItemProperty -Path $BlockAllPath -Name "installation_mode" -Value "blocked" -Type String -Force

Write-Host "  [✓] 已配置扩展安装源（Edge + Chrome）" -ForegroundColor Green
Write-Host "  [✓] 已配置 uBlock Origin 自动安装" -ForegroundColor Green
Write-Host "  [✓] 已配置 Privacy Badger 自动安装" -ForegroundColor Green
Write-Host "  [✓] 已配置 HTTPS Everywhere 自动安装" -ForegroundColor Green
Write-Host "  [✓] 已配置 Decentraleyes 自动安装" -ForegroundColor Green
Write-Host "  [✓] 已阻止其他扩展安装" -ForegroundColor Green

# ============================================================================
# 12. 创建启动脚本
# ============================================================================
Write-Host "`n[12/12] 创建启动脚本..." -ForegroundColor Yellow

$LaunchScript = @'
# Edge 启动脚本 - 带反检测参数
# 使用方法: .\LAUNCH_EDGE.ps1 -ProfileName "Profile1" -ProxyPort 7890

param(
    [string]$ProfileName = "Default",
    [int]$ProxyPort = 7890
)

$EdgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$UserDataDir = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"

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
    "--disable-features=msEdgeShoppingAssistant"
    "--disable-features=msEdgeWalletCheckout"
    "--no-first-run"
    "--no-default-browser-check"
    "--disable-popup-blocking"
    "--disable-infobars"
    "--disable-notifications"
    "--disable-save-password-bubble"
)

Write-Host "启动 Edge - $ProfileName (代理端口: $ProxyPort)" -ForegroundColor Cyan
Start-Process -FilePath $EdgePath -ArgumentList $LaunchArgs

Write-Host "[✓] Edge 已启动" -ForegroundColor Green
Write-Host "    配置文件: $ProfileName" -ForegroundColor Gray
Write-Host "    代理: socks5://127.0.0.1:$ProxyPort" -ForegroundColor Gray
'@

$LaunchScript | Out-File -FilePath ".\LAUNCH_EDGE.ps1" -Encoding UTF8 -Force

Write-Host "  [✓] 已创建 LAUNCH_EDGE.ps1" -ForegroundColor Green

# ============================================================================
# 完成
# ============================================================================
Write-Host "`n============================================" -ForegroundColor Green
Write-Host "Microsoft Edge 企业级配置完成！" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "配置内容：" -ForegroundColor Cyan
Write-Host "  ✓ 隐私和遥测控制（禁用所有数据收集）" -ForegroundColor White
Write-Host "  ✓ 完全禁用 Microsoft 服务集成" -ForegroundColor White
Write-Host "  ✓ 新标签页优化（禁用新闻和推荐）" -ForegroundColor White
Write-Host "  ✓ SmartScreen 和安全配置" -ForegroundColor White
Write-Host "  ✓ WebRTC 防护" -ForegroundColor White
Write-Host "  ✓ DNS-over-HTTPS" -ForegroundColor White
Write-Host "  ✓ 性能优化（睡眠标签页、效率模式、启动加速）" -ForegroundColor White
Write-Host "  ✓ 用户体验优化" -ForegroundColor White
Write-Host "  ✓ 权限控制" -ForegroundColor White
Write-Host "  ✓ 反检测和指纹保护" -ForegroundColor White
Write-Host "  ✓ 扩展自动安装（支持 Edge + Chrome 商店）" -ForegroundColor White
Write-Host ""
Write-Host "Edge 特有优化：" -ForegroundColor Yellow
Write-Host "  ✓ 睡眠标签页（2小时后自动休眠）" -ForegroundColor White
Write-Host "  ✓ 效率模式（节省资源）" -ForegroundColor White
Write-Host "  ✓ 启动加速（快速启动）" -ForegroundColor White
Write-Host "  ✓ 禁用购物助手、集锦、工作区" -ForegroundColor White
Write-Host "  ✓ 禁用 Bing 集成和 Microsoft Rewards" -ForegroundColor White
Write-Host ""
Write-Host "下一步：" -ForegroundColor Yellow
Write-Host "  1. 重启 Edge 使策略生效" -ForegroundColor White
Write-Host "  2. 访问 edge://policy 验证策略" -ForegroundColor White
Write-Host "  3. 使用 .\LAUNCH_EDGE.ps1 启动浏览器" -ForegroundColor White
Write-Host ""
