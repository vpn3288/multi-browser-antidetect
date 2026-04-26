#Requires -RunAsAdministrator

# ══════════════════════════════════════════════════════════════════
#  Opera 自动化配置脚本 - 基于官方文档
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Opera 自动化配置 - 基于官方企业策略" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

# Opera 路径
$operaExe = "$env:LOCALAPPDATA\Programs\Opera\opera.exe"
$operaProfile = "C:\BrowserProfiles\Opera"
$operaStableProfile = "$env:APPDATA\Opera Software\Opera Stable"

# 检查 Opera 是否安装
if (-not (Test-Path $operaExe)) {
    Write-Host "`n[!] 错误：Opera 未安装" -ForegroundColor Red
    exit 1
}

Write-Host "`n[*] Opera 路径: $operaExe" -ForegroundColor Green

# 关闭 Opera
Write-Host "`n[1/5] 关闭 Opera..." -ForegroundColor Yellow
Get-Process opera -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2
Write-Host "  ✓ Opera 已关闭" -ForegroundColor Green

# 配置企业策略（注册表）
Write-Host "`n[2/5] 配置企业策略..." -ForegroundColor Yellow

$operaPolicyPath = "HKLM:\SOFTWARE\Policies\Opera Software\Opera"

if (-not (Test-Path $operaPolicyPath)) {
    New-Item -Path $operaPolicyPath -Force | Out-Null
    Write-Host "  ✓ 已创建策略路径" -ForegroundColor Green
}

# 基本设置
$policies = @{
    # 主页和启动
    "HomepageLocation" = "about:blank"
    "RestoreOnStartup" = 5  # 5 = 打开特定页面
    "RestoreOnStartupURLs" = "about:blank"
    "ShowHomeButton" = 1
    "BookmarkBarEnabled" = 1
    
    # 隐私设置
    "DefaultCookiesSetting" = 4  # 4 = 阻止第三方 Cookie
    "DefaultNotificationsSetting" = 2  # 2 = 不允许
    "DefaultGeolocationSetting" = 2  # 2 = 不允许
    "DefaultPopupsSetting" = 2  # 2 = 不允许
    
    # 禁用功能
    "MetricsReportingEnabled" = 0
    "SpellCheckServiceEnabled" = 0
    "SearchSuggestEnabled" = 0
    "AlternateErrorPagesEnabled" = 0
    "NetworkPredictionOptions" = 2  # 2 = 不预测
    "SafeBrowsingEnabled" = 0
    "PasswordManagerEnabled" = 0
    "AutofillAddressEnabled" = 0
    "AutofillCreditCardEnabled" = 0
    
    # Opera 特有设置
    "OperaVPNEnabled" = 0  # 禁用 Opera VPN
    "SidebarEnabled" = 0  # 禁用侧边栏
    "NewsEnabled" = 0  # 禁用新闻
    "AdBlockerEnabled" = 1  # 启用广告拦截器
    "TrackerBlockingEnabled" = 1  # 启用追踪保护
    
    # 默认浏览器检查
    "DefaultBrowserSettingEnabled" = 0
    
    # WebRTC
    "WebRtcIPHandlingPolicy" = "disable_non_proxied_udp"
}

foreach ($key in $policies.Keys) {
    $value = $policies[$key]
    $type = if ($value -is [int]) { "DWord" } else { "String" }
    
    try {
        Set-ItemProperty -Path $operaPolicyPath -Name $key -Value $value -Type $type -ErrorAction Stop
        Write-Host "  ✓ $key = $value" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ $key 配置失败" -ForegroundColor Red
    }
}

# 配置启动 URL（多字符串值）
$startupUrlsPath = "$operaPolicyPath\RestoreOnStartupURLs"
if (-not (Test-Path $startupUrlsPath)) {
    New-Item -Path $startupUrlsPath -Force | Out-Null
}
Set-ItemProperty -Path $startupUrlsPath -Name "1" -Value "about:blank" -Type String
Write-Host "  ✓ 启动 URL 已配置" -ForegroundColor Green

# 配置扩展自动安装
Write-Host "`n[3/5] 配置扩展自动安装..." -ForegroundColor Yellow

$extensionPolicyPath = "$operaPolicyPath\ExtensionInstallForcelist"
if (-not (Test-Path $extensionPolicyPath)) {
    New-Item -Path $extensionPolicyPath -Force | Out-Null
}

# Opera 支持 Chrome 扩展
# 需要启用 Chrome 扩展支持
Set-ItemProperty -Path $operaPolicyPath -Name "ExtensionInstallSources" -Value @("https://chrome.google.com/webstore/*", "https://addons.opera.com/*") -Type MultiString

# 扩展列表
$extensions = @{
    # uBlock Origin
    1 = "cjpalhdlnbpafiamejdnhcphjbkeiagm;https://clients2.google.com/service/update2/crx"
    # WebRTC Leak Shield
    2 = "nphkkbaidamjmhfanlpblblcadhfbkdm;https://clients2.google.com/service/update2/crx"
}

foreach ($key in $extensions.Keys) {
    Set-ItemProperty -Path $extensionPolicyPath -Name $key -Value $extensions[$key] -Type String
    Write-Host "  ✓ 已添加扩展 $key" -ForegroundColor Green
}

# 创建配置文件
Write-Host "`n[4/5] 创建配置文件..." -ForegroundColor Yellow

if (-not (Test-Path $operaProfile)) {
    New-Item -Path $operaProfile -ItemType Directory -Force | Out-Null
}

# Preferences 文件
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
            "popups" = 2
        }
    }
    "net" = @{
        "network_prediction_options" = 2
    }
    "safebrowsing" = @{
        "enabled" = $false
    }
    "alternate_error_pages" = @{
        "enabled" = $false
    }
    "search" = @{
        "suggest_enabled" = $false
    }
}

$preferencesPath = "$operaProfile\Preferences"
$preferences | ConvertTo-Json -Depth 10 | Out-File -FilePath $preferencesPath -Encoding UTF8
Write-Host "  ✓ Preferences 文件已创建" -ForegroundColor Green

# Local State 文件
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

# 创建启动脚本
Write-Host "`n[5/5] 创建启动脚本..." -ForegroundColor Yellow

$launchScript = @"
# Opera 启动脚本（自动配置版）
`$operaExe = "$operaExe"
`$operaProfile = "$operaProfile"
`$proxy = "socks5://127.0.0.1:7890"

`$args = @(
    "--user-data-dir=`$operaProfile",
    "--proxy-server=`$proxy",
    "--disable-blink-features=AutomationControlled",
    "--disable-background-networking",
    "--disable-background-timer-throttling",
    "--disable-backgrounding-occluded-windows",
    "--disable-breakpad",
    "--disable-component-extensions-with-background-pages",
    "--disable-features=TranslateUI",
    "--disable-ipc-flooding-protection",
    "--disable-renderer-backgrounding",
    "--enable-features=NetworkService,NetworkServiceInProcess",
    "--no-first-run",
    "--password-store=basic",
    "--disable-hang-monitor",
    "--disable-prompt-on-repost",
    "--disable-sync",
    "--metrics-recording-only",
    "--force-webrtc-ip-handling-policy=disable_non_proxied_udp"
)

Write-Host "启动 Opera..." -ForegroundColor Cyan
Write-Host "  代理: `$proxy" -ForegroundColor White
Write-Host "  配置: `$operaProfile" -ForegroundColor White

Start-Process `$operaExe -ArgumentList `$args
"@

$launchScriptPath = "$PSScriptRoot\LAUNCH_OPERA.ps1"
$launchScript | Out-File -FilePath $launchScriptPath -Encoding UTF8
Write-Host "  ✓ 启动脚本已创建: $launchScriptPath" -ForegroundColor Green

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  ✓ Opera 自动化配置完成！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green

Write-Host "`n[*] 配置摘要：" -ForegroundColor Cyan
Write-Host "  ✓ 企业策略已配置（注册表）" -ForegroundColor Green
Write-Host "  ✓ 扩展自动安装已配置（2个扩展）" -ForegroundColor Green
Write-Host "  ✓ 配置文件已创建" -ForegroundColor Green
Write-Host "  ✓ 启动脚本已创建" -ForegroundColor Green

Write-Host "`n[*] 已配置的功能：" -ForegroundColor Cyan
Write-Host "  ✓ 主页：about:blank" -ForegroundColor White
Write-Host "  ✓ 书签栏：显示" -ForegroundColor White
Write-Host "  ✓ 广告拦截：启用（Opera 内置）" -ForegroundColor White
Write-Host "  ✓ 追踪保护：启用（Opera 内置）" -ForegroundColor White
Write-Host "  ✓ Opera VPN：禁用" -ForegroundColor White
Write-Host "  ✓ 侧边栏：禁用" -ForegroundColor White
Write-Host "  ✓ 新闻：禁用" -ForegroundColor White
Write-Host "  ✓ WebRTC：禁用非代理 UDP" -ForegroundColor White
Write-Host "  ✓ 第三方 Cookie：阻止" -ForegroundColor White
Write-Host "  ✓ 遥测：禁用" -ForegroundColor White

Write-Host "`n[*] 扩展安装：" -ForegroundColor Cyan
Write-Host "  ✓ uBlock Origin（将在首次启动时自动安装）" -ForegroundColor White
Write-Host "  ✓ WebRTC Leak Shield（将在首次启动时自动安装）" -ForegroundColor White

Write-Host "`n[!] 下一步：" -ForegroundColor Yellow
Write-Host "  1. 运行: .\LAUNCH_OPERA.ps1" -ForegroundColor White
Write-Host "  2. 首次启动时扩展会自动下载安装（需要1-2分钟）" -ForegroundColor White
Write-Host "  3. 访问 opera://policy/ 验证策略是否生效" -ForegroundColor White
Write-Host "  4. 访问 opera://extensions/ 检查扩展是否安装" -ForegroundColor White

Write-Host "`n[*] 验证命令：" -ForegroundColor Cyan
Write-Host "  # 检查策略" -ForegroundColor Gray
Write-Host "  Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Opera Software\Opera'" -ForegroundColor Gray
Write-Host "`n  # 检查扩展策略" -ForegroundColor Gray
Write-Host "  Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Opera Software\Opera\ExtensionInstallForcelist'" -ForegroundColor Gray

Write-Host "`n[*] 是否立即启动 Opera？(Y/N)" -ForegroundColor Cyan
$start = Read-Host

if ($start -eq "Y" -or $start -eq "y") {
    Write-Host "`n[*] 启动 Opera..." -ForegroundColor Yellow
    & $launchScriptPath
    
    Write-Host "`n[*] 请等待扩展自动安装（1-2分钟）" -ForegroundColor Yellow
    Write-Host "[*] 然后访问以下页面验证：" -ForegroundColor Yellow
    Write-Host "  - opera://policy/ （查看策略）" -ForegroundColor White
    Write-Host "  - opera://extensions/ （查看扩展）" -ForegroundColor White
    Write-Host "  - https://whoer.net （测试隐私）" -ForegroundColor White
}

Write-Host "`n[*] 完成！" -ForegroundColor Green
