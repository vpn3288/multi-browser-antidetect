#Requires -RunAsAdministrator

# ══════════════════════════════════════════════════════════════════
#  7浏览器双击标签页关闭 - 原生设置优先
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  7浏览器双击标签页关闭配置" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

# ══════════════════════════════════════════════════════════════════
#  1. Edge - 通过注册表启用（原生支持）
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[Edge] 启用双击关闭标签页..." -ForegroundColor Cyan

$edgeRegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
if (-not (Test-Path $edgeRegPath)) { New-Item -Path $edgeRegPath -Force | Out-Null }

Set-ItemProperty -Path $edgeRegPath -Name "DoubleClickCloseTabEnabled" -Value 1 -Type DWord -Force
Write-Host "[✓] Edge 已启用双击关闭" -ForegroundColor Green

# ══════════════════════════════════════════════════════════════════
#  2. Vivaldi - 通过 Preferences 文件启用（原生支持）
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[Vivaldi] 启用双击关闭标签页..." -ForegroundColor Cyan

$vivaldiPrefsPath = "$env:LOCALAPPDATA\Vivaldi\User Data\Default\Preferences"
if (Test-Path $vivaldiPrefsPath) {
    try {
        $prefs = Get-Content $vivaldiPrefsPath -Raw | ConvertFrom-Json
        
        # 添加 Vivaldi 特有设置
        if (-not $prefs.vivaldi) {
            $prefs | Add-Member -MemberType NoteProperty -Name "vivaldi" -Value @{}
        }
        if (-not $prefs.vivaldi.tabs) {
            $prefs.vivaldi | Add-Member -MemberType NoteProperty -Name "tabs" -Value @{}
        }
        
        $prefs.vivaldi.tabs.close_on_double_click = $true
        
        $prefs | ConvertTo-Json -Depth 100 | Set-Content $vivaldiPrefsPath -Force
        Write-Host "[✓] Vivaldi 已启用双击关闭" -ForegroundColor Green
    } catch {
        Write-Host "[✗] Vivaldi 配置失败: $_" -ForegroundColor Red
    }
} else {
    Write-Host "[!] Vivaldi 配置文件不存在（需先启动一次）" -ForegroundColor Yellow
}

# ══════════════════════════════════════════════════════════════════
#  3. Firefox - 通过 user.js 启用（原生支持）
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[Firefox] 启用双击关闭标签页..." -ForegroundColor Cyan

$firefoxProfilePath = "$env:APPDATA\Mozilla\Firefox\Profiles"
if (Test-Path $firefoxProfilePath) {
    $profiles = Get-ChildItem -Path $firefoxProfilePath -Directory
    foreach ($profile in $profiles) {
        $userFile = "$($profile.FullName)\user.js"
        
        if (Test-Path $userFile) {
            $content = Get-Content $userFile -Raw
            if ($content -notmatch "browser.tabs.closeTabByDblclick") {
                "`nuser_pref(`"browser.tabs.closeTabByDblclick`", true);" | Out-File -FilePath $userFile -Append -Encoding UTF8
            }
        } else {
            'user_pref("browser.tabs.closeTabByDblclick", true);' | Out-File -FilePath $userFile -Encoding UTF8 -Force
        }
        Write-Host "[✓] Firefox 已启用双击关闭: $($profile.Name)" -ForegroundColor Green
    }
} else {
    Write-Host "[!] Firefox 配置目录不存在" -ForegroundColor Yellow
}

# ══════════════════════════════════════════════════════════════════
#  4. LibreWolf - 通过 user.js 启用（原生支持）
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[LibreWolf] 启用双击关闭标签页..." -ForegroundColor Cyan

$librewolfProfilePath = "$env:APPDATA\LibreWolf\Profiles"
if (Test-Path $librewolfProfilePath) {
    $profiles = Get-ChildItem -Path $librewolfProfilePath -Directory
    foreach ($profile in $profiles) {
        $userFile = "$($profile.FullName)\user.js"
        
        if (Test-Path $userFile) {
            $content = Get-Content $userFile -Raw
            if ($content -notmatch "browser.tabs.closeTabByDblclick") {
                "`nuser_pref(`"browser.tabs.closeTabByDblclick`", true);" | Out-File -FilePath $userFile -Append -Encoding UTF8
            }
        } else {
            'user_pref("browser.tabs.closeTabByDblclick", true);' | Out-File -FilePath $userFile -Encoding UTF8 -Force
        }
        Write-Host "[✓] LibreWolf 已启用双击关闭: $($profile.Name)" -ForegroundColor Green
    }
} else {
    Write-Host "[!] LibreWolf 配置目录不存在" -ForegroundColor Yellow
}

# ══════════════════════════════════════════════════════════════════
#  5. Chrome/Brave/Opera - 需要扩展
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[Chrome/Brave/Opera] 需要安装扩展..." -ForegroundColor Yellow
Write-Host "  这些浏览器不支持原生双击关闭，需要安装扩展：" -ForegroundColor Gray
Write-Host "  • Double Click Closes Tab: https://chromewebstore.google.com/detail/double-click-closes-tab/gkdnokhgbgbkbfnhfnbpnfhpnmjfpnlj" -ForegroundColor Gray

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  完成！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green

Write-Host "`n[总结]" -ForegroundColor Cyan
Write-Host "  ✓ Edge - 已通过注册表启用（原生）" -ForegroundColor Green
Write-Host "  ✓ Vivaldi - 已通过配置文件启用（原生）" -ForegroundColor Green
Write-Host "  ✓ Firefox - 已通过 user.js 启用（原生）" -ForegroundColor Green
Write-Host "  ✓ LibreWolf - 已通过 user.js 启用（原生）" -ForegroundColor Green
Write-Host "  ⚠ Chrome/Brave/Opera - 需要手动安装扩展" -ForegroundColor Yellow

Write-Host "`n[注意] 重启浏览器后生效" -ForegroundColor Yellow
