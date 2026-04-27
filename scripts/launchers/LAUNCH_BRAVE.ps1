# Brave 启动脚本 - 带反检测参数
# 使用方法: .\LAUNCH_BRAVE.ps1 -ProfileName "Profile1" -ProxyPort 7890

param(
    [string]$ProfileName = "Default",
    [int]$ProxyPort = 7890
)

$BravePath = "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
$UserDataDir = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data"

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
    "--no-first-run"
    "--no-default-browser-check"
    "--disable-popup-blocking"
    "--disable-infobars"
    "--disable-notifications"
    "--disable-save-password-bubble"
)

Write-Host "启动 Brave - $ProfileName (代理端口: $ProxyPort)" -ForegroundColor Cyan
Start-Process -FilePath $BravePath -ArgumentList $LaunchArgs

Write-Host "[✓] Brave 已启动" -ForegroundColor Green
Write-Host "    配置文件: $ProfileName" -ForegroundColor Gray
Write-Host "    代理: socks5://127.0.0.1:$ProxyPort" -ForegroundColor Gray
Write-Host ""
Write-Host "Brave Shields 状态：" -ForegroundColor Yellow
Write-Host "  ✓ 广告拦截：已启用" -ForegroundColor Green
Write-Host "  ✓ 追踪器拦截：已启用" -ForegroundColor Green
Write-Host "  ✓ 指纹保护：已启用" -ForegroundColor Green
