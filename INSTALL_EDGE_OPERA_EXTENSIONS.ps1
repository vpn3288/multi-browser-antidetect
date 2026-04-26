# Edge 和 Opera 扩展专用安装脚本
# 使用各自的扩展商店和安装机制

$ErrorActionPreference = "Stop"

# ══════════════════════════════════════════════════════════════════
#  Edge 扩展（Microsoft Edge Add-ons）
# ══════════════════════════════════════════════════════════════════

$EdgeExtensions = @(
    @{Name="uBlock Origin";        URL="https://microsoftedge.microsoft.com/addons/detail/ublock-origin/odfafepnkmbhccpbejgmiehpchacaeak"},
    @{Name="Canvas Defender";      URL="https://microsoftedge.microsoft.com/addons/detail/canvas-defender/odefjbdlpbngmhgkbkdkbdgbdpjjfhcp"},
    @{Name="User-Agent Switcher";  URL="https://microsoftedge.microsoft.com/addons/detail/user-agent-switcher-and-manager/cnjkedgepfdpdbnepgmajmmjdjkjnifa"}
)

# ══════════════════════════════════════════════════════════════════
#  Opera 扩展（Opera Add-ons + Chrome Web Store）
# ══════════════════════════════════════════════════════════════════

$OperaExtensions = @(
    @{Name="uBlock Origin";        URL="https://addons.opera.com/extensions/details/ublock/"},
    @{Name="Canvas Defender";      URL="https://chromewebstore.google.com/detail/canvas-defender/obdbgnebcljmgkoljcdddaopadkifnpm"},
    @{Name="User-Agent Switcher";  URL="https://addons.opera.com/extensions/details/user-agent-switcher/"}
)

# ══════════════════════════════════════════════════════════════════
#  安装 Edge 扩展
# ══════════════════════════════════════════════════════════════════

function Install-EdgeExtensions {
    $edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    
    if (-not (Test-Path $edgePath)) {
        Write-Host "[!] Edge 未安装" -ForegroundColor Yellow
        return
    }
    
    Write-Host "`n[*] 启动 Edge 并打开扩展商店..." -ForegroundColor Cyan
    Write-Host "    Edge 使用 Microsoft Edge Add-ons 商店" -ForegroundColor Gray
    
    $urls = $EdgeExtensions | ForEach-Object { $_.URL }
    Start-Process -FilePath $edgePath -ArgumentList $urls
    
    Write-Host "[✓] 已打开 $($EdgeExtensions.Count) 个扩展页面" -ForegroundColor Green
    Write-Host "    请点击 [获取] 按钮安装扩展" -ForegroundColor Yellow
}

# ══════════════════════════════════════════════════════════════════
#  安装 Opera 扩展
# ══════════════════════════════════════════════════════════════════

function Install-OperaExtensions {
    $operaPath = "$env:LOCALAPPDATA\Programs\Opera\opera.exe"
    
    if (-not (Test-Path $operaPath)) {
        Write-Host "[!] Opera 未安装" -ForegroundColor Yellow
        return
    }
    
    Write-Host "`n[*] 启动 Opera 并打开扩展商店..." -ForegroundColor Cyan
    Write-Host "    Opera 支持自己的商店 + Chrome Web Store" -ForegroundColor Gray
    
    # 先启用 Chrome Web Store 支持
    Write-Host "    [提示] 如果 Chrome Web Store 扩展无法安装，请先访问：" -ForegroundColor Yellow
    Write-Host "           https://addons.opera.com/extensions/details/install-chrome-extensions/" -ForegroundColor Gray
    
    $urls = $OperaExtensions | ForEach-Object { $_.URL }
    Start-Process -FilePath $operaPath -ArgumentList $urls
    
    Write-Host "[✓] 已打开 $($OperaExtensions.Count) 个扩展页面" -ForegroundColor Green
    Write-Host "    请点击 [添加到Opera] 按钮安装扩展" -ForegroundColor Yellow
}

# ══════════════════════════════════════════════════════════════════
#  主执行流程
# ══════════════════════════════════════════════════════════════════

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Edge 和 Opera 扩展专用安装脚本" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

Write-Host "`n选择要安装的浏览器：" -ForegroundColor White
Write-Host "  1. Edge" -ForegroundColor Gray
Write-Host "  2. Opera" -ForegroundColor Gray
Write-Host "  3. 两者都安装" -ForegroundColor Gray
Write-Host ""

$choice = Read-Host "请选择 (1-3)"

switch ($choice) {
    "1" { Install-EdgeExtensions }
    "2" { Install-OperaExtensions }
    "3" { 
        Install-EdgeExtensions
        Start-Sleep -Seconds 3
        Install-OperaExtensions
    }
    default { Write-Host "无效选择" -ForegroundColor Red }
}

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  完成！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
