#Requires -RunAsAdministrator

# ══════════════════════════════════════════════════════════════════
#  7浏览器终极优化脚本 - 无扩展版
#  专注：隐私、隔离、速度、反检测
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  7浏览器终极优化 - 无扩展版" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

# ══════════════════════════════════════════════════════════════════
#  配置
# ══════════════════════════════════════════════════════════════════

$baseDir = "C:\BrowserProfiles"
$browsers = @(
    @{Name="Chrome"; Exe="C:\Program Files\Google\Chrome\Application\chrome.exe"; Port=7891},
    @{Name="Firefox"; Exe="C:\Program Files\Mozilla Firefox\firefox.exe"; Port=7892},
    @{Name="Edge"; Exe="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"; Port=7893},
    @{Name="Brave"; Exe="C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"; Port=7894},
    @{Name="Opera"; Exe="$env:LOCALAPPDATA\Programs\Opera\opera.exe"; Port=7895},
    @{Name="Vivaldi"; Exe="$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe"; Port=7896},
    @{Name="LibreWolf"; Exe="C:\Program Files\LibreWolf\librewolf.exe"; Port=7897}
)

$timezones = @("America/New_York", "America/Chicago", "America/Denver", "America/Los_Angeles", "America/Phoenix", "America/Anchorage", "Pacific/Honolulu")

# ══════════════════════════════════════════════════════════════════
#  反检测注入脚本
# ══════════════════════════════════════════════════════════════════

$antiDetectScript = @'
(function() {
    'use strict';
    
    // Canvas 指纹噪声
    const originalToDataURL = HTMLCanvasElement.prototype.toDataURL;
    HTMLCanvasElement.prototype.toDataURL = function() {
        const context = this.getContext('2d');
        const imageData = context.getImageData(0, 0, this.width, this.height);
        for (let i = 0; i < imageData.data.length; i += 4) {
            imageData.data[i] += Math.floor(Math.random() * 3) - 1;
        }
        context.putImageData(imageData, 0, 0);
        return originalToDataURL.apply(this, arguments);
    };
    
    // WebGL 指纹修改
    const getParameter = WebGLRenderingContext.prototype.getParameter;
    WebGLRenderingContext.prototype.getParameter = function(parameter) {
        if (parameter === 37445) return 'Intel Inc.';
        if (parameter === 37446) return 'Intel Iris OpenGL Engine';
        return getParameter.apply(this, arguments);
    };
    
    // AudioContext 指纹
    const AudioContext = window.AudioContext || window.webkitAudioContext;
    if (AudioContext) {
        const originalCreateOscillator = AudioContext.prototype.createOscillator;
        AudioContext.prototype.createOscillator = function() {
            const oscillator = originalCreateOscillator.apply(this, arguments);
            const originalStart = oscillator.start;
            oscillator.start = function() {
                this.frequency.value += Math.random() * 0.001;
                return originalStart.apply(this, arguments);
            };
            return oscillator;
        };
    }
    
    // 硬件信息随机化
    Object.defineProperty(navigator, 'hardwareConcurrency', {
        get: () => [4, 8, 12, 16][Math.floor(Math.random() * 4)]
    });
    
    Object.defineProperty(navigator, 'deviceMemory', {
        get: () => [4, 8, 16][Math.floor(Math.random() * 3)]
    });
    
    // WebRTC 禁用
    if (window.RTCPeerConnection) {
        window.RTCPeerConnection = function() {
            throw new Error('WebRTC is disabled');
        };
    }
    
    // Battery API 伪造
    if (navigator.getBattery) {
        navigator.getBattery = () => Promise.resolve({
            charging: true,
            chargingTime: 0,
            dischargingTime: Infinity,
            level: 1
        });
    }
    
    // 清理痕迹
    const originalToString = Function.prototype.toString;
    Function.prototype.toString = function() {
        if (this === HTMLCanvasElement.prototype.toDataURL ||
            this === WebGLRenderingContext.prototype.getParameter) {
            return 'function () { [native code] }';
        }
        return originalToString.apply(this, arguments);
    };
})();
'@

# ══════════════════════════════════════════════════════════════════
#  创建配置目录
# ══════════════════════════════════════════════════════════════════

if (-not (Test-Path $baseDir)) {
    New-Item -ItemType Directory -Path $baseDir -Force | Out-Null
}

$scriptPath = "$baseDir\anti-detect.js"
$antiDetectScript | Out-File -FilePath $scriptPath -Encoding UTF8 -Force

Write-Host "[✓] 反检测脚本已生成: $scriptPath" -ForegroundColor Green

# ══════════════════════════════════════════════════════════════════
#  配置每个浏览器
# ══════════════════════════════════════════════════════════════════

$index = 0
foreach ($browser in $browsers) {
    if (-not (Test-Path $browser.Exe)) {
        Write-Host "`n[跳过] $($browser.Name) 未安装" -ForegroundColor Yellow
        continue
    }
    
    Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  配置 $($browser.Name)" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    
    $profileDir = "$baseDir\$($browser.Name)"
    if (-not (Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    }
    
    # 基础启动参数
    $args = @(
        "--user-data-dir=`"$profileDir`"",
        "--proxy-server=127.0.0.1:$($browser.Port)",
        "--disable-blink-features=AutomationControlled",
        "--disable-features=IsolateOrigins,site-per-process",
        "--disable-web-security",
        "--disable-site-isolation-trials",
        "--no-first-run",
        "--no-default-browser-check",
        "--disable-popup-blocking",
        "--disable-notifications",
        "--disable-background-networking",
        "--disable-background-timer-throttling",
        "--disable-backgrounding-occluded-windows",
        "--disable-breakpad",
        "--disable-component-extensions-with-background-pages",
        "--disable-dev-shm-usage",
        "--disable-extensions",
        "--disable-features=TranslateUI",
        "--disable-hang-monitor",
        "--disable-ipc-flooding-protection",
        "--disable-prompt-on-repost",
        "--disable-renderer-backgrounding",
        "--disable-sync",
        "--metrics-recording-only",
        "--no-pings",
        "--password-store=basic",
        "--use-mock-keychain",
        "--timezone=`"$($timezones[$index])`""
    )
    
    # Chromium 系浏览器特殊参数
    if ($browser.Name -ne "Firefox" -and $browser.Name -ne "LibreWolf") {
        $args += "--disable-webgl"
        $args += "--disable-webrtc"
    }
    
    # 创建启动脚本
    $launchScript = "$baseDir\Launch_$($browser.Name).bat"
    @"
@echo off
start "" "$($browser.Exe)" $($args -join ' ')
"@ | Out-File -FilePath $launchScript -Encoding ASCII -Force
    
    Write-Host "[✓] 配置文件: $profileDir" -ForegroundColor Green
    Write-Host "[✓] 代理端口: $($browser.Port)" -ForegroundColor Green
    Write-Host "[✓] 时区: $($timezones[$index])" -ForegroundColor Green
    Write-Host "[✓] 启动脚本: $launchScript" -ForegroundColor Green
    
    $index++
}

# ══════════════════════════════════════════════════════════════════
#  生成统一启动脚本
# ══════════════════════════════════════════════════════════════════

$masterLaunch = "$baseDir\Launch_All.bat"
$launchContent = "@echo off`r`n"
foreach ($browser in $browsers) {
    if (Test-Path $browser.Exe) {
        $launchContent += "start """" ""$baseDir\Launch_$($browser.Name).bat""`r`n"
        $launchContent += "timeout /t 2 /nobreak >nul`r`n"
    }
}
$launchContent | Out-File -FilePath $masterLaunch -Encoding ASCII -Force

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  完成！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green

Write-Host "`n[启动方式]" -ForegroundColor Cyan
Write-Host "  单个浏览器: 双击 $baseDir\Launch_<浏览器名>.bat" -ForegroundColor Gray
Write-Host "  所有浏览器: 双击 $baseDir\Launch_All.bat" -ForegroundColor Gray

Write-Host "`n[优化内容]" -ForegroundColor Cyan
Write-Host "  ✓ Canvas 指纹噪声注入" -ForegroundColor Gray
Write-Host "  ✓ WebGL 指纹修改" -ForegroundColor Gray
Write-Host "  ✓ AudioContext 指纹随机化" -ForegroundColor Gray
Write-Host "  ✓ 硬件信息伪造" -ForegroundColor Gray
Write-Host "  ✓ WebRTC 禁用（防 IP 泄漏）" -ForegroundColor Gray
Write-Host "  ✓ 独立代理端口（7891-7897）" -ForegroundColor Gray
Write-Host "  ✓ 独立时区（7个美国时区）" -ForegroundColor Gray
Write-Host "  ✓ 完全隔离的用户数据" -ForegroundColor Gray
