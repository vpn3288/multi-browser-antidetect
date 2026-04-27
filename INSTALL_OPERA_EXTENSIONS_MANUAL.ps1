#Requires -RunAsAdministrator

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Opera 扩展手动安装脚本" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# 确保 Opera 已关闭
$operaProcess = Get-Process "opera" -ErrorAction SilentlyContinue
if ($operaProcess) {
    Write-Host "[!] 正在关闭 Opera..." -ForegroundColor Yellow
    Stop-Process -Name "opera" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 3
}

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

# 创建临时目录
$tempDir = "$env:TEMP\OperaExtensions"
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
            Write-Host "    [✓] 已下载 ($([math]::Round($fileSize/1KB, 2)) KB)" -ForegroundColor Green
            $downloadedExtensions += @{
                Name = $ext.Name
                ID = $ext.ID
                Path = $crxPath
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
    Write-Host "可能的原因：" -ForegroundColor Yellow
    Write-Host "  1. 网络连接问题" -ForegroundColor White
    Write-Host "  2. Chrome Web Store 访问受限" -ForegroundColor White
    Write-Host ""
    Write-Host "手动安装方法：" -ForegroundColor Cyan
    Write-Host "  1. 启动 Opera" -ForegroundColor White
    Write-Host "  2. 访问 opera://extensions/" -ForegroundColor White
    Write-Host "  3. 启用右上角的 'Install Chrome Extensions'" -ForegroundColor White
    Write-Host "  4. 访问 Chrome Web Store 手动安装以下扩展：" -ForegroundColor White
    foreach ($ext in $extensions) {
        Write-Host "     • $($ext.Name): https://chrome.google.com/webstore/detail/$($ext.ID)" -ForegroundColor Gray
    }
    exit 1
}

Write-Host ""
Write-Host "[2/3] 准备安装扩展..." -ForegroundColor Yellow
Write-Host ""

# 创建扩展安装目录
$profilePath = "C:\BrowserProfiles\Opera"
$extensionsDir = Join-Path $profilePath "External Extensions"

if (-not (Test-Path $extensionsDir)) {
    New-Item -ItemType Directory -Path $extensionsDir -Force | Out-Null
}

# 复制扩展到外部扩展目录
foreach ($ext in $downloadedExtensions) {
    $destPath = Join-Path $extensionsDir "$($ext.ID).crx"
    Copy-Item $ext.Path $destPath -Force
    Write-Host "  [✓] $($ext.Name) 已准备" -ForegroundColor Green
}

Write-Host ""
Write-Host "[3/3] 配置 Opera 加载外部扩展..." -ForegroundColor Yellow

# 创建 Preferences 文件配置外部扩展
$prefsPath = Join-Path $profilePath "Default\Preferences"
$prefsDir = Split-Path $prefsPath

if (-not (Test-Path $prefsDir)) {
    New-Item -ItemType Directory -Path $prefsDir -Force | Out-Null
}

# 构建扩展设置
$extSettings = @{}
foreach ($ext in $downloadedExtensions) {
    $extSettings[$ext.ID] = @{
        "external_crx" = (Join-Path $extensionsDir "$($ext.ID).crx")
        "external_version" = "1.0"
    }
}

$prefs = @{
    "extensions" = @{
        "settings" = $extSettings
    }
}

$prefsJson = $prefs | ConvertTo-Json -Depth 10
$prefsJson | Out-File -FilePath $prefsPath -Encoding UTF8 -Force

Write-Host "  [✓] 配置已更新" -ForegroundColor Green

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "准备完成！" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步操作：" -ForegroundColor Yellow
Write-Host "  1. 运行 .\LAUNCH_OPERA.ps1 启动 Opera" -ForegroundColor White
Write-Host "  2. 访问 opera://extensions/" -ForegroundColor White
Write-Host "  3. 如果扩展未自动加载，请：" -ForegroundColor White
Write-Host "     a. 启用 'Developer mode'" -ForegroundColor Gray
Write-Host "     b. 点击 'Load unpacked' 或拖拽 .crx 文件到页面" -ForegroundColor Gray
Write-Host ""
Write-Host "扩展文件位置: $extensionsDir" -ForegroundColor Cyan
Write-Host ""

# 清理临时文件
Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
