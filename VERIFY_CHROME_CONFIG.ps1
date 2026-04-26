# ============================================================================
# Chrome 配置验证脚本
# ============================================================================

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Chrome 配置验证" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$ChromePolicyPath = "HKLM:\SOFTWARE\Policies\Google\Chrome"

# 检查策略路径
if (-not (Test-Path $ChromePolicyPath)) {
    Write-Host "[✗] Chrome 策略路径不存在" -ForegroundColor Red
    Write-Host "    请先运行 CHROME_ENTERPRISE_CONFIG.ps1" -ForegroundColor Yellow
    exit 1
}

Write-Host "[✓] Chrome 策略路径存在" -ForegroundColor Green
Write-Host ""

# 验证关键策略
Write-Host "验证关键策略配置：" -ForegroundColor Yellow
Write-Host ""

$KeyPolicies = @{
    "隐私保护" = @{
        "MetricsReportingEnabled" = 0
        "SigninAllowed" = 0
        "BlockThirdPartyCookies" = 1
    }
    "WebRTC 防护" = @{
        "WebRtcIPHandling" = "disable_non_proxied_udp"
    }
    "用户体验" = @{
        "BookmarkBarEnabled" = 1
        "DefaultBrowserSettingEnabled" = 0
    }
    "安全配置" = @{
        "SafeBrowsingEnabled" = 1
        "DnsOverHttpsMode" = "automatic"
    }
}

$AllPassed = $true

foreach ($category in $KeyPolicies.GetEnumerator()) {
    Write-Host "[$($category.Key)]" -ForegroundColor Cyan
    
    foreach ($policy in $category.Value.GetEnumerator()) {
        try {
            $value = Get-ItemProperty -Path $ChromePolicyPath -Name $policy.Key -ErrorAction Stop
            $actualValue = $value.($policy.Key)
            
            if ($actualValue -eq $policy.Value) {
                Write-Host "  [✓] $($policy.Key) = $actualValue" -ForegroundColor Green
            } else {
                Write-Host "  [✗] $($policy.Key) = $actualValue (期望: $($policy.Value))" -ForegroundColor Red
                $AllPassed = $false
            }
        } catch {
            Write-Host "  [✗] $($policy.Key) 未配置" -ForegroundColor Red
            $AllPassed = $false
        }
    }
    Write-Host ""
}

# 检查扩展配置
Write-Host "[扩展配置]" -ForegroundColor Cyan
$ExtensionSettingsPath = "$ChromePolicyPath\ExtensionSettings"

if (Test-Path $ExtensionSettingsPath) {
    $extensions = Get-ChildItem -Path $ExtensionSettingsPath
    Write-Host "  [✓] 扩展配置路径存在" -ForegroundColor Green
    Write-Host "  [i] 已配置 $($extensions.Count) 个扩展策略" -ForegroundColor Gray
    
    foreach ($ext in $extensions) {
        $extName = $ext.PSChildName
        if ($extName -eq "cjpalhdlnbpafiamejdnhcphjbkeiagm") {
            Write-Host "    - uBlock Origin (强制安装)" -ForegroundColor White
        } elseif ($extName -eq "bppamachkoflopbagkdoflbgfjflfnfl") {
            Write-Host "    - WebRTC Leak Shield (强制安装)" -ForegroundColor White
        } elseif ($extName -eq "*") {
            Write-Host "    - 其他扩展 (阻止安装)" -ForegroundColor White
        }
    }
} else {
    Write-Host "  [✗] 扩展配置路径不存在" -ForegroundColor Red
    $AllPassed = $false
}

Write-Host ""

# 总结
Write-Host "============================================" -ForegroundColor Cyan
if ($AllPassed) {
    Write-Host "验证通过！所有配置正确。" -ForegroundColor Green
} else {
    Write-Host "验证失败！部分配置缺失或错误。" -ForegroundColor Red
    Write-Host "请重新运行 CHROME_ENTERPRISE_CONFIG.ps1" -ForegroundColor Yellow
}
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "下一步：" -ForegroundColor Yellow
Write-Host "  1. 启动 Chrome 并访问 chrome://policy" -ForegroundColor White
Write-Host "  2. 检查策略是否已应用" -ForegroundColor White
Write-Host "  3. 使用 LAUNCH_CHROME.ps1 启动浏览器" -ForegroundColor White
Write-Host ""
