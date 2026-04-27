param([string]$ProfileName = "default-release", [int]$ProxyPort = 7890)
$LibreWolfPath = "C:\Program Files\LibreWolf\librewolf.exe"
$env:HTTP_PROXY = "socks5://127.0.0.1:$ProxyPort"
$env:HTTPS_PROXY = "socks5://127.0.0.1:$ProxyPort"
$LaunchArgs = @("-P", $ProfileName, "-no-remote")
Write-Host "启动 LibreWolf - $ProfileName (代理: $ProxyPort)" -ForegroundColor Cyan
Start-Process -FilePath $LibreWolfPath -ArgumentList $LaunchArgs
Write-Host "[✓] LibreWolf 已启动" -ForegroundColor Green
Write-Host "  ✓ 最大隐私保护（预配置）" -ForegroundColor White
Write-Host "  ✓ Resist Fingerprinting 已启用" -ForegroundColor White
Write-Host "  ✓ 所有 Mozilla 遥测已移除" -ForegroundColor White
