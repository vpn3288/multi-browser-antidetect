#Requires -RunAsAdministrator

# ══════════════════════════════════════════════════════════════════
#  浏览器指纹随机化 - 真实美国用户伪装
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  浏览器指纹随机化 - 真实美国用户伪装" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

# ══════════════════════════════════════════════════════════════════
#  真实的美国用户配置数据
# ══════════════════════════════════════════════════════════════════

# 真实的美国常见屏幕分辨率（基于StatCounter 2024数据）
$realScreenResolutions = @(
    @{Width=1920; Height=1080; Ratio=1.0},  # 最常见 22.5%
    @{Width=1366; Height=768; Ratio=1.0},   # 笔记本常见 14.3%
    @{Width=2560; Height=1440; Ratio=1.0},  # 2K显示器 8.7%
    @{Width=1536; Height=864; Ratio=1.25},  # Windows缩放125% 6.2%
    @{Width=1440; Height=900; Ratio=1.0},   # MacBook Pro 13" 5.1%
    @{Width=1600; Height=900; Ratio=1.0},   # 4.8%
    @{Width=3840; Height=2160; Ratio=1.5},  # 4K显示器 3.2%
    @{Width=2880; Height=1800; Ratio=2.0}   # MacBook Pro 15" Retina 2.9%
)

# 真实的美国常见User-Agent（2024年真实数据）
$realUserAgents = @{
    Chrome = @(
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    )
    Firefox = @(
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0",
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.0",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:121.0) Gecko/20100101 Firefox/121.0"
    )
    Edge = @(
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0",
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0"
    )
}

# 真实的美国常见硬件配置
$realHardwareConfigs = @(
    @{Cores=8; Memory=16; Vendor="Intel"; Renderer="NVIDIA GeForce RTX 3060"},
    @{Cores=6; Memory=16; Vendor="Intel"; Renderer="Intel(R) UHD Graphics 630"},
    @{Cores=8; Memory=32; Vendor="AMD"; Renderer="AMD Radeon RX 6700 XT"},
    @{Cores=4; Memory=8; Vendor="Intel"; Renderer="Intel(R) Iris(R) Xe Graphics"},
    @{Cores=12; Memory=32; Vendor="AMD"; Renderer="NVIDIA GeForce RTX 4070"},
    @{Cores=6; Memory=16; Vendor="Intel"; Renderer="NVIDIA GeForce GTX 1660"},
    @{Cores=8; Memory=16; Vendor="Apple"; Renderer="Apple M1"},
    @{Cores=10; Memory=16; Vendor="Apple"; Renderer="Apple M2"}
)

# 真实的美国常见语言设置
$realLanguages = @(
    "en-US,en;q=0.9",
    "en-US,en;q=0.9,es;q=0.8",
    "en-US,en;q=0.9,zh-CN;q=0.8",
    "en-US,en;q=0.9,fr;q=0.8"
)

# 真实的美国常见字体列表（Windows 10/11）
$realFonts = @(
    "Arial,Calibri,Cambria,Consolas,Courier New,Georgia,Segoe UI,Tahoma,Times New Roman,Trebuchet MS,Verdana",
    "Arial,Calibri,Cambria,Comic Sans MS,Consolas,Courier New,Georgia,Impact,Segoe UI,Tahoma,Times New Roman,Verdana",
    "Arial,Calibri,Cambria,Consolas,Courier New,Franklin Gothic Medium,Georgia,Segoe UI,Tahoma,Times New Roman,Verdana"
)

# ══════════════════════════════════════════════════════════════════
#  为每个浏览器生成唯一但真实的指纹
# ══════════════════════════════════════════════════════════════════

$browserConfigs = @(
    @{Name="Chrome"; Port=7891; Index=0},
    @{Name="Chromium"; Port=7892; Index=1},
    @{Name="Firefox"; Port=7893; Index=2},
    @{Name="Edge"; Port=7894; Index=3},
    @{Name="Brave"; Port=7895; Index=4},
    @{Name="Opera"; Port=7896; Index=5},
    @{Name="Vivaldi"; Port=7897; Index=6},
    @{Name="LibreWolf"; Port=7898; Index=7}
)

Write-Host "`n[*] 为每个浏览器生成真实的美国用户指纹..." -ForegroundColor Yellow

foreach ($config in $browserConfigs) {
    $index = $config.Index
    
    # 为每个浏览器分配不同但真实的配置
    $resolution = $realScreenResolutions[$index % $realScreenResolutions.Count]
    $hardware = $realHardwareConfigs[$index % $realHardwareConfigs.Count]
    $language = $realLanguages[$index % $realLanguages.Count]
    $fonts = $realFonts[$index % $realFonts.Count]
    
    Write-Host "`n[$($config.Name)] 指纹配置:" -ForegroundColor Cyan
    Write-Host "  分辨率: $($resolution.Width)x$($resolution.Height) (缩放: $($resolution.Ratio))" -ForegroundColor Gray
    Write-Host "  硬件: $($hardware.Cores)核 / $($hardware.Memory)GB / $($hardware.Vendor)" -ForegroundColor Gray
    Write-Host "  GPU: $($hardware.Renderer)" -ForegroundColor Gray
    Write-Host "  语言: $language" -ForegroundColor Gray
    
    # 生成启动参数（包含指纹伪装）
    $profileDir = "C:\BrowserProfiles\$($config.Name)"
    $launchArgs = @(
        "--user-data-dir=`"$profileDir`"",
        "--proxy-server=127.0.0.1:$($config.Port)",
        "--disable-blink-features=AutomationControlled",
        "--window-size=$($resolution.Width),$($resolution.Height)",
        "--force-device-scale-factor=$($resolution.Ratio)",
        "--lang=$($language.Split(',')[0])",
        "--disable-features=IsolateOrigins,site-per-process",
        "--disable-site-isolation-trials",
        "--disable-web-security",
        "--disable-features=CrossSiteDocumentBlockingIfIsolating",
        "--no-first-run",
        "--no-default-browser-check"
    )
    
    # 保存配置到文件
    $configFile = "C:\BrowserProfiles\$($config.Name)_fingerprint.json"
    $fingerprintConfig = @{
        resolution = $resolution
        hardware = $hardware
        language = $language
        fonts = $fonts
        launchArgs = $launchArgs
    }
    
    $fingerprintConfig | ConvertTo-Json -Depth 10 | Out-File -FilePath $configFile -Encoding UTF8 -Force
    
    Write-Host "  [✓] 指纹配置已保存" -ForegroundColor Green
}

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  完成！每个浏览器都有独特但真实的美国用户指纹" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "`n[提示] 指纹配置已保存到 C:\BrowserProfiles\*_fingerprint.json" -ForegroundColor Yellow
Write-Host "[提示] 启动脚本将自动应用这些指纹参数" -ForegroundColor Yellow
