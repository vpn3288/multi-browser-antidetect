#Requires -RunAsAdministrator

# ══════════════════════════════════════════════════════════════════
#  浏览器扩展智能安装脚本 - 混合方案
#  自动安装 + 手动安装 + 替代方案
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  浏览器扩展智能安装脚本" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

# ══════════════════════════════════════════════════════════════════
#  第一步：解除策略限制
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[步骤 1/3] 解除扩展安装策略限制..." -ForegroundColor Cyan

$policyPaths = @(
    "HKLM:\SOFTWARE\Policies\Google\Chrome",
    "HKLM:\SOFTWARE\Policies\Microsoft\Edge",
    "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave",
    "HKLM:\SOFTWARE\Policies\Vivaldi",
    "HKLM:\SOFTWARE\Policies\Opera Software\Opera Stable"
)

foreach ($path in $policyPaths) {
    if (Test-Path $path) {
        $blockKeys = @("ExtensionInstallBlocklist", "ExtensionInstallForcelist", "ExtensionSettings")
        foreach ($key in $blockKeys) {
            if (Get-ItemProperty -Path $path -Name $key -ErrorAction SilentlyContinue) {
                Remove-ItemProperty -Path $path -Name $key -Force -ErrorAction SilentlyContinue
            }
        }
    }
}

Write-Host "[✓] 策略限制已解除" -ForegroundColor Green

# ══════════════════════════════════════════════════════════════════
#  第二步：关闭所有浏览器
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[步骤 2/3] 关闭所有浏览器..." -ForegroundColor Cyan
Get-Process chrome,firefox,msedge,brave,opera,vivaldi -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2
Write-Host "[✓] 浏览器已关闭" -ForegroundColor Green

# ══════════════════════════════════════════════════════════════════
#  第三步：安装扩展
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[步骤 3/3] 安装扩展..." -ForegroundColor Cyan

# Firefox - 自动安装（已验证成功）
Write-Host "`n[Firefox] 自动安装扩展..." -ForegroundColor Gray
if (Test-Path "C:\Program Files\Mozilla Firefox\firefox.exe") {
    $firefoxProfile = Get-ChildItem "$env:APPDATA\Mozilla\Firefox\Profiles\*.default-release" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($firefoxProfile) {
        $extDir = "$($firefoxProfile.FullName)\extensions"
        if (-not (Test-Path $extDir)) { New-Item -ItemType Directory -Path $extDir -Force | Out-Null }
        
        $firefoxExts = @(
            @{Name="uBlock Origin"; URL="https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"},
            @{Name="Canvas Blocker"; URL="https://addons.mozilla.org/firefox/downloads/latest/canvasblocker/latest.xpi"}
        )
        
        foreach ($ext in $firefoxExts) {
            try {
                $xpiFile = "$extDir\$($ext.Name -replace ' ','-').xpi"
                Invoke-WebRequest -Uri $ext.URL -OutFile $xpiFile -UseBasicParsing -TimeoutSec 30
                Write-Host "  [✓] $($ext.Name)" -ForegroundColor Green
            } catch {
                Write-Host "  [✗] $($ext.Name): $_" -ForegroundColor Red
            }
        }
    }
}

# Chrome/Edge/Brave/Vivaldi/Opera - 打开商店页面（手动安装）
Write-Host "`n[其他浏览器] 打开扩展商店页面（需手动点击安装）..." -ForegroundColor Gray

$browsers = @(
    @{
        Name="Chrome"
        Path="C:\Program Files\Google\Chrome\Application\chrome.exe"
        URLs=@(
            "https://chromewebstore.google.com/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm",
            "https://chromewebstore.google.com/detail/canvas-defender/obdbgnebcljmgkoljcdddaopadkifnpm"
        )
    },
    @{
        Name="Edge"
        Path="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
        URLs=@(
            "https://microsoftedge.microsoft.com/addons/detail/ublock-origin/odfafepnkmbhccpbejgmiehpchacaeak",
            "https://microsoftedge.microsoft.com/addons/detail/canvas-fingerprint-defend/giglaifdfkimffokoomllcpmdjeomckf"
        )
    },
    @{
        Name="Brave"
        Path="C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
        URLs=@(
            "https://chromewebstore.google.com/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm",
            "https://chromewebstore.google.com/detail/canvas-defender/obdbgnebcljmgkoljcdddaopadkifnpm"
        )
    },
    @{
        Name="Opera"
        Path="$env:LOCALAPPDATA\Programs\Opera\opera.exe"
        URLs=@(
            "https://addons.opera.com/extensions/details/ublock/",
            "https://addons.opera.com/extensions/details/install-chrome-extensions/"
        )
    },
    @{
        Name="Vivaldi"
        Path="$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe"
        URLs=@(
            "https://chromewebstore.google.com/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm",
            "https://chromewebstore.google.com/detail/canvas-defender/obdbgnebcljmgkoljcdddaopadkifnpm"
        )
    }
)

foreach ($browser in $browsers) {
    if (Test-Path $browser.Path) {
        Write-Host "  [*] 启动 $($browser.Name)..." -ForegroundColor Gray
        Start-Process -FilePath $browser.Path -ArgumentList $browser.URLs
        Start-Sleep -Seconds 2
    }
}

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  完成！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green

Write-Host "`n[Firefox] 扩展已自动安装，重启浏览器即可使用" -ForegroundColor Yellow
Write-Host "[其他浏览器] 请在打开的商店页面中点击 [添加] 按钮" -ForegroundColor Yellow
