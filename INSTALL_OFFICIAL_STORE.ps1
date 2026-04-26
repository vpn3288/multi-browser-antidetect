# ══════════════════════════════════════════════════════════════════
#  浏览器扩展官方商店一键安装脚本
#  为每个浏览器打开对应的官方商店页面
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

# ══════════════════════════════════════════════════════════════════
#  Chrome 扩展（Chrome Web Store）
# ══════════════════════════════════════════════════════════════════

$ChromeExtensions = @(
    "https://chromewebstore.google.com/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm",
    "https://chromewebstore.google.com/detail/canvas-defender/obdbgnebcljmgkoljcdddaopadkifnpm",
    "https://chromewebstore.google.com/detail/user-agent-switcher-and-manager/bhchdcejhohfmigjafbampogmaanbfkg"
)

# ══════════════════════════════════════════════════════════════════
#  Edge 扩展（Microsoft Edge Add-ons）
# ══════════════════════════════════════════════════════════════════

$EdgeExtensions = @(
    "https://microsoftedge.microsoft.com/addons/detail/ublock-origin/odfafepnkmbhccpbejgmiehpchacaeak",
    "https://microsoftedge.microsoft.com/addons/detail/canvas-fingerprint-defend/giglaifdfkimffokoomllcpmdjeomckf",
    "https://microsoftedge.microsoft.com/addons/detail/user-agent-switcher-and-manager/cnjkedgepfdpdbnepgmajmmjdjkjnifa"
)

# ══════════════════════════════════════════════════════════════════
#  Brave 扩展（Chrome Web Store）
# ══════════════════════════════════════════════════════════════════

$BraveExtensions = $ChromeExtensions

# ══════════════════════════════════════════════════════════════════
#  Opera 扩展（需要先安装 Chrome 扩展支持）
# ══════════════════════════════════════════════════════════════════

$OperaChromeSupport = "https://addons.opera.com/extensions/details/install-chrome-extensions/"
$OperaExtensions = @(
    "https://addons.opera.com/extensions/details/ublock/",
    "https://chromewebstore.google.com/detail/canvas-defender/obdbgnebcljmgkoljcdddaopadkifnpm",
    "https://addons.opera.com/extensions/details/user-agent-switcher/"
)

# ══════════════════════════════════════════════════════════════════
#  Vivaldi 扩展（Chrome Web Store）
# ══════════════════════════════════════════════════════════════════

$VivaldiExtensions = $ChromeExtensions

# ══════════════════════════════════════════════════════════════════
#  Firefox 扩展（Firefox Add-ons）
# ══════════════════════════════════════════════════════════════════

$FirefoxExtensions = @(
    "https://addons.mozilla.org/firefox/addon/ublock-origin/",
    "https://addons.mozilla.org/firefox/addon/canvasblocker/",
    "https://addons.mozilla.org/firefox/addon/user-agent-string-switcher/"
)

# ══════════════════════════════════════════════════════════════════
#  安装函数
# ══════════════════════════════════════════════════════════════════

function Install-Extensions {
    param(
        [string]$BrowserName,
        [string]$BrowserPath,
        [array]$Extensions,
        [string]$PreInstallUrl = $null
    )
    
    if (-not (Test-Path $BrowserPath)) {
        Write-Host "`n[跳过] $BrowserName 未安装" -ForegroundColor Yellow
        return
    }
    
    Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  $BrowserName - 打开扩展商店" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    
    # 如果需要预安装（例如 Opera 的 Chrome 扩展支持）
    if ($PreInstallUrl) {
        Write-Host "[1/2] 先安装必要组件..." -ForegroundColor Gray
        Start-Process -FilePath $BrowserPath -ArgumentList $PreInstallUrl
        Write-Host "[!] 请在浏览器中点击 [添加] 安装组件，完成后关闭浏览器" -ForegroundColor Yellow
        Write-Host "[!] 按任意键继续..." -ForegroundColor Yellow
        $null = Read-Host
    }
    
    # 打开所有扩展页面
    Write-Host "[*] 打开 $($Extensions.Count) 个扩展页面..." -ForegroundColor Gray
    Start-Process -FilePath $BrowserPath -ArgumentList $Extensions
    
    Write-Host "[✓] 已打开扩展商店页面" -ForegroundColor Green
    Write-Host "[!] 请在浏览器中点击 [添加] 按钮安装扩展" -ForegroundColor Yellow
}

# ══════════════════════════════════════════════════════════════════
#  主程序
# ══════════════════════════════════════════════════════════════════

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  浏览器扩展官方商店一键安装" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

Write-Host "`n将为以下浏览器安装扩展：" -ForegroundColor White
Write-Host "  ✓ uBlock Origin (广告拦截)" -ForegroundColor Gray
Write-Host "  ✓ Canvas Defender (Canvas 指纹防护)" -ForegroundColor Gray
Write-Host "  ✓ User-Agent Switcher (UA 切换)" -ForegroundColor Gray

Write-Host "`n选择浏览器：" -ForegroundColor White
Write-Host "  1. Chrome" -ForegroundColor Gray
Write-Host "  2. Edge" -ForegroundColor Gray
Write-Host "  3. Brave" -ForegroundColor Gray
Write-Host "  4. Opera" -ForegroundColor Gray
Write-Host "  5. Vivaldi" -ForegroundColor Gray
Write-Host "  6. Firefox" -ForegroundColor Gray
Write-Host "  7. 所有浏览器" -ForegroundColor Gray
Write-Host ""

$choice = Read-Host "请选择 (1-7)"

switch ($choice) {
    "1" { 
        Install-Extensions -BrowserName "Chrome" `
                          -BrowserPath "C:\Program Files\Google\Chrome\Application\chrome.exe" `
                          -Extensions $ChromeExtensions
    }
    "2" { 
        Install-Extensions -BrowserName "Edge" `
                          -BrowserPath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" `
                          -Extensions $EdgeExtensions
    }
    "3" { 
        Install-Extensions -BrowserName "Brave" `
                          -BrowserPath "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe" `
                          -Extensions $BraveExtensions
    }
    "4" { 
        Install-Extensions -BrowserName "Opera" `
                          -BrowserPath "$env:LOCALAPPDATA\Programs\Opera\opera.exe" `
                          -Extensions $OperaExtensions `
                          -PreInstallUrl $OperaChromeSupport
    }
    "5" { 
        Install-Extensions -BrowserName "Vivaldi" `
                          -BrowserPath "$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe" `
                          -Extensions $VivaldiExtensions
    }
    "6" { 
        Install-Extensions -BrowserName "Firefox" `
                          -BrowserPath "C:\Program Files\Mozilla Firefox\firefox.exe" `
                          -Extensions $FirefoxExtensions
    }
    "7" {
        Install-Extensions -BrowserName "Chrome" -BrowserPath "C:\Program Files\Google\Chrome\Application\chrome.exe" -Extensions $ChromeExtensions
        Start-Sleep -Seconds 2
        Install-Extensions -BrowserName "Edge" -BrowserPath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -Extensions $EdgeExtensions
        Start-Sleep -Seconds 2
        Install-Extensions -BrowserName "Brave" -BrowserPath "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe" -Extensions $BraveExtensions
        Start-Sleep -Seconds 2
        Install-Extensions -BrowserName "Opera" -BrowserPath "$env:LOCALAPPDATA\Programs\Opera\opera.exe" -Extensions $OperaExtensions -PreInstallUrl $OperaChromeSupport
        Start-Sleep -Seconds 2
        Install-Extensions -BrowserName "Vivaldi" -BrowserPath "$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe" -Extensions $VivaldiExtensions
        Start-Sleep -Seconds 2
        Install-Extensions -BrowserName "Firefox" -BrowserPath "C:\Program Files\Mozilla Firefox\firefox.exe" -Extensions $FirefoxExtensions
    }
    default { 
        Write-Host "无效选择" -ForegroundColor Red
        exit 1
    }
}

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  完成！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
