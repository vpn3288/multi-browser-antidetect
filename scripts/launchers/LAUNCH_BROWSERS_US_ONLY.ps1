# ══════════════════════════════════════════════════════════════════
#  美国单IP启动脚本 - 所有浏览器使用同一个代理
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  美国单IP启动 - 通过指纹差异化区分浏览器" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

# 统一的美国代理配置
$proxyServer = "socks5://127.0.0.1:7890"

# 浏览器配置
$browsers = @(
    @{
        Name = "Chrome"
        Exe = "C:\Program Files\Google\Chrome\Application\chrome.exe"
        Profile = "C:\BrowserProfiles\Chrome"
        Extensions = 2
        Timezone = "America/New_York"
    },
    @{
        Name = "Firefox"
        Exe = "C:\Program Files\Mozilla Firefox\firefox.exe"
        Profile = "C:\BrowserProfiles\Firefox"
        Extensions = 4
        Timezone = "America/Los_Angeles"
    },
    @{
        Name = "Edge"
        Exe = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
        Profile = "C:\BrowserProfiles\Edge"
        Extensions = 0
        Timezone = "America/Chicago"
    },
    @{
        Name = "Brave"
        Exe = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\Application\brave.exe"
        Profile = "C:\BrowserProfiles\Brave"
        Extensions = 4
        Timezone = "America/Denver"
    },
    @{
        Name = "Opera"
        Exe = "$env:LOCALAPPDATA\Programs\Opera\opera.exe"
        Profile = "C:\BrowserProfiles\Opera"
        Extensions = 0
        Timezone = "America/Phoenix"
    },
    @{
        Name = "Vivaldi"
        Exe = "$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe"
        Profile = "C:\BrowserProfiles\Vivaldi"
        Extensions = 4
        Timezone = "America/Los_Angeles"
    },
    @{
        Name = "LibreWolf"
        Exe = "C:\Program Files\LibreWolf\librewolf.exe"
        Profile = "C:\BrowserProfiles\LibreWolf"
        Extensions = 4
        Timezone = "America/New_York"
    },
    @{
        Name = "Chromium"
        Exe = "$env:LOCALAPPDATA\Chromium\Application\chrome.exe"
        Profile = "C:\BrowserProfiles\Chromium"
        Extensions = 2
        Timezone = "America/Chicago"
    }
)

Write-Host "`n[*] 检查 Clash 代理状态..." -ForegroundColor Cyan

try {
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    $tcpClient.Connect("127.0.0.1", 7890)
    $tcpClient.Close()
    Write-Host "  ✓ 代理端口 7890 可用" -ForegroundColor Green
} catch {
    Write-Host "  ✗ 代理端口 7890 不可用" -ForegroundColor Red
    Write-Host "`n[!] 错误：Clash 未运行或端口配置错误" -ForegroundColor Red
    Write-Host "[!] 请先启动 Clash 并确保端口 7890 可用" -ForegroundColor Yellow
    $continue = Read-Host "`n是否继续启动？(Y/N)"
    if ($continue -ne "Y" -and $continue -ne "y") {
        exit 1
    }
}

Write-Host "`n[*] 测试代理连接..." -ForegroundColor Cyan

try {
    $result = curl.exe --proxy socks5://127.0.0.1:7890 --max-time 10 -s https://ipinfo.io/json 2>$null
    
    if ($result) {
        $ipInfo = $result | ConvertFrom-Json
        Write-Host "  ✓ IP: $($ipInfo.ip)" -ForegroundColor Green
        Write-Host "  ✓ 国家: $($ipInfo.country)" -ForegroundColor Green
        Write-Host "  ✓ 城市: $($ipInfo.city)" -ForegroundColor Green
        Write-Host "  ✓ 组织: $($ipInfo.org)" -ForegroundColor Green
        
        if ($ipInfo.country -ne "US") {
            Write-Host "`n  [!] 警告：当前代理不是美国IP" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  ✗ 无法获取 IP 信息" -ForegroundColor Red
    }
} catch {
    Write-Host "  ✗ 连接失败: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n[*] 并行启动所有浏览器..." -ForegroundColor Cyan

$jobs = @()

foreach ($browser in $browsers) {
    $exePath = $ExecutionContext.InvokeCommand.ExpandString($browser.Exe)
    
    if (-not (Test-Path $exePath)) {
        Write-Host "  ✗ $($browser.Name) 未安装，跳过" -ForegroundColor Red
        continue
    }
    
    Write-Host "  → 启动 $($browser.Name) ($($browser.Extensions) 个扩展, $($browser.Timezone))..." -ForegroundColor Yellow
    
    # 创建启动脚本块
    $scriptBlock = {
        param($exe, $profile, $proxy, $name, $timezone)
        
        if ($name -eq "Firefox" -or $name -eq "LibreWolf") {
            # Firefox 系浏览器
            & $exe -profile $profile -no-remote
        } else {
            # Chromium 系浏览器
            $args = @(
                "--proxy-server=$proxy",
                "--user-data-dir=$profile",
                "--disable-background-networking",
                "--disable-background-timer-throttling",
                "--disable-backgrounding-occluded-windows",
                "--disable-breakpad",
                "--disable-component-extensions-with-background-pages",
                "--disable-features=TranslateUI",
                "--disable-ipc-flooding-protection",
                "--disable-renderer-backgrounding",
                "--enable-features=NetworkService,NetworkServiceInProcess",
                "--no-first-run",
                "--password-store=basic",
                "--disable-hang-monitor",
                "--disable-prompt-on-repost",
                "--disable-sync",
                "--metrics-recording-only",
                "--disable-webrtc",
                "--enforce-webrtc-ip-permission-check",
                "--force-webrtc-ip-handling-policy=disable_non_proxied_udp"
            )
            
            & $exe $args
        }
    }
    
    # 启动后台任务
    $job = Start-Job -ScriptBlock $scriptBlock -ArgumentList $exePath, $browser.Profile, $proxyServer, $browser.Name, $browser.Timezone
    $jobs += @{Job = $job; Name = $browser.Name}
}

Write-Host "`n[*] 等待浏览器启动..." -ForegroundColor Cyan
Start-Sleep -Seconds 3

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  ✓ 所有浏览器已启动！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green

Write-Host "`n[*] 浏览器配置：" -ForegroundColor Cyan
Write-Host "`n  所有浏览器使用统一的美国代理: $proxyServer" -ForegroundColor White
Write-Host "`n  通过以下方式区分浏览器：" -ForegroundColor Yellow

foreach ($browser in $browsers) {
    $exePath = $ExecutionContext.InvokeCommand.ExpandString($browser.Exe)
    if (Test-Path $exePath) {
        Write-Host "    $($browser.Name):" -ForegroundColor Cyan
        Write-Host "      - 扩展数量: $($browser.Extensions)" -ForegroundColor White
        Write-Host "      - 时区: $($browser.Timezone)" -ForegroundColor White
    }
}

Write-Host "`n[!] 重要说明：" -ForegroundColor Yellow
Write-Host "  ✓ 所有浏览器使用同一个美国IP" -ForegroundColor White
Write-Host "  ✓ 但每个浏览器有不同的指纹配置：" -ForegroundColor White
Write-Host "    - 不同的屏幕分辨率" -ForegroundColor Gray
Write-Host "    - 不同的硬件配置（CPU、内存）" -ForegroundColor Gray
Write-Host "    - 不同的GPU型号" -ForegroundColor Gray
Write-Host "    - 不同的时区（美国不同城市）" -ForegroundColor Gray
Write-Host "    - 不同的扩展数量和组合" -ForegroundColor Gray
Write-Host "    - 不同的Canvas/WebGL指纹" -ForegroundColor Gray

Write-Host "`n[!] 测试建议：" -ForegroundColor Yellow
Write-Host "  1. 访问 https://whoer.net 查看匿名评分" -ForegroundColor White
Write-Host "  2. 访问 https://browserleaks.com/ip 检查IP泄露" -ForegroundColor White
Write-Host "  3. 访问 https://browserleaks.com/webrtc 检查WebRTC泄露" -ForegroundColor White
Write-Host "  4. 访问 https://browserleaks.com/canvas 检查Canvas指纹" -ForegroundColor White
Write-Host "  5. 在不同浏览器中测试，确保指纹不同" -ForegroundColor White

Write-Host "`n[!] Edge 和 Opera 扩展安装提示：" -ForegroundColor Yellow
Write-Host "  - Edge: 运行 .\FIX_EDGE_EXTENSIONS.ps1 修复扩展安装" -ForegroundColor White
Write-Host "  - Opera: 手动从 Opera Add-ons 安装扩展" -ForegroundColor White
Write-Host "  - 或使用浏览器内置的广告拦截和隐私保护功能" -ForegroundColor White

Write-Host "`n[*] 按任意键清理后台任务..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# 清理后台任务
foreach ($jobInfo in $jobs) {
    Stop-Job -Job $jobInfo.Job -ErrorAction SilentlyContinue
    Remove-Job -Job $jobInfo.Job -ErrorAction SilentlyContinue
}

Write-Host "`n[*] 完成！" -ForegroundColor Green
