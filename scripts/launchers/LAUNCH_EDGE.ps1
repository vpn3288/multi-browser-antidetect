# Edge 启动脚本 - 带反检测参数
# 使用方法: .\LAUNCH_EDGE.ps1 -ProfileName "Profile1" -ProxyPort 7890

param(
    [string]$ProfileName = "Default",
    [int]$ProxyPort = 7890
)

$EdgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$UserDataDir = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"

# 反检测启动参数
$LaunchArgs = @(
    "--user-data-dir=`"$UserDataDir`""
    "--profile-directory=`"$ProfileName`""
    "--proxy-server=`"socks5://127.0.0.1:$ProxyPort`""
    "--disable-blink-features=AutomationControlled"
    "--disable-features=IsolateOrigins,site-per-process"
    "--disable-site-isolation-trials"
    "--disable-web-security"
    "--disable-features=UserAgentClientHints"
    "--disable-features=msEdgeShoppingAssistant"
    "--disable-features=msEdgeWalletCheckout"
    "--no-first-run"
    "--no-default-browser-check"
    "--disable-popup-blocking"
    "--disable-infobars"
    "--disable-notifications"
    "--disable-save-password-bubble"
)

Write-Host "启动 Edge - $ProfileName (代理端口: $ProxyPort)" -ForegroundColor Cyan
Start-Process -FilePath $EdgePath -ArgumentList $LaunchArgs

Write-Host "[✓] Edge 已启动" -ForegroundColor Green
Write-Host "    配置文件: $ProfileName" -ForegroundColor Gray
Write-Host "    代理: socks5://127.0.0.1:$ProxyPort" -ForegroundColor Gray
