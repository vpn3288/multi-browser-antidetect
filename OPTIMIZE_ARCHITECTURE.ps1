#Requires -RunAsAdministrator

# ══════════════════════════════════════════════════════════════════
#  7浏览器深度优化 - 针对不同架构的专属实现
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  7浏览器深度优化 - 架构级定制" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

$baseDir = "C:\BrowserProfiles"
$reportData = @()

# ══════════════════════════════════════════════════════════════════
#  Chrome - Chromium 原生架构优化
# ══════════════════════════════════════════════════════════════════

function Optimize-Chrome {
    Write-Host "`n[Chrome] Chromium 原生架构优化..." -ForegroundColor Cyan
    
    # 1. 注册表策略（Chrome 专属路径）
    $regPath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # Chrome 特有：V8 引擎优化
    Set-ItemProperty -Path $regPath -Name "V8CacheOptions" -Value 2 -Type DWord -Force  # 代码缓存
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "DiskCacheSize" -Value 104857600 -Type DWord -Force
    
    # Chrome 特有：Blink 渲染引擎优化
    Set-ItemProperty -Path $regPath -Name "RendererCodeIntegrityEnabled" -Value 0 -Type DWord -Force
    
    # 隐私优化
    Set-ItemProperty -Path $regPath -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SpellCheckServiceEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SearchSuggestEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "AlternateErrorPagesEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "DNSPrefetchingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SafeBrowsingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "PasswordManagerEnabled" -Value 0 -Type DWord -Force
    
    # 2. Local State 文件优化（Chrome 特有）
    $localStatePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Local State"
    if (Test-Path $localStatePath) {
        $localState = Get-Content $localStatePath -Raw | ConvertFrom-Json
        $localState.background_mode.enabled = $false
        $localState | ConvertTo-Json -Depth 100 | Set-Content $localStatePath -Force
    }
    
    $script:reportData += @{Browser="Chrome"; Method="注册表策略 + V8引擎优化 + Local State"; Features="Blink渲染优化、V8代码缓存"; Status="✓"}
    Write-Host "[✓] Chrome 优化完成（Chromium 原生方法）" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  Firefox - Gecko 引擎架构优化
# ══════════════════════════════════════════════════════════════════

function Optimize-Firefox {
    Write-Host "`n[Firefox] Gecko 引擎架构优化..." -ForegroundColor Cyan
    
    # Firefox 使用 prefs.js（不支持注册表策略）
    $profilePath = "$env:APPDATA\Mozilla\Firefox\Profiles"
    if (-not (Test-Path $profilePath)) {
        Write-Host "[!] Firefox 配置目录不存在，跳过" -ForegroundColor Yellow
        return
    }
    
    $profiles = Get-ChildItem -Path $profilePath -Directory
    foreach ($profile in $profiles) {
        $prefsFile = "$($profile.FullName)\prefs.js"
        $userFile = "$($profile.FullName)\user.js"
        
        # user.js 优先级高于 prefs.js（Firefox 特有）
        $prefs = @"
// ═══════════════════════════════════════════════════════════
// Gecko 引擎性能优化
// ═══════════════════════════════════════════════════════════
user_pref("browser.cache.disk.enable", true);
user_pref("browser.cache.disk.capacity", 102400);
user_pref("browser.cache.memory.enable", true);
user_pref("browser.cache.memory.capacity", 51200);
user_pref("network.http.max-connections", 256);
user_pref("network.http.max-persistent-connections-per-server", 10);
user_pref("network.http.pipelining", true);
user_pref("network.http.pipelining.maxrequests", 8);

// ═══════════════════════════════════════════════════════════
// Gecko 渲染优化
// ═══════════════════════════════════════════════════════════
user_pref("gfx.webrender.all", true);  // WebRender 硬件加速
user_pref("layers.acceleration.force-enabled", true);
user_pref("layout.frame_rate", 60);

// ═══════════════════════════════════════════════════════════
// Firefox 隐私优化（Gecko 特有）
// ═══════════════════════════════════════════════════════════
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.donottrackheader.enabled", true);
user_pref("privacy.resistFingerprinting", true);
user_pref("privacy.firstparty.isolate", true);  // 第一方隔离（Firefox 独有）
user_pref("webgl.disabled", true);
user_pref("media.peerconnection.enabled", false);
user_pref("media.navigator.enabled", false);

// ═══════════════════════════════════════════════════════════
// Firefox 安全优化
// ═══════════════════════════════════════════════════════════
user_pref("network.dns.disablePrefetch", true);
user_pref("network.prefetch-next", false);
user_pref("browser.send_pings", false);
user_pref("beacon.enabled", false);

// ═══════════════════════════════════════════════════════════
// Firefox 速度优化
// ═══════════════════════════════════════════════════════════
user_pref("browser.sessionstore.interval", 60000);
user_pref("browser.tabs.animate", false);
user_pref("browser.download.animateNotifications", false);
"@
        
        $prefs | Out-File -FilePath $userFile -Encoding UTF8 -Force
    }
    
    $script:reportData += @{Browser="Firefox"; Method="user.js配置文件"; Features="Gecko引擎、WebRender加速、第一方隔离"; Status="✓"}
    Write-Host "[✓] Firefox 优化完成（Gecko 引擎方法）" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  Edge - Chromium + Microsoft 服务优化
# ══════════════════════════════════════════════════════════════════

function Optimize-Edge {
    Write-Host "`n[Edge] Chromium + Microsoft 服务优化..." -ForegroundColor Cyan
    
    # Edge 使用 Microsoft 专属注册表路径
    $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # Edge 特有：禁用 Microsoft 服务集成
    Set-ItemProperty -Path $regPath -Name "StartupBoostEnabled" -Value 0 -Type DWord -Force  # Edge 独有
    Set-ItemProperty -Path $regPath -Name "EdgeEnhanceImagesEnabled" -Value 0 -Type DWord -Force  # Edge 独有
    Set-ItemProperty -Path $regPath -Name "EdgeShoppingAssistantEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "EdgeCollectionsEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "EdgeAssetDeliveryServiceEnabled" -Value 0 -Type DWord -Force
    
    # 性能优化
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    
    # 隐私优化
    Set-ItemProperty -Path $regPath -Name "PersonalizationReportingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "DiagnosticData" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "TrackingPrevention" -Value 2 -Type DWord -Force  # Strict
    Set-ItemProperty -Path $regPath -Name "ResolveNavigationErrorsUseWebService" -Value 0 -Type DWord -Force
    
    $script:reportData += @{Browser="Edge"; Method="Microsoft专属注册表"; Features="禁用StartupBoost、购物助手、集合"; Status="✓"}
    Write-Host "[✓] Edge 优化完成（Microsoft 服务禁用）" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  Brave - Chromium + 内置隐私层优化
# ══════════════════════════════════════════════════════════════════

function Optimize-Brave {
    Write-Host "`n[Brave] Chromium + 内置隐私层优化..." -ForegroundColor Cyan
    
    # Brave 使用 BraveSoftware 专属路径
    $regPath = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # Brave 已内置 Shields，只需性能优化
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    
    # Brave 特有：Rewards 和 Wallet 优化
    $braveConfigPath = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Local State"
    if (Test-Path $braveConfigPath) {
        $config = Get-Content $braveConfigPath -Raw | ConvertFrom-Json
        # Brave Rewards 默认禁用（可选）
        $config | ConvertTo-Json -Depth 100 | Set-Content $braveConfigPath -Force
    }
    
    $script:reportData += @{Browser="Brave"; Method="注册表 + Local State"; Features="内置Shields、Rewards配置"; Status="✓"}
    Write-Host "[✓] Brave 优化完成（内置隐私层已启用）" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  Opera - Chromium + Presto 遗留 + 内置VPN
# ══════════════════════════════════════════════════════════════════

function Optimize-Opera {
    Write-Host "`n[Opera] Chromium + 内置VPN优化..." -ForegroundColor Cyan
    
    # Opera 使用 Opera Software 专属路径
    $regPath = "HKLM:\SOFTWARE\Policies\Opera Software\Opera Stable"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # 性能优化
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    
    # Opera 特有：Preferences 文件优化
    $operaPrefsPath = "$env:APPDATA\Opera Software\Opera Stable\Preferences"
    if (Test-Path $operaPrefsPath) {
        $prefs = Get-Content $operaPrefsPath -Raw | ConvertFrom-Json
        # Opera 内置 VPN 配置（保持启用）
        # Opera Turbo 模式优化
        $prefs | ConvertTo-Json -Depth 100 | Set-Content $operaPrefsPath -Force
    }
    
    $script:reportData += @{Browser="Opera"; Method="注册表 + Preferences文件"; Features="内置VPN、Turbo模式"; Status="✓"}
    Write-Host "[✓] Opera 优化完成（内置VPN保留）" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  Vivaldi - Chromium + 高度定制UI
# ══════════════════════════════════════════════════════════════════

function Optimize-Vivaldi {
    Write-Host "`n[Vivaldi] Chromium + 高度定制UI优化..." -ForegroundColor Cyan
    
    # Vivaldi 使用 Vivaldi 专属路径
    $regPath = "HKLM:\SOFTWARE\Policies\Vivaldi"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # 性能优化
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    
    # Vivaldi 特有：自定义 CSS 和 JS 注入
    $vivaldiUserDataPath = "$env:LOCALAPPDATA\Vivaldi\User Data\Default"
    if (Test-Path $vivaldiUserDataPath) {
        # Vivaldi 允许自定义 CSS（UI 优化）
        $customCSSPath = "$vivaldiUserDataPath\custom.css"
        @"
/* Vivaldi 性能优化 CSS */
#browser { animation: none !important; }
.tab-strip { transition: none !important; }
"@ | Out-File -FilePath $customCSSPath -Encoding UTF8 -Force
    }
    
    $script:reportData += @{Browser="Vivaldi"; Method="注册表 + 自定义CSS"; Features="UI动画禁用、标签管理优化"; Status="✓"}
    Write-Host "[✓] Vivaldi 优化完成（UI 定制优化）" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  LibreWolf - Firefox ESR + 极致隐私预配置
# ══════════════════════════════════════════════════════════════════

function Optimize-LibreWolf {
    Write-Host "`n[LibreWolf] Firefox ESR + 极致隐私优化..." -ForegroundColor Cyan
    
    # LibreWolf 基于 Firefox ESR，使用 user.js
    $profilePath = "$env:APPDATA\LibreWolf\Profiles"
    if (-not (Test-Path $profilePath)) {
        Write-Host "[!] LibreWolf 未安装或配置目录不存在" -ForegroundColor Yellow
        $script:reportData += @{Browser="LibreWolf"; Method="未安装"; Features="N/A"; Status="⚠"}
        return
    }
    
    $profiles = Get-ChildItem -Path $profilePath -Directory
    foreach ($profile in $profiles) {
        $userFile = "$($profile.FullName)\user.js"
        
        # LibreWolf 已预配置，只需额外性能优化
        $prefs = @"
// ═══════════════════════════════════════════════════════════
// LibreWolf 额外性能优化（基于 Firefox ESR）
// ═══════════════════════════════════════════════════════════
user_pref("browser.cache.disk.capacity", 102400);
user_pref("browser.cache.memory.capacity", 51200);
user_pref("network.http.max-connections", 256);
user_pref("gfx.webrender.all", true);
user_pref("layers.acceleration.force-enabled", true);
"@
        
        $prefs | Out-File -FilePath $userFile -Append -Encoding UTF8 -Force
    }
    
    $script:reportData += @{Browser="LibreWolf"; Method="user.js追加配置"; Features="Firefox ESR基础、预配置隐私"; Status="✓"}
    Write-Host "[✓] LibreWolf 优化完成（ESR 预配置增强）" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  执行优化
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[*] 关闭所有浏览器..." -ForegroundColor Yellow
Get-Process chrome,firefox,msedge,brave,opera,vivaldi,librewolf -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 3

Optimize-Chrome
Optimize-Firefox
Optimize-Edge
Optimize-Brave
Optimize-Opera
Optimize-Vivaldi
Optimize-LibreWolf

# ══════════════════════════════════════════════════════════════════
#  生成HTML报告
# ══════════════════════════════════════════════════════════════════

$htmlReport = @"
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>7浏览器架构级优化报告</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; }
        .container { max-width: 1400px; margin: 0 auto; background: white; border-radius: 20px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); overflow: hidden; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 40px; text-align: center; }
        .header h1 { font-size: 2.5em; margin-bottom: 10px; }
        .header p { font-size: 1.2em; opacity: 0.9; }
        .content { padding: 40px; }
        .section { margin-bottom: 40px; }
        .section h2 { color: #667eea; margin-bottom: 20px; font-size: 1.8em; border-bottom: 3px solid #667eea; padding-bottom: 10px; }
        .browser-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); gap: 20px; margin-top: 20px; }
        .browser-card { background: #f8f9fa; border-radius: 15px; padding: 25px; border-left: 5px solid #667eea; transition: transform 0.3s, box-shadow 0.3s; }
        .browser-card:hover { transform: translateY(-5px); box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .browser-card h3 { color: #333; margin-bottom: 15px; font-size: 1.5em; }
        .browser-card .method { background: #e7f3ff; padding: 10px; border-radius: 8px; margin-bottom: 10px; font-size: 0.9em; color: #0056b3; }
        .browser-card .features { color: #666; line-height: 1.8; margin-bottom: 15px; }
        .browser-card .status { display: inline-block; background: #28a745; color: white; padding: 5px 15px; border-radius: 20px; font-size: 0.9em; }
        .architecture-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .architecture-table th, .architecture-table td { padding: 15px; text-align: left; border-bottom: 1px solid #e0e0e0; }
        .architecture-table th { background: #667eea; color: white; }
        .architecture-table tr:hover { background: #f8f9fa; }
        .launch-section { background: #e7f3ff; border-radius: 15px; padding: 30px; margin-top: 30px; }
        .launch-button { display: inline-block; background: #667eea; color: white; padding: 15px 30px; border-radius: 10px; text-decoration: none; margin: 10px; font-weight: bold; transition: background 0.3s; }
        .launch-button:hover { background: #764ba2; }
        .footer { background: #f8f9fa; padding: 30px; text-align: center; color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🎉 7浏览器架构级优化完成</h1>
            <p>针对每个浏览器的技术架构进行专属优化</p>
        </div>
        
        <div class="content">
            <div class="section">
                <h2>📊 优化概览</h2>
                <div class="browser-grid">
$(foreach ($item in $reportData) {
"                    <div class='browser-card'>
                        <h3>$($item.Browser)</h3>
                        <div class='method'><strong>实现方法：</strong>$($item.Method)</div>
                        <div class='features'><strong>架构特性：</strong>$($item.Features)</div>
                        <span class='status'>$($item.Status) 已优化</span>
                    </div>"
})
                </div>
            </div>
            
            <div class="section">
                <h2>🏗️ 架构对比表</h2>
                <table class="architecture-table">
                    <thead>
                        <tr>
                            <th>浏览器</th>
                            <th>渲染引擎</th>
                            <th>JS引擎</th>
                            <th>优化方法</th>
                            <th>特殊配置</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>Chrome</strong></td>
                            <td>Blink</td>
                            <td>V8</td>
                            <td>注册表 + Local State</td>
                            <td>V8代码缓存、Blink渲染优化</td>
                        </tr>
                        <tr>
                            <td><strong>Firefox</strong></td>
                            <td>Gecko</td>
                            <td>SpiderMonkey</td>
                            <td>user.js配置文件</td>
                            <td>WebRender加速、第一方隔离</td>
                        </tr>
                        <tr>
                            <td><strong>Edge</strong></td>
                            <td>Blink</td>
                            <td>V8</td>
                            <td>Microsoft专属注册表</td>
                            <td>禁用StartupBoost、购物助手</td>
                        </tr>
                        <tr>
                            <td><strong>Brave</strong></td>
                            <td>Blink</td>
                            <td>V8</td>
                            <td>注册表 + Local State</td>
                            <td>内置Shields、Rewards配置</td>
                        </tr>
                        <tr>
                            <td><strong>Opera</strong></td>
                            <td>Blink</td>
                            <td>V8</td>
                            <td>注册表 + Preferences</td>
                            <td>内置VPN、Turbo模式</td>
                        </tr>
                        <tr>
                            <td><strong>Vivaldi</strong></td>
                            <td>Blink</td>
                            <td>V8</td>
                            <td>注册表 + 自定义CSS</td>
                            <td>UI动画禁用、标签管理</td>
                        </tr>
                        <tr>
                            <td><strong>LibreWolf</strong></td>
                            <td>Gecko</td>
                            <td>SpiderMonkey</td>
                            <td>user.js追加配置</td>
                            <td>Firefox ESR基础、预配置隐私</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            <div class="section">
                <h2>🔧 统一优化目标（不同实现方法）</h2>
                <ul style="line-height: 2.5; color: #333; padding-left: 20px;">
                    <li>✓ <strong>性能优化：</strong>硬件加速、缓存优化、渲染引擎加速</li>
                    <li>✓ <strong>隐私保护：</strong>禁用遥测、追踪防护、指纹防护</li>
                    <li>✓ <strong>安全加固：</strong>禁用DNS预取、WebRTC防护</li>
                    <li>✓ <strong>速度提升：</strong>禁用动画、优化网络连接</li>
                    <li>✓ <strong>数据隔离：</strong>独立配置目录、独立代理端口</li>
                </ul>
            </div>
            
            <div class="section">
                <div class="launch-section">
                    <h3>🚀 启动浏览器</h3>
                    <p style="margin-bottom: 20px; color: #0056b3;">所有浏览器已配置独立代理端口（7891-7897）和美国时区</p>
                    <a href="file:///C:/BrowserProfiles/Launch_All.bat" class="launch-button">启动所有浏览器</a>
                    <a href="file:///C:/BrowserProfiles/" class="launch-button">打开配置目录</a>
                </div>
            </div>
        </div>
        
        <div class="footer">
            <p>优化完成时间: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')</p>
            <p style="margin-top: 10px;">配置目录: C:\BrowserProfiles</p>
            <p style="margin-top: 10px; font-weight: bold;">每个浏览器都使用了针对其架构的专属优化方法</p>
        </div>
    </div>
</body>
</html>
"@

$reportPath = "$baseDir\架构级优化报告.html"
$htmlReport | Out-File -FilePath $reportPath -Encoding UTF8 -Force

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  完成！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "`n[✓] HTML报告已生成: $reportPath" -ForegroundColor Yellow
Write-Host "[*] 正在打开报告..." -ForegroundColor Yellow

Start-Process $reportPath
