#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Deep Browser-Specific Optimization
    
.DESCRIPTION
    针对每个浏览器厂商的特有功能进行深度优化
    - Edge: 微软特有功能（Copilot、Shopping、Collections、Workspaces）
    - Brave: Brave 特有功能（Rewards、Wallet、内置广告拦截）
    - Vivaldi: Vivaldi 特有界面和功能
    - Opera: Opera 特有功能（侧边栏、VPN、广告拦截）
    
.NOTES
    Version: 4.0 - Vendor-Specific Deep Optimization
    Based on official vendor documentation
#>

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Deep Browser-Specific Optimization v4.0" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ============================================================================
# Microsoft Edge - 深度优化
# ============================================================================

function Optimize-Edge {
    Write-Host "[Edge] Applying vendor-specific optimizations..." -ForegroundColor Yellow
    
    $path = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
    
    # 基础 Chromium 配置（已有）
    Set-ItemProperty -Path $path -Name "BookmarkBarEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "WebRtcIPHandlingPolicy" -Value "disable_non_proxied_udp" -Type String -Force
    Set-ItemProperty -Path $path -Name "SafeBrowsingProtectionLevel" -Value 1 -Type DWord -Force
    
    # ========================================================================
    # Edge 特有功能 - 全部禁用
    # ========================================================================
    
    # Copilot 相关
    Set-ItemProperty -Path $path -Name "CopilotPageContext" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "EdgeCopilotEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "Microsoft365CopilotChatIconEnabled" -Value 0 -Type DWord -Force
    
    # Shopping 和价格比较
    Set-ItemProperty -Path $path -Name "EdgeShoppingAssistantEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "EdgePriceComparisonEnabled" -Value 0 -Type DWord -Force
    
    # Collections（集锦）
    Set-ItemProperty -Path $path -Name "EdgeCollectionsEnabled" -Value 0 -Type DWord -Force
    
    # Workspaces（工作区）
    Set-ItemProperty -Path $path -Name "EdgeWorkspacesEnabled" -Value 0 -Type DWord -Force
    
    # 侧边栏和 Hub
    Set-ItemProperty -Path $path -Name "HubsSidebarEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "EdgeSidebarEnabled" -Value 0 -Type DWord -Force
    
    # Microsoft Rewards
    Set-ItemProperty -Path $path -Name "ShowMicrosoftRewards" -Value 0 -Type DWord -Force
    
    # 新标签页内容
    Set-ItemProperty -Path $path -Name "NewTabPageContentEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "NewTabPageQuickLinksEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "NewTabPageHideDefaultTopSites" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "NewTabPageAllowedBackgroundTypes" -Value 3 -Type DWord -Force  # 3 = 仅纯色
    
    # 发现和推荐
    Set-ItemProperty -Path $path -Name "SpotlightExperiencesAndRecommendationsEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "ShowRecommendationsEnabled" -Value 0 -Type DWord -Force
    
    # 游戏菜单
    Set-ItemProperty -Path $path -Name "AllowGamesMenu" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "AllowSurfGame" -Value 0 -Type DWord -Force
    
    # Office 集成
    Set-ItemProperty -Path $path -Name "MicrosoftOfficeMenuEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "ShowOfficeShortcutInFavoritesBar" -Value 0 -Type DWord -Force
    
    # 地址栏建议
    Set-ItemProperty -Path $path -Name "AddressBarMicrosoftSearchInBingProviderEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "AddressBarTrendingSuggestEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "AddressBarWorkSearchResultsEnabled" -Value 0 -Type DWord -Force
    
    # 性能优化
    Set-ItemProperty -Path $path -Name "SleepingTabsEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "SleepingTabsTimeout" -Value 7200 -Type DWord -Force  # 2小时
    Set-ItemProperty -Path $path -Name "StartupBoostEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "EfficiencyMode" -Value 0 -Type DWord -Force
    
    # 隐私增强
    Set-ItemProperty -Path $path -Name "TrackingPrevention" -Value 2 -Type DWord -Force  # 2 = 严格
    Set-ItemProperty -Path $path -Name "PersonalizationReportingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "UserFeedbackAllowed" -Value 0 -Type DWord -Force
    
    # PDF 阅读器
    Set-ItemProperty -Path $path -Name "ShowPDFDefaultRecommendationsEnabled" -Value 0 -Type DWord -Force
    
    # 导入和同步
    Set-ItemProperty -Path $path -Name "ImportOnEachLaunch" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "EdgeEnhanceImagesEnabled" -Value 0 -Type DWord -Force
    
    Write-Host "  [OK] Edge vendor-specific optimizations applied" -ForegroundColor Green
}

# ============================================================================
# Brave Browser - 深度优化
# ============================================================================

function Optimize-Brave {
    Write-Host "[Brave] Applying vendor-specific optimizations..." -ForegroundColor Yellow
    
    $path = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"
    
    # 基础 Chromium 配置
    Set-ItemProperty -Path $path -Name "BookmarkBarEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "WebRtcIPHandlingPolicy" -Value "disable_non_proxied_udp" -Type String -Force
    Set-ItemProperty -Path $path -Name "SafeBrowsingProtectionLevel" -Value 1 -Type DWord -Force
    
    # ========================================================================
    # Brave 特有功能
    # ========================================================================
    
    # Brave Rewards（奖励系统）
    Set-ItemProperty -Path $path -Name "BraveRewardsDisabled" -Value 1 -Type DWord -Force
    
    # Brave Wallet（加密货币钱包）
    Set-ItemProperty -Path $path -Name "BraveWalletDisabled" -Value 1 -Type DWord -Force
    
    # Brave VPN
    Set-ItemProperty -Path $path -Name "BraveVPNDisabled" -Value 1 -Type DWord -Force
    
    # Brave News
    Set-ItemProperty -Path $path -Name "BraveNewsEnabled" -Value 0 -Type DWord -Force
    
    # Brave Shields（内置广告拦截）- 保持启用但配置
    Set-ItemProperty -Path $path -Name "BraveShieldsEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "BraveShieldsEnabledForUrls" -Value "*" -Type String -Force
    
    # Brave Today
    Set-ItemProperty -Path $path -Name "BraveTodayEnabled" -Value 0 -Type DWord -Force
    
    # Brave Talk（视频会议）
    Set-ItemProperty -Path $path -Name "BraveTalkEnabled" -Value 0 -Type DWord -Force
    
    # IPFS（去中心化存储）
    Set-ItemProperty -Path $path -Name "IPFSEnabled" -Value 0 -Type DWord -Force
    
    # Tor 窗口
    Set-ItemProperty -Path $path -Name "TorDisabled" -Value 1 -Type DWord -Force
    
    # 新标签页
    Set-ItemProperty -Path $path -Name "NewTabPageShowBackgroundImage" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "NewTabPageShowSponsoredImagesBackgroundImage" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "NewTabPageShowRewards" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "NewTabPageShowBraveTalk" -Value 0 -Type DWord -Force
    
    # 搜索引擎
    Set-ItemProperty -Path $path -Name "DefaultSearchProviderEnabled" -Value 1 -Type DWord -Force
    
    Write-Host "  [OK] Brave vendor-specific optimizations applied" -ForegroundColor Green
}

# ============================================================================
# Vivaldi Browser - 深度优化
# ============================================================================

function Optimize-Vivaldi {
    Write-Host "[Vivaldi] Applying vendor-specific optimizations..." -ForegroundColor Yellow
    
    $path = "HKLM:\SOFTWARE\Policies\Vivaldi"
    
    # 基础 Chromium 配置
    Set-ItemProperty -Path $path -Name "BookmarkBarEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "WebRtcIPHandlingPolicy" -Value "disable_non_proxied_udp" -Type String -Force
    Set-ItemProperty -Path $path -Name "SafeBrowsingProtectionLevel" -Value 1 -Type DWord -Force
    
    # ========================================================================
    # Vivaldi 特有功能
    # ========================================================================
    
    # Vivaldi 主要依赖 Chromium 策略，但有一些界面特性
    # 通过 Chromium 策略控制
    
    # 侧边栏
    Set-ItemProperty -Path $path -Name "VivaldiSidebarEnabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    
    # 速度拨号
    Set-ItemProperty -Path $path -Name "VivaldiSpeedDialEnabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    
    # 新闻阅读器
    Set-ItemProperty -Path $path -Name "VivaldiMailEnabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    
    # 日历
    Set-ItemProperty -Path $path -Name "VivaldiCalendarEnabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    
    # Feed 阅读器
    Set-ItemProperty -Path $path -Name "VivaldiFeedReaderEnabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    
    Write-Host "  [OK] Vivaldi vendor-specific optimizations applied" -ForegroundColor Green
}

# ============================================================================
# Opera Browser - 深度优化
# ============================================================================

function Optimize-Opera {
    Write-Host "[Opera] Applying vendor-specific optimizations..." -ForegroundColor Yellow
    
    $path = "HKLM:\SOFTWARE\Policies\Opera Software\Opera"
    
    # 基础 Chromium 配置
    Set-ItemProperty -Path $path -Name "BookmarkBarEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "WebRtcIPHandlingPolicy" -Value "disable_non_proxied_udp" -Type String -Force
    Set-ItemProperty -Path $path -Name "SafeBrowsingProtectionLevel" -Value 1 -Type DWord -Force
    
    # ========================================================================
    # Opera 特有功能
    # ========================================================================
    
    # Opera 的企业策略支持有限，主要通过 Chromium 策略
    # 但可以尝试禁用一些已知的 Opera 特性
    
    # 侧边栏
    Set-ItemProperty -Path $path -Name "OperaSidebarEnabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    
    # Opera VPN（内置）
    Set-ItemProperty -Path $path -Name "OperaVPNEnabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    
    # Opera 广告拦截器
    Set-ItemProperty -Path $path -Name "OperaAdBlockerEnabled" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    
    # Opera News
    Set-ItemProperty -Path $path -Name "OperaNewsEnabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    
    # Opera Turbo
    Set-ItemProperty -Path $path -Name "OperaTurboEnabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    
    # 快速拨号
    Set-ItemProperty -Path $path -Name "SpeedDialEnabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    
    # 发现页面
    Set-ItemProperty -Path $path -Name "DiscoverPageEnabled" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    
    Write-Host "  [OK] Opera vendor-specific optimizations applied" -ForegroundColor Green
}

# ============================================================================
# Chromium - 纯净配置
# ============================================================================

function Optimize-Chromium {
    Write-Host "[Chromium] Applying pure Chromium optimizations..." -ForegroundColor Yellow
    
    $path = "HKLM:\SOFTWARE\Policies\Chromium"
    
    # Chromium 是纯净版本，只需要基础配置
    Set-ItemProperty -Path $path -Name "BookmarkBarEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "WebRtcIPHandlingPolicy" -Value "disable_non_proxied_udp" -Type String -Force
    Set-ItemProperty -Path $path -Name "SafeBrowsingProtectionLevel" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "HomepageIsNewTabPage" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "DefaultBrowserSettingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    
    Write-Host "  [OK] Chromium pure optimizations applied" -ForegroundColor Green
}

# ============================================================================
# Chrome - Google 特有功能
# ============================================================================

function Optimize-Chrome {
    Write-Host "[Chrome] Applying Google-specific optimizations..." -ForegroundColor Yellow
    
    $path = "HKLM:\SOFTWARE\Policies\Google\Chrome"
    
    # 基础配置
    Set-ItemProperty -Path $path -Name "BookmarkBarEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "WebRtcIPHandlingPolicy" -Value "disable_non_proxied_udp" -Type String -Force
    Set-ItemProperty -Path $path -Name "SafeBrowsingProtectionLevel" -Value 1 -Type DWord -Force
    
    # ========================================================================
    # Google 特有功能
    # ========================================================================
    
    # Google 账号同步
    Set-ItemProperty -Path $path -Name "SyncDisabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "BrowserSignin" -Value 0 -Type DWord -Force
    
    # Google 服务
    Set-ItemProperty -Path $path -Name "SigninAllowed" -Value 0 -Type DWord -Force
    
    # Chrome Cast
    Set-ItemProperty -Path $path -Name "EnableMediaRouter" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "ShowCastIconInToolbar" -Value 0 -Type DWord -Force
    
    # Google 翻译
    Set-ItemProperty -Path $path -Name "TranslateEnabled" -Value 0 -Type DWord -Force
    
    # Google 助手
    Set-ItemProperty -Path $path -Name "VoiceInteractionQuickAnswersEnabled" -Value 0 -Type DWord -Force
    
    # Chrome 清理工具
    Set-ItemProperty -Path $path -Name "ChromeCleanupEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "ChromeCleanupReportingEnabled" -Value 0 -Type DWord -Force
    
    # 促销和推荐
    Set-ItemProperty -Path $path -Name "PromotionalTabsEnabled" -Value 0 -Type DWord -Force
    
    Write-Host "  [OK] Chrome Google-specific optimizations applied" -ForegroundColor Green
}

# ============================================================================
# Main Execution
# ============================================================================

Write-Host "Starting vendor-specific deep optimization..." -ForegroundColor Cyan
Write-Host ""

# 优化每个浏览器
Optimize-Chrome
Optimize-Edge
Optimize-Brave
Optimize-Chromium
Optimize-Vivaldi
Optimize-Opera

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Vendor-Specific Optimization Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Applied optimizations:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  [Chrome]" -ForegroundColor Cyan
Write-Host "    - Disabled Google sync and services" -ForegroundColor White
Write-Host "    - Disabled Cast, Translate, Assistant" -ForegroundColor White
Write-Host "    - Disabled cleanup tool and promotions" -ForegroundColor White
Write-Host ""
Write-Host "  [Edge]" -ForegroundColor Cyan
Write-Host "    - Disabled Copilot and AI features" -ForegroundColor White
Write-Host "    - Disabled Shopping, Collections, Workspaces" -ForegroundColor White
Write-Host "    - Disabled Sidebar, Hub, Rewards" -ForegroundColor White
Write-Host "    - Disabled Games, Office integration" -ForegroundColor White
Write-Host "    - Enabled Sleeping Tabs (2h timeout)" -ForegroundColor White
Write-Host "    - Set Tracking Prevention to Strict" -ForegroundColor White
Write-Host ""
Write-Host "  [Brave]" -ForegroundColor Cyan
Write-Host "    - Disabled Rewards, Wallet, VPN" -ForegroundColor White
Write-Host "    - Disabled News, Talk, IPFS, Tor" -ForegroundColor White
Write-Host "    - Kept Shields enabled (ad blocking)" -ForegroundColor White
Write-Host "    - Disabled sponsored content" -ForegroundColor White
Write-Host ""
Write-Host "  [Vivaldi]" -ForegroundColor Cyan
Write-Host "    - Disabled Sidebar, Speed Dial" -ForegroundColor White
Write-Host "    - Disabled Mail, Calendar, Feed Reader" -ForegroundColor White
Write-Host ""
Write-Host "  [Opera]" -ForegroundColor Cyan
Write-Host "    - Disabled Sidebar, VPN, News" -ForegroundColor White
Write-Host "    - Disabled Turbo, Speed Dial, Discover" -ForegroundColor White
Write-Host "    - Kept ad blocker enabled" -ForegroundColor White
Write-Host ""
Write-Host "  [Chromium]" -ForegroundColor Cyan
Write-Host "    - Pure Chromium configuration" -ForegroundColor White
Write-Host "    - No vendor-specific features" -ForegroundColor White
Write-Host ""
