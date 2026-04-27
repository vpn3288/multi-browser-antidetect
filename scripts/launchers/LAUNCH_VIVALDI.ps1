param([string]$ProfileName = "Default", [int]$ProxyPort = 7890)
$VivaldiPath = "C:\Program Files\Vivaldi\Application\vivaldi.exe"
$UserDataDir = "$env:LOCALAPPDATA\Vivaldi\User Data"
$LaunchArgs = @(
    "--user-data-dir=`"$UserDataDir`""
    "--profile-directory=`"$ProfileName`""
    "--proxy-server=`"socks5://127.0.0.1:$ProxyPort`""
    "--disable-blink-features=AutomationControlled"
    "--no-first-run"
)
Write-Host "启动 Vivaldi - $ProfileName (代理: $ProxyPort)" -ForegroundColor Cyan
Start-Process -FilePath $VivaldiPath -ArgumentList $LaunchArgs
Write-Host "[✓] Vivaldi 已启动" -ForegroundColor Green
