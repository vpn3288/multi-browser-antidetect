#Requires -RunAsAdministrator

<#
.SYNOPSIS
    修复所有 Chromium 系浏览器的扩展配置冲突
.DESCRIPTION
    删除 ExtensionSettings 中的 blocked 配置，保留 ExtensionInstallForcelist
#>

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "修复所有浏览器扩展配置冲突" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$browsers = @{
    "Chrome" = "HKLM:\SOFTWARE\Policies\Google\Chrome"
    "Edge" = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
    "Brave" = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"
    "Chromium" = "HKLM:\SOFTWARE\Policies\Chromium"
    "Vivaldi" = "HKLM:\SOFTWARE\Policies\Vivaldi"
    "Opera" = "HKLM:\SOFTWARE\Policies\Opera Software\Opera"
}

$fixedCount = 0

foreach ($browserName in $browsers.Keys) {
    $policyPath = $browsers[$browserName]
    
    if (-not (Test-Path $policyPath)) {
        continue
    }
    
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "检查 $browserName" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
    
    $hasConflict = $false
    
    # 检查 ExtensionSettings
    $extSettingsPath = "$policyPath\ExtensionSettings"
    if (Test-Path $extSettingsPath) {
        $extSettings = Get-ChildItem $extSettingsPath -ErrorAction SilentlyContinue
        
        if ($extSettings) {
            Write-Host "  [!] 发现 ExtensionSettings 配置" -ForegroundColor Yellow
            
            foreach ($ext in $extSettings) {
                $props = Get-ItemProperty -Path $ext.PSPath -ErrorAction SilentlyContinue
                if ($props.installation_mode -eq "blocked") {
                    Write-Host "    [✗] $($ext.PSChildName): blocked" -ForegroundColor Red
                    $hasConflict = $true
                }
            }
            
            if ($hasConflict) {
                Write-Host ""
                Write-Host "  [i] 删除冲突的 ExtensionSettings..." -ForegroundColor Yellow
                Remove-Item $extSettingsPath -Recurse -Force
                Write-Host "  [✓] 已删除" -ForegroundColor Green
                $fixedCount++
            }
        }
    }
    
    # 检查 ExtensionInstallBlocklist
    $blocklistPath = "$policyPath\ExtensionInstallBlocklist"
    if (Test-Path $blocklistPath) {
        Write-Host "  [!] 发现 ExtensionInstallBlocklist（阻止列表）" -ForegroundColor Yellow
        Remove-Item $blocklistPath -Recurse -Force
        Write-Host "  [✓] 已删除" -ForegroundColor Green
        $fixedCount++
    }
    
    # 验证 ExtensionInstallForcelist
    $forcelistPath = "$policyPath\ExtensionInstallForcelist"
    if (Test-Path $forcelistPath) {
        $forcelist = Get-ItemProperty $forcelistPath -ErrorAction SilentlyContinue
        $count = ($forcelist.PSObject.Properties | Where-Object { $_.Name -notlike "PS*" }).Count
        
        if ($count -gt 0) {
            Write-Host "  [✓] ExtensionInstallForcelist 配置正确（$count 个扩展）" -ForegroundColor Green
        } else {
            Write-Host "  [!] ExtensionInstallForcelist 为空" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  [✗] ExtensionInstallForcelist 未配置" -ForegroundColor Red
    }
    
    if (-not $hasConflict) {
        Write-Host "  [✓] 无配置冲突" -ForegroundColor Green
    }
    
    Write-Host ""
}

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "修复完成！" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

if ($fixedCount -gt 0) {
    Write-Host "已修复 $fixedCount 个浏览器的配置冲突" -ForegroundColor White
    Write-Host ""
    Write-Host "下一步操作：" -ForegroundColor Yellow
    Write-Host "  1. 完全关闭所有浏览器（包括后台进程）" -ForegroundColor White
    Write-Host "  2. 重新启动浏览器" -ForegroundColor White
    Write-Host "  3. 等待 2-3 分钟让扩展自动下载" -ForegroundColor White
    Write-Host "  4. 访问 chrome://extensions/ 查看扩展" -ForegroundColor White
    Write-Host ""
    Write-Host "验证配置：" -ForegroundColor Cyan
    Write-Host "  • Chrome/Edge/Brave/Chromium/Vivaldi: chrome://policy/" -ForegroundColor Gray
    Write-Host "  • 查找 'ExtensionInstallForcelist' 策略" -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host "所有浏览器配置正常，无需修复" -ForegroundColor Green
    Write-Host ""
}

Write-Host "如果扩展仍未自动安装，可能原因：" -ForegroundColor Yellow
Write-Host "  1. 代理阻止了 Chrome Web Store 访问" -ForegroundColor White
Write-Host "  2. 浏览器首次启动时需要网络连接" -ForegroundColor White
Write-Host "  3. 需要等待更长时间（最多 5 分钟）" -ForegroundColor White
Write-Host ""
Write-Host "手动安装方案：" -ForegroundColor Cyan
Write-Host "  运行 .\INSTALL_CHROMIUM_EXTENSIONS_MANUAL.ps1" -ForegroundColor Gray
Write-Host ""
