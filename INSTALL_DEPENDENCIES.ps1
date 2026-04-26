#Requires -RunAsAdministrator

# ══════════════════════════════════════════════════════════════════
#  安装所有必需的依赖
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Continue"

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  安装所有必需的依赖" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

# ══════════════════════════════════════════════════════════════════
#  1. 安装 winget (Windows Package Manager)
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[1/3] 检查 winget..." -ForegroundColor Cyan

try {
    $wingetVersion = winget --version
    Write-Host "[✓] winget 已安装: $wingetVersion" -ForegroundColor Green
} catch {
    Write-Host "[*] 正在安装 winget..." -ForegroundColor Yellow
    
    # 下载并安装 App Installer (包含 winget)
    $progressPreference = 'silentlyContinue'
    
    # 安装 VCLibs
    Write-Host "  [*] 安装 VCLibs..." -ForegroundColor Gray
    $vcLibsUrl = "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"
    $vcLibsPath = "$env:TEMP\VCLibs.appx"
    Invoke-WebRequest -Uri $vcLibsUrl -OutFile $vcLibsPath -UseBasicParsing
    Add-AppxPackage -Path $vcLibsPath -ErrorAction SilentlyContinue
    
    # 安装 UI.Xaml
    Write-Host "  [*] 安装 UI.Xaml..." -ForegroundColor Gray
    $uiXamlUrl = "https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx"
    $uiXamlPath = "$env:TEMP\UIXaml.appx"
    Invoke-WebRequest -Uri $uiXamlUrl -OutFile $uiXamlPath -UseBasicParsing
    Add-AppxPackage -Path $uiXamlPath -ErrorAction SilentlyContinue
    
    # 安装 App Installer (winget)
    Write-Host "  [*] 安装 App Installer (winget)..." -ForegroundColor Gray
    $appInstallerUrl = "https://aka.ms/getwinget"
    $appInstallerPath = "$env:TEMP\AppInstaller.msixbundle"
    Invoke-WebRequest -Uri $appInstallerUrl -OutFile $appInstallerPath -UseBasicParsing
    Add-AppxPackage -Path $appInstallerPath -ErrorAction SilentlyContinue
    
    # 清理临时文件
    Remove-Item $vcLibsPath, $uiXamlPath, $appInstallerPath -Force -ErrorAction SilentlyContinue
    
    Write-Host "[✓] winget 安装完成" -ForegroundColor Green
    Write-Host "[!] 请重启 PowerShell 后再运行部署脚本" -ForegroundColor Yellow
}

# ══════════════════════════════════════════════════════════════════
#  2. 安装 Git
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[2/3] 检查 Git..." -ForegroundColor Cyan

try {
    $gitVersion = git --version
    Write-Host "[✓] Git 已安装: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "[*] 正在安装 Git..." -ForegroundColor Yellow
    
    try {
        # 尝试使用 winget 安装
        winget install --id Git.Git -e --silent --accept-package-agreements --accept-source-agreements
        Write-Host "[✓] Git 安装完成" -ForegroundColor Green
        Write-Host "[!] 请重启 PowerShell 后 Git 才能使用" -ForegroundColor Yellow
    } catch {
        # 如果 winget 失败，使用直接下载
        Write-Host "  [*] winget 不可用，使用直接下载..." -ForegroundColor Gray
        $gitUrl = "https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe"
        $gitInstaller = "$env:TEMP\GitInstaller.exe"
        
        Invoke-WebRequest -Uri $gitUrl -OutFile $gitInstaller -UseBasicParsing
        Start-Process -FilePath $gitInstaller -ArgumentList "/VERYSILENT /NORESTART" -Wait
        Remove-Item $gitInstaller -Force -ErrorAction SilentlyContinue
        
        Write-Host "[✓] Git 安装完成" -ForegroundColor Green
        Write-Host "[!] 请重启 PowerShell 后 Git 才能使用" -ForegroundColor Yellow
    }
}

# ══════════════════════════════════════════════════════════════════
#  3. 检查 PowerShell 版本
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[3/3] 检查 PowerShell 版本..." -ForegroundColor Cyan

$psVersion = $PSVersionTable.PSVersion
Write-Host "[✓] PowerShell 版本: $psVersion" -ForegroundColor Green

if ($psVersion.Major -lt 5) {
    Write-Host "[!] 建议升级到 PowerShell 5.1 或更高版本" -ForegroundColor Yellow
    Write-Host "    下载地址: https://aka.ms/powershell" -ForegroundColor Gray
}

# ══════════════════════════════════════════════════════════════════
#  完成
# ══════════════════════════════════════════════════════════════════

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  依赖安装完成！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green

Write-Host "`n下一步:" -ForegroundColor Yellow
Write-Host "  1. 重启 PowerShell（以管理员身份）" -ForegroundColor Gray
Write-Host "  2. 运行: .\DEPLOY_8_BROWSERS.ps1" -ForegroundColor Gray
Write-Host "`n按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
