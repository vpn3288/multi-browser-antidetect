#Requires -RunAsAdministrator

# ══════════════════════════════════════════════════════════════════
#  Opera 完整修复脚本 - 针对所有优化失败的情况
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Opera 完整修复 - 重新配置所有优化" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

$operaProfile = "C:\BrowserProfiles\Opera"
$operaExe = "$env:LOCALAPPDATA\Programs\Opera\opera.exe"

# 检查 Opera 是否安装
if (-not (Test-Path $operaExe)) {
    Write-Host "`n[!] 错误：Opera 未安装" -ForegroundColor Red
    Write-Host "[*] 请先运行 DEPLOY_8_BROWSERS.ps1 安装 Opera" -ForegroundColor Yellow
    exit 1
}

Write-Host "`n[*] Opera 可执行文件: $operaExe" -ForegroundColor Green

# 关闭 Opera
Write-Host "`n[1/6] 关闭 Opera..." -ForegroundColor Yellow
Get-Process opera -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2
Write-Host "  ✓ Opera 已关闭" -ForegroundColor Green

# 创建配置文件目录
Write-Host "`n[2/6] 创建配置文件目录..." -ForegroundColor Yellow
if (-not (Test-Path $operaProfile)) {
    New-Item -Path $operaProfile -ItemType Directory -Force | Out-Null
    Write-Host "  ✓ 已创建: $operaProfile" -ForegroundColor Green
} else {
    Write-Host "  ✓ 目录已存在: $operaProfile" -ForegroundColor Green
}

# 创建 Preferences 文件（Opera 的主配置文件）
Write-Host "`n[3/6] 创建 Preferences 配置文件..." -ForegroundColor Yellow

$preferences = @{
    "browser" = @{
        "show_home_button" = $true
        "check_default_browser" = $false
    }
    "bookmark_bar" = @{
        "show_on_all_tabs" = $true
    }
    "homepage" = "about:blank"
    "homepage_is_newtabpage" = $false
    "session" = @{
        "restore_on_startup" = 5
        "startup_urls" = @("about:blank")
    }
    "profile" = @{
        "default_content_setting_values" = @{
            "cookies" = 4
            "notifications" = 2
            "geolocation" = 2
        }
    }
    "webkit" = @{
        "webprefs" = @{
            "default_font_size" = 16
            "javascript_enabled" = $true
        }
    }
    "download" = @{
        "prompt_for_download" = $true
    }
}

$preferencesPath = "$operaProfile\Preferences"
$preferences | ConvertTo-Json -Depth 10 | Out-File -FilePath $preferencesPath -Encoding UTF8
Write-Host "  ✓ Preferences 文件已创建" -ForegroundColor Green

# 创建 Local State 文件
Write-Host "`n[4/6] 创建 Local State 配置文件..." -ForegroundColor Yellow

$localState = @{
    "browser" = @{
        "enabled_labs_experiments" = @()
    }
    "dns_prefetching" = @{
        "enabled" = $false
    }
    "net" = @{
        "network_prediction_options" = 2
    }
}

$localStatePath = "$operaProfile\Local State"
$localState | ConvertTo-Json -Depth 10 | Out-File -FilePath $localStatePath -Encoding UTF8
Write-Host "  ✓ Local State 文件已创建" -ForegroundColor Green

# 尝试通过注册表配置 Opera（企业策略）
Write-Host "`n[5/6] 配置 Opera 企业策略..." -ForegroundColor Yellow

$operaPolicyPath = "HKLM:\SOFTWARE\Policies\Opera Software\Opera"

try {
    if (-not (Test-Path $operaPolicyPath)) {
        New-Item -Path $operaPolicyPath -Force | Out-Null
    }
    
    # 基本设置
    Set-ItemProperty -Path $operaPolicyPath -Name "HomepageLocation" -Value "about:blank" -Type String
    Set-ItemProperty -Path $operaPolicyPath -Name "RestoreOnStartup" -Value 5 -Type DWord
    Set-ItemProperty -Path $operaPolicyPath -Name "ShowHomeButton" -Value 1 -Type DWord
    Set-ItemProperty -Path $operaPolicyPath -Name "BookmarkBarEnabled" -Value 1 -Type DWord
    
    # 隐私设置
    Set-ItemProperty -Path $operaPolicyPath -Name "DefaultCookiesSetting" -Value 4 -Type DWord
    Set-ItemProperty -Path $operaPolicyPath -Name "DefaultNotificationsSetting" -Value 2 -Type DWord
    Set-ItemProperty -Path $operaPolicyPath -Name "DefaultGeolocationSetting" -Value 2 -Type DWord
    
    # 禁用遥测
    Set-ItemProperty -Path $operaPolicyPath -Name "MetricsReportingEnabled" -Value 0 -Type DWord
    Set-ItemProperty -Path $operaPolicyPath -Name "SpellCheckServiceEnabled" -Value 0 -Type DWord
    
    Write-Host "  ✓ 企业策略已配置" -ForegroundColor Green
} catch {
    Write-Host "  ✗ 企业策略配置失败: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "  [*] 将使用配置文件方式" -ForegroundColor Yellow
}

# 创建启动脚本
Write-Host "`n[6/6] 创建 Opera 启动脚本..." -ForegroundColor Yellow

$launchScript = @"
# Opera 启动脚本
`$operaExe = "$operaExe"
`$operaProfile = "$operaProfile"
`$proxy = "socks5://127.0.0.1:7890"

`$args = @(
    "--user-data-dir=`$operaProfile",
    "--proxy-server=`$proxy",
    "--disable-background-networking",
    "--disable-features=TranslateUI",
    "--no-first-run",
    "--disable-sync",
    "--disable-webrtc",
    "--enforce-webrtc-ip-permission-check"
)

Write-Host "启动 Opera..." -ForegroundColor Cyan
& `$operaExe `$args
"@

$launchScriptPath = "$PSScriptRoot\LAUNCH_OPERA.ps1"
$launchScript | Out-File -FilePath $launchScriptPath -Encoding UTF8
Write-Host "  ✓ 启动脚本已创建: $launchScriptPath" -ForegroundColor Green

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  ✓ Opera 修复完成！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green

Write-Host "`n[!] 重要说明：" -ForegroundColor Yellow
Write-Host "  Opera 的企业策略支持有限，部分优化可能无法通过注册表生效" -ForegroundColor White
Write-Host "  建议使用以下方法：" -ForegroundColor White
Write-Host "`n  方法1：使用 Opera 内置功能（推荐）" -ForegroundColor Cyan
Write-Host "    1. 打开 Opera" -ForegroundColor White
Write-Host "    2. 设置 → 基本设置 → 启用广告拦截" -ForegroundColor White
Write-Host "    3. 设置 → 隐私和安全 → 启用追踪保护" -ForegroundColor White
Write-Host "    4. 设置 → 隐私和安全 → 禁用 Cookie" -ForegroundColor White
Write-Host "    5. 设置 → 浏览器 → 启动时 → 打开特定页面 → about:blank" -ForegroundColor White
Write-Host "    6. 设置 → 浏览器 → 显示书签栏" -ForegroundColor White

Write-Host "`n  方法2：手动安装扩展" -ForegroundColor Cyan
Write-Host "    1. 打开 Opera" -ForegroundColor White
Write-Host "    2. 按 Ctrl+Shift+E 打开扩展页面" -ForegroundColor White
Write-Host "    3. 点击'获取扩展'" -ForegroundColor White
Write-Host "    4. 搜索并安装：" -ForegroundColor White
Write-Host "       - uBlock Origin" -ForegroundColor Gray
Write-Host "       - WebRTC Leak Shield" -ForegroundColor Gray

Write-Host "`n  方法3：使用启动脚本" -ForegroundColor Cyan
Write-Host "    运行: .\LAUNCH_OPERA.ps1" -ForegroundColor White

Write-Host "`n[*] Opera 内置功能说明：" -ForegroundColor Cyan
Write-Host "  ✓ 内置广告拦截器（无需 uBlock Origin）" -ForegroundColor Green
Write-Host "  ✓ 内置追踪保护（无需 Privacy Badger）" -ForegroundColor Green
Write-Host "  ✓ 内置 VPN（但建议禁用，使用 Clash 代理）" -ForegroundColor Yellow
Write-Host "  ✓ 内置省电模式" -ForegroundColor Green

Write-Host "`n[*] 是否立即启动 Opera 进行手动配置？(Y/N)" -ForegroundColor Cyan
$start = Read-Host

if ($start -eq "Y" -or $start -eq "y") {
    Write-Host "`n[*] 启动 Opera..." -ForegroundColor Yellow
    & $launchScriptPath
    
    Write-Host "`n[*] 请在 Opera 中手动完成以下配置：" -ForegroundColor Yellow
    Write-Host "  1. 设置 → 基本设置 → 启用广告拦截" -ForegroundColor White
    Write-Host "  2. 设置 → 隐私和安全 → 启用追踪保护" -ForegroundColor White
    Write-Host "  3. 设置 → 浏览器 → 启动时 → 打开特定页面 → about:blank" -ForegroundColor White
    Write-Host "  4. 设置 → 浏览器 → 显示书签栏" -ForegroundColor White
    Write-Host "  5. 按 Ctrl+Shift+E → 安装 WebRTC Leak Shield 扩展" -ForegroundColor White
}

Write-Host "`n[*] 完成！" -ForegroundColor Green
"@

$fixOperaPath = "$PSScriptRoot\FIX_OPERA_COMPLETE.ps1"
$fixOperaScript | Out-File -FilePath $fixOperaPath -Encoding UTF8
Write-Host "  ✓ 修复脚本已创建: $fixOperaPath" -ForegroundColor Green
