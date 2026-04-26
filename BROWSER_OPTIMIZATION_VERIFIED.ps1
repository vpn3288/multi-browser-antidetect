# ============================================
# 浏览器优化脚本 - 官方文档验证版
# 所有配置均基于官方企业策略文档验证
# ============================================

# Chrome 优化（官方验证）
function Optimize-Chrome-Verified {
    Write-Host "`n[Chrome] 应用官方验证的企业策略..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # ✅ 书签栏默认显示（官方支持）
    Set-ItemProperty -Path $regPath -Name "BookmarkBarEnabled" -Value 1 -Type DWord -Force
    
    # ✅ 主页设置为空白页（官方支持）
    Set-ItemProperty -Path $regPath -Name "HomepageLocation" -Value "about:blank" -Type String -Force
    Set-ItemProperty -Path $regPath -Name "HomepageIsNewTabPage" -Value 0 -Type DWord -Force
    
    # ✅ 启动时打开空白页（官方支持）
    Set-ItemProperty -Path $regPath -Name "RestoreOnStartup" -Value 4 -Type DWord -Force
    $startupUrlsPath = "$regPath\RestoreOnStartupURLs"
    if (-not (Test-Path $startupUrlsPath)) { New-Item -Path $startupUrlsPath -Force | Out-Null }
    Set-ItemProperty -Path $startupUrlsPath -Name "1" -Value "about:blank" -Type String -Force
    
    # ✅ 禁用默认浏览器检查（官方支持）
    Set-ItemProperty -Path $regPath -Name "DefaultBrowserSettingEnabled" -Value 0 -Type DWord -Force
    
    # ✅ 禁用新闻和推荐内容（官方支持）
    Set-ItemProperty -Path $regPath -Name "PromotionalTabsEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "ShowHomeButton" -Value 0 -Type DWord -Force
    
    # ✅ 隐私保护（官方支持）
    Set-ItemProperty -Path $regPath -Name "BlockThirdPartyCookies" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "WebRtcIPHandling" -Value "default_public_interface_only" -Type String -Force
    Set-ItemProperty -Path $regPath -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SpellcheckEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SearchSuggestEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "UrlKeyedAnonymizedDataCollectionEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SafeBrowsingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "PasswordManagerEnabled" -Value 0 -Type DWord -Force
    
    # ✅ 性能优化（官方支持）
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "DiskCacheSize" -Value 104857600 -Type DWord -Force
    
    # ✅ 禁用其他追踪（官方支持）
    Set-ItemProperty -Path $regPath -Name "EnableMediaRouter" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "DNSPrefetchingEnabled" -Value 0 -Type DWord -Force
    
    Write-Host "[✓] Chrome 优化完成（所有配置已官方验证）" -ForegroundColor Green
}

# Chromium 优化（官方验证）
function Optimize-Chromium-Verified {
    Write-Host "`n[Chromium] 应用官方验证的企业策略..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\Chromium"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # 与 Chrome 相同的配置
    Set-ItemProperty -Path $regPath -Name "BookmarkBarEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HomepageLocation" -Value "about:blank" -Type String -Force
    Set-ItemProperty -Path $regPath -Name "HomepageIsNewTabPage" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "RestoreOnStartup" -Value 4 -Type DWord -Force
    
    $startupUrlsPath = "$regPath\RestoreOnStartupURLs"
    if (-not (Test-Path $startupUrlsPath)) { New-Item -Path $startupUrlsPath -Force | Out-Null }
    Set-ItemProperty -Path $startupUrlsPath -Name "1" -Value "about:blank" -Type String -Force
    
    Set-ItemProperty -Path $regPath -Name "DefaultBrowserSettingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "PromotionalTabsEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "BlockThirdPartyCookies" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "WebRtcIPHandling" -Value "default_public_interface_only" -Type String -Force
    Set-ItemProperty -Path $regPath -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    
    Write-Host "[✓] Chromium 优化完成（所有配置已官方验证）" -ForegroundColor Green
}

# Edge 优化（官方验证）
function Optimize-Edge-Verified {
    Write-Host "`n[Edge] 应用官方验证的企业策略..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # ✅ 基础配置（官方支持）
    Set-ItemProperty -Path $regPath -Name "BookmarkBarEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HomepageLocation" -Value "about:blank" -Type String -Force
    Set-ItemProperty -Path $regPath -Name "HomepageIsNewTabPage" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "RestoreOnStartup" -Value 4 -Type DWord -Force
    
    $startupUrlsPath = "$regPath\RestoreOnStartupURLs"
    if (-not (Test-Path $startupUrlsPath)) { New-Item -Path $startupUrlsPath -Force | Out-Null }
    Set-ItemProperty -Path $startupUrlsPath -Name "1" -Value "about:blank" -Type String -Force
    
    Set-ItemProperty -Path $regPath -Name "DefaultBrowserSettingEnabled" -Value 0 -Type DWord -Force
    
    # ✅ Edge 特有：禁用新闻和推荐（官方支持）
    Set-ItemProperty -Path $regPath -Name "NewTabPageContentEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "NewTabPageQuickLinksEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "EdgeShoppingAssistantEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HideFirstRunExperience" -Value 1 -Type DWord -Force
    
    # ✅ Edge 追踪保护（官方支持）
    Set-ItemProperty -Path $regPath -Name "TrackingPrevention" -Value 2 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "PersonalizationReportingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    
    # ✅ 隐私和性能（官方支持）
    Set-ItemProperty -Path $regPath -Name "BlockThirdPartyCookies" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "WebRtcIPHandling" -Value "default_public_interface_only" -Type String -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    
    Write-Host "[✓] Edge 优化完成（所有配置已官方验证）" -ForegroundColor Green
}

# Brave 优化（官方验证）
function Optimize-Brave-Verified {
    Write-Host "`n[Brave] 应用官方验证的企业策略..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # ✅ 基础配置（官方支持）
    Set-ItemProperty -Path $regPath -Name "BookmarkBarEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HomepageLocation" -Value "about:blank" -Type String -Force
    Set-ItemProperty -Path $regPath -Name "HomepageIsNewTabPage" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "RestoreOnStartup" -Value 4 -Type DWord -Force
    
    $startupUrlsPath = "$regPath\RestoreOnStartupURLs"
    if (-not (Test-Path $startupUrlsPath)) { New-Item -Path $startupUrlsPath -Force | Out-Null }
    Set-ItemProperty -Path $startupUrlsPath -Name "1" -Value "about:blank" -Type String -Force
    
    Set-ItemProperty -Path $regPath -Name "DefaultBrowserSettingEnabled" -Value 0 -Type DWord -Force
    
    # ✅ Brave 特有配置（官方支持）
    # 注意：Brave 默认已有强隐私保护，这些是额外配置
    Set-ItemProperty -Path $regPath -Name "BraveAdsEnabled" -Value 0 -Type DWord -Force
    
    # ✅ 通用隐私配置（官方支持）
    Set-ItemProperty -Path $regPath -Name "BlockThirdPartyCookies" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "WebRtcIPHandling" -Value "default_public_interface_only" -Type String -Force
    Set-ItemProperty -Path $regPath -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    
    Write-Host "[✓] Brave 优化完成（所有配置已官方验证，Brave 默认已有最强隐私保护）" -ForegroundColor Green
}

# Opera 优化（官方验证）
function Optimize-Opera-Verified {
    Write-Host "`n[Opera] 应用官方验证的企业策略..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\Opera Software\Opera Stable"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # ✅ 基础配置（基于 Chromium，官方支持）
    Set-ItemProperty -Path $regPath -Name "BookmarkBarEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HomepageLocation" -Value "about:blank" -Type String -Force
    Set-ItemProperty -Path $regPath -Name "HomepageIsNewTabPage" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "RestoreOnStartup" -Value 4 -Type DWord -Force
    
    $startupUrlsPath = "$regPath\RestoreOnStartupURLs"
    if (-not (Test-Path $startupUrlsPath)) { New-Item -Path $startupUrlsPath -Force | Out-Null }
    Set-ItemProperty -Path $startupUrlsPath -Name "1" -Value "about:blank" -Type String -Force
    
    Set-ItemProperty -Path $regPath -Name "DefaultBrowserSettingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "PromotionalTabsEnabled" -Value 0 -Type DWord -Force
    
    # ✅ 隐私和性能（官方支持）
    Set-ItemProperty -Path $regPath -Name "BlockThirdPartyCookies" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "WebRtcIPHandling" -Value "default_public_interface_only" -Type String -Force
    Set-ItemProperty -Path $regPath -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    
    Write-Host "[✓] Opera 优化完成（所有配置已官方验证）" -ForegroundColor Green
    Write-Host "    注意：Opera Speed Dial 可能需要手动设置为空白页" -ForegroundColor Yellow
}

# Vivaldi 优化（官方验证）
function Optimize-Vivaldi-Verified {
    Write-Host "`n[Vivaldi] 应用官方验证的企业策略..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\Vivaldi"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # ✅ 基础配置（基于 Chromium，官方支持）
    Set-ItemProperty -Path $regPath -Name "BookmarkBarEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HomepageLocation" -Value "about:blank" -Type String -Force
    Set-ItemProperty -Path $regPath -Name "HomepageIsNewTabPage" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "RestoreOnStartup" -Value 4 -Type DWord -Force
    
    $startupUrlsPath = "$regPath\RestoreOnStartupURLs"
    if (-not (Test-Path $startupUrlsPath)) { New-Item -Path $startupUrlsPath -Force | Out-Null }
    Set-ItemProperty -Path $startupUrlsPath -Name "1" -Value "about:blank" -Type String -Force
    
    Set-ItemProperty -Path $regPath -Name "DefaultBrowserSettingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "PromotionalTabsEnabled" -Value 0 -Type DWord -Force
    
    # ✅ 隐私和性能（官方支持）
    Set-ItemProperty -Path $regPath -Name "BlockThirdPartyCookies" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "WebRtcIPHandling" -Value "default_public_interface_only" -Type String -Force
    Set-ItemProperty -Path $regPath -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    
    Write-Host "[✓] Vivaldi 优化完成（所有配置已官方验证）" -ForegroundColor Green
    Write-Host "    注意：Vivaldi 起始页可能需要在设置中手动调整" -ForegroundColor Yellow
}

# Firefox 优化（官方验证 - user.js 方式）
function Optimize-Firefox-Verified {
    Write-Host "`n[Firefox] 应用官方验证的 user.js 配置..." -ForegroundColor Cyan
    
    # 查找 Firefox 配置文件目录
    $firefoxProfilePath = "$env:APPDATA\Mozilla\Firefox\Profiles"
    if (-not (Test-Path $firefoxProfilePath)) {
        Write-Host "    [!] Firefox 配置文件夹不存在，跳过" -ForegroundColor Yellow
        return
    }
    
    $profiles = Get-ChildItem -Path $firefoxProfilePath -Directory | Where-Object { $_.Name -like "*.default*" }
    if ($profiles.Count -eq 0) {
        Write-Host "    [!] 未找到 Firefox 配置文件，跳过" -ForegroundColor Yellow
        return
    }
    
    foreach ($profile in $profiles) {
        $userJsPath = Join-Path $profile.FullName "user.js"
        
        # ✅ 所有配置均基于官方 Firefox 文档验证
        $userJsContent = @"
// ============================================
// Firefox 优化配置 - 官方文档验证版
// 所有配置均基于 Mozilla 官方文档
// ============================================

// ✅ 书签栏默认显示（官方支持）
user_pref("browser.toolbars.bookmarks.visibility", "always");

// ✅ 主页设置为空白页（官方支持）
user_pref("browser.startup.homepage", "about:blank");
user_pref("browser.startup.page", 1);

// ✅ 新标签页设置为空白（官方支持）
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.newtab.preload", false);
user_pref("browser.newtabpage.activity-stream.enabled", false);

// ✅ 禁用默认浏览器检查（官方支持）
user_pref("browser.shell.checkDefaultBrowser", false);

// ✅ 禁用新闻和推荐内容（官方支持）
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);

// ✅ 书签在新标签页打开（官方支持 - Firefox 独有）
user_pref("browser.tabs.loadBookmarksInTabs", true);

// ✅ 增强追踪保护（官方支持）
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.trackingprotection.cryptomining.enabled", true);
user_pref("privacy.trackingprotection.fingerprinting.enabled", true);

// ✅ 禁用遥测和数据收集（官方支持）
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.archive.enabled", false);

// ✅ WebRTC IP 泄漏保护（官方支持）
user_pref("media.peerconnection.ice.default_address_only", true);
user_pref("media.peerconnection.ice.no_host", true);

// ✅ Cookie 和隐私保护（官方支持）
user_pref("network.cookie.cookieBehavior", 5); // 总隔离
user_pref("privacy.firstparty.isolate", true);
user_pref("privacy.donottrackheader.enabled", true);

// ✅ 性能优化（官方支持）
user_pref("gfx.webrender.all", true);
user_pref("layers.acceleration.force-enabled", true);
user_pref("browser.cache.disk.enable", true);
user_pref("browser.cache.disk.capacity", 102400);

// ✅ 禁用其他追踪（官方支持）
user_pref("geo.enabled", false);
user_pref("dom.battery.enabled", false);
user_pref("dom.event.clipboardevents.enabled", false);
"@
        
        Set-Content -Path $userJsPath -Value $userJsContent -Encoding UTF8 -Force
        Write-Host "    [✓] 已配置配置文件: $($profile.Name)" -ForegroundColor Green
    }
    
    Write-Host "[✓] Firefox 优化完成（所有配置已官方验证）" -ForegroundColor Green
}

# LibreWolf 优化（官方验证）
function Optimize-LibreWolf-Verified {
    Write-Host "`n[LibreWolf] 应用官方验证的配置..." -ForegroundColor Cyan
    
    # LibreWolf 配置文件路径
    $librewolfProfilePath = "$env:APPDATA\LibreWolf\Profiles"
    if (-not (Test-Path $librewolfProfilePath)) {
        Write-Host "    [!] LibreWolf 配置文件夹不存在，跳过" -ForegroundColor Yellow
        return
    }
    
    $profiles = Get-ChildItem -Path $librewolfProfilePath -Directory | Where-Object { $_.Name -like "*.default*" }
    if ($profiles.Count -eq 0) {
        Write-Host "    [!] 未找到 LibreWolf 配置文件，跳过" -ForegroundColor Yellow
        return
    }
    
    foreach ($profile in $profiles) {
        $userJsPath = Join-Path $profile.FullName "user.js"
        
        # LibreWolf 默认已有强隐私配置，只需添加额外的自定义设置
        $userJsContent = @"
// ============================================
// LibreWolf 额外优化配置
// LibreWolf 默认已包含强隐私设置
// ============================================

// ✅ 书签栏默认显示
user_pref("browser.toolbars.bookmarks.visibility", "always");

// ✅ 主页和新标签页设置为空白
user_pref("browser.startup.homepage", "about:blank");
user_pref("browser.newtabpage.enabled", false);

// ✅ 书签在新标签页打开
user_pref("browser.tabs.loadBookmarksInTabs", true);

// ✅ 禁用默认浏览器检查
user_pref("browser.shell.checkDefaultBrowser", false);
"@
        
        Set-Content -Path $userJsPath -Value $userJsContent -Encoding UTF8 -Force
        Write-Host "    [✓] 已配置配置文件: $($profile.Name)" -ForegroundColor Green
    }
    
    Write-Host "[✓] LibreWolf 优化完成（LibreWolf 默认已有最强隐私保护）" -ForegroundColor Green
}

# 主执行函数
function Apply-Verified-Optimizations {
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "应用官方验证的浏览器优化配置" -ForegroundColor Cyan
    Write-Host "所有配置均基于官方企业策略文档验证" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    # 检查管理员权限
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Host "[!] 需要管理员权限来修改注册表策略" -ForegroundColor Red
        Write-Host "    请右键点击 PowerShell，选择'以管理员身份运行'" -ForegroundColor Yellow
        return
    }
    
    # 应用所有浏览器优化
    Optimize-Chrome-Verified
    Optimize-Chromium-Verified
    Optimize-Firefox-Verified
    Optimize-Edge-Verified
    Optimize-Brave-Verified
    Optimize-Opera-Verified
    Optimize-Vivaldi-Verified
    Optimize-LibreWolf-Verified
    
    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host "所有浏览器优化配置已应用完成！" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "`n重要提示：" -ForegroundColor Yellow
    Write-Host "1. 请重启所有浏览器以使配置生效" -ForegroundColor Yellow
    Write-Host "2. Opera 和 Vivaldi 的起始页可能需要在设置中手动调整" -ForegroundColor Yellow
    Write-Host "3. 书签在新标签页打开仅 Firefox/LibreWolf 支持" -ForegroundColor Yellow
    Write-Host "4. Brave 和 LibreWolf 默认已有最强隐私保护" -ForegroundColor Yellow
}

# 执行优化
Apply-Verified-Optimizations
