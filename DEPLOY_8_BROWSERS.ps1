#Requires -RunAsAdministrator

# ══════════════════════════════════════════════════════════════════
#  8浏览器完整部署 - 自动安装 + 架构级优化
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  8浏览器完整部署 - 自动安装 + 架构级优化" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

$baseDir = "C:\BrowserProfiles"
$reportData = @()

# ══════════════════════════════════════════════════════════════════
#  选择要安装的浏览器
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[步骤 1/3] 选择要安装的浏览器..." -ForegroundColor Cyan

$browsers = @(
    @{Name="Chrome"; Exe="C:\Program Files\Google\Chrome\Application\chrome.exe"; Installer="https://dl.google.com/chrome/install/latest/chrome_installer.exe"; WingetId=$null},
    @{Name="Firefox"; Exe="C:\Program Files\Mozilla Firefox\firefox.exe"; Installer="https://download.mozilla.org/?product=firefox-latest&os=win64&lang=zh-CN"; WingetId=$null},
    @{Name="Edge"; Exe="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"; Installer=$null; WingetId=$null},
    @{Name="Brave"; Exe=@("C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe", "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\Application\brave.exe"); Installer="https://laptop-updates.brave.com/latest/winx64"; WingetId=$null},
    @{Name="Opera"; Exe="$env:LOCALAPPDATA\Programs\Opera\opera.exe"; Installer="https://net.geo.opera.com/opera/stable/windows"; WingetId=$null},
    @{Name="Vivaldi"; Exe="$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe"; Installer="https://downloads.vivaldi.com/stable/Vivaldi.6.5.3206.63.x64.exe"; WingetId=$null},
    @{Name="LibreWolf"; Exe="C:\Program Files\LibreWolf\librewolf.exe"; Installer=$null; WingetId="LibreWolf.LibreWolf"},
    @{Name="Chromium"; Exe="$env:LOCALAPPDATA\Chromium\Application\chrome.exe"; Installer=$null; WingetId="Hibbiki.Chromium"}
)

Write-Host "`n请选择要安装的浏览器（多选用逗号分隔，例如: 1,2,3 或直接回车安装全部）:" -ForegroundColor Yellow
for ($i = 0; $i -lt $browsers.Count; $i++) {
    $browser = $browsers[$i]
    $exePath = $ExecutionContext.InvokeCommand.ExpandString($browser.Exe)
    $status = if (Test-Path $exePath) { "[已安装]" } else { "[未安装]" }
    Write-Host "  $($i+1). $($browser.Name) $status" -ForegroundColor $(if (Test-Path $exePath) { "Green" } else { "Gray" })
}

$selection = Read-Host "`n输入选项 (1-8，用逗号分隔，或直接回车安装全部)"

$selectedBrowsers = @()
if ([string]::IsNullOrWhiteSpace($selection)) {
    # 安装全部
    $selectedBrowsers = $browsers
    Write-Host "`n[*] 将安装所有浏览器" -ForegroundColor Cyan
} else {
    # 解析用户选择
    $indices = $selection -split ',' | ForEach-Object { $_.Trim() }
    foreach ($idx in $indices) {
        if ($idx -match '^\d+$' -and [int]$idx -ge 1 -and [int]$idx -le $browsers.Count) {
            $selectedBrowsers += $browsers[[int]$idx - 1]
        }
    }
    Write-Host "`n[*] 将安装 $($selectedBrowsers.Count) 个浏览器: $($selectedBrowsers.Name -join ', ')" -ForegroundColor Cyan
}

# ══════════════════════════════════════════════════════════════════
#  检查并安装选中的浏览器
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[步骤 2/3] 检查并安装浏览器..." -ForegroundColor Cyan

# 辅助函数：检查浏览器是否存在（支持多路径）
function Test-BrowserExists {
    param($browser)
    
    $exePath = $browser.Exe
    if ($exePath -is [array]) {
        foreach ($path in $exePath) {
            $expandedPath = $ExecutionContext.InvokeCommand.ExpandString($path)
            if (Test-Path $expandedPath) {
                return $expandedPath
            }
        }
        return $null
    } else {
        $expandedPath = $ExecutionContext.InvokeCommand.ExpandString($exePath)
        if (Test-Path $expandedPath) {
            return $expandedPath
        }
        return $null
    }
}

foreach ($browser in $selectedBrowsers) {
    $foundPath = Test-BrowserExists $browser
    
    if (-not $foundPath) {
        if ($browser.WingetId) {
            Write-Host "`n[*] 使用 winget 安装 $($browser.Name)..." -ForegroundColor Yellow
            try {
                # 检查 winget 是否可用
                $wingetCmd = Get-Command winget -ErrorAction SilentlyContinue
                if ($wingetCmd) {
                    Write-Host "    正在下载和安装，请稍候..." -ForegroundColor Gray
                    $result = winget install --id $browser.WingetId --silent --accept-package-agreements --accept-source-agreements 2>&1
                    
                    # 等待安装完成
                    Start-Sleep -Seconds 5
                    
                    # 再次检查是否安装成功
                    $foundPath = Test-BrowserExists $browser
                    if ($foundPath) {
                        Write-Host "[✓] $($browser.Name) 安装完成" -ForegroundColor Green
                    } else {
                        Write-Host "[!] $($browser.Name) 安装可能需要更多时间，请稍后手动检查" -ForegroundColor Yellow
                    }
                } else {
                    Write-Host "[!] winget 未安装，跳过 $($browser.Name)" -ForegroundColor Yellow
                    Write-Host "    手动安装: https://librewolf.net/ 或 https://chromium.woolyss.com/" -ForegroundColor Gray
                }
            } catch {
                Write-Host "[✗] $($browser.Name) 安装失败: $_" -ForegroundColor Red
            }
        } elseif ($browser.Installer) {
            Write-Host "`n[*] 下载安装 $($browser.Name)..." -ForegroundColor Yellow
            $installerPath = "$env:TEMP\$($browser.Name)_installer.exe"
            
            try {
                Write-Host "    正在下载..." -ForegroundColor Gray
                Invoke-WebRequest -Uri $browser.Installer -OutFile $installerPath -UseBasicParsing -TimeoutSec 300
                
                Write-Host "    正在安装..." -ForegroundColor Gray
                if ($browser.Name -eq "Chrome") {
                    Start-Process -FilePath $installerPath -ArgumentList "/silent /install" -Wait -NoNewWindow
                } elseif ($browser.Name -eq "Firefox") {
                    Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait -NoNewWindow
                } elseif ($browser.Name -eq "Brave") {
                    # 用户级安装，避免 0x80040c01 错误
                    Start-Process -FilePath $installerPath -ArgumentList "--install --silent" -Wait -NoNewWindow
                } elseif ($browser.Name -eq "Opera") {
                    Start-Process -FilePath $installerPath -ArgumentList "/silent /launchopera=0" -Wait -NoNewWindow
                } elseif ($browser.Name -eq "Vivaldi") {
                    Start-Process -FilePath $installerPath -ArgumentList "--vivaldi-silent --do-not-launch-chrome" -Wait -NoNewWindow
                }
                
                Remove-Item $installerPath -Force -ErrorAction SilentlyContinue
                
                # 等待安装完成
                Start-Sleep -Seconds 3
                
                # 检查是否安装成功
                $foundPath = Test-BrowserExists $browser
                if ($foundPath) {
                    Write-Host "[✓] $($browser.Name) 安装完成" -ForegroundColor Green
                } else {
                    Write-Host "[!] $($browser.Name) 安装完成，但未在预期位置找到" -ForegroundColor Yellow
                }
            } catch {
                Write-Host "[✗] $($browser.Name) 安装失败: $_" -ForegroundColor Red
                Remove-Item $installerPath -Force -ErrorAction SilentlyContinue
            }
        } else {
            Write-Host "[!] $($browser.Name) 未安装（系统预装）" -ForegroundColor Yellow
        }
    } else {
        Write-Host "[✓] $($browser.Name) 已安装" -ForegroundColor Green
    }
}

Start-Sleep -Seconds 3

# ══════════════════════════════════════════════════════════════════
#  架构级优化
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[步骤 3/3] 架构级优化..." -ForegroundColor Cyan

Write-Host "`n[*] 关闭所有浏览器..." -ForegroundColor Yellow
Get-Process chrome,firefox,msedge,brave,opera,vivaldi,librewolf -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 3

# Chrome 优化
function Optimize-Chrome {
    Write-Host "`n[Chrome] Chromium 原生架构优化..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # 性能优化
    Set-ItemProperty -Path $regPath -Name "V8CacheOptions" -Value 2 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "DiskCacheSize" -Value 104857600 -Type DWord -Force
    
    # 隐私和安全优化
    Set-ItemProperty -Path $regPath -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SpellCheckServiceEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SearchSuggestEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "DNSPrefetchingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SafeBrowsingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "PasswordManagerEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "UrlKeyedAnonymizedDataCollectionEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "UserFeedbackAllowed" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "ChromeCleanupEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "ChromeCleanupReportingEnabled" -Value 0 -Type DWord -Force
    
    # 禁用默认浏览器检查和提示
    Set-ItemProperty -Path $regPath -Name "DefaultBrowserSettingEnabled" -Value 0 -Type DWord -Force
    
    # 书签栏默认显示
    Set-ItemProperty -Path $regPath -Name "BookmarkBarEnabled" -Value 1 -Type DWord -Force
    
    # 主页和新标签页设置为空白页
    Set-ItemProperty -Path $regPath -Name "HomepageIsNewTabPage" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "NewTabPageLocation" -Value "about:blank" -Type String -Force
    Set-ItemProperty -Path $regPath -Name "RestoreOnStartup" -Value 5 -Type DWord -Force
    
    # 禁用新闻、广告、促销
    Set-ItemProperty -Path $regPath -Name "PromotionalTabsEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "ShowCastIconInToolbar" -Value 0 -Type DWord -Force
    
    # 增强追踪保护
    Set-ItemProperty -Path $regPath -Name "BlockThirdPartyCookies" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "EnableMediaRouter" -Value 0 -Type DWord -Force
    
    # WebRTC IP泄漏防护
    Set-ItemProperty -Path $regPath -Name "WebRtcIPHandling" -Value "default_public_interface_only" -Type String -Force
    
    $script:reportData += @{Browser="Chrome"; Method="注册表策略"; Features="V8引擎优化、硬件加速、极致隐私"; Status="✓"}
    Write-Host "[✓] Chrome 优化完成" -ForegroundColor Green
}

# Chromium 优化
function Optimize-Chromium {
    Write-Host "`n[Chromium] 开源版优化..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\Chromium"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # 性能优化
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "DiskCacheSize" -Value 104857600 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    
    # 禁用默认浏览器检查
    Set-ItemProperty -Path $regPath -Name "DefaultBrowserSettingEnabled" -Value 0 -Type DWord -Force
    
    # 书签栏默认显示
    Set-ItemProperty -Path $regPath -Name "BookmarkBarEnabled" -Value 1 -Type DWord -Force
    
    # 主页和新标签页设置
    Set-ItemProperty -Path $regPath -Name "HomepageIsNewTabPage" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "NewTabPageLocation" -Value "about:blank" -Type String -Force
    Set-ItemProperty -Path $regPath -Name "RestoreOnStartup" -Value 5 -Type DWord -Force
    
    # 隐私保护
    Set-ItemProperty -Path $regPath -Name "BlockThirdPartyCookies" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "DNSPrefetchingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SafeBrowsingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "PasswordManagerEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "PromotionalTabsEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "WebRtcIPHandling" -Value "default_public_interface_only" -Type String -Force
    
    $script:reportData += @{Browser="Chromium"; Method="注册表策略"; Features="开源版、无遥测、极致隐私"; Status="✓"}
    Write-Host "[✓] Chromium 优化完成" -ForegroundColor Green
}

# Firefox 优化
function Optimize-Firefox {
    Write-Host "`n[Firefox] Gecko 引擎架构优化..." -ForegroundColor Cyan
    
    $profilePath = "$env:APPDATA\Mozilla\Firefox\Profiles"
    if (-not (Test-Path $profilePath)) {
        Write-Host "[!] Firefox 配置目录不存在" -ForegroundColor Yellow
        return
    }
    
    $profiles = Get-ChildItem -Path $profilePath -Directory
    foreach ($profile in $profiles) {
        $userFile = "$($profile.FullName)\user.js"
        
        $prefs = @"
// ═══════════════════════════════════════════════════════════
// Gecko 引擎性能优化
// ═══════════════════════════════════════════════════════════
user_pref("browser.cache.disk.capacity", 102400);
user_pref("browser.cache.memory.capacity", 51200);
user_pref("network.http.max-connections", 256);
user_pref("gfx.webrender.all", true);
user_pref("layers.acceleration.force-enabled", true);

// ═══════════════════════════════════════════════════════════
// 书签栏和主页设置
// ═══════════════════════════════════════════════════════════
user_pref("browser.toolbars.bookmarks.visibility", "always");
user_pref("browser.startup.homepage", "about:blank");
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.startup.page", 1);

// ═══════════════════════════════════════════════════════════
// 禁用默认浏览器检查
// ═══════════════════════════════════════════════════════════
user_pref("browser.shell.checkDefaultBrowser", false);

// ═══════════════════════════════════════════════════════════
// 书签在新标签页打开
// ═══════════════════════════════════════════════════════════
user_pref("browser.tabs.loadBookmarksInTabs", true);

// ═══════════════════════════════════════════════════════════
// 禁用新闻、广告、推荐
// ═══════════════════════════════════════════════════════════
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);

// ═══════════════════════════════════════════════════════════
// 隐私和追踪保护
// ═══════════════════════════════════════════════════════════
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.donottrackheader.enabled", true);
user_pref("privacy.resistFingerprinting", false);
user_pref("privacy.firstparty.isolate", true);
user_pref("webgl.disabled", false);
user_pref("media.peerconnection.enabled", false);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.prefetch-next", false);
user_pref("beacon.enabled", false);

// ═══════════════════════════════════════════════════════════
// 禁用遥测和数据收集
// ═══════════════════════════════════════════════════════════
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.archive.enabled", false);

// ═══════════════════════════════════════════════════════════
// 双击关闭标签页
// ═══════════════════════════════════════════════════════════
user_pref("browser.tabs.closeTabByDblclick", true);
"@
        
        $prefs | Out-File -FilePath $userFile -Encoding UTF8 -Force
    }
    
    $script:reportData += @{Browser="Firefox"; Method="user.js配置"; Features="Gecko引擎、WebRender、极致隐私"; Status="✓"}
    Write-Host "[✓] Firefox 优化完成" -ForegroundColor Green
}

# Edge 优化
function Optimize-Edge {
    Write-Host "`n[Edge] Chromium + Microsoft 服务优化..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # 禁用 Microsoft 特有服务
    Set-ItemProperty -Path $regPath -Name "StartupBoostEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "EdgeShoppingAssistantEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "EdgeCollectionsEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "EdgeEnhanceImagesEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "EdgeAssetDeliveryServiceEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "PersonalizationReportingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "ShowMicrosoftRewards" -Value 0 -Type DWord -Force
    
    # 性能优化
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    
    # 隐私和追踪保护
    Set-ItemProperty -Path $regPath -Name "TrackingPrevention" -Value 2 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "BlockThirdPartyCookies" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "DNSInterceptionChecksEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "ResolveNavigationErrorsUseWebService" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "AlternateErrorPagesEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SpellcheckEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SearchSuggestEnabled" -Value 0 -Type DWord -Force
    
    # 禁用默认浏览器检查
    Set-ItemProperty -Path $regPath -Name "DefaultBrowserSettingEnabled" -Value 0 -Type DWord -Force
    
    # 书签栏默认显示
    Set-ItemProperty -Path $regPath -Name "FavoritesBarEnabled" -Value 1 -Type DWord -Force
    
    # 主页和新标签页设置
    Set-ItemProperty -Path $regPath -Name "HomepageIsNewTabPage" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "NewTabPageLocation" -Value "about:blank" -Type String -Force
    Set-ItemProperty -Path $regPath -Name "RestoreOnStartup" -Value 5 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "NewTabPageContentEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "NewTabPageQuickLinksEnabled" -Value 0 -Type DWord -Force
    
    # 禁用新闻和促销
    Set-ItemProperty -Path $regPath -Name "PromotionalTabsEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "ShowCastIconInToolbar" -Value 0 -Type DWord -Force
    
    # WebRTC IP泄漏防护
    Set-ItemProperty -Path $regPath -Name "WebRtcIPHandling" -Value "default_public_interface_only" -Type String -Force
    
    # 双击关闭标签页
    Set-ItemProperty -Path $regPath -Name "DoubleClickCloseTabEnabled" -Value 1 -Type DWord -Force
    
    $script:reportData += @{Browser="Edge"; Method="Microsoft注册表"; Features="禁用所有MS服务、极致隐私、双击关闭"; Status="✓"}
    Write-Host "[✓] Edge 优化完成" -ForegroundColor Green
}

# Brave 优化
function Optimize-Brave {
    Write-Host "`n[Brave] Chromium + 内置隐私层优化..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # 性能优化
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    
    # 禁用默认浏览器检查
    Set-ItemProperty -Path $regPath -Name "DefaultBrowserSettingEnabled" -Value 0 -Type DWord -Force
    
    # 书签栏默认显示
    Set-ItemProperty -Path $regPath -Name "BookmarkBarEnabled" -Value 1 -Type DWord -Force
    
    # 主页和新标签页设置
    Set-ItemProperty -Path $regPath -Name "HomepageIsNewTabPage" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "NewTabPageLocation" -Value "about:blank" -Type String -Force
    Set-ItemProperty -Path $regPath -Name "RestoreOnStartup" -Value 5 -Type DWord -Force
    
    # 隐私保护
    Set-ItemProperty -Path $regPath -Name "BlockThirdPartyCookies" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "DNSPrefetchingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SafeBrowsingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "PasswordManagerEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "PromotionalTabsEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "WebRtcIPHandling" -Value "default_public_interface_only" -Type String -Force
    
    $script:reportData += @{Browser="Brave"; Method="注册表策略"; Features="内置Shields、极致隐私"; Status="✓"}
    Write-Host "[✓] Brave 优化完成" -ForegroundColor Green
}

# Opera 优化
function Optimize-Opera {
    Write-Host "`n[Opera] Chromium + 内置VPN优化..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\Opera Software\Opera Stable"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # 性能优化
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    
    # 禁用默认浏览器检查
    Set-ItemProperty -Path $regPath -Name "DefaultBrowserSettingEnabled" -Value 0 -Type DWord -Force
    
    # 书签栏默认显示
    Set-ItemProperty -Path $regPath -Name "BookmarkBarEnabled" -Value 1 -Type DWord -Force
    
    # 主页和新标签页设置
    Set-ItemProperty -Path $regPath -Name "HomepageIsNewTabPage" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "NewTabPageLocation" -Value "about:blank" -Type String -Force
    Set-ItemProperty -Path $regPath -Name "RestoreOnStartup" -Value 5 -Type DWord -Force
    
    # 隐私保护
    Set-ItemProperty -Path $regPath -Name "BlockThirdPartyCookies" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "DNSPrefetchingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SafeBrowsingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "PasswordManagerEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "PromotionalTabsEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "WebRtcIPHandling" -Value "default_public_interface_only" -Type String -Force
    
    $script:reportData += @{Browser="Opera"; Method="注册表策略"; Features="内置VPN、极致隐私"; Status="✓"}
    Write-Host "[✓] Opera 优化完成" -ForegroundColor Green
}

# Vivaldi 优化
function Optimize-Vivaldi {
    Write-Host "`n[Vivaldi] Chromium + 高度定制UI优化..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\Vivaldi"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # 性能优化
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    
    # 禁用默认浏览器检查
    Set-ItemProperty -Path $regPath -Name "DefaultBrowserSettingEnabled" -Value 0 -Type DWord -Force
    
    # 书签栏默认显示
    Set-ItemProperty -Path $regPath -Name "BookmarkBarEnabled" -Value 1 -Type DWord -Force
    
    # 主页和新标签页设置
    Set-ItemProperty -Path $regPath -Name "HomepageIsNewTabPage" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "NewTabPageLocation" -Value "about:blank" -Type String -Force
    Set-ItemProperty -Path $regPath -Name "RestoreOnStartup" -Value 5 -Type DWord -Force
    
    # 隐私保护
    Set-ItemProperty -Path $regPath -Name "BlockThirdPartyCookies" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "DNSPrefetchingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SafeBrowsingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "PasswordManagerEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "PromotionalTabsEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "WebRtcIPHandling" -Value "default_public_interface_only" -Type String -Force
    
    # Vivaldi 双击关闭配置
    $vivaldiPrefsPath = "$env:LOCALAPPDATA\Vivaldi\User Data\Default\Preferences"
    if (Test-Path $vivaldiPrefsPath) {
        try {
            $prefs = Get-Content $vivaldiPrefsPath -Raw | ConvertFrom-Json
            if (-not $prefs.vivaldi) { $prefs | Add-Member -MemberType NoteProperty -Name "vivaldi" -Value @{} }
            if (-not $prefs.vivaldi.tabs) { $prefs.vivaldi | Add-Member -MemberType NoteProperty -Name "tabs" -Value @{} }
            $prefs.vivaldi.tabs.close_on_double_click = $true
            $prefs | ConvertTo-Json -Depth 100 | Set-Content $vivaldiPrefsPath -Force
        } catch {
            Write-Host "[!] Vivaldi Preferences 配置失败，跳过" -ForegroundColor Yellow
        }
    }
    
    $script:reportData += @{Browser="Vivaldi"; Method="注册表+配置文件"; Features="双击关闭、极致隐私"; Status="✓"}
    Write-Host "[✓] Vivaldi 优化完成" -ForegroundColor Green
}

# LibreWolf 优化
function Optimize-LibreWolf {
    Write-Host "`n[LibreWolf] Firefox ESR + 极致隐私优化..." -ForegroundColor Cyan
    
    $profilePath = "$env:APPDATA\LibreWolf\Profiles"
    if (-not (Test-Path $profilePath)) {
        Write-Host "[!] LibreWolf 配置目录不存在" -ForegroundColor Yellow
        $script:reportData += @{Browser="LibreWolf"; Method="未配置"; Features="N/A"; Status="⚠"}
        return
    }
    
    $profiles = Get-ChildItem -Path $profilePath -Directory
    foreach ($profile in $profiles) {
        $userFile = "$($profile.FullName)\user.js"
        
        $prefs = @"
// ═══════════════════════════════════════════════════════════
// LibreWolf 性能优化
// ═══════════════════════════════════════════════════════════
user_pref("browser.cache.disk.capacity", 102400);
user_pref("browser.cache.memory.capacity", 51200);
user_pref("network.http.max-connections", 256);
user_pref("gfx.webrender.all", true);
user_pref("layers.acceleration.force-enabled", true);

// ═══════════════════════════════════════════════════════════
// 书签栏和主页设置
// ═══════════════════════════════════════════════════════════
user_pref("browser.toolbars.bookmarks.visibility", "always");
user_pref("browser.startup.homepage", "about:blank");
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.startup.page", 1);

// ═══════════════════════════════════════════════════════════
// 禁用默认浏览器检查
// ═══════════════════════════════════════════════════════════
user_pref("browser.shell.checkDefaultBrowser", false);

// ═══════════════════════════════════════════════════════════
// 书签在新标签页打开
// ═══════════════════════════════════════════════════════════
user_pref("browser.tabs.loadBookmarksInTabs", true);

// ═══════════════════════════════════════════════════════════
// 禁用新闻、广告、推荐
// ═══════════════════════════════════════════════════════════
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);

// ═══════════════════════════════════════════════════════════
// 隐私保护（LibreWolf已预配置，这里微调）
// ═══════════════════════════════════════════════════════════
user_pref("privacy.resistFingerprinting", false);
user_pref("webgl.disabled", false);
user_pref("media.peerconnection.enabled", false);

// ═══════════════════════════════════════════════════════════
// 双击关闭标签页
// ═══════════════════════════════════════════════════════════
user_pref("browser.tabs.closeTabByDblclick", true);
"@
        
        $prefs | Out-File -FilePath $userFile -Encoding UTF8 -Force
    }
    
    $script:reportData += @{Browser="LibreWolf"; Method="user.js配置"; Features="Firefox ESR、极致隐私、双击关闭"; Status="✓"}
    Write-Host "[✓] LibreWolf 优化完成" -ForegroundColor Green
}

# 执行优化
Optimize-Chrome
Optimize-Chromium
Optimize-Firefox
Optimize-Edge
Optimize-Brave
Optimize-Opera
Optimize-Vivaldi
Optimize-LibreWolf

# ══════════════════════════════════════════════════════════════════
#  生成启动脚本
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[*] 生成启动脚本..." -ForegroundColor Yellow

if (-not (Test-Path $baseDir)) { New-Item -ItemType Directory -Path $baseDir -Force | Out-Null }

$browserConfigs = @(
    @{Name="Chrome"; Exe="C:\Program Files\Google\Chrome\Application\chrome.exe"; Port=7891; Timezone="America/New_York"},
    @{Name="Chromium"; Exe="$env:LOCALAPPDATA\Chromium\Application\chrome.exe"; Port=7892; Timezone="America/Chicago"},
    @{Name="Firefox"; Exe="C:\Program Files\Mozilla Firefox\firefox.exe"; Port=7893; Timezone="America/Denver"},
    @{Name="Edge"; Exe="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"; Port=7894; Timezone="America/Los_Angeles"},
    @{Name="Brave"; Exe="C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"; Port=7895; Timezone="America/Phoenix"},
    @{Name="Opera"; Exe="$env:LOCALAPPDATA\Programs\Opera\opera.exe"; Port=7896; Timezone="America/Anchorage"},
    @{Name="Vivaldi"; Exe="$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe"; Port=7897; Timezone="Pacific/Honolulu"},
    @{Name="LibreWolf"; Exe="C:\Program Files\LibreWolf\librewolf.exe"; Port=7898; Timezone="America/Boise"}
)

foreach ($config in $browserConfigs) {
    $exePath = $ExecutionContext.InvokeCommand.ExpandString($config.Exe)
    if (Test-Path $exePath) {
        $profileDir = "$baseDir\$($config.Name)"
        if (-not (Test-Path $profileDir)) { New-Item -ItemType Directory -Path $profileDir -Force | Out-Null }
        
        # 生成真实的美国用户指纹参数
        $index = [array]::IndexOf($browserConfigs.Name, $config.Name)
        $resolutions = @(
            @{W=1920;H=1080;S=1.0}, @{W=1366;H=768;S=1.0}, @{W=2560;H=1440;S=1.0}, @{W=1536;H=864;S=1.25},
            @{W=1440;H=900;S=1.0}, @{W=1600;H=900;S=1.0}, @{W=3840;H=2160;S=1.5}, @{W=2880;H=1800;S=2.0}
        )
        $res = $resolutions[$index % $resolutions.Count]
        
        # 复制指纹保护脚本到浏览器配置目录
        $scriptSource = "$PSScriptRoot\canvas_fingerprint_protection.js"
        if (Test-Path $scriptSource) {
            Copy-Item -Path $scriptSource -Destination "$profileDir\fingerprint_protection.js" -Force
        }
        
        $launchScript = "$baseDir\Launch_$($config.Name).bat"
        @"
@echo off
start "" "$exePath" --user-data-dir="$profileDir" --proxy-server=127.0.0.1:$($config.Port) --timezone="$($config.Timezone)" --disable-blink-features=AutomationControlled --window-size=$($res.W),$($res.H) --force-device-scale-factor=$($res.S) --lang=en-US --no-first-run --no-default-browser-check --disable-features=IsolateOrigins,site-per-process --disable-site-isolation-trials
"@ | Out-File -FilePath $launchScript -Encoding ASCII -Force
    }
}

# 统一启动脚本
$masterLaunch = "$baseDir\Launch_All.bat"
$launchContent = "@echo off`r`n"
foreach ($config in $browserConfigs) {
    $exePath = $ExecutionContext.InvokeCommand.ExpandString($config.Exe)
    if (Test-Path $exePath) {
        $launchContent += "start """" ""$baseDir\Launch_$($config.Name).bat""`r`n"
        $launchContent += "timeout /t 2 /nobreak >nul`r`n"
    }
}
$launchContent | Out-File -FilePath $masterLaunch -Encoding ASCII -Force

# ══════════════════════════════════════════════════════════════════
#  生成HTML报告
# ══════════════════════════════════════════════════════════════════

$htmlReport = @"
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>8浏览器部署完成</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; }
        .container { max-width: 1400px; margin: 0 auto; background: white; border-radius: 20px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 40px; text-align: center; }
        .header h1 { font-size: 2.5em; }
        .content { padding: 40px; }
        .browser-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }
        .browser-card { background: #f8f9fa; border-radius: 15px; padding: 25px; border-left: 5px solid #667eea; }
        .browser-card h3 { color: #333; margin-bottom: 15px; }
        .status { background: #28a745; color: white; padding: 5px 15px; border-radius: 20px; }
        .launch-button { display: inline-block; background: #667eea; color: white; padding: 15px 30px; border-radius: 10px; text-decoration: none; margin: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🎉 8浏览器部署完成</h1>
            <p>Chrome + Chromium + Firefox + Edge + Brave + Opera + Vivaldi + LibreWolf</p>
        </div>
        <div class="content">
            <h2>📊 优化概览</h2>
            <div class="browser-grid">
$(foreach ($item in $reportData) {
"                <div class='browser-card'>
                    <h3>$($item.Browser)</h3>
                    <p><strong>方法：</strong>$($item.Method)</p>
                    <p><strong>特性：</strong>$($item.Features)</p>
                    <span class='status'>$($item.Status)</span>
                </div>"
})
            </div>
            <h2 style="margin-top: 40px;">🚀 启动浏览器</h2>
            <a href="file:///C:/BrowserProfiles/Launch_All.bat" class="launch-button">启动所有浏览器</a>
            <a href="file:///C:/BrowserProfiles/" class="launch-button">打开配置目录</a>
            <h2 style="margin-top: 40px;">📝 代理端口分配</h2>
            <ul style="line-height: 2;">
                <li>Chrome: 7891 (America/New_York)</li>
                <li>Chromium: 7892 (America/Chicago)</li>
                <li>Firefox: 7893 (America/Denver)</li>
                <li>Edge: 7894 (America/Los_Angeles)</li>
                <li>Brave: 7895 (America/Phoenix)</li>
                <li>Opera: 7896 (America/Anchorage)</li>
                <li>Vivaldi: 7897 (Pacific/Honolulu)</li>
                <li>LibreWolf: 7898 (America/Boise)</li>
            </ul>
        </div>
    </div>
</body>
</html>
"@

$reportPath = "$baseDir\8浏览器部署报告.html"
$htmlReport | Out-File -FilePath $reportPath -Encoding UTF8 -Force

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  完成！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "`n[✓] HTML报告: $reportPath" -ForegroundColor Yellow
Write-Host "[*] 正在打开报告..." -ForegroundColor Yellow

Start-Process $reportPath
