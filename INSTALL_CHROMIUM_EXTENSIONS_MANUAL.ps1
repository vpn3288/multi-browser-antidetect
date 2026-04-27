#Requires -RunAsAdministrator

<#
.SYNOPSIS
    为所有 Chromium 系浏览器手动安装扩展
.DESCRIPTION
    下载 CRX 文件并配置浏览器加载扩展
#>

param(
    [string[]]$Browsers = @("Chrome", "Edge", "Brave", "Chromium", "Vivaldi", "Opera")
)

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Chromium 系浏览器扩展手动安装" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# 扩展信息
$extensions = @(
    @{
        Name = "uBlock Origin"
        ID = "cjpalhdlnbpafiamejdnhcphjbkeiagm"
        URL = "https://clients2.google.com/service/update2/crx?response=redirect&prodversion=130.0&acceptformat=crx2,crx3&x=id%3Dcjpalhdlnbpafiamejdnhcphjbkeiagm%26uc"
    },
    @{
        Name = "Privacy Badger"
        ID = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"
        URL = "https://clients2.google.com/service/update2/crx?response=redirect&prodversion=130.0&acceptformat=crx2,crx3&x=id%3Dpkehgijcmpdhfbdbbnkijodmdjhbjlgp%26uc"
    },
    @{
        Name = "HTTPS Everywhere"
        ID = "gcbommkclmclpchllfjekcdonpmejbdp"
        URL = "https://clients2.google.com/service/update2/crx?response=redirect&prodversion=130.0&acceptformat=crx2,crx3&x=id%3Dgcbommkclmclpchllfjekcdonpmejbdp%26uc"
    },
    @{
        Name = "Decentraleyes"
        ID = "ldpochfccmkkmhdbclfhpagapcfdljkj"
        URL = "https://clients2.google.com/service/update2/crx?response=redirect&prodversion=130.0&acceptformat=crx2,crx3&x=id%3Dldpochfccmkkmhdbclfhpagapcfdljkj%26uc"
    }
)

# 浏览器配置
$browserConfigs = @{
    "Chrome" = @{
        ProfilePath = "C:\BrowserProfiles\Chrome"
        ProcessName = "chrome"
    }
    "Edge" = @{
        ProfilePath = "C:\BrowserProfiles\Edge"
        ProcessName = "msedge"
    }
    "Brave" = @{
        ProfilePath = "C:\BrowserProfiles\Brave"
        ProcessName = "brave"
    }
    "Chromium" = @{
        ProfilePath = "C:\BrowserProfiles\Chromium"
        ProcessName = "chrome"
    }
    "Vivaldi" = @{
        ProfilePath = "C:\BrowserProfiles\Vivaldi"
        ProcessName = "vivaldi"
    }
    "Opera" = @{
        ProfilePath = "C:\BrowserProfiles\Opera"
        ProcessName = "opera"
    }
}

# 创建临时目录
$tempDir = "$env:TEMP\ChromiumExtensions"
if (Test-Path $tempDir) {
    Remove-Item $tempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

Write-Host "[1/3] 下载扩展..." -ForegroundColor Yellow
Write-Host ""

$downloadedExtensions = @()

foreach ($ext in $extensions) {
    Write-Host "  下载 $($ext.Name)..." -ForegroundColor White
    $crxPath = Join-Path $tempDir "$($ext.ID).crx"
    
    try {
        # 临时禁用代理下载
        $env:HTTP_PROXY = ""
        $env:HTTPS_PROXY = ""
        
        Invoke-WebRequest -Uri $ext.URL -OutFile $crxPath -UseBasicParsing -ErrorAction Stop
        
        if (Test-Path $crxPath) {
            $fileSize = (Get-Item $crxPath).Length
            if ($fileSize -gt 1KB) {
                Write-Host "    [✓] 已下载 ($([math]::Round($fileSize/1KB, 2)) KB)" -ForegroundColor Green
                $downloadedExtensions += @{
                    Name = $ext.Name
                    ID = $ext.ID
                    Path = $crxPath
                }
            } else {
                Write-Host "    [✗] 下载失败（文件过小）" -ForegroundColor Red
                Remove-Item $crxPath -Force -ErrorAction SilentlyContinue
            }
        } else {
            Write-Host "    [✗] 下载失败" -ForegroundColor Red
        }
    } catch {
        Write-Host "    [✗] 下载失败: $($_.Exception.Message)" -ForegroundColor Red
    }
}

if ($downloadedExtensions.Count -eq 0) {
    Write-Host ""
    Write-Host "[✗] 没有成功下载任何扩展" -ForegroundColor Red
    Write-Host ""
    Write-Host "请手动安装扩展：" -ForegroundColor Yellow
    Write-Host "  1. 启动浏览器" -ForegroundColor White
    Write-Host "  2. 访问 chrome://extensions/" -ForegroundColor White
    Write-Host "  3. 启用 'Developer mode'" -ForegroundColor White
    Write-Host "  4. 从 Chrome Web Store 手动安装扩展" -ForegroundColor White
    exit 1
}

Write-Host ""
Write-Host "[2/3] 为浏览器准备扩展..." -ForegroundColor Yellow
Write-Host ""

$installedCount = 0

foreach ($browserName in $Browsers) {
    if (-not $browserConfigs.ContainsKey($browserName)) {
        continue
    }
    
    $config = $browserConfigs[$browserName]
    $profilePath = $config.ProfilePath
    
    if (-not (Test-Path $profilePath)) {
        Write-Host "  [!] $browserName 配置目录不存在，跳过" -ForegroundColor Yellow
        continue
    }
    
    # 关闭浏览器
    $process = Get-Process $config.ProcessName -ErrorAction SilentlyContinue
    if ($process) {
        Write-Host "  [!] 关闭 $browserName..." -ForegroundColor Yellow
        Stop-Process -Name $config.ProcessName -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    }
    
    # 创建外部扩展目录
    $externalExtDir = Join-Path $profilePath "External Extensions"
    if (-not (Test-Path $externalExtDir)) {
        New-Item -ItemType Directory -Path $externalExtDir -Force | Out-Null
    }
    
    # 复制扩展
    foreach ($ext in $downloadedExtensions) {
        $destPath = Join-Path $externalExtDir "$($ext.ID).crx"
        Copy-Item $ext.Path $destPath -Force
    }
    
    Write-Host "  [✓] $browserName 扩展已准备 ($($downloadedExtensions.Count) 个)" -ForegroundColor Green
    $installedCount++
}

Write-Host ""
Write-Host "[3/3] 配置完成" -ForegroundColor Yellow
Write-Host ""

# 清理临时文件
Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "安装完成！" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "已为 $installedCount 个浏览器准备扩展" -ForegroundColor White
Write-Host ""
Write-Host "下一步操作：" -ForegroundColor Yellow
Write-Host "  1. 启动浏览器" -ForegroundColor White
Write-Host "  2. 访问 chrome://extensions/" -ForegroundColor White
Write-Host "  3. 启用 'Developer mode'" -ForegroundColor White
Write-Host "  4. 点击 'Load unpacked' 或拖拽 .crx 文件" -ForegroundColor White
Write-Host ""
Write-Host "扩展文件位置：" -ForegroundColor Cyan
foreach ($browserName in $Browsers) {
    if ($browserConfigs.ContainsKey($browserName)) {
        $extDir = Join-Path $browserConfigs[$browserName].ProfilePath "External Extensions"
        if (Test-Path $extDir) {
            Write-Host "  $browserName`: $extDir" -ForegroundColor Gray
        }
    }
}
Write-Host ""
Write-Host "注意：企业策略的扩展强制安装可能需要：" -ForegroundColor Yellow
Write-Host "  • 浏览器首次启动时联网" -ForegroundColor White
Write-Host "  • 等待 2-5 分钟自动下载" -ForegroundColor White
Write-Host "  • 代理允许访问 Chrome Web Store" -ForegroundColor White
Write-Host ""
