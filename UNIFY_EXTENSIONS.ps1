#Requires -RunAsAdministrator

# ============================================================================
# 统一所有浏览器扩展配置
# ============================================================================
# 功能：为所有 Chromium 系浏览器配置统一的 4 个隐私扩展
# ============================================================================

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "统一浏览器扩展配置" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# 标准扩展列表（4个）
$StandardExtensions = @{
    "uBlock Origin" = "cjpalhdlnbpafiamejdnhcphjbkeiagm"
    "Privacy Badger" = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"
    "HTTPS Everywhere" = "gcbommkclmclpchllfjekcdonpmejbdp"
    "Decentraleyes" = "ldpochfccmkkmhdbclfhpagapcfdljkj"
}

Write-Host "标准扩展列表：" -ForegroundColor Yellow
foreach ($ext in $StandardExtensions.GetEnumerator()) {
    Write-Host "  - $($ext.Key)" -ForegroundColor White
}
Write-Host ""

# 浏览器策略路径
$Browsers = @{
    "Chrome" = "HKLM:\SOFTWARE\Policies\Google\Chrome"
    "Chromium" = "HKLM:\SOFTWARE\Policies\Chromium"
    "Edge" = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
    "Brave" = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"
    "Vivaldi" = "HKLM:\SOFTWARE\Policies\Vivaldi"
    "Opera" = "HKLM:\SOFTWARE\Policies\Opera Software\Opera"
}

$SuccessCount = 0
$FailCount = 0

foreach ($browser in $Browsers.GetEnumerator()) {
    $browserName = $browser.Key
    $policyPath = $browser.Value
    
    Write-Host "[$browserName] 配置扩展..." -ForegroundColor Yellow
    
    # 检查策略路径是否存在
    if (-not (Test-Path $policyPath)) {
        Write-Host "  [!] 策略路径不存在，跳过" -ForegroundColor Gray
        continue
    }
    
    try {
        # 创建 ExtensionSettings 路径
        $ExtensionSettingsPath = "$policyPath\ExtensionSettings"
        if (-not (Test-Path $ExtensionSettingsPath)) {
            New-Item -Path $ExtensionSettingsPath -Force | Out-Null
        }
        
        # 配置每个扩展
        foreach ($ext in $StandardExtensions.GetEnumerator()) {
            $extName = $ext.Key
            $extId = $ext.Value
            $extPath = "$ExtensionSettingsPath\$extId"
            
            if (-not (Test-Path $extPath)) {
                New-Item -Path $extPath -Force | Out-Null
            }
            
            Set-ItemProperty -Path $extPath -Name "installation_mode" -Value "force_installed" -Type String -Force
            Set-ItemProperty -Path $extPath -Name "update_url" -Value "https://clients2.google.com/service/update2/crx" -Type String -Force
            
            Write-Host "  [✓] $extName" -ForegroundColor Green
        }
        
        # 阻止其他扩展
        $BlockAllPath = "$ExtensionSettingsPath\*"
        if (-not (Test-Path $BlockAllPath)) {
            New-Item -Path $BlockAllPath -Force | Out-Null
        }
        Set-ItemProperty -Path $BlockAllPath -Name "installation_mode" -Value "blocked" -Type String -Force
        
        Write-Host "  [✓] 已阻止其他扩展" -ForegroundColor Green
        $SuccessCount++
        
    } catch {
        Write-Host "  [✗] 配置失败: $($_.Exception.Message)" -ForegroundColor Red
        $FailCount++
    }
    
    Write-Host ""
}

# Opera 特殊处理（使用 ExtensionInstallForcelist）
Write-Host "[Opera] 特殊配置..." -ForegroundColor Yellow
$operaPolicyPath = "HKLM:\SOFTWARE\Policies\Opera Software\Opera"

if (Test-Path $operaPolicyPath) {
    try {
        $extensionPolicyPath = "$operaPolicyPath\ExtensionInstallForcelist"
        if (-not (Test-Path $extensionPolicyPath)) {
            New-Item -Path $extensionPolicyPath -Force | Out-Null
        }
        
        # Opera 使用不同的格式
        $index = 1
        foreach ($ext in $StandardExtensions.GetEnumerator()) {
            $extId = $ext.Value
            $value = "$extId;https://clients2.google.com/service/update2/crx"
            Set-ItemProperty -Path $extensionPolicyPath -Name $index -Value $value -Type String -Force
            Write-Host "  [✓] $($ext.Key)" -ForegroundColor Green
            $index++
        }
        
        # 启用 Chrome 扩展支持
        Set-ItemProperty -Path $operaPolicyPath -Name "ExtensionInstallSources" -Value @("https://chrome.google.com/webstore/*", "https://addons.opera.com/*") -Type MultiString -Force
        Write-Host "  [✓] 已启用 Chrome 扩展支持" -ForegroundColor Green
        
        $SuccessCount++
    } catch {
        Write-Host "  [✗] 配置失败: $($_.Exception.Message)" -ForegroundColor Red
        $FailCount++
    }
} else {
    Write-Host "  [!] Opera 策略路径不存在，跳过" -ForegroundColor Gray
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "配置完成" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "结果：" -ForegroundColor Yellow
Write-Host "  成功：$SuccessCount 个浏览器" -ForegroundColor Green
if ($FailCount -gt 0) {
    Write-Host "  失败：$FailCount 个浏览器" -ForegroundColor Red
}
Write-Host ""

Write-Host "下一步：" -ForegroundColor Yellow
Write-Host "  1. 重启所有浏览器" -ForegroundColor White
Write-Host "  2. 验证扩展：" -ForegroundColor White
Write-Host "     - Chrome/Edge/Brave/Vivaldi: chrome://extensions" -ForegroundColor Gray
Write-Host "     - Opera: opera://extensions" -ForegroundColor Gray
Write-Host ""
