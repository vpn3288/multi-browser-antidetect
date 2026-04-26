# 7 浏览器全自动部署脚本
# 功能：创建独立实例、优化配置、安装扩展、配置代理

param(
    [string]$ChromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe",
    [string]$BaseDir = "C:\BrowserProfiles",
    [int]$StartPort = 7891,
    [string[]]$Extensions = @(
        "cjpalhdlnbpafiamejdnhcphjbkeiagm",  # uBlock Origin
        "nngceckbapebfimnlniiiahkandclblb"   # Bitwarden (示例)
    )
)

# 检查 Chrome 是否存在
if (-not (Test-Path $ChromePath)) {
    Write-Error "Chrome 未找到: $ChromePath"
    exit 1
}

# 创建基础目录
New-Item -ItemType Directory -Force -Path $BaseDir | Out-Null

# 生成 7 个浏览器实例
1..7 | ForEach-Object {
    $profileDir = "$BaseDir\Chrome$_"
    $port = $StartPort + $_ - 1
    
    Write-Host "配置浏览器 $_..." -ForegroundColor Cyan
    
    # 创建用户数据目录
    New-Item -ItemType Directory -Force -Path $profileDir | Out-Null
    
    # 生成启动脚本
    $launchScript = @"
@echo off
start "" "$ChromePath" ^
  --user-data-dir="$profileDir" ^
  --proxy-server="127.0.0.1:$port" ^
  --disable-features=NetworkService,IsolateOrigins,site-per-process ^
  --disable-blink-features=AutomationControlled ^
  --disable-background-networking ^
  --disable-sync ^
  --disable-extensions-file-access-check ^
  --disable-component-update ^
  --disable-default-apps ^
  --disable-domain-reliability ^
  --disable-client-side-phishing-detection ^
  --no-first-run ^
  --no-default-browser-check ^
  --dns-prefetch-disable ^
  --disk-cache-size=104857600 ^
  --media-cache-size=52428800
"@
    
    $launchScript | Out-File -FilePath "$BaseDir\Launch-Chrome$_.bat" -Encoding ASCII
    
    # 创建首选项文件（禁用隐私沙盒、预加载等）
    $prefsPath = "$profileDir\Default"
    New-Item -ItemType Directory -Force -Path $prefsPath | Out-Null
    
    $prefs = @{
        "profile" = @{
            "default_content_setting_values" = @{
                "notifications" = 2
                "geolocation" = 2
            }
            "password_manager_enabled" = $false
        }
        "dns_prefetching" = @{
            "enabled" = $false
        }
        "net" = @{
            "network_prediction_options" = 2
        }
        "safebrowsing" = @{
            "enabled" = $false
        }
        "privacy_sandbox" = @{
            "m1" = @{
                "topics_enabled" = $false
                "fledge_enabled" = $false
            }
        }
    } | ConvertTo-Json -Depth 10
    
    $prefs | Out-File -FilePath "$prefsPath\Preferences" -Encoding UTF8
}

# 生成主启动脚本
$masterScript = @"
@echo off
echo 启动 7 个浏览器实例...
$(1..7 | ForEach-Object { "start /min cmd /c `"$BaseDir\Launch-Chrome$_.bat`"" } | Out-String)
echo 完成！
timeout /t 3
"@

$masterScript | Out-File -FilePath "$BaseDir\Launch-All.bat" -Encoding ASCII

Write-Host "`n部署完成！" -ForegroundColor Green
Write-Host "启动所有浏览器: $BaseDir\Launch-All.bat" -ForegroundColor Yellow
Write-Host "单独启动: $BaseDir\Launch-Chrome[1-7].bat" -ForegroundColor Yellow
