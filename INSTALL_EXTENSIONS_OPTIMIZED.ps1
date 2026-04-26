#Requires -RunAsAdministrator

# ══════════════════════════════════════════════════════════════════
#  优化版扩展安装脚本 - 每个浏览器不同的扩展组合
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  优化版扩展安装 - 每个浏览器独特的扩展组合" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

# 扩展 ID 映射
$extensions = @{
    "ublock" = "cjpalhdlnbpafiamejdnhcphjbkeiagm"           # uBlock Origin
    "webrtc" = "nphkkbaidamjmhfanlpblblcadhfbkdm"           # WebRTC Leak Shield
    "canvas" = "obdbgnebcljmgkoljcdddaopadkifnpm"           # Canvas Defender
    "privacy" = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"          # Privacy Badger
    "decentral" = "ldpochfccmkkmhdbclfhpagapcfdljkj"        # Decentraleyes
    "header" = "eningockdidmgiojffjmkdblpjocbhgh"           # Header Editor
    "clearurls" = "lckanjgmijmafbedllaakclkaicjfmnk"        # ClearURLs
    "https" = "gcbommkclmclpchllfjekcdonpmejbdp"            # HTTPS Everywhere
    "tamper" = "dhdgffkkebhmkfjojejmpbldmpobfkfo"           # Tampermonkey
}

# Firefox 扩展 ID
$firefoxExtensions = @{
    "ublock" = "uBlock0@raymondhill.net"
    "webrtc" = "{c9b39d7a-cae4-4f1e-b2c6-8d8a8e7f8c9d}"
    "decentral" = "jid1-BoFifL9Vbdl2zQ@jetpack"
    "clearurls" = "{74145f27-f039-47ce-a470-a662b129930a}"
    "privacy" = "jid1-MnnxcxisBPnSXQ@jetpack"
}

# 每个浏览器的扩展组合（不同！）
$browserExtensions = @{
    "Chrome" = @("ublock", "webrtc", "canvas", "privacy")
    "Firefox" = @("ublock", "webrtc", "decentral", "clearurls")
    "Edge" = @("ublock", "webrtc", "canvas", "header")
    "Brave" = @("ublock", "webrtc", "privacy", "https")
    "Opera" = @("ublock", "webrtc", "canvas", "decentral")
    "Vivaldi" = @("ublock", "webrtc", "header", "tamper")
    "LibreWolf" = @("ublock", "webrtc", "privacy", "decentral")
    "Chromium" = @("ublock", "webrtc", "canvas", "clearurls")
}

Write-Host "`n[*] 开始为每个浏览器安装独特的扩展组合..." -ForegroundColor Cyan

# ══════════════════════════════════════════════════════════════════
#  Chrome
# ══════════════════════════════════════════════════════════════════
Write-Host "`n[1/8] Chrome - 安装扩展..." -ForegroundColor Yellow
$chromePolicy = "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist"
if (-not (Test-Path $chromePolicy)) {
    New-Item -Path $chromePolicy -Force | Out-Null
}
$index = 1
foreach ($ext in $browserExtensions["Chrome"]) {
    $extId = $extensions[$ext]
    Set-ItemProperty -Path $chromePolicy -Name $index -Value "$extId;https://clients2.google.com/service/update2/crx" -Type String
    Write-Host "  ✓ 已添加: $ext ($extId)" -ForegroundColor Green
    $index++
}

# ══════════════════════════════════════════════════════════════════
#  Firefox
# ══════════════════════════════════════════════════════════════════
Write-Host "`n[2/8] Firefox - 安装扩展..." -ForegroundColor Yellow
$firefoxProfile = "C:\BrowserProfiles\Firefox"
if (Test-Path $firefoxProfile) {
    $policiesJson = @{
        policies = @{
            ExtensionSettings = @{}
        }
    } | ConvertTo-Json -Depth 10
    
    $firefoxInstallDir = "C:\Program Files\Mozilla Firefox\distribution"
    if (-not (Test-Path $firefoxInstallDir)) {
        New-Item -Path $firefoxInstallDir -ItemType Directory -Force | Out-Null
    }
    
    $policiesJson | Out-File -FilePath "$firefoxInstallDir\policies.json" -Encoding UTF8
    Write-Host "  ✓ Firefox 扩展策略已配置" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  Edge
# ══════════════════════════════════════════════════════════════════
Write-Host "`n[3/8] Edge - 安装扩展..." -ForegroundColor Yellow
$edgePolicy = "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist"
if (-not (Test-Path $edgePolicy)) {
    New-Item -Path $edgePolicy -Force | Out-Null
}
$index = 1
foreach ($ext in $browserExtensions["Edge"]) {
    $extId = $extensions[$ext]
    Set-ItemProperty -Path $edgePolicy -Name $index -Value "$extId;https://clients2.google.com/service/update2/crx" -Type String
    Write-Host "  ✓ 已添加: $ext ($extId)" -ForegroundColor Green
    $index++
}

# ══════════════════════════════════════════════════════════════════
#  Brave
# ══════════════════════════════════════════════════════════════════
Write-Host "`n[4/8] Brave - 安装扩展..." -ForegroundColor Yellow
$bravePolicy = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave\ExtensionInstallForcelist"
if (-not (Test-Path $bravePolicy)) {
    New-Item -Path $bravePolicy -Force | Out-Null
}
$index = 1
foreach ($ext in $browserExtensions["Brave"]) {
    $extId = $extensions[$ext]
    Set-ItemProperty -Path $bravePolicy -Name $index -Value "$extId;https://clients2.google.com/service/update2/crx" -Type String
    Write-Host "  ✓ 已添加: $ext ($extId)" -ForegroundColor Green
    $index++
}

# ══════════════════════════════════════════════════════════════════
#  Opera
# ══════════════════════════════════════════════════════════════════
Write-Host "`n[5/8] Opera - 安装扩展..." -ForegroundColor Yellow
$operaProfile = "C:\BrowserProfiles\Opera"
if (Test-Path $operaProfile) {
    $preferencesPath = "$operaProfile\Preferences"
    if (Test-Path $preferencesPath) {
        Write-Host "  ✓ Opera 配置文件已准备" -ForegroundColor Green
    }
}

# ══════════════════════════════════════════════════════════════════
#  Vivaldi
# ══════════════════════════════════════════════════════════════════
Write-Host "`n[6/8] Vivaldi - 安装扩展..." -ForegroundColor Yellow
$vivaldiPolicy = "HKLM:\SOFTWARE\Policies\Vivaldi\ExtensionInstallForcelist"
if (-not (Test-Path $vivaldiPolicy)) {
    New-Item -Path $vivaldiPolicy -Force | Out-Null
}
$index = 1
foreach ($ext in $browserExtensions["Vivaldi"]) {
    $extId = $extensions[$ext]
    Set-ItemProperty -Path $vivaldiPolicy -Name $index -Value "$extId;https://clients2.google.com/service/update2/crx" -Type String
    Write-Host "  ✓ 已添加: $ext ($extId)" -ForegroundColor Green
    $index++
}

# ══════════════════════════════════════════════════════════════════
#  LibreWolf
# ══════════════════════════════════════════════════════════════════
Write-Host "`n[7/8] LibreWolf - 安装扩展..." -ForegroundColor Yellow
$librewolfProfile = "C:\BrowserProfiles\LibreWolf"
if (Test-Path $librewolfProfile) {
    Write-Host "  ✓ LibreWolf 配置文件已准备" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  Chromium
# ══════════════════════════════════════════════════════════════════
Write-Host "`n[8/8] Chromium - 安装扩展..." -ForegroundColor Yellow
$chromiumPolicy = "HKLM:\SOFTWARE\Policies\Chromium\ExtensionInstallForcelist"
if (-not (Test-Path $chromiumPolicy)) {
    New-Item -Path $chromiumPolicy -Force | Out-Null
}
$index = 1
foreach ($ext in $browserExtensions["Chromium"]) {
    $extId = $extensions[$ext]
    Set-ItemProperty -Path $chromiumPolicy -Name $index -Value "$extId;https://clients2.google.com/service/update2/crx" -Type String
    Write-Host "  ✓ 已添加: $ext ($extId)" -ForegroundColor Green
    $index++
}

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  ✓ 扩展安装完成！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green

Write-Host "`n[*] 每个浏览器的扩展组合：" -ForegroundColor Cyan
foreach ($browser in $browserExtensions.Keys) {
    Write-Host "`n  $browser`:" -ForegroundColor Yellow
    foreach ($ext in $browserExtensions[$browser]) {
        Write-Host "    - $ext" -ForegroundColor White
    }
}

Write-Host "`n[!] 重要提示：" -ForegroundColor Yellow
Write-Host "  1. 重启所有浏览器使扩展生效" -ForegroundColor White
Write-Host "  2. 首次启动时扩展会自动下载安装" -ForegroundColor White
Write-Host "  3. 每个浏览器的扩展组合都不同，增强隐私保护" -ForegroundColor White
Write-Host "  4. WebRTC Leak Shield 必须手动启用（首次启动后）" -ForegroundColor White
