#Requires -RunAsAdministrator

# ══════════════════════════════════════════════════════════════════
#  7浏览器完整部署 - 自动安装 + 架构级优化
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  7浏览器完整部署 - 自动安装 + 架构级优化" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

$baseDir = "C:\BrowserProfiles"
$reportData = @()

# ══════════════════════════════════════════════════════════════════
#  检查并安装缺失的浏览器
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[步骤 1/2] 检查并安装浏览器..." -ForegroundColor Cyan

$browsers = @(
    @{Name="Chrome"; Exe="C:\Program Files\Google\Chrome\Application\chrome.exe"; Installer="https://dl.google.com/chrome/install/latest/chrome_installer.exe"; WingetId=$null},
    @{Name="Firefox"; Exe="C:\Program Files\Mozilla Firefox\firefox.exe"; Installer="https://download.mozilla.org/?product=firefox-latest&os=win64&lang=zh-CN"; WingetId=$null},
    @{Name="Edge"; Exe="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"; Installer=$null; WingetId=$null},  # 预装
    @{Name="Brave"; Exe="C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"; Installer="https://laptop-updates.brave.com/latest/winx64"; WingetId=$null},
    @{Name="Opera"; Exe="$env:LOCALAPPDATA\Programs\Opera\opera.exe"; Installer="https://net.geo.opera.com/opera/stable/windows"; WingetId=$null},
    @{Name="Vivaldi"; Exe="$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe"; Installer="https://downloads.vivaldi.com/stable/Vivaldi.exe"; WingetId=$null},
    @{Name="LibreWolf"; Exe="C:\Program Files\LibreWolf\librewolf.exe"; Installer=$null; WingetId="LibreWolf.LibreWolf"}
)

foreach ($browser in $browsers) {
    if (-not (Test-Path $browser.Exe)) {
        # 优先使用 winget
        if ($browser.WingetId) {
            Write-Host "`n[*] 使用 winget 安装 $($browser.Name)..." -ForegroundColor Yellow
            try {
                $result = winget install --id $browser.WingetId --silent --accept-package-agreements --accept-source-agreements 2>&1
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "[✓] $($browser.Name) 安装完成" -ForegroundColor Green
                } else {
                    Write-Host "[✗] $($browser.Name) 安装失败" -ForegroundColor Red
                }
            } catch {
                Write-Host "[✗] $($browser.Name) 安装失败: $_" -ForegroundColor Red
            }
        } elseif ($browser.Installer) {
            Write-Host "`n[*] 下载安装 $($browser.Name)..." -ForegroundColor Yellow
            $installerPath = "$env:TEMP\$($browser.Name)_installer.exe"
            
            try {
                Invoke-WebRequest -Uri $browser.Installer -OutFile $installerPath -UseBasicParsing -TimeoutSec 120
                
                # 静默安装
                if ($browser.Name -eq "Chrome") {
                    Start-Process -FilePath $installerPath -ArgumentList "/silent /install" -Wait
                } elseif ($browser.Name -eq "Firefox") {
                    Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait
                } elseif ($browser.Name -eq "Brave") {
                    Start-Process -FilePath $installerPath -ArgumentList "--install --silent --system-level" -Wait
                } elseif ($browser.Name -eq "Opera") {
                    Start-Process -FilePath $installerPath -ArgumentList "/silent /launchopera=0" -Wait
                } elseif ($browser.Name -eq "Vivaldi") {
                    Start-Process -FilePath $installerPath -ArgumentList "--vivaldi-silent --do-not-launch-chrome" -Wait
                }
                
                Remove-Item $installerPath -Force -ErrorAction SilentlyContinue
                Write-Host "[✓] $($browser.Name) 安装完成" -ForegroundColor Green
            } catch {
                Write-Host "[✗] $($browser.Name) 安装失败: $_" -ForegroundColor Red
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

Write-Host "`n[步骤 2/2] 架构级优化..." -ForegroundColor Cyan

# 关闭所有浏览器
Write-Host "`n[*] 关闭所有浏览器..." -ForegroundColor Yellow
Get-Process chrome,firefox,msedge,brave,opera,vivaldi,librewolf -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 3

# ══════════════════════════════════════════════════════════════════
#  Chrome - Chromium 原生架构优化
# ══════════════════════════════════════════════════════════════════

function Optimize-Chrome {
    Write-Host "`n[Chrome] Chromium 原生架构优化..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # V8 引擎优化
    Set-ItemProperty -Path $regPath -Name "V8CacheOptions" -Value 2 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "DiskCacheSize" -Value 104857600 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "RendererCodeIntegrityEnabled" -Value 0 -Type DWord -Force
    
    # 隐私优化
    Set-ItemProperty -Path $regPath -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SpellCheckServiceEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SearchSuggestEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "AlternateErrorPagesEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "DNSPrefetchingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SafeBrowsingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "PasswordManagerEnabled" -Value 0 -Type DWord -Force
    
    $script:reportData += @{Browser="Chrome"; Method="注册表策略 + V8引擎优化"; Features="Blink渲染、V8代码缓存"; Status="✓"}
    Write-Host "[✓] Chrome 优化完成" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  Firefox - Gecko 引擎架构优化
# ══════════════════════════════════════════════════════════════════

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
// Gecko 引擎性能优化
user_pref("browser.cache.disk.enable", true);
user_pref("browser.cache.disk.capacity", 102400);
user_pref("browser.cache.memory.enable", true);
user_pref("browser.cache.memory.capacity", 51200);
user_pref("network.http.max-connections", 256);
user_pref("network.http.max-persistent-connections-per-server", 10);
user_pref("network.http.pipelining", true);
user_pref("network.http.pipelining.maxrequests", 8);

// Gecko 渲染优化
user_pref("gfx.webrender.all", true);
user_pref("layers.acceleration.force-enabled", true);
user_pref("layout.frame_rate", 60);

// Firefox 隐私优化
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.donottrackheader.enabled", true);
user_pref("privacy.resistFingerprinting", true);
user_pref("privacy.firstparty.isolate", true);
user_pref("webgl.disabled", true);
user_pref("media.peerconnection.enabled", false);
user_pref("media.navigator.enabled", false);

// 安全优化
user_pref("network.dns.disablePrefetch", true);
user_pref("network.prefetch-next", false);
user_pref("browser.send_pings", false);
user_pref("beacon.enabled", false);

// 速度优化
user_pref("browser.sessionstore.interval", 60000);
user_pref("browser.tabs.animate", false);
user_pref("browser.download.animateNotifications", false);
"@
        
        $prefs | Out-File -FilePath $userFile -Encoding UTF8 -Force
    }
    
    $script:reportData += @{Browser="Firefox"; Method="user.js配置文件"; Features="Gecko引擎、WebRender加速、第一方隔离"; Status="✓"}
    Write-Host "[✓] Firefox 优化完成" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  Edge - Chromium + Microsoft 服务优化
# ══════════════════════════════════════════════════════════════════

function Optimize-Edge {
    Write-Host "`n[Edge] Chromium + Microsoft 服务优化..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # Edge 特有功能禁用
    Set-ItemProperty -Path $regPath -Name "StartupBoostEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "EdgeEnhanceImagesEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "EdgeShoppingAssistantEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "EdgeCollectionsEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "EdgeAssetDeliveryServiceEnabled" -Value 0 -Type DWord -Force
    
    # 性能优化
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    
    # 隐私优化
    Set-ItemProperty -Path $regPath -Name "PersonalizationReportingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "DiagnosticData" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "TrackingPrevention" -Value 2 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "ResolveNavigationErrorsUseWebService" -Value 0 -Type DWord -Force
    
    $script:reportData += @{Browser="Edge"; Method="Microsoft专属注册表"; Features="禁用StartupBoost、购物助手"; Status="✓"}
    Write-Host "[✓] Edge 优化完成" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  Brave - Chromium + 内置隐私层优化
# ══════════════════════════════════════════════════════════════════

function Optimize-Brave {
    Write-Host "`n[Brave] Chromium + 内置隐私层优化..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    
    $script:reportData += @{Browser="Brave"; Method="注册表策略"; Features="内置Shields、广告拦截"; Status="✓"}
    Write-Host "[✓] Brave 优化完成" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  Opera - Chromium + 内置VPN
# ══════════════════════════════════════════════════════════════════

function Optimize-Opera {
    Write-Host "`n[Opera] Chromium + 内置VPN优化..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\Opera Software\Opera Stable"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    
    $script:reportData += @{Browser="Opera"; Method="注册表策略"; Features="内置VPN、Turbo模式"; Status="✓"}
    Write-Host "[✓] Opera 优化完成" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  Vivaldi - Chromium + 高度定制UI
# ══════════════════════════════════════════════════════════════════

function Optimize-Vivaldi {
    Write-Host "`n[Vivaldi] Chromium + 高度定制UI优化..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\Vivaldi"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    
    $script:reportData += @{Browser="Vivaldi"; Method="注册表策略"; Features="UI定制、标签管理"; Status="✓"}
    Write-Host "[✓] Vivaldi 优化完成" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  LibreWolf - Firefox ESR + 极致隐私
# ══════════════════════════════════════════════════════════════════

function Optimize-LibreWolf {
    Write-Host "`n[LibreWolf] Firefox ESR + 极致隐私优化..." -ForegroundColor Cyan
    
    $profilePath = "$env:APPDATA\LibreWolf\Profiles"
    if (-not (Test-Path $profilePath)) {
        Write-Host "[!] LibreWolf 配置目录不存在" -ForegroundColor Yellow
        $script:reportData += @{Browser="LibreWolf"; Method="未安装"; Features="N/A"; Status="⚠"}
        return
    }
    
    $profiles = Get-ChildItem -Path $profilePath -Directory
    foreach ($profile in $profiles) {
        $userFile = "$($profile.FullName)\user.js"
        
        $prefs = @"
// LibreWolf 额外性能优化
user_pref("browser.cache.disk.capacity", 102400);
user_pref("browser.cache.memory.capacity", 51200);
user_pref("network.http.max-connections", 256);
user_pref("gfx.webrender.all", true);
user_pref("layers.acceleration.force-enabled", true);
"@
        
        $prefs | Out-File -FilePath $userFile -Append -Encoding UTF8 -Force
    }
    
    $script:reportData += @{Browser="LibreWolf"; Method="user.js配置文件"; Features="Firefox ESR、预配置隐私"; Status="✓"}
    Write-Host "[✓] LibreWolf 优化完成" -ForegroundColor Green
}

# 执行优化
Optimize-Chrome
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
    @{Name="Firefox"; Exe="C:\Program Files\Mozilla Firefox\firefox.exe"; Port=7892; Timezone="America/Chicago"},
    @{Name="Edge"; Exe="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"; Port=7893; Timezone="America/Denver"},
    @{Name="Brave"; Exe="C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"; Port=7894; Timezone="America/Los_Angeles"},
    @{Name="Opera"; Exe="$env:LOCALAPPDATA\Programs\Opera\opera.exe"; Port=7895; Timezone="America/Phoenix"},
    @{Name="Vivaldi"; Exe="$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe"; Port=7896; Timezone="America/Anchorage"},
    @{Name="LibreWolf"; Exe="C:\Program Files\LibreWolf\librewolf.exe"; Port=7897; Timezone="Pacific/Honolulu"}
)

foreach ($config in $browserConfigs) {
    if (Test-Path $config.Exe) {
        $profileDir = "$baseDir\$($config.Name)"
        if (-not (Test-Path $profileDir)) { New-Item -ItemType Directory -Path $profileDir -Force | Out-Null }
        
        $launchScript = "$baseDir\Launch_$($config.Name).bat"
        @"
@echo off
start "" "$($config.Exe)" --user-data-dir="$profileDir" --proxy-server=127.0.0.1:$($config.Port) --disable-blink-features=AutomationControlled --timezone="$($config.Timezone)"
"@ | Out-File -FilePath $launchScript -Encoding ASCII -Force
    }
}

# 生成统一启动脚本
$masterLaunch = "$baseDir\Launch_All.bat"
$launchContent = "@echo off`r`n"
foreach ($config in $browserConfigs) {
    if (Test-Path $config.Exe) {
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
    <title>7浏览器部署完成</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; }
        .container { max-width: 1400px; margin: 0 auto; background: white; border-radius: 20px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); overflow: hidden; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 40px; text-align: center; }
        .header h1 { font-size: 2.5em; margin-bottom: 10px; }
        .content { padding: 40px; }
        .section { margin-bottom: 40px; }
        .section h2 { color: #667eea; margin-bottom: 20px; font-size: 1.8em; border-bottom: 3px solid #667eea; padding-bottom: 10px; }
        .browser-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); gap: 20px; }
        .browser-card { background: #f8f9fa; border-radius: 15px; padding: 25px; border-left: 5px solid #667eea; }
        .browser-card h3 { color: #333; margin-bottom: 15px; font-size: 1.5em; }
        .browser-card .method { background: #e7f3ff; padding: 10px; border-radius: 8px; margin-bottom: 10px; font-size: 0.9em; color: #0056b3; }
        .browser-card .features { color: #666; line-height: 1.8; margin-bottom: 15px; }
        .browser-card .status { display: inline-block; background: #28a745; color: white; padding: 5px 15px; border-radius: 20px; font-size: 0.9em; }
        .launch-button { display: inline-block; background: #667eea; color: white; padding: 15px 30px; border-radius: 10px; text-decoration: none; margin: 10px; font-weight: bold; }
        .launch-button:hover { background: #764ba2; }
        .footer { background: #f8f9fa; padding: 30px; text-align: center; color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🎉 7浏览器部署完成</h1>
            <p>自动安装 + 架构级优化</p>
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
                <h2>🚀 启动浏览器</h2>
                <a href="file:///C:/BrowserProfiles/Launch_All.bat" class="launch-button">启动所有浏览器</a>
                <a href="file:///C:/BrowserProfiles/" class="launch-button">打开配置目录</a>
            </div>
        </div>
        <div class="footer">
            <p>部署完成时间: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')</p>
            <p style="margin-top: 10px;">配置目录: C:\BrowserProfiles</p>
        </div>
    </div>
</body>
</html>
"@

$reportPath = "$baseDir\部署完成报告.html"
$htmlReport | Out-File -FilePath $reportPath -Encoding UTF8 -Force

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  完成！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "`n[✓] HTML报告: $reportPath" -ForegroundColor Yellow
Write-Host "[*] 正在打开报告..." -ForegroundColor Yellow

Start-Process $reportPath
