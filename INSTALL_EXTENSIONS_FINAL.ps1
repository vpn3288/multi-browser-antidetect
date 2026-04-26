# ══════════════════════════════════════════════════════════════════
#  浏览器扩展自动安装脚本 v2.0 (配置文件方式，100%无需权限)
#  原理：直接修改浏览器User Data目录的Preferences文件
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

# ══════════════════════════════════════════════════════════════════
#  扩展配置
# ══════════════════════════════════════════════════════════════════

$ChromiumExtensions = @(
    @{Name="uBlock Origin";        ID="cjpalhdlnbpafiamejdnhcphjbkeiagm"},
    @{Name="Canvas Defender";      ID="obdbgnebcljmgkoljcdddaopadkifnpm"},
    @{Name="WebRTC Leak Shield";   ID="bppamachkoflopbagkdoflbgfjflfnfl"},
    @{Name="User-Agent Switcher";  ID="djflhoibgkdhkhhcedjiklpkjnoahfmg"},
    @{Name="Cookie AutoDelete";    ID="fhcgjolkccmbidfldomjliifgaodjagh"}
)

# ══════════════════════════════════════════════════════════════════
#  Chromium 系浏览器扩展安装（配置文件方式）
# ══════════════════════════════════════════════════════════════════

function Install-ChromiumExtensionsToProfile {
    param(
        [string]$ProfilePath,
        [string]$BrowserName
    )
    
    if (-not (Test-Path $ProfilePath)) {
        Write-Host "  [!] 配置目录不存在: $ProfilePath" -ForegroundColor Yellow
        return
    }
    
    Write-Host "`n[*] 配置 $BrowserName 扩展..." -ForegroundColor Cyan
    
    # 查找所有Profile目录
    $profiles = @("Default") + (Get-ChildItem -Path $ProfilePath -Directory | Where-Object { $_.Name -match "^Profile \d+$" } | Select-Object -ExpandProperty Name)
    
    foreach ($profile in $profiles) {
        $prefPath = Join-Path $ProfilePath "$profile\Preferences"
        
        if (-not (Test-Path $prefPath)) {
            Write-Host "  [!] 跳过 $profile (未初始化)" -ForegroundColor Gray
            continue
        }
        
        try {
            # 读取Preferences文件
            $prefs = Get-Content $prefPath -Raw | ConvertFrom-Json
            
            # 确保extensions节点存在
            if (-not $prefs.extensions) {
                $prefs | Add-Member -MemberType NoteProperty -Name "extensions" -Value @{} -Force
            }
            if (-not $prefs.extensions.settings) {
                $prefs.extensions | Add-Member -MemberType NoteProperty -Name "settings" -Value @{} -Force
            }
            
            # 添加扩展
            foreach ($ext in $ChromiumExtensions) {
                $extSettings = @{
                    "state" = 1
                    "path" = $ext.ID
                    "manifest" = @{
                        "name" = $ext.Name
                        "update_url" = "https://clients2.google.com/service/update2/crx"
                    }
                }
                
                $prefs.extensions.settings | Add-Member -MemberType NoteProperty -Name $ext.ID -Value $extSettings -Force
            }
            
            # 写回文件
            $prefs | ConvertTo-Json -Depth 10 | Set-Content $prefPath -Encoding UTF8
            
            Write-Host "  [✓] $profile ($($ChromiumExtensions.Count) 个扩展)" -ForegroundColor Green
            
        } catch {
            Write-Host "  [✗] $profile : $_" -ForegroundColor Red
        }
    }
}

# ══════════════════════════════════════════════════════════════════
#  Firefox 扩展安装
# ══════════════════════════════════════════════════════════════════

function Install-FirefoxExtensions {
    Write-Host "`n[*] 配置 Firefox 扩展..." -ForegroundColor Cyan
    
    $firefoxProfilePath = "$env:APPDATA\Mozilla\Firefox\Profiles"
    
    if (-not (Test-Path $firefoxProfilePath)) {
        Write-Host "  [!] Firefox 未安装" -ForegroundColor Yellow
        return
    }
    
    $profiles = Get-ChildItem -Path $firefoxProfilePath -Directory
    
    foreach ($profile in $profiles) {
        $extensionsDir = Join-Path $profile.FullName "extensions"
        if (-not (Test-Path $extensionsDir)) {
            New-Item -ItemType Directory -Path $extensionsDir -Force | Out-Null
        }
        
        # 创建扩展配置文件
        $extensionsJson = @{
            "addons" = @(
                @{
                    "id" = "uBlock0@raymondhill.net"
                    "syncGUID" = "{$(New-Guid)}"
                },
                @{
                    "id" = "CanvasBlocker@kkapsner.de"
                    "syncGUID" = "{$(New-Guid)}"
                }
            )
        }
        
        $extensionsJsonPath = Join-Path $profile.FullName "extensions.json"
        $extensionsJson | ConvertTo-Json -Depth 5 | Set-Content $extensionsJsonPath -Encoding UTF8
        
        Write-Host "  [✓] $($profile.Name)" -ForegroundColor Green
    }
}

# ══════════════════════════════════════════════════════════════════
#  主执行流程
# ══════════════════════════════════════════════════════════════════

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  浏览器扩展自动安装脚本 v2.0" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

# 关闭所有浏览器
Write-Host "`n[*] 关闭所有浏览器进程..." -ForegroundColor Yellow
Get-Process chrome,firefox,msedge,brave,opera,vivaldi -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

# Chrome
$chromePath = "$env:LOCALAPPDATA\Google\Chrome\User Data"
if (Test-Path $chromePath) {
    Install-ChromiumExtensionsToProfile -ProfilePath $chromePath -BrowserName "Chrome"
}

# Edge
$edgePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"
if (Test-Path $edgePath) {
    Install-ChromiumExtensionsToProfile -ProfilePath $edgePath -BrowserName "Edge"
}

# Brave
$bravePath = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data"
if (Test-Path $bravePath) {
    Install-ChromiumExtensionsToProfile -ProfilePath $bravePath -BrowserName "Brave"
}

# Opera
$operaPath = "$env:APPDATA\Opera Software\Opera Stable"
if (Test-Path $operaPath) {
    Install-ChromiumExtensionsToProfile -ProfilePath $operaPath -BrowserName "Opera"
}

# Vivaldi
$vivaldiPath = "$env:LOCALAPPDATA\Vivaldi\User Data"
if (Test-Path $vivaldiPath) {
    Install-ChromiumExtensionsToProfile -ProfilePath $vivaldiPath -BrowserName "Vivaldi"
}

# Firefox
Install-FirefoxExtensions

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  扩展配置完成！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "`n[!] 重要：首次启动浏览器时，需要手动访问扩展商店确认安装" -ForegroundColor Yellow
Write-Host "    Chrome: chrome://extensions/" -ForegroundColor Gray
Write-Host "    Edge:   edge://extensions/" -ForegroundColor Gray
Write-Host "    Brave:  brave://extensions/" -ForegroundColor Gray
