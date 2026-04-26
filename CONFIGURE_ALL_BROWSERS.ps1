# ============================================================================
# 统一浏览器配置管理脚本
# ============================================================================
# 功能：一键配置所有 8 个浏览器
# 使用方法：以管理员身份运行此脚本
# ============================================================================

#Requires -RunAsAdministrator

$ErrorActionPreference = "Continue"

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "统一浏览器配置管理" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# 检测已安装的浏览器
Write-Host "[1/3] 检测已安装的浏览器..." -ForegroundColor Yellow
Write-Host ""

$Browsers = @{
    "Chrome" = @{
        "Path" = "C:\Program Files\Google\Chrome\Application\chrome.exe"
        "Script" = ".\CHROME_ENTERPRISE_CONFIG.ps1"
        "Installed" = $false
    }
    "Chromium" = @{
        "Path" = "C:\Program Files\Chromium\Application\chrome.exe"
        "Script" = ".\CHROMIUM_ENTERPRISE_CONFIG.ps1"
        "Installed" = $false
    }
    "Edge" = @{
        "Path" = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
        "Script" = ".\EDGE_ENTERPRISE_CONFIG.ps1"
        "Installed" = $false
    }
    "Firefox" = @{
        "Path" = "C:\Program Files\Mozilla Firefox\firefox.exe"
        "Script" = ".\FIREFOX_ENTERPRISE_CONFIG.ps1"
        "Installed" = $false
    }
    "Brave" = @{
        "Path" = "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
        "Script" = ".\BRAVE_ENTERPRISE_CONFIG.ps1"
        "Installed" = $false
    }
    "Vivaldi" = @{
        "Path" = "C:\Program Files\Vivaldi\Application\vivaldi.exe"
        "Script" = ".\VIVALDI_ENTERPRISE_CONFIG.ps1"
        "Installed" = $false
    }
    "LibreWolf" = @{
        "Path" = "C:\Program Files\LibreWolf\librewolf.exe"
        "Script" = ".\LIBREWOLF_ENTERPRISE_CONFIG.ps1"
        "Installed" = $false
    }
    "Opera" = @{
        "Path" = "C:\Program Files\Opera\launcher.exe"
        "Script" = ".\OPERA_AUTO_CONFIG.ps1"
        "Installed" = $false
    }
}

$InstalledBrowsers = @()

foreach ($browser in $Browsers.GetEnumerator()) {
    $name = $browser.Key
    $path = $browser.Value.Path
    
    if (Test-Path $path) {
        $Browsers[$name].Installed = $true
        $InstalledBrowsers += $name
        Write-Host "  [✓] $name" -ForegroundColor Green
    } else {
        Write-Host "  [✗] $name (未安装)" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "检测到 $($InstalledBrowsers.Count) 个已安装的浏览器" -ForegroundColor Cyan
Write-Host ""

if ($InstalledBrowsers.Count -eq 0) {
    Write-Host "[✗] 未检测到任何浏览器，退出" -ForegroundColor Red
    exit 1
}

# 询问用户是否配置所有浏览器
Write-Host "[2/3] 选择配置模式..." -ForegroundColor Yellow
Write-Host ""
Write-Host "1. 配置所有已安装的浏览器 (推荐)" -ForegroundColor White
Write-Host "2. 选择要配置的浏览器" -ForegroundColor White
Write-Host "3. 退出" -ForegroundColor White
Write-Host ""

$choice = Read-Host "请选择 (1-3)"

$BrowsersToConfig = @()

switch ($choice) {
    "1" {
        $BrowsersToConfig = $InstalledBrowsers
        Write-Host ""
        Write-Host "[i] 将配置所有 $($BrowsersToConfig.Count) 个浏览器" -ForegroundColor Cyan
    }
    "2" {
        Write-Host ""
        Write-Host "请选择要配置的浏览器（用空格分隔，例如：1 3 5）：" -ForegroundColor Yellow
        for ($i = 0; $i -lt $InstalledBrowsers.Count; $i++) {
            Write-Host "  $($i + 1). $($InstalledBrowsers[$i])" -ForegroundColor White
        }
        Write-Host ""
        
        $selection = Read-Host "请输入编号"
        $indices = $selection -split '\s+' | Where-Object { $_ -match '^\d+$' } | ForEach-Object { [int]$_ - 1 }
        
        foreach ($index in $indices) {
            if ($index -ge 0 -and $index -lt $InstalledBrowsers.Count) {
                $BrowsersToConfig += $InstalledBrowsers[$index]
            }
        }
        
        if ($BrowsersToConfig.Count -eq 0) {
            Write-Host "[✗] 未选择任何浏览器，退出" -ForegroundColor Red
            exit 1
        }
        
        Write-Host ""
        Write-Host "[i] 将配置 $($BrowsersToConfig.Count) 个浏览器：$($BrowsersToConfig -join ', ')" -ForegroundColor Cyan
    }
    "3" {
        Write-Host ""
        Write-Host "[i] 退出" -ForegroundColor Yellow
        exit 0
    }
    default {
        Write-Host ""
        Write-Host "[✗] 无效选择，退出" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "按任意键开始配置..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Write-Host ""

# 配置浏览器
Write-Host "[3/3] 配置浏览器..." -ForegroundColor Yellow
Write-Host ""

$SuccessCount = 0
$FailCount = 0

foreach ($browserName in $BrowsersToConfig) {
    $script = $Browsers[$browserName].Script
    
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "配置 $browserName" -ForegroundColor Cyan
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host ""
    
    if (Test-Path $script) {
        try {
            & $script
            $SuccessCount++
            Write-Host ""
            Write-Host "[✓] $browserName 配置成功" -ForegroundColor Green
        } catch {
            $FailCount++
            Write-Host ""
            Write-Host "[✗] $browserName 配置失败：$($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        $FailCount++
        Write-Host "[✗] 配置脚本不存在：$script" -ForegroundColor Red
    }
    
    Write-Host ""
}

# 总结
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "配置完成" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "配置结果：" -ForegroundColor Yellow
Write-Host "  成功：$SuccessCount 个浏览器" -ForegroundColor Green
if ($FailCount -gt 0) {
    Write-Host "  失败：$FailCount 个浏览器" -ForegroundColor Red
}
Write-Host ""

Write-Host "下一步：" -ForegroundColor Yellow
Write-Host "  1. 重启所有浏览器使配置生效" -ForegroundColor White
Write-Host "  2. 验证配置：" -ForegroundColor White
Write-Host "     - Chrome/Chromium/Edge/Brave/Vivaldi/Opera: 访问 chrome://policy" -ForegroundColor Gray
Write-Host "     - Firefox/LibreWolf: 访问 about:policies" -ForegroundColor Gray
Write-Host "  3. 使用启动脚本启动浏览器：" -ForegroundColor White
Write-Host "     - .\LAUNCH_CHROME.ps1" -ForegroundColor Gray
Write-Host "     - .\LAUNCH_FIREFOX.ps1" -ForegroundColor Gray
Write-Host "     - 等等..." -ForegroundColor Gray
Write-Host ""

Write-Host "隐私测试：" -ForegroundColor Yellow
Write-Host "  - WebRTC 泄漏: https://browserleaks.com/webrtc" -ForegroundColor White
Write-Host "  - 指纹测试: https://coveryourtracks.eff.org/" -ForegroundColor White
Write-Host "  - DNS 泄漏: https://dnsleaktest.com/" -ForegroundColor White
Write-Host "  - IP 泄漏: https://ipleak.net/" -ForegroundColor White
Write-Host ""

Write-Host "按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
