# Chromium 启动脚本 - 带反检测参数
# 使用方法: .\LAUNCH_CHROMIUM.ps1 -ProfileName "Profile1" -ProxyPort 7890

param(
    [string]$ProfileName = "Default",
    [int]$ProxyPort = 7890
)

$ChromiumPath = "C:\Program Files\Chromium\Application\chrome.exe"
$UserDataDir = "$env:LOCALAPPDATA\Chromium\User Data"

# 反检测启动参数（Chromium 特有优化）
$LaunchArgs = @(
    "--user-data-dir=`"$UserDataDir`""
    "--profile-directory=`"$ProfileName`""
    "--proxy-server=`"socks5://127.0.0.1:$ProxyPort`""
    "--disable-blink-features=AutomationControlled"
    "--disable-features=IsolateOrigins,site-per-process"
    "--disable-site-isolation-trials"
    "--disable-web-security"
    "--disable-features=UserAgentClientHints"
    "--disable-background-networking"
    "--disable-breakpad"
    "--disable-crash-reporter"
    "--disable-sync"
    "--disable-translate"
    "--disable-features=AutofillServerCommunication"
    "--disable-features=MediaRouter"
    "--disable-features=OptimizationHints"
    "--no-pings"
    "--no-report-upload"
    "--disable-domain-reliability"
    "--no-first-run"
    "--no-default-browser-check"
    "--disable-popup-blocking"
    "--disable-infobars"
    "--disable-notifications"
    "--disable-save-password-bubble"
)

Write-Host "启动 Chromium - $ProfileName (代理端口: $ProxyPort)" -ForegroundColor Cyan
Start-Process -FilePath $ChromiumPath -ArgumentList $LaunchArgs

Write-Host "[✓] Chromium 已启动" -ForegroundColor Green
Write-Host "    配置文件: $ProfileName" -ForegroundColor Gray
Write-Host "    代理: socks5://127.0.0.1:$ProxyPort" -ForegroundColor Gray
