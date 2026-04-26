# ============================================
# 浏览器扩展自动安装脚本
# 基于官方企业策略文档验证
# ============================================

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "浏览器扩展自动安装" -ForegroundColor Cyan
Write-Host "隐私和安全扩展部署" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# 检查管理员权限
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[!] 需要管理员权限来配置企业策略" -ForegroundColor Red
    Write-Host "    请右键点击 PowerShell，选择'以管理员身份运行'" -ForegroundColor Yellow
    exit
}

# ============================================
# 推荐扩展列表
# ============================================

$chromiumExtensions = @{
    "uBlock Origin" = "cjpalhdlnbpafiamejdnhcphjbkeiagm"
    "Privacy Badger" = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"
    "Decentraleyes" = "ldpochfccmkkmhdbclfhpagapcfdljkj"
    "Canvas Defender" = "obdbgnebcljmgkoljcdddaopadkifnpm"
    "ClearURLs" = "lckanjgmijmafbedllaakclkaicjfmnk"
}

$firefoxExtensions = @{
    "uBlock Origin" = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
    "Privacy Badger" = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi"
    "Decentraleyes" = "https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/latest.xpi"
    "ClearURLs" = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi"
}

# ============================================
# Chromium 系浏览器扩展安装
# ============================================

function Install-ChromiumExtensions {
    param(
        [string]$BrowserName,
        [string]$RegPath
    )
    
    Write-Host "`n[${BrowserName}] 配置扩展自动安装..." -ForegroundColor Cyan
    
    # 创建 ExtensionInstallForcelist 策略路径
    $extListPath = "$RegPath\ExtensionInstallForcelist"
    if (-not (Test-Path $extListPath)) {
        New-Item -Path $extListPath -Force | Out-Null
    }
    
    # 添加每个扩展
    $index = 1
    foreach ($extName in $chromiumExtensions.Keys) {
        $extId = $chromiumExtensions[$extName]
        # 格式：扩展ID;更新URL
        $value = "${extId};https://clients2.google.com/service/update2/crx"
        Set-ItemProperty -Path $extListPath -Name "$index" -Value $value -Type String -Force
        Write-Host "    [✓] $extName ($extId)" -ForegroundColor Green
        $index++
    }
    
    # 禁用扩展开发者模式警告
    Set-ItemProperty -Path $RegPath -Name "ExtensionInstallBlocklist" -Value @("*") -Type MultiString -Force
    Set-ItemProperty -Path $RegPath -Name "ExtensionInstallAllowlist" -Value @("*") -Type MultiString -Force
    
    Write-Host "    [✓] ${BrowserName} 扩展配置完成" -ForegroundColor Green
}

# 为所有 Chromium 系浏览器安装扩展
Install-ChromiumExtensions -BrowserName "Chrome" -RegPath "HKLM:\SOFTWARE\Policies\Google\Chrome"
Install-ChromiumExtensions -BrowserName "Chromium" -RegPath "HKLM:\SOFTWARE\Policies\Chromium"
Install-ChromiumExtensions -BrowserName "Edge" -RegPath "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
Install-ChromiumExtensions -BrowserName "Brave" -RegPath "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"
Install-ChromiumExtensions -BrowserName "Opera" -RegPath "HKLM:\SOFTWARE\Policies\Opera Software\Opera Stable"
Install-ChromiumExtensions -BrowserName "Vivaldi" -RegPath "HKLM:\SOFTWARE\Policies\Vivaldi"

# ============================================
# Firefox 扩展安装
# ============================================

Write-Host "`n[Firefox] 配置扩展自动安装..." -ForegroundColor Cyan

$firefoxInstallPath = "C:\Program Files\Mozilla Firefox"
if (Test-Path $firefoxInstallPath) {
    # 创建 distribution 目录
    $distributionPath = Join-Path $firefoxInstallPath "distribution"
    if (-not (Test-Path $distributionPath)) {
        New-Item -Path $distributionPath -ItemType Directory -Force | Out-Null
    }
    
    # 创建 policies.json
    $policiesPath = Join-Path $distributionPath "policies.json"
    
    $extensionUrls = @()
    foreach ($extName in $firefoxExtensions.Keys) {
        $extensionUrls += $firefoxExtensions[$extName]
        Write-Host "    [✓] $extName" -ForegroundColor Green
    }
    
    $policies = @{
        "policies" = @{
            "Extensions" = @{
                "Install" = $extensionUrls
            }
            "ExtensionSettings" = @{
                "*" = @{
                    "installation_mode" = "allowed"
                }
            }
        }
    }
    
    $policies | ConvertTo-Json -Depth 10 | Set-Content -Path $policiesPath -Encoding UTF8 -Force
    Write-Host "    [✓] Firefox 扩展配置完成" -ForegroundColor Green
} else {
    Write-Host "    [!] Firefox 未安装，跳过" -ForegroundColor Yellow
}

# ============================================
# LibreWolf 扩展安装
# ============================================

Write-Host "`n[LibreWolf] 配置扩展自动安装..." -ForegroundColor Cyan

$librewolfInstallPath = "C:\Program Files\LibreWolf"
if (Test-Path $librewolfInstallPath) {
    $distributionPath = Join-Path $librewolfInstallPath "distribution"
    if (-not (Test-Path $distributionPath)) {
        New-Item -Path $distributionPath -ItemType Directory -Force | Out-Null
    }
    
    $policiesPath = Join-Path $distributionPath "policies.json"
    
    $extensionUrls = @()
    foreach ($extName in $firefoxExtensions.Keys) {
        $extensionUrls += $firefoxExtensions[$extName]
        Write-Host "    [✓] $extName" -ForegroundColor Green
    }
    
    $policies = @{
        "policies" = @{
            "Extensions" = @{
                "Install" = $extensionUrls
            }
        }
    }
    
    $policies | ConvertTo-Json -Depth 10 | Set-Content -Path $policiesPath -Encoding UTF8 -Force
    Write-Host "    [✓] LibreWolf 扩展配置完成" -ForegroundColor Green
} else {
    Write-Host "    [!] LibreWolf 未安装，跳过" -ForegroundColor Yellow
}

# ============================================
# 完成
# ============================================

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "扩展自动安装配置完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

Write-Host "`n已配置的扩展：" -ForegroundColor Cyan
Write-Host "  • uBlock Origin - 广告和追踪拦截" -ForegroundColor White
Write-Host "  • Privacy Badger - 智能追踪保护" -ForegroundColor White
Write-Host "  • Decentraleyes - 本地 CDN 模拟" -ForegroundColor White
Write-Host "  • Canvas Defender - Canvas 指纹保护（Chromium）" -ForegroundColor White
Write-Host "  • ClearURLs - 清理 URL 追踪参数" -ForegroundColor White

Write-Host "`n重要提示：" -ForegroundColor Yellow
Write-Host "1. 首次启动浏览器时会自动下载并安装扩展" -ForegroundColor Yellow
Write-Host "2. 扩展会自动更新，无需手动维护" -ForegroundColor Yellow
Write-Host "3. 用户无法卸载这些扩展（企业策略强制安装）" -ForegroundColor Yellow
Write-Host "4. Brave 浏览器已内置广告拦截，扩展为额外增强" -ForegroundColor Yellow
Write-Host "5. 如需允许用户管理扩展，请修改 ExtensionInstallBlocklist 策略" -ForegroundColor Yellow

Write-Host "`n配置详情：" -ForegroundColor Cyan
Write-Host "  Chromium 系: 注册表策略 ExtensionInstallForcelist" -ForegroundColor Gray
Write-Host "  Firefox 系: distribution/policies.json" -ForegroundColor Gray

Write-Host "`n按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
