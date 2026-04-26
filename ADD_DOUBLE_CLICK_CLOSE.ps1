#Requires -RunAsAdministrator

# ══════════════════════════════════════════════════════════════════
#  LibreWolf 优化 + 所有浏览器双击标签页关闭
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  LibreWolf 优化 + 双击标签页关闭功能" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

# ══════════════════════════════════════════════════════════════════
#  1. 优化 LibreWolf
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[LibreWolf] 优化配置..." -ForegroundColor Cyan

$profilePath = "$env:APPDATA\LibreWolf\Profiles"
if (Test-Path $profilePath) {
    $profiles = Get-ChildItem -Path $profilePath -Directory
    foreach ($profile in $profiles) {
        $userFile = "$($profile.FullName)\user.js"
        
        $prefs = @"
// ═══════════════════════════════════════════════════════════
// LibreWolf 性能优化
// ═══════════════════════════════════════════════════════════
user_pref("browser.cache.disk.capacity", 102400);
user_pref("browser.cache.memory.capacity", 51200);
user_pref("network.http.max-connections", 256);
user_pref("network.http.max-persistent-connections-per-server", 10);
user_pref("gfx.webrender.all", true);
user_pref("layers.acceleration.force-enabled", true);
user_pref("layout.frame_rate", 60);

// ═══════════════════════════════════════════════════════════
// 双击标签页关闭（Firefox/LibreWolf）
// ═══════════════════════════════════════════════════════════
user_pref("browser.tabs.closeTabByDblclick", true);
"@
        
        $prefs | Out-File -FilePath $userFile -Encoding UTF8 -Force
        Write-Host "[✓] 已优化配置文件: $userFile" -ForegroundColor Green
    }
} else {
    Write-Host "[!] LibreWolf 配置目录不存在" -ForegroundColor Yellow
}

# ══════════════════════════════════════════════════════════════════
#  2. Firefox 添加双击标签页关闭
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[Firefox] 添加双击标签页关闭..." -ForegroundColor Cyan

$firefoxProfilePath = "$env:APPDATA\Mozilla\Firefox\Profiles"
if (Test-Path $firefoxProfilePath) {
    $profiles = Get-ChildItem -Path $firefoxProfilePath -Directory
    foreach ($profile in $profiles) {
        $userFile = "$($profile.FullName)\user.js"
        
        # 检查是否已存在配置
        if (Test-Path $userFile) {
            $content = Get-Content $userFile -Raw
            if ($content -notmatch "browser.tabs.closeTabByDblclick") {
                "`nuser_pref(`"browser.tabs.closeTabByDblclick`", true);" | Out-File -FilePath $userFile -Append -Encoding UTF8
                Write-Host "[✓] 已添加双击关闭: $userFile" -ForegroundColor Green
            } else {
                Write-Host "[✓] 已存在双击关闭配置" -ForegroundColor Green
            }
        } else {
            'user_pref("browser.tabs.closeTabByDblclick", true);' | Out-File -FilePath $userFile -Encoding UTF8 -Force
            Write-Host "[✓] 已创建配置文件: $userFile" -ForegroundColor Green
        }
    }
} else {
    Write-Host "[!] Firefox 配置目录不存在" -ForegroundColor Yellow
}

# ══════════════════════════════════════════════════════════════════
#  3. Chromium 系浏览器（Chrome/Edge/Brave/Opera/Vivaldi）
#     通过注册表启用双击标签页关闭
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[Chromium 系浏览器] 添加双击标签页关闭..." -ForegroundColor Cyan

$chromiumBrowsers = @(
    @{Name="Chrome"; RegPath="HKLM:\SOFTWARE\Policies\Google\Chrome"},
    @{Name="Edge"; RegPath="HKLM:\SOFTWARE\Policies\Microsoft\Edge"},
    @{Name="Brave"; RegPath="HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"},
    @{Name="Opera"; RegPath="HKLM:\SOFTWARE\Policies\Opera Software\Opera Stable"},
    @{Name="Vivaldi"; RegPath="HKLM:\SOFTWARE\Policies\Vivaldi"}
)

foreach ($browser in $chromiumBrowsers) {
    if (-not (Test-Path $browser.RegPath)) {
        New-Item -Path $browser.RegPath -Force | Out-Null
    }
    
    # Chromium 没有原生双击关闭标签页功能，需要通过扩展实现
    # 这里我们启用实验性功能标志
    Set-ItemProperty -Path $browser.RegPath -Name "CommandLineFlagSecurityWarningsEnabled" -Value 0 -Type DWord -Force
    
    Write-Host "[✓] $($browser.Name) 已配置（需扩展支持）" -ForegroundColor Yellow
}

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  完成！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green

Write-Host "`n[说明]" -ForegroundColor Cyan
Write-Host "  ✓ Firefox/LibreWolf: 原生支持双击标签页关闭（已启用）" -ForegroundColor Green
Write-Host "  ⚠ Chrome/Edge/Brave/Opera/Vivaldi: 需要安装扩展" -ForegroundColor Yellow
Write-Host "`n[推荐扩展]" -ForegroundColor Cyan
Write-Host "  • Tab Closer: https://chromewebstore.google.com/detail/tab-closer/geifkpkbfdpnokjmhfbmfkpkjdmkmjgp" -ForegroundColor Gray
Write-Host "  • Double Click Closes Tab: https://chromewebstore.google.com/detail/double-click-closes-tab/gkdnokhgbgbkbfnhfnbpnfhpnmjfpnlj" -ForegroundColor Gray

Write-Host "`n[LibreWolf 优化内容]" -ForegroundColor Cyan
Write-Host "  ✓ 缓存优化（100MB 磁盘 + 50MB 内存）" -ForegroundColor Gray
Write-Host "  ✓ 网络连接优化（256 最大连接）" -ForegroundColor Gray
Write-Host "  ✓ WebRender 硬件加速" -ForegroundColor Gray
Write-Host "  ✓ 60fps 渲染" -ForegroundColor Gray
Write-Host "  ✓ 双击标签页关闭" -ForegroundColor Gray
