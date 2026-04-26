# ══════════════════════════════════════════════════════════════════
#  Opera 配置验证脚本
# ══════════════════════════════════════════════════════════════════

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Opera 配置验证" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

$operaPolicyPath = "HKLM:\SOFTWARE\Policies\Opera Software\Opera"
$extensionPolicyPath = "$operaPolicyPath\ExtensionInstallForcelist"

Write-Host "`n[1/3] 检查企业策略..." -ForegroundColor Yellow

if (Test-Path $operaPolicyPath) {
    Write-Host "  ✓ 策略路径存在" -ForegroundColor Green
    
    $policies = Get-ItemProperty -Path $operaPolicyPath -ErrorAction SilentlyContinue
    
    if ($policies) {
        Write-Host "`n  已配置的策略：" -ForegroundColor Cyan
        
        $importantPolicies = @(
            "HomepageLocation",
            "RestoreOnStartup",
            "BookmarkBarEnabled",
            "AdBlockerEnabled",
            "TrackerBlockingEnabled",
            "OperaVPNEnabled",
            "WebRtcIPHandlingPolicy",
            "DefaultCookiesSetting"
        )
        
        foreach ($policy in $importantPolicies) {
            $value = $policies.$policy
            if ($null -ne $value) {
                Write-Host "    ✓ $policy = $value" -ForegroundColor Green
            } else {
                Write-Host "    ✗ $policy 未配置" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "  ✗ 无法读取策略" -ForegroundColor Red
    }
} else {
    Write-Host "  ✗ 策略路径不存在" -ForegroundColor Red
}

Write-Host "`n[2/3] 检查扩展策略..." -ForegroundColor Yellow

if (Test-Path $extensionPolicyPath) {
    Write-Host "  ✓ 扩展策略路径存在" -ForegroundColor Green
    
    $extensions = Get-ItemProperty -Path $extensionPolicyPath -ErrorAction SilentlyContinue
    
    if ($extensions) {
        Write-Host "`n  已配置的扩展：" -ForegroundColor Cyan
        
        $extensionNames = @{
            "cjpalhdlnbpafiamejdnhcphjbkeiagm" = "uBlock Origin"
            "nphkkbaidamjmhfanlpblblcadhfbkdm" = "WebRTC Leak Shield"
        }
        
        $count = 0
        foreach ($prop in $extensions.PSObject.Properties) {
            if ($prop.Name -match '^\d+$') {
                $count++
                $extId = ($prop.Value -split ';')[0]
                $extName = $extensionNames[$extId]
                if ($extName) {
                    Write-Host "    ✓ $extName ($extId)" -ForegroundColor Green
                } else {
                    Write-Host "    ? 未知扩展 ($extId)" -ForegroundColor Yellow
                }
            }
        }
        
        Write-Host "`n  总计: $count 个扩展" -ForegroundColor Cyan
    } else {
        Write-Host "  ✗ 无法读取扩展策略" -ForegroundColor Red
    }
} else {
    Write-Host "  ✗ 扩展策略路径不存在" -ForegroundColor Red
}

Write-Host "`n[3/3] 检查配置文件..." -ForegroundColor Yellow

$operaProfile = "C:\BrowserProfiles\Opera"
$preferencesPath = "$operaProfile\Preferences"
$localStatePath = "$operaProfile\Local State"

if (Test-Path $operaProfile) {
    Write-Host "  ✓ 配置目录存在: $operaProfile" -ForegroundColor Green
    
    if (Test-Path $preferencesPath) {
        Write-Host "  ✓ Preferences 文件存在" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Preferences 文件不存在" -ForegroundColor Red
    }
    
    if (Test-Path $localStatePath) {
        Write-Host "  ✓ Local State 文件存在" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Local State 文件不存在" -ForegroundColor Red
    }
} else {
    Write-Host "  ✗ 配置目录不存在" -ForegroundColor Red
}

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  验证完成" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

Write-Host "`n[*] 下一步：" -ForegroundColor Yellow
Write-Host "  1. 如果所有检查都通过，运行: .\LAUNCH_OPERA.ps1" -ForegroundColor White
Write-Host "  2. 如果有失败项，重新运行: .\OPERA_AUTO_CONFIG.ps1" -ForegroundColor White
Write-Host "  3. 启动后访问 opera://policy/ 查看策略是否生效" -ForegroundColor White
Write-Host "  4. 访问 opera://extensions/ 查看扩展是否安装" -ForegroundColor White
