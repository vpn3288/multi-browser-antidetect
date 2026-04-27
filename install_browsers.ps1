#Requires -RunAsAdministrator

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Browser Installation Script v2.0" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$downloadDir = "C:\BrowserInstallers"
if (-not (Test-Path $downloadDir)) {
    New-Item -ItemType Directory -Path $downloadDir -Force | Out-Null
}

# Chrome
Write-Host "[1/8] Chrome" -ForegroundColor Yellow
$chromeUrl = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
$chromeInstaller = "$downloadDir\chrome_installer.exe"
if (-not (Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe")) {
    Invoke-WebRequest -Uri $chromeUrl -OutFile $chromeInstaller -UseBasicParsing
    Start-Process -FilePath $chromeInstaller -ArgumentList "/silent /install" -Wait
    Write-Host "  Installed" -ForegroundColor Green
} else {
    Write-Host "  Already installed" -ForegroundColor Green
}

# Edge
Write-Host "[2/8] Edge" -ForegroundColor Yellow
if (Test-Path "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe") {
    Write-Host "  Already installed" -ForegroundColor Green
} else {
    Write-Host "  Edge is pre-installed on Windows 11" -ForegroundColor Green
}

# Brave
Write-Host "[3/8] Brave" -ForegroundColor Yellow
$braveUrl = "https://laptop-updates.brave.com/latest/winx64"
$braveInstaller = "$downloadDir\brave_installer.exe"
if (-not (Test-Path "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe")) {
    Invoke-WebRequest -Uri $braveUrl -OutFile $braveInstaller -UseBasicParsing
    Start-Process -FilePath $braveInstaller -ArgumentList "/silent /install" -Wait
    Write-Host "  Installed" -ForegroundColor Green
} else {
    Write-Host "  Already installed" -ForegroundColor Green
}

# Firefox
Write-Host "[4/8] Firefox" -ForegroundColor Yellow
$firefoxUrl = "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US"
$firefoxInstaller = "$downloadDir\firefox_installer.exe"
if (-not (Test-Path "C:\Program Files\Mozilla Firefox\firefox.exe")) {
    Invoke-WebRequest -Uri $firefoxUrl -OutFile $firefoxInstaller -UseBasicParsing
    Start-Process -FilePath $firefoxInstaller -ArgumentList "/S" -Wait
    Write-Host "  Installed" -ForegroundColor Green
} else {
    Write-Host "  Already installed" -ForegroundColor Green
}

# Vivaldi
Write-Host "[5/8] Vivaldi" -ForegroundColor Yellow
$vivaldiUrl = "https://downloads.vivaldi.com/stable/Vivaldi.6.6.3271.57.x64.exe"
$vivaldiInstaller = "$downloadDir\vivaldi_installer.exe"
if (-not (Test-Path "$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe")) {
    Invoke-WebRequest -Uri $vivaldiUrl -OutFile $vivaldiInstaller -UseBasicParsing
    Start-Process -FilePath $vivaldiInstaller -ArgumentList "--vivaldi-silent --do-not-launch-chrome" -Wait
    Write-Host "  Installed" -ForegroundColor Green
} else {
    Write-Host "  Already installed" -ForegroundColor Green
}

# Opera
Write-Host "[6/8] Opera" -ForegroundColor Yellow
$operaUrl = "https://net.geo.opera.com/opera/stable/windows"
$operaInstaller = "$downloadDir\opera_installer.exe"
if (-not (Test-Path "$env:LOCALAPPDATA\Programs\Opera\opera.exe")) {
    Invoke-WebRequest -Uri $operaUrl -OutFile $operaInstaller -UseBasicParsing
    Start-Process -FilePath $operaInstaller -ArgumentList "/silent /launchopera=0 /setdefaultbrowser=0" -Wait
    Write-Host "  Installed" -ForegroundColor Green
} else {
    Write-Host "  Already installed" -ForegroundColor Green
}

# Chromium
Write-Host "[7/8] Chromium" -ForegroundColor Yellow
$chromiumPath = "$env:LOCALAPPDATA\Chromium"
if (-not (Test-Path "$chromiumPath\Application\chrome.exe")) {
    Write-Host "  Downloading Chromium snapshot..." -ForegroundColor Gray
    
    # 获取最新版本号
    $lastChangeUrl = "https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Win_x64%2FLAST_CHANGE?alt=media"
    $lastChange = (Invoke-WebRequest -Uri $lastChangeUrl -UseBasicParsing).Content.Trim()
    
    # 下载 Chromium
    $chromiumZipUrl = "https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Win_x64%2F$lastChange%2Fchrome-win.zip?alt=media"
    $chromiumZip = "$downloadDir\chromium.zip"
    Invoke-WebRequest -Uri $chromiumZipUrl -OutFile $chromiumZip -UseBasicParsing
    
    # 解压
    Expand-Archive -Path $chromiumZip -DestinationPath $chromiumPath -Force
    
    # 移动到标准位置
    if (Test-Path "$chromiumPath\chrome-win") {
        if (-not (Test-Path "$chromiumPath\Application")) {
            New-Item -ItemType Directory -Path "$chromiumPath\Application" -Force | Out-Null
        }
        Get-ChildItem "$chromiumPath\chrome-win" | Move-Item -Destination "$chromiumPath\Application" -Force
        Remove-Item "$chromiumPath\chrome-win" -Force
    }
    
    Write-Host "  Installed" -ForegroundColor Green
} else {
    Write-Host "  Already installed" -ForegroundColor Green
}

# LibreWolf
Write-Host "[8/8] LibreWolf" -ForegroundColor Yellow
$librewolfUrl = "https://gitlab.com/api/v4/projects/24386000/packages/generic/librewolf/latest/librewolf-latest-windows-x86_64-setup.exe"
$librewolfInstaller = "$downloadDir\librewolf_installer.exe"
if (-not (Test-Path "C:\Program Files\LibreWolf\librewolf.exe")) {
    Write-Host "  Downloading LibreWolf..." -ForegroundColor Gray
    Invoke-WebRequest -Uri $librewolfUrl -OutFile $librewolfInstaller -UseBasicParsing
    Start-Process -FilePath $librewolfInstaller -ArgumentList "/S" -Wait
    Write-Host "  Installed" -ForegroundColor Green
} else {
    Write-Host "  Already installed" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next: Run deploy.ps1 to configure all 8 browsers" -ForegroundColor Cyan
Write-Host ""
