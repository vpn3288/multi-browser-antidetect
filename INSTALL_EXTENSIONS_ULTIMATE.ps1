#Requires -RunAsAdministrator

# ══════════════════════════════════════════════════════════════════
#  终极扩展安装脚本 v4.0
#  整合所有浏览器的最佳安装方案
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

# ══════════════════════════════════════════════════════════════════
#  扩展配置
# ══════════════════════════════════════════════════════════════════

$Extensions = @(
    @{Name="uBlock Origin";        ID="cjpalhdlnbpafiamejdnhcphjbkeiagm"},
    @{Name="Canvas Defender";      ID="obdbgnebcljmgkoljcdddaopadkifnpm"},
    @{Name="WebRTC Leak Shield";   ID="bppamachkoflopbagkdoflbgfjflfnfl"},
    @{Name="User-Agent Switcher";  ID="bhchdcejhohfmigjafbampogmaanbfkg"},
    @{Name="Cookie AutoDelete";    ID="fhcgjolkccmbidfldomjliifgaodjagh"}
)

# ══════════════════════════════════════════════════════════════════
#  通过注册表强制安装扩展（Chromium 系浏览器）
# ══════════════════════════════════════════════════════════════════

function Install-ExtensionsViaRegistry {
    param(
        [string]$BrowserName,
        [string]$RegistryPath
    )
    
    Write-Host "`n[*] 配置 $BrowserName 扩展（注册表方式）..." -ForegroundColor Cyan
    
    # 创建 ExtensionInstallForcelist 路径
    $forcelistPath = "$RegistryPath\ExtensionInstallForcelist"
    if (-not (Test-Path $forcelistPath)) {
        New-Item -Path $forcelistPath -Force | Out-Null
    }
    
    $index = 1
    foreach ($ext in $Extensions) {
        try {
            # 格式：扩展ID;更新URL
            $value = "$($ext.ID);https://clients2.google.com/service/update2/crx"
            Set-ItemProperty -Path $forcelistPath -Name $index -Value $value -Type String -Force
            Write-Host "  [✓] $($ext.Name)" -ForegroundColor Green
            $index++
        } catch {
            Write-Host "  [✗] $($ext.Name): $_" -ForegroundColor Red
        }
    }
}

# ══════════════════════════════════════════════════════════════════
#  Opera 特殊处理：先安装 Chrome 扩展支持
# ══════════════════════════════════════════════════════════════════

function Install-OperaExtensions {
    Write-Host "`n[*] 配置 Opera 扩展..." -ForegroundColor Cyan
    
    $operaPath = "$env:LOCALAPPDATA\Programs\Opera\opera.exe"
    if (-not (Test-Path $operaPath)) {
        Write-Host "  [!] Opera 未安装" -ForegroundColor Yellow
        return
    }
    
    Write-Host "  [1/2] 安装 Chrome 扩展支持..." -ForegroundColor Gray
    $chromeExtSupport = "https://addons.opera.com/extensions/details/install-chrome-extensions/"
    Start-Process -FilePath $operaPath -ArgumentList $chromeExtSupport
    
    Write-Host "  [!] 请在 Opera 中点击 [添加到Opera] 安装 Chrome 扩展支持" -ForegroundColor Yellow
    Write-Host "  [!] 安装完成后按任意键继续..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    
    Write-Host "  [2/2] 打开扩展商店..." -ForegroundColor Gray
    $urls = $Extensions | ForEach-Object { "https://chromewebstore.google.com/detail/$($_.ID)" }
    Start-Process -FilePath $operaPath -ArgumentList $urls
    
    Write-Host "  [✓] 已打开 $($Extensions.Count) 个扩展页面" -ForegroundColor Green
    Write-Host "  [!] 请在 Opera 中点击 [添加到Opera] 安装扩展" -ForegroundColor Yellow
}

# ══════════════════════════════════════════════════════════════════
#  Edge 特殊处理：使用 Microsoft Edge Add-ons
# ══════════════════════════════════════════════════════════════════

function Install-EdgeExtensions {
    Write-Host "`n[*] 配置 Edge 扩展..." -ForegroundColor Cyan
    
    $edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    if (-not (Test-Path $edgePath)) {
        Write-Host "  [!] Edge 未安装" -ForegroundColor Yellow
        return
    }
    
    # Edge 扩展映射（Microsoft Edge Add-ons）
    $edgeExtensions = @(
        "https://microsoftedge.microsoft.com/addons/detail/odfafepnkmbhccpbejgmiehpchacaeak",  # uBlock Origin
        "https://microsoftedge.microsoft.com/addons/detail/odefjbdlpbngmhgkbkdkbdgbdpjjfhcp",  # Canvas Defender
        "https://microsoftedge.microsoft.com/addons/detail/cnjkedgepfdpdbnepgmajmmjdjkjnifa"   # User-Agent Switcher
    )
    
    Start-Process -FilePath $edgePath -ArgumentList $edgeExtensions
    
    Write-Host "  [✓] 已打开 $($edgeExtensions.Count) 个扩展页面" -ForegroundColor Green
    Write-Host "  [!] 请在 Edge 中点击 [获取] 安装扩展" -ForegroundColor Yellow
}

# ══════════════════════════════════════════════════════════════════
#  主执行流程
# ══════════════════════════════════════════════════════════════════

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  终极扩展安装脚本 v4.0" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

Write-Host "`n将为以下浏览器安装扩展：" -ForegroundColor White
$Extensions | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor Gray }

Write-Host "`n[*] 关闭所有浏览器进程..." -ForegroundColor Yellow
Get-Process chrome,firefox,msedge,brave,opera,vivaldi -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

# Chrome（注册表强制安装）
if (Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe") {
    Install-ExtensionsViaRegistry -BrowserName "Chrome" -RegistryPath "HKLM:\SOFTWARE\Policies\Google\Chrome"
}

# Brave（注册表强制安装）
if (Test-Path "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe") {
    Install-ExtensionsViaRegistry -BrowserName "Brave" -RegistryPath "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"
}

# Vivaldi（注册表强制安装）
if (Test-Path "$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe") {
    Install-ExtensionsViaRegistry -BrowserName "Vivaldi" -RegistryPath "HKLM:\SOFTWARE\Policies\Vivaldi"
}

# Edge（Microsoft Edge Add-ons）
Install-EdgeExtensions

# Opera（Chrome Web Store + 扩展支持）
Install-OperaExtensions

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  配置完成！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "`n[!] 重启浏览器后扩展将自动加载" -ForegroundColor Yellow
Write-Host "    Chrome/Brave/Vivaldi: 扩展会自动安装（注册表强制）" -ForegroundColor Gray
Write-Host "    Edge/Opera: 需要手动点击安装按钮" -ForegroundColor Gray
