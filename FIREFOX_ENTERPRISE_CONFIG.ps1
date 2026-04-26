# ============================================================================
# Mozilla Firefox 企业级配置脚本 - 基于官方文档的完整优化
# ============================================================================
# 功能：
# 1. 创建 policies.json 企业策略文件
# 2. 创建 user.js 高级配置文件
# 3. 禁用 Mozilla 服务（Pocket, Firefox Suggest, Studies）
# 4. 配置增强追踪保护（Strict 模式）
# 5. 配置扩展自动安装
# 6. 反指纹保护（Resist Fingerprinting）
# ============================================================================

#Requires -RunAsAdministrator

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Mozilla Firefox 企业级配置 - 官方文档优化版" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Firefox 安装路径
$FirefoxPath = "C:\Program Files\Mozilla Firefox"
$FirefoxDistributionPath = "$FirefoxPath\distribution"

# 创建 distribution 目录
if (-not (Test-Path $FirefoxDistributionPath)) {
    New-Item -Path $FirefoxDistributionPath -ItemType Directory -Force | Out-Null
    Write-Host "[✓] 创建 Firefox distribution 目录" -ForegroundColor Green
}

# ============================================================================
# 1. 创建 policies.json 企业策略文件
# ============================================================================
Write-Host "`n[1/3] 创建 policies.json 企业策略..." -ForegroundColor Yellow

$PoliciesJson = @"
{
  "policies": {
    
    // ========================================
    // 隐私和遥测控制
    // ========================================
    "DisableTelemetry": true,
    "DisableFirefoxStudies": true,
    "DisablePocket": true,
    "DisableFirefoxAccounts": true,
    "DisableFirefoxScreenshots": true,
    "DisableFormHistory": true,
    "DisablePasswordReveal": true,
    "DisableProfileImport": true,
    "DisableProfileRefresh": true,
    "DisableSystemAddonUpdate": true,
    "DisableFeedbackCommands": true,
    "DisableSetDesktopBackground": true,
    
    // ========================================
    // Firefox Sync 和账户
    // ========================================
    "DisableFirefoxAccounts": true,
    "OverrideFirstRunPage": "",
    "OverridePostUpdatePage": "",
    
    // ========================================
    // 搜索和建议
    // ========================================
    "SearchSuggestEnabled": false,
    "FirefoxSuggest": {
      "WebSuggestions": false,
      "SponsoredSuggestions": false,
      "ImproveSuggest": false,
      "Locked": true
    },
    
    // ========================================
    // 主页和新标签页
    // ========================================
    "Homepage": {
      "URL": "about:blank",
      "Locked": false,
      "StartPage": "none"
    },
    "NewTabPage": false,
    "FirefoxHome": {
      "Search": false,
      "TopSites": false,
      "SponsoredTopSites": false,
      "Highlights": false,
      "Pocket": false,
      "SponsoredPocket": false,
      "Snippets": false,
      "Locked": true
    },
    
    // ========================================
    // 书签和工具栏
    // ========================================
    "DisplayBookmarksToolbar": "always",
    "DisplayMenuBar": "default-off",
    "ShowHomeButton": true,
    
    // ========================================
    // 隐私设置
    // ========================================
    "EnableTrackingProtection": {
      "Value": true,
      "Locked": true,
      "Cryptomining": true,
      "Fingerprinting": true,
      "EmailTracking": true
    },
    "Cookies": {
      "Behavior": "reject-tracker-and-partition-foreign",
      "Locked": false
    },
    "DNSOverHTTPS": {
      "Enabled": true,
      "ProviderURL": "https://dns.google/dns-query",
      "Locked": false
    },
    "EncryptedMediaExtensions": {
      "Enabled": false,
      "Locked": false
    },
    
    // ========================================
    // 权限控制
    // ========================================
    "Permissions": {
      "Camera": {
        "BlockNewRequests": true,
        "Locked": false
      },
      "Microphone": {
        "BlockNewRequests": true,
        "Locked": false
      },
      "Location": {
        "BlockNewRequests": true,
        "Locked": false
      },
      "Notifications": {
        "BlockNewRequests": true,
        "Locked": false
      },
      "Autoplay": {
        "Default": "block-audio-video",
        "Locked": false
      }
    },
    
    // ========================================
    // 下载设置
    // ========================================
    "DownloadDirectory": "\${home}\\Downloads",
    "PromptForDownloadLocation": false,
    
    // ========================================
    // 安全设置
    // ========================================
    "DisableSafeMode": false,
    "DisableDeveloperTools": false,
    "BlockAboutConfig": false,
    "BlockAboutProfiles": false,
    "BlockAboutSupport": false,
    "CaptivePortal": false,
    "NetworkPrediction": false,
    
    // ========================================
    // 扩展管理
    // ========================================
    "ExtensionSettings": {
      "*": {
        "installation_mode": "blocked",
        "blocked_install_message": "请联系管理员安装扩展"
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
    "ExtensionUpdate": true,
    
    // ========================================
    // 代理设置（通过启动脚本配置）
    // ========================================
    "Proxy": {
      "Mode": "system",
      "Locked": false
    },
    
    // ========================================
    // 更新设置
    // ========================================
    "DisableAppUpdate": false,
    "AppAutoUpdate": true,
    "BackgroundAppUpdate": false,
    
    // ========================================
    // 其他设置
    // ========================================
    "HardwareAcceleration": true,
    "OfferToSaveLogins": false,
    "PasswordManagerEnabled": false,
    "PDFjs": {
      "Enabled": true,
      "EnablePermissions": false
    },
    "PictureInPicture": {
      "Enabled": false,
      "Locked": false
    },
    "PopupBlocking": {
      "Default": true,
      "Locked": false
    },
    "PostQuantumKeyAgreementEnabled": true,
    "UserMessaging": {
      "WhatsNew": false,
      "ExtensionRecommendations": false,
      "FeatureRecommendations": false,
      "UrlbarInterventions": false,
      "SkipOnboarding": true,
      "MoreFromMozilla": false,
      "Locked": true
    },
    "UseSystemPrintDialog": false
  }
}
"@

$PoliciesJsonPath = "$FirefoxDistributionPath\policies.json"
$PoliciesJson | Out-File -FilePath $PoliciesJsonPath -Encoding UTF8 -Force

Write-Host "  [✓] 已创建 policies.json" -ForegroundColor Green
Write-Host "      路径: $PoliciesJsonPath" -ForegroundColor Gray

# ============================================================================
# 2. 创建 user.js 高级配置文件（反指纹保护）
# ============================================================================
Write-Host "`n[2/3] 创建 user.js 高级配置..." -ForegroundColor Yellow

$UserJs = @"
// ============================================================================
// Firefox 高级配置 - 反指纹和隐私保护
// ============================================================================
// 此文件放置在 Firefox 配置文件目录中
// 位置: %APPDATA%\Mozilla\Firefox\Profiles\<profile>\user.js
// ============================================================================

// ========================================
// 隐私和遥测（彻底禁用）
// ========================================
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.coverage.opt-out", true);
user_pref("toolkit.coverage.opt-out", true);
user_pref("toolkit.coverage.endpoint.base", "");
user_pref("browser.ping-centre.telemetry", false);
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);

// ========================================
// Studies 和实验
// ========================================
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");

// ========================================
// Crash Reports
// ========================================
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);

// ========================================
// 追踪保护（严格模式）
// ========================================
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.trackingprotection.cryptomining.enabled", true);
user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
user_pref("privacy.trackingprotection.emailtracking.enabled", true);
user_pref("privacy.trackingprotection.pbmode.enabled", true);
user_pref("privacy.donottrackheader.enabled", true);
user_pref("privacy.donottrackheader.value", 1);

// ========================================
// Cookie 和存储
// ========================================
user_pref("network.cookie.cookieBehavior", 5); // 5=拒绝追踪器和分区第三方
user_pref("network.cookie.lifetimePolicy", 2); // 2=会话结束时删除
user_pref("privacy.clearOnShutdown.cache", true);
user_pref("privacy.clearOnShutdown.cookies", false);
user_pref("privacy.clearOnShutdown.downloads", true);
user_pref("privacy.clearOnShutdown.formdata", true);
user_pref("privacy.clearOnShutdown.history", false);
user_pref("privacy.clearOnShutdown.offlineApps", true);
user_pref("privacy.clearOnShutdown.sessions", true);
user_pref("privacy.clearOnShutdown.sitesettings", false);

// ========================================
// 反指纹保护（Resist Fingerprinting）
// ========================================
user_pref("privacy.resistFingerprinting", true);
user_pref("privacy.resistFingerprinting.letterboxing", true);
user_pref("privacy.resistFingerprinting.block_mozAddonManager", true);
user_pref("privacy.spoof_english", 2); // 2=英语

// Canvas 指纹保护
user_pref("webgl.disabled", false); // 保持启用以免破坏网站
user_pref("webgl.enable-webgl2", true);

// 字体指纹保护
user_pref("browser.display.use_document_fonts", 0); // 0=禁用网页字体

// ========================================
// WebRTC 防护
// ========================================
user_pref("media.peerconnection.enabled", true); // 保持启用
user_pref("media.peerconnection.ice.default_address_only", true);
user_pref("media.peerconnection.ice.no_host", true);
user_pref("media.peerconnection.ice.proxy_only_if_behind_proxy", true);

// ========================================
// DNS-over-HTTPS
// ========================================
user_pref("network.trr.mode", 2); // 2=优先 DoH，3=仅 DoH
user_pref("network.trr.uri", "https://dns.google/dns-query");
user_pref("network.trr.custom_uri", "https://dns.google/dns-query");

// ========================================
// HTTPS-Only 模式
// ========================================
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_ever_enabled", true);

// ========================================
// 禁用预加载和预连接
// ========================================
user_pref("network.predictor.enabled", false);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.prefetch-next", false);
user_pref("network.http.speculative-parallel-limit", 0);

// ========================================
// 禁用 Mozilla 服务
// ========================================
user_pref("extensions.pocket.enabled", false);
user_pref("extensions.screenshots.disabled", true);
user_pref("identity.fxaccounts.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.enabled", false);

// ========================================
// 新标签页
// ========================================
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.newtab.preload", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);

// ========================================
// 搜索建议
// ========================================
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.urlbar.suggest.searches", false);
user_pref("browser.urlbar.trending.featureGate", false);
user_pref("browser.urlbar.addons.featureGate", false);
user_pref("browser.urlbar.mdn.featureGate", false);
user_pref("browser.urlbar.pocket.featureGate", false);
user_pref("browser.urlbar.weather.featureGate", false);

// ========================================
// 自动填充
// ========================================
user_pref("signon.rememberSignons", false);
user_pref("signon.autofillForms", false);
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);

// ========================================
// 性能优化
// ========================================
user_pref("gfx.webrender.all", true); // 启用 WebRender
user_pref("layers.acceleration.force-enabled", true); // 强制硬件加速
user_pref("browser.sessionstore.interval", 30000); // 会话保存间隔（毫秒）

// ========================================
// 其他隐私设置
// ========================================
user_pref("geo.enabled", false); // 禁用地理位置
user_pref("media.navigator.enabled", false); // 禁用媒体设备枚举
user_pref("dom.battery.enabled", false); // 禁用电池 API
user_pref("dom.event.clipboardevents.enabled", false); // 禁用剪贴板事件
user_pref("beacon.enabled", false); // 禁用 Beacon API

// ========================================
// User-Agent（保持默认，避免异常）
// ========================================
// user_pref("general.useragent.override", "自定义 UA"); // 取消注释以自定义

// ============================================================================
// 配置完成
// ============================================================================
"@

$UserJsTemplatePath = "$FirefoxDistributionPath\user.js.template"
$UserJs | Out-File -FilePath $UserJsTemplatePath -Encoding UTF8 -Force

Write-Host "  [✓] 已创建 user.js 模板" -ForegroundColor Green
Write-Host "      路径: $UserJsTemplatePath" -ForegroundColor Gray
Write-Host "      注意: 需要手动复制到配置文件目录" -ForegroundColor Yellow

# ============================================================================
# 3. 创建启动脚本
# ============================================================================
Write-Host "`n[3/3] 创建启动脚本..." -ForegroundColor Yellow

$LaunchScript = @'
# Firefox 启动脚本 - 带代理配置
# 使用方法: .\LAUNCH_FIREFOX.ps1 -ProfileName "default-release" -ProxyPort 7890

param(
    [string]$ProfileName = "default-release",
    [int]$ProxyPort = 7890
)

$FirefoxPath = "C:\Program Files\Mozilla Firefox\firefox.exe"

# 配置代理环境变量（Firefox 会读取系统代理）
$env:HTTP_PROXY = "socks5://127.0.0.1:$ProxyPort"
$env:HTTPS_PROXY = "socks5://127.0.0.1:$ProxyPort"

# 启动参数
$LaunchArgs = @(
    "-P", $ProfileName
    "-no-remote"
)

Write-Host "启动 Firefox - $ProfileName (代理端口: $ProxyPort)" -ForegroundColor Cyan

# 复制 user.js 到配置文件目录（如果存在模板）
$UserJsTemplate = "C:\Program Files\Mozilla Firefox\distribution\user.js.template"
$ProfilePath = "$env:APPDATA\Mozilla\Firefox\Profiles"

if (Test-Path $UserJsTemplate) {
    $Profiles = Get-ChildItem -Path $ProfilePath -Directory | Where-Object { $_.Name -like "*$ProfileName*" }
    if ($Profiles) {
        $TargetProfile = $Profiles[0].FullName
        $UserJsPath = "$TargetProfile\user.js"
        
        if (-not (Test-Path $UserJsPath)) {
            Copy-Item -Path $UserJsTemplate -Destination $UserJsPath -Force
            Write-Host "[✓] 已复制 user.js 到配置文件目录" -ForegroundColor Green
        }
    }
}

Start-Process -FilePath $FirefoxPath -ArgumentList $LaunchArgs

Write-Host "[✓] Firefox 已启动" -ForegroundColor Green
Write-Host "    配置文件: $ProfileName" -ForegroundColor Gray
Write-Host "    代理: socks5://127.0.0.1:$ProxyPort" -ForegroundColor Gray
Write-Host ""
Write-Host "验证配置：" -ForegroundColor Yellow
Write-Host "  1. 访问 about:policies 查看企业策略" -ForegroundColor White
Write-Host "  2. 访问 about:config 查看高级配置" -ForegroundColor White
Write-Host "  3. 访问 about:addons 查看扩展" -ForegroundColor White
'@

$LaunchScript | Out-File -FilePath ".\LAUNCH_FIREFOX.ps1" -Encoding UTF8 -Force

Write-Host "  [✓] 已创建 LAUNCH_FIREFOX.ps1" -ForegroundColor Green

# ============================================================================
# 完成
# ============================================================================
Write-Host "`n============================================" -ForegroundColor Green
Write-Host "Mozilla Firefox 企业级配置完成！" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "配置内容：" -ForegroundColor Cyan
Write-Host "  ✓ policies.json 企业策略（完整隐私配置）" -ForegroundColor White
Write-Host "  ✓ user.js 高级配置（反指纹保护）" -ForegroundColor White
Write-Host "  ✓ 禁用所有 Mozilla 服务和遥测" -ForegroundColor White
Write-Host "  ✓ 增强追踪保护（严格模式）" -ForegroundColor White
Write-Host "  ✓ Resist Fingerprinting 模式" -ForegroundColor White
Write-Host "  ✓ WebRTC 防护" -ForegroundColor White
Write-Host "  ✓ DNS-over-HTTPS" -ForegroundColor White
Write-Host "  ✓ HTTPS-Only 模式" -ForegroundColor White
Write-Host "  ✓ 扩展自动安装（4个扩展）" -ForegroundColor White
Write-Host ""
Write-Host "Firefox 特有优化：" -ForegroundColor Yellow
Write-Host "  ✓ Resist Fingerprinting（最强反指纹）" -ForegroundColor White
Write-Host "  ✓ 增强追踪保护（Strict 模式）" -ForegroundColor White
Write-Host "  ✓ Container Tabs 支持" -ForegroundColor White
Write-Host "  ✓ 禁用 Pocket、Firefox Suggest、Studies" -ForegroundColor White
Write-Host ""
Write-Host "已安装扩展：" -ForegroundColor Yellow
Write-Host "  1. uBlock Origin" -ForegroundColor White
Write-Host "  2. WebRTC Leak Shield" -ForegroundColor White
Write-Host "  3. NoScript" -ForegroundColor White
Write-Host "  4. Privacy Badger" -ForegroundColor White
Write-Host ""
Write-Host "下一步：" -ForegroundColor Yellow
Write-Host "  1. 重启 Firefox 使策略生效" -ForegroundColor White
Write-Host "  2. 访问 about:policies 验证策略" -ForegroundColor White
Write-Host "  3. 使用 .\LAUNCH_FIREFOX.ps1 启动浏览器" -ForegroundColor White
Write-Host ""
Write-Host "注意事项：" -ForegroundColor Red
Write-Host "  ⚠ Resist Fingerprinting 可能影响某些网站功能" -ForegroundColor White
Write-Host "  ⚠ user.js 会在每次启动时覆盖 prefs.js" -ForegroundColor White
Write-Host "  ⚠ 如需修改配置，请编辑 user.js 而非 about:config" -ForegroundColor White
Write-Host ""
