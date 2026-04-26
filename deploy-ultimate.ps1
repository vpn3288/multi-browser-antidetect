# 养号浏览器终极增强版 v3.0
# 最大化反检测能力（JavaScript 注入方案的极限）

param(
    [string]$ChromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe",
    [string]$BaseDir = "C:\BrowserProfiles",
    [int]$StartPort = 7891,
    [int]$BrowserCount = 3,  # 默认只部署3个（降低风险）
    [string[]]$Timezones = @(
        "America/New_York",
        "America/Chicago", 
        "America/Los_Angeles"
    )
)

if (-not (Test-Path $ChromePath)) {
    Write-Error "Chrome 未找到: $ChromePath"
    exit 1
}

New-Item -ItemType Directory -Force -Path $BaseDir | Out-Null

# 生成完整指纹配置
function New-CompleteFingerprint {
    param([int]$Seed)
    
    $rng = New-Object System.Random($Seed)
    
    # 屏幕分辨率池（常见真实分辨率）
    $screens = @(
        @{Width=1920; Height=1080; Ratio=1.0},
        @{Width=2560; Height=1440; Ratio=1.0},
        @{Width=1366; Height=768; Ratio=1.0},
        @{Width=1536; Height=864; Ratio=1.25},
        @{Width=1920; Height=1200; Ratio=1.0}
    )
    $screen = $screens[$rng.Next(0, $screens.Count)]
    
    # GPU 配置池
    $gpus = @(
        @{Vendor="Intel Inc."; Renderer="ANGLE (Intel, Intel(R) UHD Graphics 620 Direct3D11 vs_5_0 ps_5_0, D3D11)"},
        @{Vendor="NVIDIA Corporation"; Renderer="ANGLE (NVIDIA, NVIDIA GeForce GTX 1060 6GB Direct3D11 vs_5_0 ps_5_0, D3D11)"},
        @{Vendor="AMD"; Renderer="ANGLE (AMD, AMD Radeon RX 580 Series Direct3D11 vs_5_0 ps_5_0, D3D11)"},
        @{Vendor="Intel Inc."; Renderer="ANGLE (Intel, Intel(R) Iris(R) Xe Graphics Direct3D11 vs_5_0 ps_5_0, D3D11)"}
    )
    $gpu = $gpus[$rng.Next(0, $gpus.Count)]
    
    # User-Agent 池（真实 Chrome 版本）
    $userAgents = @(
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36",
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36"
    )
    
    return @{
        # Canvas 指纹
        CanvasNoise = ($rng.Next(1, 50) / 1000.0)
        
        # WebGL 指纹
        WebGLVendor = $gpu.Vendor
        WebGLRenderer = $gpu.Renderer
        WebGLVersion = "WebGL 1.0 (OpenGL ES 2.0 Chromium)"
        WebGLShadingLanguageVersion = "WebGL GLSL ES 1.0 (OpenGL ES GLSL ES 1.0 Chromium)"
        
        # 硬件信息
        HardwareConcurrency = @(4, 8, 12, 16)[$rng.Next(0, 4)]
        DeviceMemory = @(4, 8, 16)[$rng.Next(0, 3)]
        
        # 屏幕信息
        ScreenWidth = $screen.Width
        ScreenHeight = $screen.Height
        ScreenColorDepth = 24
        ScreenPixelDepth = 24
        DevicePixelRatio = $screen.Ratio
        
        # 浏览器信息
        UserAgent = $userAgents[$rng.Next(0, $userAgents.Count)]
        Platform = "Win32"
        Language = "en-US"
        Languages = @("en-US", "en")
        
        # 音频指纹噪声
        AudioNoise = ($rng.Next(1, 100) / 10000.0)
        
        # WebRTC 配置
        WebRTCDisabled = $true
        
        # 字体列表（随机子集）
        FontCount = $rng.Next(40, 80)
    }
}

# 生成终极反检测脚本
function New-UltimateAntiDetectScript {
    param($Fingerprint)
    
    return @"
(function() {
    'use strict';
    
    // ============ Canvas 指纹修改 ============
    const canvasNoise = $($Fingerprint.CanvasNoise);
    
    const originalToDataURL = HTMLCanvasElement.prototype.toDataURL;
    const originalToBlob = HTMLCanvasElement.prototype.toBlob;
    const originalGetImageData = CanvasRenderingContext2D.prototype.getImageData;
    
    // 修改 toDataURL
    HTMLCanvasElement.prototype.toDataURL = function() {
        const context = this.getContext('2d');
        if (context) {
            const imageData = context.getImageData(0, 0, this.width, this.height);
            for (let i = 0; i < imageData.data.length; i += 4) {
                imageData.data[i] = Math.min(255, imageData.data[i] + Math.floor(canvasNoise * 255));
            }
            context.putImageData(imageData, 0, 0);
        }
        return originalToDataURL.apply(this, arguments);
    };
    
    // 修改 getImageData
    CanvasRenderingContext2D.prototype.getImageData = function() {
        const imageData = originalGetImageData.apply(this, arguments);
        for (let i = 0; i < imageData.data.length; i += 4) {
            imageData.data[i] = Math.min(255, imageData.data[i] + Math.floor(canvasNoise * 255));
        }
        return imageData;
    };
    
    // ============ WebGL 指纹修改 ============
    const getParameter = WebGLRenderingContext.prototype.getParameter;
    WebGLRenderingContext.prototype.getParameter = function(parameter) {
        if (parameter === 37445) return '$($Fingerprint.WebGLVendor)';
        if (parameter === 37446) return '$($Fingerprint.WebGLRenderer)';
        if (parameter === 7936) return '$($Fingerprint.WebGLVersion)';
        if (parameter === 35724) return '$($Fingerprint.WebGLShadingLanguageVersion)';
        if (parameter === 3379) {
            const original = getParameter.apply(this, arguments);
            return Math.max(8, original - 2);
        }
        return getParameter.apply(this, arguments);
    };
    
    const getParameter2 = WebGL2RenderingContext.prototype.getParameter;
    WebGL2RenderingContext.prototype.getParameter = function(parameter) {
        if (parameter === 37445) return '$($Fingerprint.WebGLVendor)';
        if (parameter === 37446) return '$($Fingerprint.WebGLRenderer)';
        return getParameter2.apply(this, arguments);
    };
    
    // ============ 硬件信息修改 ============
    Object.defineProperty(navigator, 'hardwareConcurrency', {
        get: () => $($Fingerprint.HardwareConcurrency),
        configurable: true
    });
    
    Object.defineProperty(navigator, 'deviceMemory', {
        get: () => $($Fingerprint.DeviceMemory),
        configurable: true
    });
    
    // ============ 屏幕信息修改 ============
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
    
    Object.defineProperty(screen, 'colorDepth', {
        get: () => $($Fingerprint.ScreenColorDepth)
    });
    
    Object.defineProperty(screen, 'pixelDepth', {
        get: () => $($Fingerprint.ScreenPixelDepth)
    });
    
    Object.defineProperty(window, 'devicePixelRatio', {
        get: () => $($Fingerprint.DevicePixelRatio)
    });
    
    // ============ 音频指纹修改 ============
    const audioNoise = $($Fingerprint.AudioNoise);
    const originalGetChannelData = AudioBuffer.prototype.getChannelData;
    AudioBuffer.prototype.getChannelData = function() {
        const data = originalGetChannelData.apply(this, arguments);
        for (let i = 0; i < data.length; i++) {
            data[i] = data[i] + audioNoise * (Math.random() - 0.5);
        }
        return data;
    };
    
    // ============ WebRTC 禁用 ============
    if ($($Fingerprint.WebRTCDisabled.ToString().ToLower())) {
        Object.defineProperty(navigator, 'mediaDevices', {
            get: () => undefined
        });
        
        window.RTCPeerConnection = undefined;
        window.RTCSessionDescription = undefined;
        window.RTCIceCandidate = undefined;
    }
    
    // ============ 隐藏自动化特征 ============
    Object.defineProperty(navigator, 'webdriver', {
        get: () => undefined
    });
    
    delete navigator.__proto__.webdriver;
    
    // ============ 修改 navigator 属性 ============
    Object.defineProperty(navigator, 'platform', {
        get: () => '$($Fingerprint.Platform)'
    });
    
    Object.defineProperty(navigator, 'language', {
        get: () => '$($Fingerprint.Language)'
    });
    
    Object.defineProperty(navigator, 'languages', {
        get: () => $(($Fingerprint.Languages | ConvertTo-Json -Compress))
    });
    
    // ============ 修改 plugins ============
    Object.defineProperty(navigator, 'plugins', {
        get: () => {
            const plugins = [];
            for (let i = 0; i < 5; i++) {
                plugins.push({
                    name: 'Plugin ' + i,
                    description: 'Plugin Description ' + i,
                    filename: 'plugin' + i + '.dll',
                    length: 1
                });
            }
            return plugins;
        }
    });
    
    // ============ 修改 mimeTypes ============
    Object.defineProperty(navigator, 'mimeTypes', {
        get: () => {
            const mimeTypes = [];
            for (let i = 0; i < 4; i++) {
                mimeTypes.push({
                    type: 'application/x-test-' + i,
                    description: 'Test MIME Type ' + i,
                    suffixes: 'test' + i
                });
            }
            return mimeTypes;
        }
    });
    
    // ============ 修改 permissions ============
    const originalQuery = navigator.permissions.query;
    navigator.permissions.query = function(parameters) {
        if (parameters.name === 'notifications') {
            return Promise.resolve({ state: 'denied' });
        }
        return originalQuery.apply(this, arguments);
    };
    
    // ============ 修改 battery ============
    if (navigator.getBattery) {
        navigator.getBattery = () => Promise.resolve({
            charging: true,
            chargingTime: 0,
            dischargingTime: Infinity,
            level: 1
        });
    }
    
    // ============ 修改 connection ============
    if (navigator.connection) {
        Object.defineProperty(navigator.connection, 'rtt', {
            get: () => 50 + Math.floor(Math.random() * 50)
        });
    }
    
    // ============ 清理痕迹 ============
    const originalToString = Function.prototype.toString;
    Function.prototype.toString = function() {
        if (this === navigator.permissions.query) {
            return 'function query() { [native code] }';
        }
        return originalToString.apply(this, arguments);
    };
    
    console.log('[AntiDetect] Fingerprint loaded successfully');
})();
"@
}

# 部署浏览器
1..$BrowserCount | ForEach-Object {
    $index = $_
    $profileDir = "$BaseDir\Chrome$index"
    $port = $StartPort + $index - 1
    $timezone = $Timezones[($index - 1) % $Timezones.Count]
    
    Write-Host "配置浏览器 $index/$BrowserCount (时区: $timezone)..." -ForegroundColor Cyan
    
    # 生成指纹
    $fingerprint = New-CompleteFingerprint -Seed (2000 + $index * 137)
    
    # 创建目录
    New-Item -ItemType Directory -Force -Path "$profileDir\Default" | Out-Null
    New-Item -ItemType Directory -Force -Path "$profileDir\Downloads" | Out-Null
    
    # 保存指纹
    $fingerprint | ConvertTo-Json -Depth 10 | Out-File "$profileDir\fingerprint.json" -Encoding UTF8
    
    # 生成反检测脚本
    $antiDetectScript = New-UltimateAntiDetectScript -Fingerprint $fingerprint
    $antiDetectScript | Out-File "$profileDir\anti-detect.js" -Encoding UTF8
    
    # 生成 Preferences
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
        "webkit" = @{
            "webprefs" = @{
                "fonts" = @{
                    "standard" = @{
                        "Zyyy" = "Arial"
                    }
                }
            }
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
  --force-device-scale-factor=$($fingerprint.DevicePixelRatio) ^
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
  --no-first-run ^
  --no-default-browser-check ^
  --no-service-autorun ^
  --dns-prefetch-disable ^
  --disk-cache-size=104857600 ^
  --media-cache-size=52428800 ^
  --lang=en-US
"@
    
    $launchScript | Out-File "$BaseDir\Launch-Chrome$index.bat" -Encoding ASCII
    
    Write-Host "  GPU: $($fingerprint.WebGLVendor)" -ForegroundColor Gray
    Write-Host "  分辨率: $($fingerprint.ScreenWidth)x$($fingerprint.ScreenHeight)" -ForegroundColor Gray
}

# 生成主启动脚本（间隔启动）
$masterScript = @"
@echo off
echo ========================================
echo 养号浏览器启动器 v3.0
echo ========================================
echo.
echo 重要提示:
echo 1. 确保 Clash Verge 已启动
echo 2. 浏览器将间隔 10 秒启动（降低检测风险）
echo 3. 首次使用建议只启动 1 个浏览器测试
echo.
pause
echo.
$(1..$BrowserCount | ForEach-Object { 
    "echo [$_/$BrowserCount] 启动浏览器 $_ (端口 $($StartPort + $_ - 1))..."
    "start /min cmd /c `"$BaseDir\Launch-Chrome$_.bat`""
    if ($_ -lt $BrowserCount) {
        "echo 等待 10 秒..."
        "timeout /t 10 /nobreak >nul"
        "echo."
    }
} | Out-String)
echo.
echo 完成！所有浏览器已启动
echo.
echo 验证步骤:
echo 1. 访问 https://ip.sb 确认不同 IP
echo 2. 访问 https://browserleaks.com/canvas 确认不同指纹
echo 3. 访问 https://pixelscan.net 综合检测
echo.
pause
"@

$masterScript | Out-File "$BaseDir\Launch-All.bat" -Encoding ASCII

# 生成单独启动脚本
$singleScript = @"
@echo off
echo 单个浏览器启动器
echo.
$(1..$BrowserCount | ForEach-Object { "echo [$_] 浏览器 $_ (端口 $($StartPort + $_ - 1), 时区 $($Timezones[($_ - 1) % $Timezones.Count]))" } | Out-String)
echo.
set /p choice="选择浏览器编号 (1-$BrowserCount): "
if exist "$BaseDir\Launch-Chrome%choice%.bat" (
    start "" "$BaseDir\Launch-Chrome%choice%.bat"
    echo 浏览器 %choice% 已启动
) else (
    echo 无效的选择
)
pause
"@

$singleScript | Out-File "$BaseDir\Launch-Single.bat" -Encoding ASCII

# 生成风险控制指南
$guideScript = @"
# 养号风险控制指南

## 第一周：建立信任

### 第 1-3 天
- 只启动 1 个浏览器
- 每天登录 1 次，停留 5-10 分钟
- 只浏览，不操作（不点赞、不评论、不关注）
- 浏览路径：首页 → 热门内容 → 随机点击 2-3 个链接

### 第 4-7 天
- 继续 1 个浏览器
- 每天登录 1-2 次，停留 10-20 分钟
- 开始轻度互动：点赞 1-2 个内容
- 避免连续操作（间隔 30 秒以上）

## 第二周：逐步扩展

### 第 8-10 天
- 启动第 2 个浏览器
- 第 1 个浏览器增加活跃度：评论 1-2 条
- 第 2 个浏览器重复第一周流程

### 第 11-14 天
- 两个浏览器交替使用
- 避免同时在线
- 每个浏览器每天 20-30 分钟

## 第三周：稳定运营

### 第 15-21 天
- 可以启动第 3 个浏览器
- 每个浏览器建立固定的活跃时间段
- 开始执行任务（但要控制频率）

## 操作规范

### 时间间隔
- 登录后等待 30-60 秒再操作
- 每次操作间隔 10-30 秒
- 避免机械化的固定间隔（加入随机性）

### 行为模式
- 模拟真人浏览路径（不要直接跳转到任务页面）
- 偶尔返回上一页
- 偶尔刷新页面
- 偶尔打开新标签页

### IP 管理
- 每个账号绑定固定 IP
- 不要频繁切换 IP
- 如果必须换 IP，间隔至少 7 天

### 异常处理
- 如果收到验证码：正常完成验证，暂停操作 24 小时
- 如果账号被限制：立即停止所有操作，等待 7 天
- 如果账号被封：分析原因，调整其他账号的策略

## 检测指标

### 每周检查
- [ ] IP 是否干净（访问 https://scamalytics.com）
- [ ] 指纹是否一致（访问 https://browserleaks.com/canvas）
- [ ] 账号是否有异常提示

### 每月检查
- [ ] 更新浏览器指纹配置（重新运行部署脚本）
- [ ] 检查 Clash 节点质量
- [ ] 评估账号健康度

## 风险信号

⚠️ 立即停止操作的信号：
- 频繁要求验证码
- 操作被限制（如无法点赞/评论）
- 收到安全提示邮件
- 登录时提示"异常登录"

## 记录模板

建议为每个账号建立记录文件：

\`\`\`
账号 1 - 浏览器 1
- 注册日期：2026-04-26
- IP：xxx.xxx.xxx.xxx
- 时区：America/New_York
- 活跃时间段：每天 9:00-10:00
- 当前状态：正常
- 操作记录：
  - 2026-04-26：注册，浏览 10 分钟
  - 2026-04-27：登录，浏览 15 分钟，点赞 2 次
  - ...
\`\`\`

## 最后提醒

**养号是长期工程，不要急于求成。**

- 宁可慢一点，也不要冒险
- 一个稳定的老号 > 十个新号
- 被封后重新养号的成本远高于谨慎操作的时间成本
"@

$guideScript | Out-File "$BaseDir\养号指南.txt" -Encoding UTF8

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "部署完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "`n已部署 $BrowserCount 个浏览器实例" -ForegroundColor Yellow
Write-Host "`n启动方式：" -ForegroundColor Cyan
Write-Host "  全部启动: $BaseDir\Launch-All.bat" -ForegroundColor White
Write-Host "  单独启动: $BaseDir\Launch-Single.bat" -ForegroundColor White
Write-Host "`n重要文件：" -ForegroundColor Cyan
Write-Host "  风险控制指南: $BaseDir\养号指南.txt" -ForegroundColor White
Write-Host "`n⚠️  强烈建议：" -ForegroundColor Red
Write-Host "  1. 先阅读养号指南" -ForegroundColor Yellow
Write-Host "  2. 第一周只启动 1 个浏览器测试" -ForegroundColor Yellow
Write-Host "  3. 确认无风险后再扩展到 2-3 个" -ForegroundColor Yellow
