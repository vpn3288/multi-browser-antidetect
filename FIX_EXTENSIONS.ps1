#Requires -RunAsAdministrator

# ============================================================================
# 修复扩展配置脚本 - 清理并重新配置为标准 4 个扩展
# ============================================================================

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "修复扩展配置" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# 标准的 4 个扩展
$standardExtensions = @{
    1 = "cjpalhdlnbpafiamejdnhcphjbkeiagm;https://clients2.google.com/service/update2/crx"  # uBlock Origin
    2 = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp;https://clients2.google.com/service/update2/crx"  # Privacy Badger
    3 = "gcbommkclmclpchllfjekcdonpmejbdp;https://clients2.google.com/service/update2/crx"  # HTTPS Everywhere
    4 = "ldpochfccmkkmhdbclfhpagapcfdljkj;https://clients2.google.com/service/update2/crx"  # Decentraleyes
}

# Chromium 系浏览器列表
$browsers = @{
    "Chrome" = "HKLM:\SOFTWARE\Policies\Google\Chrome"
    "Edge" = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
    "Chromium" = "HKLM:\SOFTWARE\Policies\Chromium"
    "Brave" = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"
    "Vivaldi" = "HKLM:\SOFTWARE\Policies\Vivaldi"
    "Opera" = "HKLM:\SOFTWARE\Policies\Opera Software\Opera"
}

$fixedCount = 0
$failedCount = 0

foreach ($browserName in $browsers.Keys) {
    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "修复 $browserName" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    
    $policyPath = $browsers[$browserName]
    $extensionPath = "$policyPath\ExtensionInstallForcelist"
    
    # 检查策略路径是否存在
    if (-not (Test-Path $policyPath)) {
        Write-Host "  [!] 策略路径不存在，跳过" -ForegroundColor Yellow
        continue
    }
    
    Write-Host "`n[1/3] 检查当前扩展配置..." -ForegroundColor Yellow
    
    if (Test-Path $extensionPath) {
        $currentExtensions = Get-ItemProperty -Path $extensionPath -ErrorAction SilentlyContinue
        if ($currentExtensions) {
            $count = ($currentExtensions.PSObject.Properties | Where-Object { $_.Name -notlike "PS*" }).Count
            Write-Host "  [i] 当前扩展数量: $count" -ForegroundColor Cyan
            
            # 显示当前扩展
            $currentExtensions.PSObject.Properties | Where-Object { $_.Name -notlike "PS*" } | ForEach-Object {
                $extId = ($_.Value -split ";")[0]
                Write-Host "      $($_.Name): $extId" -ForegroundColor Gray
            }
        }
    } else {
        Write-Host "  [!] 扩展配置不存在" -ForegroundColor Yellow
    }
    
    Write-Host "`n[2/3] 清理旧扩展配置..." -ForegroundColor Yellow
    
    try {
        # 删除整个扩展配置键
        if (Test-Path $extensionPath) {
            Remove-Item -Path $extensionPath -Recurse -Force -ErrorAction Stop
            Write-Host "  [✓] 已清理旧配置" -ForegroundColor Green
        }
        
        # 重新创建
        New-Item -Path $extensionPath -Force | Out-Null
        Write-Host "  [✓] 已创建新配置路径" -ForegroundColor Green
        
    } catch {
        Write-Host "  [✗] 清理失败: $($_.Exception.Message)" -ForegroundColor Red
        $failedCount++
        continue
    }
    
    Write-Host "`n[3/3] 配置标准 4 个扩展..." -ForegroundColor Yellow
    
    try {
        foreach ($key in $standardExtensions.Keys) {
            Set-ItemProperty -Path $extensionPath -Name $key -Value $standardExtensions[$key] -Type String -ErrorAction Stop
            
            $extId = ($standardExtensions[$key] -split ";")[0]
            $extName = switch ($extId) {
                "cjpalhdlnbpafiamejdnhcphjbkeiagm" { "uBlock Origin" }
                "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" { "Privacy Badger" }
                "gcbommkclmclpchllfjekcdonpmejbdp" { "HTTPS Everywhere" }
                "ldpochfccmkkmhdbclfhpagapcfdljkj" { "Decentraleyes" }
            }
            
            Write-Host "  [✓] $key. $extName" -ForegroundColor Green
        }
        
        $fixedCount++
        Write-Host "`n  [✓] $browserName 扩展配置已修复" -ForegroundColor Green
        
    } catch {
        Write-Host "  [✗] 配置失败: $($_.Exception.Message)" -ForegroundColor Red
        $failedCount++
    }
}

# 总结
Write-Host "`n`n============================================" -ForegroundColor Cyan
Write-Host "修复完成" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "成功修复: $fixedCount 个浏览器" -ForegroundColor Green
if ($failedCount -gt 0) {
    Write-Host "修复失败: $failedCount 个浏览器" -ForegroundColor Red
}
Write-Host ""

Write-Host "下一步：" -ForegroundColor Yellow
Write-Host "  1. 关闭所有浏览器" -ForegroundColor White
Write-Host "  2. 重新启动浏览器" -ForegroundColor White
Write-Host "  3. 访问 chrome://extensions/ 验证扩展" -ForegroundColor White
Write-Host "  4. 运行 .\DIAGNOSE_ALL_BROWSERS.ps1 再次检查" -ForegroundColor White
Write-Host ""
