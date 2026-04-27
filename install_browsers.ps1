#Requires -RunAsAdministrator

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Browser Installation Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$downloadDir = "C:\BrowserInstallers"
if (-not (Test-Path $downloadDir)) {
    New-Item -ItemType Directory -Path $downloadDir -Force | Out-Null
}

# Chrome
Write-Host "[Chrome]" -ForegroundColor Yellow
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
Write-Host "[Edge]" -ForegroundColor Yellow
if (-not (Test-Path "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe")) {
    Write-Host "  Edge is pre-installed on Windows 11" -ForegroundColor Green
} else {
    Write-Host "  Already installed" -ForegroundColor Green
}

# Brave
Write-Host "[Brave]" -ForegroundColor Yellow
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
Write-Host "[Firefox]" -ForegroundColor Yellow
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
Write-Host "[Vivaldi]" -ForegroundColor Yellow
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
Write-Host "[Opera]" -ForegroundColor Yellow
$operaUrl = "https://net.geo.opera.com/opera/stable/windows"
$operaInstaller = "$downloadDir\opera_installer.exe"
if (-not (Test-Path "$env:LOCALAPPDATA\Programs\Opera\opera.exe")) {
    Invoke-WebRequest -Uri $operaUrl -OutFile $operaInstaller -UseBasicParsing
    Start-Process -FilePath $operaInstaller -ArgumentList "/silent /launchopera=0 /setdefaultbrowser=0" -Wait
    Write-Host "  Installed" -ForegroundColor Green
} else {
    Write-Host "  Already installed" -ForegroundColor Green
}

Write-Host ""
Write-Host "Installation complete! Run deploy.ps1 to configure." -ForegroundColor Green
