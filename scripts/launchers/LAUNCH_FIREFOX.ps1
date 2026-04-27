# Firefox 启动脚本 - 带代理配置
# 使用方法: .\LAUNCH_FIREFOX.ps1 -ProfileName "default-release" -ProxyPort 7890

param(
    [string]$ProfileName = "default-release",
    [int]$ProxyPort = 7890
)

$FirefoxPath = "C:\Program Files\Mozilla Firefox\firefox.exe"

# 配置代理环境变量（Firefox 会读取系统代理）
$env:HTTP_PROXY = "socks5://127.0.0.1:$ProxyPort"
$env:HTTPS_PROXY = "socks5://127.0.0.1:$ProxyPort"

# 启动参数
$LaunchArgs = @(
    "-P", $ProfileName
    "-no-remote"
)

Write-Host "启动 Firefox - $ProfileName (代理端口: $ProxyPort)" -ForegroundColor Cyan

# 复制 user.js 到配置文件目录（如果存在模板）
$UserJsTemplate = "C:\Program Files\Mozilla Firefox\distribution\user.js.template"
$ProfilePath = "$env:APPDATA\Mozilla\Firefox\Profiles"

if (Test-Path $UserJsTemplate) {
    $Profiles = Get-ChildItem -Path $ProfilePath -Directory | Where-Object { $_.Name -like "*$ProfileName*" }
    if ($Profiles) {
        $TargetProfile = $Profiles[0].FullName
        $UserJsPath = "$TargetProfile\user.js"
        
        if (-not (Test-Path $UserJsPath)) {
            Copy-Item -Path $UserJsTemplate -Destination $UserJsPath -Force
            Write-Host "[✓] 已复制 user.js 到配置文件目录" -ForegroundColor Green
        }
    }
}

Start-Process -FilePath $FirefoxPath -ArgumentList $LaunchArgs

Write-Host "[✓] Firefox 已启动" -ForegroundColor Green
Write-Host "    配置文件: $ProfileName" -ForegroundColor Gray
Write-Host "    代理: socks5://127.0.0.1:$ProxyPort" -ForegroundColor Gray
Write-Host ""
Write-Host "验证配置：" -ForegroundColor Yellow
Write-Host "  1. 访问 about:policies 查看企业策略" -ForegroundColor White
Write-Host "  2. 访问 about:config 查看高级配置" -ForegroundColor White
Write-Host "  3. 访问 about:addons 查看扩展" -ForegroundColor White
