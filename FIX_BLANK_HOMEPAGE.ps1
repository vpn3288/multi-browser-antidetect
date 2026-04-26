# ============================================
# 修复空白主页问题 - 官方文档验证版
# 解决 Opera、Vivaldi、Brave 不显示空白标签页的问题
# ============================================

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "修复浏览器空白主页配置" -ForegroundColor Cyan
Write-Host "基于官方企业策略文档验证" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# 检查管理员权限
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[!] 需要管理员权限来修改注册表策略" -ForegroundColor Red
    Write-Host "    请右键点击 PowerShell，选择'以管理员身份运行'" -ForegroundColor Yellow
    exit
}

# 关闭所有浏览器
Write-Host "[*] 关闭所有浏览器..." -ForegroundColor Yellow
Get-Process chrome,chromium,firefox,msedge,brave,opera,vivaldi,librewolf -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

# 修复函数
function Fix-ChromiumBrowser {
    param(
        [string]$BrowserName,
        [string]$RegPath
    )
    
    Write-Host "`n[${BrowserName}] 修复空白主页配置..." -ForegroundColor Cyan
    
    if (-not (Test-Path $RegPath)) { 
        New-Item -Path $RegPath -Force | Out-Null 
    }
    
    # ✅ 关键修复：正确的空白主页配置
    # HomepageIsNewTabPage = 0 表示主页不是新标签页，而是使用 HomepageLocation
    Set-ItemProperty -Path $RegPath -Name "HomepageIsNewTabPage" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $RegPath -Name "HomepageLocation" -Value "about:blank" -Type String -Force
    
    # RestoreOnStartup = 4 表示打开特定页面（配合 RestoreOnStartupURLs）
    Set-ItemProperty -Path $RegPath -Name "RestoreOnStartup" -Value 4 -Type DWord -Force
    
    # 设置启动页面为 about:blank
    $startupUrlsPath = "$RegPath\RestoreOnStartupURLs"
    if (-not (Test-Path $startupUrlsPath)) { 
        New-Item -Path $startupUrlsPath -Force | Out-Null 
    }
    Set-ItemProperty -Path $startupUrlsPath -Name "1" -Value "about:blank" -Type String -Force
    
    # 确保书签栏显示
    Set-ItemProperty -Path $RegPath -Name "BookmarkBarEnabled" -Value 1 -Type DWord -Force
    
    # 禁用默认浏览器提示
    Set-ItemProperty -Path $RegPath -Name "DefaultBrowserSettingEnabled" -Value 0 -Type DWord -Force
    
    Write-Host "    [✓] ${BrowserName} 配置已修复" -ForegroundColor Green
}

# 修复所有 Chromium 系浏览器
Fix-ChromiumBrowser -BrowserName "Chrome" -RegPath "HKLM:\SOFTWARE\Policies\Google\Chrome"
Fix-ChromiumBrowser -BrowserName "Chromium" -RegPath "HKLM:\SOFTWARE\Policies\Chromium"
Fix-ChromiumBrowser -BrowserName "Edge" -RegPath "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
Fix-ChromiumBrowser -BrowserName "Brave" -RegPath "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"
Fix-ChromiumBrowser -BrowserName "Opera" -RegPath "HKLM:\SOFTWARE\Policies\Opera Software\Opera Stable"
Fix-ChromiumBrowser -BrowserName "Vivaldi" -RegPath "HKLM:\SOFTWARE\Policies\Vivaldi"

# 修复 Firefox
Write-Host "`n[Firefox] 修复空白主页配置..." -ForegroundColor Cyan
$firefoxProfilePath = "$env:APPDATA\Mozilla\Firefox\Profiles"
if (Test-Path $firefoxProfilePath) {
    $profiles = Get-ChildItem -Path $firefoxProfilePath -Directory | Where-Object { $_.Name -like "*.default*" }
    foreach ($profile in $profiles) {
        $userJsPath = Join-Path $profile.FullName "user.js"
        $userJsContent = @"
// Firefox 空白主页配置
user_pref("browser.startup.homepage", "about:blank");
user_pref("browser.startup.page", 1);
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.newtab.preload", false);
user_pref("browser.newtabpage.activity-stream.enabled", false);
user_pref("browser.toolbars.bookmarks.visibility", "always");
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.tabs.loadBookmarksInTabs", true);
"@
        Set-Content -Path $userJsPath -Value $userJsContent -Encoding UTF8 -Force
        Write-Host "    [✓] 已配置: $($profile.Name)" -ForegroundColor Green
    }
} else {
    Write-Host "    [!] Firefox 未安装或未运行过" -ForegroundColor Yellow
}

# 修复 LibreWolf
Write-Host "`n[LibreWolf] 修复空白主页配置..." -ForegroundColor Cyan
$librewolfProfilePath = "$env:APPDATA\LibreWolf\Profiles"
if (Test-Path $librewolfProfilePath) {
    $profiles = Get-ChildItem -Path $librewolfProfilePath -Directory | Where-Object { $_.Name -like "*.default*" }
    foreach ($profile in $profiles) {
        $userJsPath = Join-Path $profile.FullName "user.js"
        $userJsContent = @"
// LibreWolf 空白主页配置
user_pref("browser.startup.homepage", "about:blank");
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.toolbars.bookmarks.visibility", "always");
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.tabs.loadBookmarksInTabs", true);
"@
        Set-Content -Path $userJsPath -Value $userJsContent -Encoding UTF8 -Force
        Write-Host "    [✓] 已配置: $($profile.Name)" -ForegroundColor Green
    }
} else {
    Write-Host "    [!] LibreWolf 未安装或未运行过" -ForegroundColor Yellow
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "空白主页配置修复完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

Write-Host "`n重要提示：" -ForegroundColor Yellow
Write-Host "1. 请重启所有浏览器以使配置生效" -ForegroundColor Yellow
Write-Host "2. 如果 Opera/Vivaldi 仍显示 Speed Dial，请手动在设置中选择'打开特定页面'并设置为 about:blank" -ForegroundColor Yellow
Write-Host "3. 配置说明：" -ForegroundColor Cyan
Write-Host "   - HomepageIsNewTabPage = 0 (主页不是新标签页)" -ForegroundColor Gray
Write-Host "   - HomepageLocation = about:blank (主页地址)" -ForegroundColor Gray
Write-Host "   - RestoreOnStartup = 4 (打开特定页面)" -ForegroundColor Gray
Write-Host "   - RestoreOnStartupURLs = [about:blank] (启动页面列表)" -ForegroundColor Gray

Write-Host "`n按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
