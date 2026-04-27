# ============================================================================
# LibreWolf 企业级配置脚本 - Firefox 隐私增强版
# ============================================================================
# LibreWolf 是 Firefox 的隐私增强版本，已预配置最大隐私保护
# 配置方式：policies.json + librewolf.overrides.cfg
# ============================================================================

#Requires -RunAsAdministrator

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "LibreWolf 企业级配置" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$LibreWolfPath = "C:\Program Files\LibreWolf"
$DistributionPath = "$LibreWolfPath\distribution"

if (-not (Test-Path $DistributionPath)) {
    New-Item -Path $DistributionPath -ItemType Directory -Force | Out-Null
}

# 创建 policies.json
$PoliciesJson = @"
{
  "policies": {
    "DisableTelemetry": true,
    "DisableFirefoxStudies": true,
    "DisablePocket": true,
    "DisableFirefoxAccounts": true,
    "DisplayBookmarksToolbar": "always",
    "Homepage": {
      "URL": "about:blank",
      "Locked": false
    },
    "NewTabPage": false,
    "EnableTrackingProtection": {
      "Value": true,
      "Locked": true,
      "Cryptomining": true,
      "Fingerprinting": true
    },
    "DNSOverHTTPS": {
      "Enabled": true,
      "ProviderURL": "https://dns.google/dns-query"
    },
    "ExtensionSettings": {
      "*": {
        "installation_mode": "blocked"
      },
      "uBlock0@raymondhill.net": {
        "installation_mode": "force_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
      },
      "jid1-CnnpBIS9aGJIcQ@jetpack": {
        "installation_mode": "force_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/webrtc-leak-shield/latest.xpi"
      },
      "{73a6fe31-595d-460b-a920-fcc0f8843232}": {
        "installation_mode": "force_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/noscript/latest.xpi"
      },
      "jid1-MnnxcxisBPnSXQ@jetpack": {
        "installation_mode": "force_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi"
      }
    },
    "Permissions": {
      "Camera": {"BlockNewRequests": true},
      "Microphone": {"BlockNewRequests": true},
      "Location": {"BlockNewRequests": true},
      "Notifications": {"BlockNewRequests": true}
    }
  }
}
"@

$PoliciesJson | Out-File -FilePath "$DistributionPath\policies.json" -Encoding UTF8 -Force

# 创建启动脚本
$LaunchScript = @'
param([string]$ProfileName = "default-release", [int]$ProxyPort = 7890)
$LibreWolfPath = "C:\Program Files\LibreWolf\librewolf.exe"
$env:HTTP_PROXY = "socks5://127.0.0.1:$ProxyPort"
$env:HTTPS_PROXY = "socks5://127.0.0.1:$ProxyPort"
$LaunchArgs = @("-P", $ProfileName, "-no-remote")
Write-Host "启动 LibreWolf - $ProfileName (代理: $ProxyPort)" -ForegroundColor Cyan
Start-Process -FilePath $LibreWolfPath -ArgumentList $LaunchArgs
Write-Host "[✓] LibreWolf 已启动" -ForegroundColor Green
Write-Host "  ✓ 最大隐私保护（预配置）" -ForegroundColor White
Write-Host "  ✓ Resist Fingerprinting 已启用" -ForegroundColor White
Write-Host "  ✓ 所有 Mozilla 遥测已移除" -ForegroundColor White
'@
$LaunchScript | Out-File -FilePath ".\LAUNCH_LIBREWOLF.ps1" -Encoding UTF8 -Force

Write-Host "`n[✓] LibreWolf 配置完成！" -ForegroundColor Green
Write-Host "  ✓ policies.json 已创建" -ForegroundColor White
Write-Host "  ✓ 4个扩展自动安装" -ForegroundColor White
Write-Host "  ✓ 最大隐私保护（LibreWolf 默认）" -ForegroundColor White
Write-Host ""
Write-Host "LibreWolf 特点：" -ForegroundColor Yellow
Write-Host "  ✓ 基于 Firefox，移除所有 Mozilla 遥测" -ForegroundColor White
Write-Host "  ✓ 默认启用 Resist Fingerprinting" -ForegroundColor White
Write-Host "  ✓ 默认启用 uBlock Origin" -ForegroundColor White
Write-Host "  ✓ 无需额外配置即可获得最大隐私" -ForegroundColor White
Write-Host ""
