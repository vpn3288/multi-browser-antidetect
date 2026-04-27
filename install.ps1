#Requires -RunAsAdministrator

<#
.SYNOPSIS
    One-click installer for Multi-Browser Anti-Detect from GitHub
    
.DESCRIPTION
    Downloads and executes the deployment script directly from GitHub repository
    
.EXAMPLE
    irm https://raw.githubusercontent.com/vpn3288/multi-browser-antidetect/master/install.ps1 | iex
#>

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Multi-Browser Anti-Detect Installer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check admin privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "[✗] This script requires administrator privileges." -ForegroundColor Red
    Write-Host ""
    Write-Host "Please run PowerShell as Administrator and try again:" -ForegroundColor Yellow
    Write-Host "  Right-click PowerShell → Run as Administrator" -ForegroundColor White
    Write-Host ""
    exit 1
}

# Check winget
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "[✗] Winget not found." -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install 'App Installer' from Microsoft Store:" -ForegroundColor Yellow
    Write-Host "  https://www.microsoft.com/store/productId/9NBLGGH4NNS1" -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host "[*] Downloading deployment script from GitHub..." -ForegroundColor Cyan

$repoUrl = "https://raw.githubusercontent.com/vpn3288/multi-browser-antidetect/master"
$deployScript = "$repoUrl/deploy.ps1"

try {
    $scriptContent = Invoke-RestMethod -Uri $deployScript -UseBasicParsing
    
    Write-Host "[✓] Download complete" -ForegroundColor Green
    Write-Host ""
    Write-Host "[*] Executing deployment script..." -ForegroundColor Cyan
    Write-Host ""
    
    # Execute the script
    Invoke-Expression $scriptContent
    
} catch {
    Write-Host "[✗] Failed to download or execute script" -ForegroundColor Red
    Write-Host ""
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please try manual installation:" -ForegroundColor Yellow
    Write-Host "  git clone https://github.com/vpn3288/multi-browser-antidetect.git" -ForegroundColor White
    Write-Host "  cd multi-browser-antidetect" -ForegroundColor White
    Write-Host "  .\deploy.ps1" -ForegroundColor White
    Write-Host ""
    exit 1
}
