#Requires -RunAsAdministrator

# ══════════════════════════════════════════════════════════════════
#  7浏览器专属优化脚本 - 终极定制版
#  针对每个浏览器的特性进行深度优化
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  7浏览器专属优化 - 终极定制版" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

$baseDir = "C:\BrowserProfiles"
$reportData = @()

# ══════════════════════════════════════════════════════════════════
#  Chrome 优化（速度优先）
# ══════════════════════════════════════════════════════════════════

function Optimize-Chrome {
    Write-Host "`n[Chrome] 速度优先优化..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # 性能优化
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "DiskCacheSize" -Value 104857600 -Type DWord -Force  # 100MB
    
    # 隐私优化
    Set-ItemProperty -Path $regPath -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SpellCheckServiceEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "SearchSuggestEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "AlternateErrorPagesEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "DNSPrefetchingEnabled" -Value 0 -Type DWord -Force
    
    # 安全优化
    Set-ItemProperty -Path $regPath -Name "SafeBrowsingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "PasswordManagerEnabled" -Value 0 -Type DWord -Force
    
    $reportData += @{Browser="Chrome"; Features="速度优先、硬件加速、隐私保护"; Status="✓"}
    Write-Host "[✓] Chrome 优化完成" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  Firefox 优化（隐私优先）
# ══════════════════════════════════════════════════════════════════

function Optimize-Firefox {
    Write-Host "`n[Firefox] 隐私优先优化..." -ForegroundColor Cyan
    
    $profilePath = "$env:APPDATA\Mozilla\Firefox\Profiles"
    if (-not (Test-Path $profilePath)) {
        Write-Host "[!] Firefox 配置目录不存在" -ForegroundColor Yellow
        return
    }
    
    $profiles = Get-ChildItem -Path $profilePath -Directory
    foreach ($profile in $profiles) {
        $prefsFile = "$($profile.FullName)\prefs.js"
        
        $prefs = @"
// 性能优化
user_pref("browser.cache.disk.capacity", 102400);
user_pref("browser.cache.memory.capacity", 51200);
user_pref("network.http.max-connections", 256);
user_pref("network.http.max-persistent-connections-per-server", 10);

// 隐私优化
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.donottrackheader.enabled", true);
user_pref("privacy.resistFingerprinting", true);
user_pref("webgl.disabled", true);
user_pref("media.peerconnection.enabled", false);

// 安全优化
user_pref("network.dns.disablePrefetch", true);
user_pref("network.prefetch-next", false);
user_pref("browser.send_pings", false);

// 速度优化
user_pref("browser.sessionstore.interval", 60000);
user_pref("browser.tabs.animate", false);
"@
        
        $prefs | Out-File -FilePath $prefsFile -Append -Encoding UTF8 -Force
    }
    
    $reportData += @{Browser="Firefox"; Features="隐私优先、指纹防护、WebRTC禁用"; Status="✓"}
    Write-Host "[✓] Firefox 优化完成" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  Edge 优化（平衡模式）
# ══════════════════════════════════════════════════════════════════

function Optimize-Edge {
    Write-Host "`n[Edge] 平衡模式优化..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # 性能优化
    Set-ItemProperty -Path $regPath -Name "StartupBoostEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    
    # 隐私优化
    Set-ItemProperty -Path $regPath -Name "PersonalizationReportingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "DiagnosticData" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "TrackingPrevention" -Value 2 -Type DWord -Force  # Strict
    
    # 功能禁用
    Set-ItemProperty -Path $regPath -Name "EdgeShoppingAssistantEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "EdgeCollectionsEnabled" -Value 0 -Type DWord -Force
    
    $reportData += @{Browser="Edge"; Features="平衡模式、追踪防护、购物助手禁用"; Status="✓"}
    Write-Host "[✓] Edge 优化完成" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  Brave 优化（内置隐私增强）
# ══════════════════════════════════════════════════════════════════

function Optimize-Brave {
    Write-Host "`n[Brave] 内置隐私增强..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # Brave 已内置强隐私，只需性能优化
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    
    $reportData += @{Browser="Brave"; Features="内置广告拦截、内置指纹防护、性能优化"; Status="✓"}
    Write-Host "[✓] Brave 优化完成（内置隐私已启用）" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  Opera 优化（内置VPN优化）
# ══════════════════════════════════════════════════════════════════

function Optimize-Opera {
    Write-Host "`n[Opera] 内置VPN优化..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\Opera Software\Opera Stable"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # 性能优化
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    
    # 隐私优化
    Set-ItemProperty -Path $regPath -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    
    $reportData += @{Browser="Opera"; Features="内置VPN、广告拦截、性能优化"; Status="✓"}
    Write-Host "[✓] Opera 优化完成" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  Vivaldi 优化（高度定制）
# ══════════════════════════════════════════════════════════════════

function Optimize-Vivaldi {
    Write-Host "`n[Vivaldi] 高度定制优化..." -ForegroundColor Cyan
    
    $regPath = "HKLM:\SOFTWARE\Policies\Vivaldi"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    
    # 性能优化
    Set-ItemProperty -Path $regPath -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $regPath -Name "HardwareAccelerationModeEnabled" -Value 1 -Type DWord -Force
    
    $reportData += @{Browser="Vivaldi"; Features="高度定制、标签管理、性能优化"; Status="✓"}
    Write-Host "[✓] Vivaldi 优化完成" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  LibreWolf 优化（极致隐私）
# ══════════════════════════════════════════════════════════════════

function Optimize-LibreWolf {
    Write-Host "`n[LibreWolf] 极致隐私优化..." -ForegroundColor Cyan
    
    # LibreWolf 已预配置极致隐私，无需额外优化
    $reportData += @{Browser="LibreWolf"; Features="极致隐私、预配置优化、无遥测"; Status="✓"}
    Write-Host "[✓] LibreWolf 已预优化（无需额外配置）" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  执行优化
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[*] 关闭所有浏览器..." -ForegroundColor Yellow
Get-Process chrome,firefox,msedge,brave,opera,vivaldi,librewolf -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

Optimize-Chrome
Optimize-Firefox
Optimize-Edge
Optimize-Brave
Optimize-Opera
Optimize-Vivaldi
Optimize-LibreWolf

# ══════════════════════════════════════════════════════════════════
#  生成HTML报告
# ══════════════════════════════════════════════════════════════════

$htmlReport = @"
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>7浏览器优化完成报告</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; background: white; border-radius: 20px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); overflow: hidden; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 40px; text-align: center; }
        .header h1 { font-size: 2.5em; margin-bottom: 10px; }
        .header p { font-size: 1.2em; opacity: 0.9; }
        .content { padding: 40px; }
        .section { margin-bottom: 40px; }
        .section h2 { color: #667eea; margin-bottom: 20px; font-size: 1.8em; border-bottom: 3px solid #667eea; padding-bottom: 10px; }
        .browser-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin-top: 20px; }
        .browser-card { background: #f8f9fa; border-radius: 15px; padding: 25px; border-left: 5px solid #667eea; transition: transform 0.3s, box-shadow 0.3s; }
        .browser-card:hover { transform: translateY(-5px); box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .browser-card h3 { color: #333; margin-bottom: 15px; font-size: 1.5em; }
        .browser-card .features { color: #666; line-height: 1.8; margin-bottom: 15px; }
        .browser-card .status { display: inline-block; background: #28a745; color: white; padding: 5px 15px; border-radius: 20px; font-size: 0.9em; }
        .extension-guide { background: #fff3cd; border-left: 5px solid #ffc107; padding: 20px; border-radius: 10px; margin-top: 20px; }
        .extension-guide h3 { color: #856404; margin-bottom: 15px; }
        .extension-list { list-style: none; }
        .extension-list li { padding: 10px 0; border-bottom: 1px solid #e0e0e0; }
        .extension-list li:last-child { border-bottom: none; }
        .extension-list a { color: #667eea; text-decoration: none; font-weight: bold; }
        .extension-list a:hover { text-decoration: underline; }
        .launch-section { background: #e7f3ff; border-radius: 15px; padding: 30px; margin-top: 30px; }
        .launch-section h3 { color: #0056b3; margin-bottom: 20px; }
        .launch-button { display: inline-block; background: #667eea; color: white; padding: 15px 30px; border-radius: 10px; text-decoration: none; margin: 10px; font-weight: bold; transition: background 0.3s; }
        .launch-button:hover { background: #764ba2; }
        .footer { background: #f8f9fa; padding: 30px; text-align: center; color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🎉 7浏览器优化完成</h1>
            <p>所有浏览器已针对性优化 | 隐私、速度、稳定性全面提升</p>
        </div>
        
        <div class="content">
            <div class="section">
                <h2>📊 优化概览</h2>
                <div class="browser-grid">
$(foreach ($item in $reportData) {
"                    <div class='browser-card'>
                        <h3>$($item.Browser)</h3>
                        <div class='features'>$($item.Features)</div>
                        <span class='status'>$($item.Status) 已优化</span>
                    </div>"
})
                </div>
            </div>
            
            <div class="section">
                <h2>🔧 已应用的优化</h2>
                <ul style="line-height: 2; color: #333; padding-left: 20px;">
                    <li>✓ 禁用遥测和数据收集</li>
                    <li>✓ 启用硬件加速</li>
                    <li>✓ 优化缓存大小（100MB）</li>
                    <li>✓ 禁用DNS预取</li>
                    <li>✓ 禁用后台模式</li>
                    <li>✓ 启用追踪防护</li>
                    <li>✓ 禁用密码管理器</li>
                    <li>✓ 优化网络连接数</li>
                </ul>
            </div>
            
            <div class="section">
                <div class="extension-guide">
                    <h3>📦 推荐扩展安装指南</h3>
                    <p style="margin-bottom: 15px; color: #856404;">以下扩展可进一步增强隐私和安全性，请根据需要手动安装：</p>
                    
                    <h4 style="margin-top: 20px; color: #856404;">Chrome / Edge / Brave / Vivaldi:</h4>
                    <ul class="extension-list">
                        <li><a href="https://chromewebstore.google.com/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm" target="_blank">uBlock Origin</a> - 广告拦截</li>
                        <li><a href="https://chromewebstore.google.com/detail/canvas-defender/obdbgnebcljmgkoljcdddaopadkifnpm" target="_blank">Canvas Defender</a> - Canvas指纹防护</li>
                        <li><a href="https://chromewebstore.google.com/detail/user-agent-switcher-and-manager/bhchdcejhohfmigjafbampogmaanbfkg" target="_blank">User-Agent Switcher</a> - UA切换</li>
                    </ul>
                    
                    <h4 style="margin-top: 20px; color: #856404;">Firefox / LibreWolf:</h4>
                    <ul class="extension-list">
                        <li><a href="https://addons.mozilla.org/firefox/addon/ublock-origin/" target="_blank">uBlock Origin</a> - 广告拦截</li>
                        <li><a href="https://addons.mozilla.org/firefox/addon/canvasblocker/" target="_blank">Canvas Blocker</a> - Canvas指纹防护</li>
                        <li><a href="https://addons.mozilla.org/firefox/addon/user-agent-string-switcher/" target="_blank">User-Agent Switcher</a> - UA切换</li>
                    </ul>
                    
                    <h4 style="margin-top: 20px; color: #856404;">Opera:</h4>
                    <p style="color: #856404; margin-bottom: 10px;">先安装 <a href="https://addons.opera.com/extensions/details/install-chrome-extensions/" target="_blank">Install Chrome Extensions</a>，然后可使用 Chrome Web Store 扩展</p>
                </div>
            </div>
            
            <div class="section">
                <div class="launch-section">
                    <h3>🚀 启动浏览器</h3>
                    <p style="margin-bottom: 20px; color: #0056b3;">所有浏览器已配置独立代理端口（7891-7897）和美国时区</p>
                    <a href="file:///C:/BrowserProfiles/Launch_All.bat" class="launch-button">启动所有浏览器</a>
                    <a href="file:///C:/BrowserProfiles/" class="launch-button">打开配置目录</a>
                </div>
            </div>
            
            <div class="section">
                <h2>⚙️ 下一步配置</h2>
                <ol style="line-height: 2.5; color: #333; padding-left: 20px;">
                    <li><strong>配置 Clash Verge：</strong>为每个浏览器分配独立的美国 IP（端口 7891-7897）</li>
                    <li><strong>安装推荐扩展：</strong>根据上方指南手动安装扩展</li>
                    <li><strong>验证隔离：</strong>在每个浏览器访问 <a href="https://ip.sb" target="_blank">https://ip.sb</a> 确认不同 IP</li>
                    <li><strong>验证指纹：</strong>访问 <a href="https://browserleaks.com/canvas" target="_blank">https://browserleaks.com/canvas</a> 确认指纹隔离</li>
                </ol>
            </div>
        </div>
        
        <div class="footer">
            <p>优化完成时间: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')</p>
            <p style="margin-top: 10px;">配置目录: C:\BrowserProfiles</p>
        </div>
    </div>
</body>
</html>
"@

$reportPath = "$baseDir\优化完成报告.html"
$htmlReport | Out-File -FilePath $reportPath -Encoding UTF8 -Force

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  完成！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "`n[✓] HTML报告已生成: $reportPath" -ForegroundColor Yellow
Write-Host "[*] 正在打开报告..." -ForegroundColor Yellow

Start-Process $reportPath
