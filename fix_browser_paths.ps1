# ============================================================================
# 浏览器路径修复脚本
# ============================================================================
# 功能：修复 CONFIGURE_ALL_BROWSERS.ps1 中的浏览器检测路径
# 使用方法：在项目目录下运行此脚本
# ============================================================================

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "修复浏览器检测路径" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# 检查是否在正确的目录
if (-not (Test-Path ".\CONFIGURE_ALL_BROWSERS.ps1")) {
    Write-Host "[✗] 错误：未找到 CONFIGURE_ALL_BROWSERS.ps1" -ForegroundColor Red
    Write-Host "    请在 multi-browser-antidetect 目录下运行此脚本" -ForegroundColor Yellow
    exit 1
}

Write-Host "[1/4] 备份原文件..." -ForegroundColor Yellow
Copy-Item .\CONFIGURE_ALL_BROWSERS.ps1 .\CONFIGURE_ALL_BROWSERS.ps1.backup -Force
Write-Host "  [✓] 已备份到 CONFIGURE_ALL_BROWSERS.ps1.backup" -ForegroundColor Green
Write-Host ""

Write-Host "[2/4] 修复浏览器路径..." -ForegroundColor Yellow

# 修复 Chromium 路径
Write-Host "  修复 Chromium 路径..." -ForegroundColor Gray
(Get-Content .\CONFIGURE_ALL_BROWSERS.ps1) -replace 'C:\\Program Files\\Chromium\\Application\\chrome.exe', '$env:LOCALAPPDATA\Chromium\Application\chrome.exe' | Set-Content .\CONFIGURE_ALL_BROWSERS.ps1

# 修复 Vivaldi 路径
Write-Host "  修复 Vivaldi 路径..." -ForegroundColor Gray
(Get-Content .\CONFIGURE_ALL_BROWSERS.ps1) -replace 'C:\\Program Files\\Vivaldi\\Application\\vivaldi.exe', '$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe' | Set-Content .\CONFIGURE_ALL_BROWSERS.ps1

# 修复 Opera 路径
Write-Host "  修复 Opera 路径..." -ForegroundColor Gray
(Get-Content .\CONFIGURE_ALL_BROWSERS.ps1) -replace 'C:\\Program Files\\Opera\\launcher.exe', '$env:LOCALAPPDATA\Programs\Opera\opera.exe' | Set-Content .\CONFIGURE_ALL_BROWSERS.ps1

Write-Host "  [✓] 路径修复完成" -ForegroundColor Green
Write-Host ""

Write-Host "[3/4] 验证修复结果..." -ForegroundColor Yellow
$content = Get-Content .\CONFIGURE_ALL_BROWSERS.ps1 -Raw

$chromiumOk = $content -match '\$env:LOCALAPPDATA\\Chromium\\Application\\chrome.exe'
$vivaldiOk = $content -match '\$env:LOCALAPPDATA\\Vivaldi\\Application\\vivaldi.exe'
$operaOk = $content -match '\$env:LOCALAPPDATA\\Programs\\Opera\\opera.exe'

if ($chromiumOk) {
    Write-Host "  [✓] Chromium 路径正确" -ForegroundColor Green
} else {
    Write-Host "  [✗] Chromium 路径修复失败" -ForegroundColor Red
}

if ($vivaldiOk) {
    Write-Host "  [✓] Vivaldi 路径正确" -ForegroundColor Green
} else {
    Write-Host "  [✗] Vivaldi 路径修复失败" -ForegroundColor Red
}

if ($operaOk) {
    Write-Host "  [✓] Opera 路径正确" -ForegroundColor Green
} else {
    Write-Host "  [✗] Opera 路径修复失败" -ForegroundColor Red
}

Write-Host ""

Write-Host "[4/4] 测试浏览器检测..." -ForegroundColor Yellow
Write-Host ""

$testPaths = @{
    "Chromium" = "$env:LOCALAPPDATA\Chromium\Application\chrome.exe"
    "Vivaldi" = "$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe"
    "Opera" = "$env:LOCALAPPDATA\Programs\Opera\opera.exe"
}

foreach ($browser in $testPaths.GetEnumerator()) {
    if (Test-Path $browser.Value) {
        Write-Host "  [✓] $($browser.Key) 已安装" -ForegroundColor Green
    } else {
        Write-Host "  [✗] $($browser.Key) 未安装" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "修复完成" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步：运行 .\CONFIGURE_ALL_BROWSERS.ps1 配置浏览器" -ForegroundColor Yellow
Write-Host ""
