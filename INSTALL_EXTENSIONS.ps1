#Requires -RunAsAdministrator

# ══════════════════════════════════════════════════════════════════
#  浏览器扩展自动安装脚本 v1.0
#  支持：Chrome/Edge/Brave/Opera/Vivaldi (Chromium系)
#         Firefox (独立机制)
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

# ══════════════════════════════════════════════════════════════════
#  扩展配置（Chrome Web Store ID）
# ══════════════════════════════════════════════════════════════════

$ChromiumExtensions = @(
    @{Name="uBlock Origin";        ID="cjpalhdlnbpafiamejdnhcphjbkeiagm"},
    @{Name="Canvas Defender";      ID="obdbgnebcljmgkoljcdddaopadkifnpm"},
    @{Name="WebRTC Leak Shield";   ID="bppamachkoflopbagkdoflbgfjflfnfl"},
    @{Name="User-Agent Switcher";  ID="djflhoibgkdhkhhcedjiklpkjnoahfmg"},
    @{Name="Cookie AutoDelete";    ID="fhcgjolkccmbidfldomjliifgaodjagh"}
)

$FirefoxExtensions = @(
    @{Name="uBlock Origin";        ID="uBlock0@raymondhill.net";        URL="https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"},
    @{Name="Canvas Blocker";       ID="{canvas-blocker}";               URL="https://addons.mozilla.org/firefox/downloads/latest/canvasblocker/latest.xpi"},
    @{Name="WebRTC Control";       ID="{webrtc-control}";               URL="https://addons.mozilla.org/firefox/downloads/latest/webrtc-control/latest.xpi"},
    @{Name="User-Agent Switcher";  ID="{user-agent-switcher}";          URL="https://addons.mozilla.org/firefox/downloads/latest/user-agent-string-switcher/latest.xpi"}
)

# ══════════════════════════════════════════════════════════════════
#  Chromium 系浏览器扩展安装（通过注册表强制安装）
# ══════════════════════════════════════════════════════════════════

function Install-ChromiumExtensions {
    param(
        [string]$BrowserName,
        [string]$RegistryPath
    )
    
    Write-Host "`n[*] 配置 $BrowserName 扩展..." -ForegroundColor Cyan
    
    # 创建扩展注册表路径
    $extPath = "$RegistryPath\Extensions"
    if (-not (Test-Path $extPath)) {
        New-Item -Path $extPath -Force | Out-Null
    }
    
    foreach ($ext in $ChromiumExtensions) {
        try {
            $extKeyPath = "$extPath\$($ext.ID)"
            if (-not (Test-Path $extKeyPath)) {
                New-Item -Path $extKeyPath -Force | Out-Null
            }
            
            # 设置扩展更新URL（Chrome Web Store）
            Set-ItemProperty -Path $extKeyPath -Name "update_url" -Value "https://clients2.google.com/service/update2/crx" -Type String -Force
            
            Write-Host "  [✓] $($ext.Name)" -ForegroundColor Green
        } catch {
            Write-Host "  [✗] $($ext.Name): $_" -ForegroundColor Red
        }
    }
}

# ══════════════════════════════════════════════════════════════════
#  Firefox 扩展安装（通过 extensions.json）
# ══════════════════════════════════════════════════════════════════

function Install-FirefoxExtensions {
    Write-Host "`n[*] 配置 Firefox 扩展..." -ForegroundColor Cyan
    
    $firefoxProfilePath = "$env:APPDATA\Mozilla\Firefox\Profiles"
    
    if (-not (Test-Path $firefoxProfilePath)) {
        Write-Host "  [!] Firefox 配置目录不存在，跳过" -ForegroundColor Yellow
        return
    }
    
    # 查找默认配置文件
    $profiles = Get-ChildItem -Path $firefoxProfilePath -Directory | Where-Object { $_.Name -like "*.default*" }
    
    if ($profiles.Count -eq 0) {
        Write-Host "  [!] 未找到 Firefox 配置文件，跳过" -ForegroundColor Yellow
        return
    }
    
    foreach ($profile in $profiles) {
        $extensionsDir = Join-Path $profile.FullName "extensions"
        if (-not (Test-Path $extensionsDir)) {
            New-Item -ItemType Directory -Path $extensionsDir -Force | Out-Null
        }
        
        foreach ($ext in $FirefoxExtensions) {
            try {
                $xpiPath = Join-Path $extensionsDir "$($ext.ID).xpi"
                
                # 下载扩展
                Invoke-WebRequest -Uri $ext.URL -OutFile $xpiPath -UseBasicParsing
                
                Write-Host "  [✓] $($ext.Name)" -ForegroundColor Green
            } catch {
                Write-Host "  [✗] $($ext.Name): $_" -ForegroundColor Red
            }
        }
    }
}

# ══════════════════════════════════════════════════════════════════
#  主执行流程
# ══════════════════════════════════════════════════════════════════

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  浏览器扩展自动安装脚本" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

# 关闭所有浏览器进程
Write-Host "`n[*] 关闭所有浏览器进程..." -ForegroundColor Yellow
Get-Process chrome,firefox,msedge,brave,opera,vivaldi -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

# Chrome
if (Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe") {
    Install-ChromiumExtensions -BrowserName "Chrome" -RegistryPath "HKLM:\SOFTWARE\Policies\Google\Chrome"
}

# Edge
if (Test-Path "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe") {
    Install-ChromiumExtensions -BrowserName "Edge" -RegistryPath "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
}

# Brave
if (Test-Path "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe") {
    Install-ChromiumExtensions -BrowserName "Brave" -RegistryPath "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"
}

# Opera
if (Test-Path "$env:LOCALAPPDATA\Programs\Opera\opera.exe") {
    Install-ChromiumExtensions -BrowserName "Opera" -RegistryPath "HKLM:\SOFTWARE\Policies\Opera Software\Opera Stable"
}

# Vivaldi
if (Test-Path "$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe") {
    Install-ChromiumExtensions -BrowserName "Vivaldi" -RegistryPath "HKLM:\SOFTWARE\Policies\Vivaldi"
}

# Firefox
if (Test-Path "C:\Program Files\Mozilla Firefox\firefox.exe") {
    Install-FirefoxExtensions
}

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  扩展安装完成！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "`n重启浏览器后扩展将自动加载" -ForegroundColor Yellow
Write-Host "如果扩展未出现，请手动访问扩展商店确认安装" -ForegroundColor Yellow
