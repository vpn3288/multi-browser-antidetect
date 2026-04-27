#Requires -RunAsAdministrator

Write-Host "修复 Opera 扩展配置..." -ForegroundColor Cyan
Write-Host ""

# 1. 确保 Opera 已关闭
$operaProcess = Get-Process "opera" -ErrorAction SilentlyContinue
if ($operaProcess) {
    Write-Host "[!] 检测到 Opera 正在运行，正在关闭..." -ForegroundColor Yellow
    Stop-Process -Name "opera" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

# 2. 配置注册表策略
$policyPath = "HKLM:\SOFTWARE\Policies\Opera Software\Opera"

# 启用 Chrome Web Store
Write-Host "[1/4] 启用 Chrome Web Store 访问..." -ForegroundColor Yellow
Set-ItemProperty -Path $policyPath -Name "ExtensionInstallSources" -Value @(
    "https://chrome.google.com/webstore/*",
    "https://addons.opera.com/*"
) -Type MultiString -Force
Write-Host "  [✓] 已启用" -ForegroundColor Green

# 允许所有扩展
Write-Host "`n[2/4] 配置扩展白名单..." -ForegroundColor Yellow
if (-not (Test-Path "$policyPath\ExtensionInstallAllowlist")) {
    New-Item -Path "$policyPath\ExtensionInstallAllowlist" -Force | Out-Null
}

$allowlistPath = "$policyPath\ExtensionInstallAllowlist"
Set-ItemProperty -Path $allowlistPath -Name "1" -Value "*" -Force
Write-Host "  [✓] 已配置" -ForegroundColor Green

# 3. 配置强制安装扩展
Write-Host "`n[3/4] 配置强制安装扩展..." -ForegroundColor Yellow

$extensions = @{
    "1" = "cjpalhdlnbpafiamejdnhcphjbkeiagm;https://clients2.google.com/service/update2/crx"  # uBlock Origin
    "2" = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp;https://clients2.google.com/service/update2/crx"  # Privacy Badger
    "3" = "gcbommkclmclpchllfjekcdonpmejbdp;https://clients2.google.com/service/update2/crx"  # HTTPS Everywhere
    "4" = "ldpochfccmkkmhdbclfhpagapcfdljkj;https://clients2.google.com/service/update2/crx"  # Decentraleyes
}

$forcelistPath = "$policyPath\ExtensionInstallForcelist"
if (-not (Test-Path $forcelistPath)) {
    New-Item -Path $forcelistPath -Force | Out-Null
}

foreach ($key in $extensions.Keys) {
    Set-ItemProperty -Path $forcelistPath -Name $key -Value $extensions[$key] -Force
    $extId = ($extensions[$key] -split ";")[0]
    Write-Host "  [✓] $key. $extId" -ForegroundColor Green
}

# 4. 清理旧的配置文件（可选）
Write-Host "`n[4/4] 清理扩展缓存..." -ForegroundColor Yellow
$profilePath = "C:\BrowserProfiles\Opera"
$extensionStatePath = "$profilePath\Extension State"

if (Test-Path $extensionStatePath) {
    Remove-Item $extensionStatePath -Force -ErrorAction SilentlyContinue
    Write-Host "  [✓] 已清理扩展状态" -ForegroundColor Green
} else {
    Write-Host "  [i] 无需清理" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "配置完成！" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步操作：" -ForegroundColor Yellow
Write-Host "  1. 运行 .\LAUNCH_OPERA.ps1 启动 Opera" -ForegroundColor White
Write-Host "  2. 首次启动时，Opera 会下载并安装扩展（需要几分钟）" -ForegroundColor White
Write-Host "  3. 访问 opera://extensions/ 查看扩展" -ForegroundColor White
Write-Host "  4. 如果扩展未自动安装，请检查代理设置和网络连接" -ForegroundColor White
Write-Host ""
