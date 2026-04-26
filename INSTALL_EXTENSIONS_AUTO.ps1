# ══════════════════════════════════════════════════════════════════
#  浏览器扩展真正自动安装脚本 v3.0
#  原理：启动浏览器时自动打开扩展商店页面，用户一键安装
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

# ══════════════════════════════════════════════════════════════════
#  扩展配置（Chrome Web Store URL）
# ══════════════════════════════════════════════════════════════════

$Extensions = @(
    @{Name="uBlock Origin";        URL="https://chromewebstore.google.com/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm"},
    @{Name="Canvas Defender";      URL="https://chromewebstore.google.com/detail/canvas-defender/obdbgnebcljmgkoljcdddaopadkifnpm"},
    @{Name="WebRTC Leak Shield";   URL="https://chromewebstore.google.com/detail/webrtc-leak-shield/bppamachkoflopbagkdoflbgfjflfnfl"},
    @{Name="User-Agent Switcher";  URL="https://chromewebstore.google.com/detail/user-agent-switcher-and-manager/bhchdcejhohfmigjafbampogmaanbfkg"},
    @{Name="Cookie AutoDelete";    URL="https://chromewebstore.google.com/detail/cookie-autodelete/fhcgjolkccmbidfldomjliifgaodjagh"}
)

# ══════════════════════════════════════════════════════════════════
#  为每个浏览器打开扩展商店
# ══════════════════════════════════════════════════════════════════

function Open-ExtensionsInBrowser {
    param(
        [string]$BrowserPath,
        [string]$BrowserName
    )
    
    if (-not (Test-Path $BrowserPath)) {
        Write-Host "[跳过] $BrowserName 未安装" -ForegroundColor Yellow
        return
    }
    
    Write-Host "`n[*] 启动 $BrowserName 并打开扩展商店..." -ForegroundColor Cyan
    
    # 构建所有扩展URL
    $urls = $Extensions | ForEach-Object { $_.URL }
    
    # 启动浏览器并打开所有扩展页面
    Start-Process -FilePath $BrowserPath -ArgumentList $urls
    
    Write-Host "[✓] 已打开 $($Extensions.Count) 个扩展页面" -ForegroundColor Green
    Write-Host "    请在浏览器中点击 [添加到Chrome/Edge/Brave] 按钮" -ForegroundColor Gray
}

# ══════════════════════════════════════════════════════════════════
#  主执行流程
# ══════════════════════════════════════════════════════════════════

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  浏览器扩展自动安装助手 v3.0" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

Write-Host "`n将为以下浏览器安装扩展：" -ForegroundColor White
$Extensions | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor Gray }

Write-Host "`n按任意键开始..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Chrome
Open-ExtensionsInBrowser -BrowserPath "C:\Program Files\Google\Chrome\Application\chrome.exe" -BrowserName "Chrome"
Start-Sleep -Seconds 3

# Edge
Open-ExtensionsInBrowser -BrowserPath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -BrowserName "Edge"
Start-Sleep -Seconds 3

# Brave
Open-ExtensionsInBrowser -BrowserPath "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe" -BrowserName "Brave"
Start-Sleep -Seconds 3

# Opera
Open-ExtensionsInBrowser -BrowserPath "$env:LOCALAPPDATA\Programs\Opera\opera.exe" -BrowserName "Opera"
Start-Sleep -Seconds 3

# Vivaldi
Open-ExtensionsInBrowser -BrowserPath "$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe" -BrowserName "Vivaldi"

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  所有浏览器已启动！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "`n请在每个浏览器中点击 [添加到浏览器] 按钮完成安装" -ForegroundColor Yellow
