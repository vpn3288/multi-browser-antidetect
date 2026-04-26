# 养号专用浏览器部署脚本 v2.0
# 功能：指纹随机化、持久化、反检测、独立代理

param(
    [string]$ChromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe",
    [string]$BaseDir = "C:\BrowserProfiles",
    [int]$StartPort = 7891,
    [string[]]$Timezones = @(
        "America/New_York",
        "America/Chicago", 
        "America/Denver",
        "America/Los_Angeles",
        "America/Phoenix",
        "America/Detroit",
        "America/Indianapolis"
    )
)

# 检查 Chrome
if (-not (Test-Path $ChromePath)) {
    Write-Error "Chrome 未找到: $ChromePath"
    exit 1
}

# 创建基础目录
New-Item -ItemType Directory -Force -Path $BaseDir | Out-Null

# 生成随机指纹函数
function New-BrowserFingerprint {
    param([int]$Seed)
    
    $rng = New-Object System.Random($Seed)
    
    return @{
        CanvasNoise = $rng.Next(1, 100) / 1000.0
        WebGLVendor = @("Intel Inc.", "NVIDIA Corporation", "AMD", "Google Inc.")[($rng.Next(0, 4))]
        WebGLRenderer = @(
            "ANGLE (Intel, Intel(R) UHD Graphics 620 Direct3D11 vs_5_0 ps_5_0)",
            "ANGLE (NVIDIA, NVIDIA GeForce GTX 1060 Direct3D11 vs_5_0 ps_5_0)",
            "ANGLE (AMD, AMD Radeon RX 580 Direct3D11 vs_5_0 ps_5_0)"
        )[($rng.Next(0, 3))]
        HardwareConcurrency = @(4, 8, 12, 16)[($rng.Next(0, 4))]
        DeviceMemory = @(4, 8, 16)[($rng.Next(0, 3))]
        ScreenWidth = @(1920, 2560, 1366, 1440)[($rng.Next(0, 4))]
        ScreenHeight = @(1080, 1440, 768, 900)[($rng.Next(0, 4))]
        UserAgent = @(
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36",
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36"
        )[($rng.Next(0, 3))]
    }
}

# 生成反检测注入脚本
function New-AntiDetectScript {
    param($Fingerprint)
    
    return @"
// Canvas 指纹噪声注入
(function() {
    const originalToDataURL = HTMLCanvasElement.prototype.toDataURL;
    const originalToBlob = HTMLCanvasElement.prototype.toBlob;
    const noise = $($Fingerprint.CanvasNoise);
    
    HTMLCanvasElement.prototype.toDataURL = function() {
        const context = this.getContext('2d');
        const imageData = context.getImageData(0, 0, this.width, this.height);
        for (let i = 0; i < imageData.data.length; i += 4) {
            imageData.data[i] = imageData.data[i] + Math.floor(noise * 10);
        }
        context.putImageData(imageData, 0, 0);
        return originalToDataURL.apply(this, arguments);
    };
})();

// WebGL 指纹修改
(function() {
    const getParameter = WebGLRenderingContext.prototype.getParameter;
    WebGLRenderingContext.prototype.getParameter = function(parameter) {
        if (parameter === 37445) return '$($Fingerprint.WebGLVendor)';
        if (parameter === 37446) return '$($Fingerprint.WebGLRenderer)';
        return getParameter.apply(this, arguments);
    };
})();

// 硬件信息修改
Object.defineProperty(navigator, 'hardwareConcurrency', {
    get: () => $($Fingerprint.HardwareConcurrency)
});

Object.defineProperty(navigator, 'deviceMemory', {
    get: () => $($Fingerprint.DeviceMemory)
});

// 屏幕分辨率修改
Object.defineProperty(screen, 'width', {
    get: () => $($Fingerprint.ScreenWidth)
});

Object.defineProperty(screen, 'height', {
    get: () => $($Fingerprint.ScreenHeight)
});

Object.defineProperty(screen, 'availWidth', {
    get: () => $($Fingerprint.ScreenWidth)
});

Object.defineProperty(screen, 'availHeight', {
    get: () => $($Fingerprint.ScreenHeight - 40)
});

// 隐藏 webdriver
Object.defineProperty(navigator, 'webdriver', {
    get: () => undefined
});

// 修改 plugins
Object.defineProperty(navigator, 'plugins', {
    get: () => [1, 2, 3, 4, 5]
});

// 修改 languages
Object.defineProperty(navigator, 'languages', {
    get: () => ['en-US', 'en']
});
})();
"@
}

# 部署 7 个浏览器
1..7 | ForEach-Object {
    $index = $_
    $profileDir = "$BaseDir\Chrome$index"
    $port = $StartPort + $index - 1
    $timezone = $Timezones[$index - 1]
    
    Write-Host "配置浏览器 $index (时区: $timezone)..." -ForegroundColor Cyan
    
    # 生成唯一指纹
    $fingerprint = New-BrowserFingerprint -Seed (1000 + $index)
    
    # 创建目录
    New-Item -ItemType Directory -Force -Path "$profileDir\Default" | Out-Null
    
    # 保存指纹配置（用于持久化）
    $fingerprint | ConvertTo-Json | Out-File "$profileDir\fingerprint.json" -Encoding UTF8
    
    # 生成反检测脚本
    $antiDetectScript = New-AntiDetectScript -Fingerprint $fingerprint
    $scriptPath = "$profileDir\anti-detect.js"
    $antiDetectScript | Out-File $scriptPath -Encoding UTF8
    
    # 生成 Preferences 文件
    $prefs = @{
        "profile" = @{
            "default_content_setting_values" = @{
                "notifications" = 2
                "geolocation" = 2
                "media_stream_camera" = 2
                "media_stream_mic" = 2
            }
            "password_manager_enabled" = $false
            "exit_type" = "Normal"
        }
        "intl" = @{
            "selected_languages" = "en-US,en"
        }
        "browser" = @{
            "check_default_browser" = $false
            "show_home_button" = $true
        }
        "dns_prefetching" = @{
            "enabled" = $false
        }
        "net" = @{
            "network_prediction_options" = 2
        }
        "safebrowsing" = @{
            "enabled" = $false
        }
        "privacy_sandbox" = @{
            "m1" = @{
                "topics_enabled" = $false
                "fledge_enabled" = $false
            }
        }
        "download" = @{
            "default_directory" = "$profileDir\Downloads"
        }
    } | ConvertTo-Json -Depth 10
    
    $prefs | Out-File "$profileDir\Default\Preferences" -Encoding UTF8
    
    # 生成启动脚本
    $launchScript = @"
@echo off
title Browser $index - $timezone
start "" "$ChromePath" ^
  --user-data-dir="$profileDir" ^
  --proxy-server="127.0.0.1:$port" ^
  --user-agent="$($fingerprint.UserAgent)" ^
  --window-size=$($fingerprint.ScreenWidth),$($fingerprint.ScreenHeight) ^
  --disable-features=NetworkService,IsolateOrigins,site-per-process,PrivacySandboxSettings4 ^
  --disable-blink-features=AutomationControlled ^
  --disable-background-networking ^
  --disable-sync ^
  --disable-extensions-file-access-check ^
  --disable-component-update ^
  --disable-default-apps ^
  --disable-domain-reliability ^
  --disable-client-side-phishing-detection ^
  --disable-hang-monitor ^
  --disable-popup-blocking ^
  --disable-prompt-on-repost ^
  --disable-web-security ^
  --no-first-run ^
  --no-default-browser-check ^
  --no-service-autorun ^
  --dns-prefetch-disable ^
  --disk-cache-size=104857600 ^
  --media-cache-size=52428800 ^
  --lang=en-US
"@
    
    $launchScript | Out-File "$BaseDir\Launch-Chrome$index.bat" -Encoding ASCII
    
    Write-Host "  指纹: Canvas=$($fingerprint.CanvasNoise), GPU=$($fingerprint.WebGLVendor)" -ForegroundColor Gray
}

# 生成主启动脚本
$masterScript = @"
@echo off
echo ========================================
echo 启动 7 个独立浏览器实例
echo 每个浏览器具有独立指纹和代理
echo ========================================
echo.
$(1..7 | ForEach-Object { 
    "echo 启动浏览器 $_ (端口 $($StartPort + $_ - 1), 时区 $($Timezones[$_ - 1]))..."
    "start /min cmd /c `"$BaseDir\Launch-Chrome$_.bat`""
    "timeout /t 2 /nobreak >nul"
} | Out-String)
echo.
echo 完成！所有浏览器已启动
echo 请在每个浏览器访问 https://ip.sb 验证 IP
echo 访问 https://browserleaks.com/canvas 验证指纹
pause
"@

$masterScript | Out-File "$BaseDir\Launch-All.bat" -Encoding ASCII

# 生成指纹验证脚本
$verifyScript = @"
@echo off
echo ========================================
echo 浏览器指纹验证指南
echo ========================================
echo.
echo 1. 启动所有浏览器: Launch-All.bat
echo.
echo 2. 在每个浏览器访问以下网站验证:
echo    - IP 验证: https://ip.sb
echo    - Canvas 指纹: https://browserleaks.com/canvas
echo    - WebGL 指纹: https://browserleaks.com/webgl
echo    - 综合检测: https://pixelscan.net
echo.
echo 3. 确认每个浏览器显示:
echo    - 不同的美国 IP 地址
echo    - 不同的 Canvas 哈希值
echo    - 不同的 WebGL 参数
echo.
echo 4. 指纹配置文件位置:
$(1..7 | ForEach-Object { "echo    Browser $_: $BaseDir\Chrome$_\fingerprint.json" } | Out-String)
pause
"@

$verifyScript | Out-File "$BaseDir\Verify-Fingerprints.bat" -Encoding ASCII

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "部署完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "`n启动所有浏览器: $BaseDir\Launch-All.bat" -ForegroundColor Yellow
Write-Host "验证指纹: $BaseDir\Verify-Fingerprints.bat" -ForegroundColor Yellow
Write-Host "`n每个浏览器的指纹配置已保存到对应目录的 fingerprint.json" -ForegroundColor Cyan
