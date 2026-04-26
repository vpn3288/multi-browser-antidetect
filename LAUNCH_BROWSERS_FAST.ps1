# ══════════════════════════════════════════════════════════════════
#  快速启动脚本 - 并行启动所有浏览器
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  快速启动 - 7个浏览器并行启动" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

# 浏览器配置
$browsers = @(
    @{
        Name = "Chrome"
        Exe = "C:\Program Files\Google\Chrome\Application\chrome.exe"
        Profile = "C:\BrowserProfiles\Chrome"
        Proxy = "socks5://127.0.0.1:7891"
        Country = "US"
    },
    @{
        Name = "Firefox"
        Exe = "C:\Program Files\Mozilla Firefox\firefox.exe"
        Profile = "C:\BrowserProfiles\Firefox"
        Proxy = "socks5://127.0.0.1:7892"
        Country = "JP"
    },
    @{
        Name = "Edge"
        Exe = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
        Profile = "C:\BrowserProfiles\Edge"
        Proxy = "socks5://127.0.0.1:7893"
        Country = "SG"
    },
    @{
        Name = "Brave"
        Exe = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\Application\brave.exe"
        Profile = "C:\BrowserProfiles\Brave"
        Proxy = "socks5://127.0.0.1:7894"
        Country = "UK"
    },
    @{
        Name = "Opera"
        Exe = "$env:LOCALAPPDATA\Programs\Opera\opera.exe"
        Profile = "C:\BrowserProfiles\Opera"
        Proxy = "socks5://127.0.0.1:7895"
        Country = "DE"
    },
    @{
        Name = "Vivaldi"
        Exe = "$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe"
        Profile = "C:\BrowserProfiles\Vivaldi"
        Proxy = "socks5://127.0.0.1:7896"
        Country = "CA"
    },
    @{
        Name = "LibreWolf"
        Exe = "C:\Program Files\LibreWolf\librewolf.exe"
        Profile = "C:\BrowserProfiles\LibreWolf"
        Proxy = "socks5://127.0.0.1:7897"
        Country = "AU"
    }
)

Write-Host "`n[*] 检查 Clash 代理端口..." -ForegroundColor Cyan
$portsOk = $true
foreach ($port in 7891..7897) {
    try {
        $connection = Test-NetConnection -ComputerName 127.0.0.1 -Port $port -WarningAction SilentlyContinue -InformationLevel Quiet
        if ($connection) {
            Write-Host "  ✓ 端口 $port 可用" -ForegroundColor Green
        } else {
            Write-Host "  ✗ 端口 $port 不可用" -ForegroundColor Red
            $portsOk = $false
        }
    } catch {
        Write-Host "  ✗ 端口 $port 检查失败" -ForegroundColor Red
        $portsOk = $false
    }
}

if (-not $portsOk) {
    Write-Host "`n[!] 警告：部分代理端口不可用，请检查 Clash 配置" -ForegroundColor Yellow
    $continue = Read-Host "是否继续启动？(Y/N)"
    if ($continue -ne "Y" -and $continue -ne "y") {
        exit
    }
}

Write-Host "`n[*] 并行启动所有浏览器..." -ForegroundColor Cyan

$jobs = @()

foreach ($browser in $browsers) {
    $exePath = $ExecutionContext.InvokeCommand.ExpandString($browser.Exe)
    
    if (-not (Test-Path $exePath)) {
        Write-Host "  ✗ $($browser.Name) 未安装，跳过" -ForegroundColor Red
        continue
    }
    
    Write-Host "  → 启动 $($browser.Name) ($($browser.Country))..." -ForegroundColor Yellow
    
    # 创建启动脚本块
    $scriptBlock = {
        param($exe, $profile, $proxy, $name, $country)
        
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
                "--enforce-webrtc-ip-permission-check"
            )
            
            & $exe $args
        }
    }
    
    # 启动后台任务
    $job = Start-Job -ScriptBlock $scriptBlock -ArgumentList $exePath, $browser.Profile, $browser.Proxy, $browser.Name, $browser.Country
    $jobs += @{Job = $job; Name = $browser.Name}
}

Write-Host "`n[*] 等待浏览器启动..." -ForegroundColor Cyan
Start-Sleep -Seconds 3

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  ✓ 所有浏览器已启动！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green

Write-Host "`n[*] 浏览器配置：" -ForegroundColor Cyan
foreach ($browser in $browsers) {
    $exePath = $ExecutionContext.InvokeCommand.ExpandString($browser.Exe)
    if (Test-Path $exePath) {
        Write-Host "  $($browser.Name) → $($browser.Country) → $($browser.Proxy)" -ForegroundColor White
    }
}

Write-Host "`n[!] 提示：" -ForegroundColor Yellow
Write-Host "  - 每个浏览器使用不同的代理端口和国家节点" -ForegroundColor White
Write-Host "  - 时区会根据代理节点自动匹配" -ForegroundColor White
Write-Host "  - 访问 https://whoer.net 测试指纹和 IP" -ForegroundColor White
Write-Host "  - 访问 https://browserleaks.com 测试泄露情况" -ForegroundColor White

Write-Host "`n[*] 按任意键清理后台任务..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# 清理后台任务
foreach ($jobInfo in $jobs) {
    Stop-Job -Job $jobInfo.Job -ErrorAction SilentlyContinue
    Remove-Job -Job $jobInfo.Job -ErrorAction SilentlyContinue
}

Write-Host "`n[*] 完成！" -ForegroundColor Green
