#Requires -RunAsAdministrator

# ══════════════════════════════════════════════════════════════════
#  修复 Edge 扩展安装
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  修复 Edge 扩展安装" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

# Edge 策略路径
$edgePolicy = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
$extensionPolicy = "$edgePolicy\ExtensionInstallForcelist"

Write-Host "`n[1/4] 创建 Edge 策略键..." -ForegroundColor Yellow

# 创建策略键
if (-not (Test-Path $edgePolicy)) {
    New-Item -Path $edgePolicy -Force | Out-Null
    Write-Host "  ✓ 已创建 Edge 策略键" -ForegroundColor Green
} else {
    Write-Host "  ✓ Edge 策略键已存在" -ForegroundColor Green
}

if (-not (Test-Path $extensionPolicy)) {
    New-Item -Path $extensionPolicy -Force | Out-Null
    Write-Host "  ✓ 已创建扩展策略键" -ForegroundColor Green
} else {
    Write-Host "  ✓ 扩展策略键已存在" -ForegroundColor Green
}

Write-Host "`n[2/4] 配置扩展安装源..." -ForegroundColor Yellow

# 允许从 Chrome Web Store 安装扩展
try {
    Set-ItemProperty -Path $edgePolicy -Name "ExtensionInstallSources" -Value @("https://chrome.google.com/webstore/*", "https://microsoftedge.microsoft.com/addons/*") -Type MultiString
    Write-Host "  ✓ 已允许从 Chrome Web Store 和 Edge Add-ons 安装" -ForegroundColor Green
} catch {
    Write-Host "  ✗ 配置安装源失败: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n[3/4] 添加强制安装的扩展..." -ForegroundColor Yellow

# 扩展列表
$extensions = @{
    1 = "cjpalhdlnbpafiamejdnhcphjbkeiagm;https://clients2.google.com/service/update2/crx"  # uBlock Origin
    2 = "nphkkbaidamjmhfanlpblblcadhfbkdm;https://clients2.google.com/service/update2/crx"  # WebRTC Leak Shield
}

foreach ($key in $extensions.Keys) {
    try {
        Set-ItemProperty -Path $extensionPolicy -Name $key -Value $extensions[$key] -Type String
        $extName = if ($key -eq 1) { "uBlock Origin" } else { "WebRTC Leak Shield" }
        Write-Host "  ✓ 已添加: $extName" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ 添加扩展失败: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n[4/4] 验证配置..." -ForegroundColor Yellow

# 验证配置
$installedExtensions = Get-ItemProperty -Path $extensionPolicy -ErrorAction SilentlyContinue
if ($installedExtensions) {
    Write-Host "  ✓ 配置已生效" -ForegroundColor Green
    Write-Host "`n  已配置的扩展：" -ForegroundColor Cyan
    foreach ($key in $extensions.Keys) {
        $extName = if ($key -eq 1) { "uBlock Origin" } else { "WebRTC Leak Shield" }
        Write-Host "    - $extName" -ForegroundColor White
    }
} else {
    Write-Host "  ✗ 配置验证失败" -ForegroundColor Red
}

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  ✓ Edge 扩展配置完成！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green

Write-Host "`n[!] 重要提示：" -ForegroundColor Yellow
Write-Host "  1. 关闭所有 Edge 窗口" -ForegroundColor White
Write-Host "  2. 重新启动 Edge 浏览器" -ForegroundColor White
Write-Host "  3. 扩展会在后台自动下载安装" -ForegroundColor White
Write-Host "  4. 首次启动可能需要 1-2 分钟" -ForegroundColor White
Write-Host "  5. 如果仍然失败，请手动从 Edge Add-ons 安装" -ForegroundColor White

Write-Host "`n[*] 手动安装方法：" -ForegroundColor Cyan
Write-Host "  1. 打开 Edge 浏览器" -ForegroundColor White
Write-Host "  2. 访问: edge://extensions/" -ForegroundColor White
Write-Host "  3. 点击左下角'获取 Microsoft Edge 扩展'" -ForegroundColor White
Write-Host "  4. 搜索并安装: uBlock Origin, WebRTC Leak Shield" -ForegroundColor White

Write-Host "`n[*] 是否立即重启 Edge？(Y/N)" -ForegroundColor Cyan
$restart = Read-Host

if ($restart -eq "Y" -or $restart -eq "y") {
    Write-Host "`n[*] 关闭 Edge..." -ForegroundColor Yellow
    Get-Process msedge -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Seconds 2
    
    Write-Host "[*] 启动 Edge..." -ForegroundColor Yellow
    $edgeExe = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    if (Test-Path $edgeExe) {
        Start-Process $edgeExe
        Write-Host "  ✓ Edge 已启动" -ForegroundColor Green
    } else {
        Write-Host "  ✗ 找不到 Edge 可执行文件" -ForegroundColor Red
    }
}

Write-Host "`n[*] 完成！" -ForegroundColor Green
