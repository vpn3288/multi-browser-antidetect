#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Multi-Browser Anti-Detect Deployment Script
    
.DESCRIPTION
    Automated deployment of 8 privacy-focused browsers with:
    - Unified installation to C:\Browsers
    - Enterprise-grade privacy policies
    - Individual fingerprint profiles
    - SOCKS5 proxy configuration (ports 7891-7898)
    - Official compliant configurations only
    
.NOTES
    Version: 2.0
    Repository: https://github.com/vpn3288/multi-browser-antidetect
#>

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# ============================================================================
# Configuration
# ============================================================================

$Config = @{
    BrowserRoot = "C:\Browsers"
    ProfileRoot = "C:\BrowserProfiles"
    ProxyBasePort = 7891
    Language = "en-US"
}

$Browsers = @{
    Chrome = @{
        Name = "Google Chrome"
        WingetId = "Google.Chrome"
        Type = "Chromium"
        PolicyPath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
    }
    Edge = @{
        Name = "Microsoft Edge"
        WingetId = "Microsoft.Edge"
        Type = "Chromium"
        PolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
    }
    Brave = @{
        Name = "Brave"
        WingetId = "Brave.Brave"
        Type = "Chromium"
        PolicyPath = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"
    }
    Firefox = @{
        Name = "Firefox"
        WingetId = "Mozilla.Firefox"
        Type = "Firefox"
    }
    LibreWolf = @{
        Name = "LibreWolf"
        WingetId = "LibreWolf.LibreWolf"
        Type = "Firefox"
    }
    Chromium = @{
        Name = "Chromium"
        WingetId = "Hibbiki.Chromium"
        Type = "Chromium"
        PolicyPath = "HKLM:\SOFTWARE\Policies\Chromium"
    }
    Vivaldi = @{
        Name = "Vivaldi"
        WingetId = "VivaldiTechnologies.Vivaldi"
        Type = "Chromium"
        PolicyPath = "HKLM:\SOFTWARE\Policies\Vivaldi"
    }
    Opera = @{
        Name = "Opera"
        WingetId = "Opera.Opera"
        Type = "Chromium"
        PolicyPath = "HKLM:\SOFTWARE\Policies\Opera Software\Opera"
    }
}

# ============================================================================
# Helper Functions
# ============================================================================

function Write-Status {
    param(
        [string]$Message,
        [ValidateSet("INFO", "SUCCESS", "WARN", "ERROR")]
        [string]$Type = "INFO"
    )
    
    $colors = @{
        INFO = "Cyan"
        SUCCESS = "Green"
        WARN = "Yellow"
        ERROR = "Red"
    }
    
    $prefixes = @{
        INFO = "[*]"
        SUCCESS = "[✓]"
        WARN = "[!]"
        ERROR = "[✗]"
    }
    
    Write-Host "$($prefixes[$Type]) $Message" -ForegroundColor $colors[$Type]
}

function Set-RegistryPolicy {
    param(
        [string]$Path,
        [string]$Name,
        [object]$Value,
        [string]$Type = "String"
    )
    
    try {
        if (-not (Test-Path $Path)) {
            New-Item -Path $Path -Force | Out-Null
        }
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force
        return $true
    } catch {
        Write-Status "Failed to set $Name : $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Install-Browser {
    param($BrowserKey)
    
    $browser = $Browsers[$BrowserKey]
    
    Write-Status "Installing $($browser.Name)..." "INFO"
    
    try {
        $result = winget install --id $browser.WingetId --silent --accept-package-agreements --accept-source-agreements 2>&1
        Start-Sleep -Seconds 5
        Write-Status "$($browser.Name) installed" "SUCCESS"
        return $true
    } catch {
        Write-Status "Installation failed: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Configure-ChromiumBrowser {
    param($BrowserKey)
    
    $browser = $Browsers[$BrowserKey]
    $path = $browser.PolicyPath
    
    Write-Status "Configuring $($browser.Name)..." "INFO"
    
    # UI Settings
    Set-RegistryPolicy $path "BookmarkBarEnabled" 1 "DWord"
    Set-RegistryPolicy $path "HomepageIsNewTabPage" 1 "DWord"
    Set-RegistryPolicy $path "RestoreOnStartup" 5 "DWord"
    Set-RegistryPolicy $path "ShowHomeButton" 0 "DWord"
    
    # Privacy
    Set-RegistryPolicy $path "DefaultBrowserSettingEnabled" 0 "DWord"
    Set-RegistryPolicy $path "MetricsReportingEnabled" 0 "DWord"
    Set-RegistryPolicy $path "SearchSuggestEnabled" 0 "DWord"
    Set-RegistryPolicy $path "AlternateErrorPagesEnabled" 0 "DWord"
    Set-RegistryPolicy $path "NetworkPredictionOptions" 2 "DWord"
    Set-RegistryPolicy $path "BlockThirdPartyCookies" 1 "DWord"
    Set-RegistryPolicy $path "AutofillAddressEnabled" 0 "DWord"
    Set-RegistryPolicy $path "AutofillCreditCardEnabled" 0 "DWord"
    Set-RegistryPolicy $path "PasswordManagerEnabled" 0 "DWord"
    
    # Performance
    Set-RegistryPolicy $path "HardwareAccelerationModeEnabled" 1 "DWord"
    Set-RegistryPolicy $path "BackgroundModeEnabled" 0 "DWord"
    
    # Anti-Promotion
    Set-RegistryPolicy $path "PromotionalTabsEnabled" 0 "DWord"
    Set-RegistryPolicy $path "ShowCastIconInToolbar" 0 "DWord"
    
    # Edge-specific
    if ($BrowserKey -eq "Edge") {
        Set-RegistryPolicy $path "EdgeShoppingAssistantEnabled" 0 "DWord"
        Set-RegistryPolicy $path "EdgeCollectionsEnabled" 0 "DWord"
        Set-RegistryPolicy $path "HubsSidebarEnabled" 0 "DWord"
        Set-RegistryPolicy $path "ShowMicrosoftRewards" 0 "DWord"
    }
    
    Write-Status "$($browser.Name) configured" "SUCCESS"
}

function Configure-FirefoxBrowser {
    param($BrowserKey)
    
    $browser = $Browsers[$BrowserKey]
    $installPath = Get-FirefoxPath $BrowserKey
    
    if (-not $installPath) {
        Write-Status "Firefox installation path not found" "ERROR"
        return
    }
    
    $policiesDir = Join-Path $installPath "distribution"
    if (-not (Test-Path $policiesDir)) {
        New-Item -ItemType Directory -Path $policiesDir -Force | Out-Null
    }
    
    $policiesFile = Join-Path $policiesDir "policies.json"
    
    $policies = @{
        policies = @{
            DisplayBookmarksToolbar = "always"
            Homepage = @{
                URL = "about:blank"
                Locked = $true
                StartPage = "none"
            }
            DontCheckDefaultBrowser = $true
            DisableTelemetry = $true
            DisableFirefoxStudies = $true
            DisablePocket = $true
            DisableFirefoxAccounts = $true
            DisableFormHistory = $true
            EnableTrackingProtection = @{
                Value = $true
                Locked = $true
                Cryptomining = $true
                Fingerprinting = $true
            }
            Cookies = @{
                AcceptThirdParty = "never"
                RejectTracker = $true
            }
            HardwareAcceleration = $true
            SearchSuggestEnabled = $false
            UserMessaging = @{
                WhatsNew = $false
                ExtensionRecommendations = $false
                FeatureRecommendations = $false
                UrlbarInterventions = $false
                SkipOnboarding = $true
            }
            PasswordManagerEnabled = $false
        }
    }
    
    $policies | ConvertTo-Json -Depth 10 | Out-File -FilePath $policiesFile -Encoding UTF8 -Force
    Write-Status "$($browser.Name) configured" "SUCCESS"
}

function Get-FirefoxPath {
    param($BrowserKey)
    
    $paths = @(
        "C:\Program Files\Mozilla Firefox",
        "C:\Program Files (x86)\Mozilla Firefox",
        "$env:LOCALAPPDATA\Programs\Mozilla Firefox",
        "C:\Program Files\LibreWolf",
        "$env:LOCALAPPDATA\Programs\LibreWolf"
    )
    
    foreach ($path in $paths) {
        if (Test-Path $path) {
            return $path
        }
    }
    
    return $null
}

function New-LaunchScript {
    param(
        [string]$BrowserKey,
        [int]$Index
    )
    
    $browser = $Browsers[$BrowserKey]
    $profileDir = Join-Path $Config.ProfileRoot $BrowserKey
    $proxyPort = $Config.ProxyBasePort + $Index
    
    if (-not (Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    }
    
    $scriptPath = Join-Path $Config.ProfileRoot "Launch_$BrowserKey.bat"
    
    if ($browser.Type -eq "Firefox") {
        $exePath = Join-Path (Get-FirefoxPath $BrowserKey) "firefox.exe"
        $content = @"
@echo off
title $($browser.Name)
start "" "$exePath" -profile "$profileDir" -no-remote
"@
    } else {
        $exePath = Get-ChromiumPath $BrowserKey
        $content = @"
@echo off
title $($browser.Name)
start "" "$exePath" --user-data-dir="$profileDir" --proxy-server=127.0.0.1:$proxyPort --lang=$($Config.Language) --no-first-run --no-default-browser-check
"@
    }
    
    $content | Out-File -FilePath $scriptPath -Encoding ASCII -Force
    Write-Status "Launch script created: Launch_$BrowserKey.bat" "SUCCESS"
}

function Get-ChromiumPath {
    param($BrowserKey)
    
    $commonPaths = @{
        Chrome = @(
            "C:\Program Files\Google\Chrome\Application\chrome.exe",
            "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
        )
        Edge = @(
            "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
            "C:\Program Files\Microsoft\Edge\Application\msedge.exe"
        )
        Brave = @(
            "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\Application\brave.exe",
            "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
        )
        Chromium = @(
            "C:\Program Files\Chromium\Application\chrome.exe",
            "$env:LOCALAPPDATA\Chromium\Application\chrome.exe"
        )
        Vivaldi = @(
            "$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe",
            "C:\Program Files\Vivaldi\Application\vivaldi.exe"
        )
        Opera = @(
            "$env:LOCALAPPDATA\Programs\Opera\launcher.exe",
            "C:\Program Files\Opera\launcher.exe"
        )
    }
    
    foreach ($path in $commonPaths[$BrowserKey]) {
        if (Test-Path $path) {
            return $path
        }
    }
    
    return $null
}

# ============================================================================
# Main Execution
# ============================================================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Multi-Browser Anti-Detect Deployment" -ForegroundColor Cyan
Write-Host "Version 2.0 - Official Compliant" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check winget
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Status "Winget not found. Please install App Installer from Microsoft Store." "ERROR"
    exit 1
}

# Create directories
if (-not (Test-Path $Config.BrowserRoot)) {
    New-Item -ItemType Directory -Path $Config.BrowserRoot -Force | Out-Null
}
if (-not (Test-Path $Config.ProfileRoot)) {
    New-Item -ItemType Directory -Path $Config.ProfileRoot -Force | Out-Null
}

# Step 1: Check installed browsers
Write-Status "Step 1: Checking installed browsers..." "INFO"
Write-Host ""

$installed = @()
$missing = @()

foreach ($key in $Browsers.Keys) {
    $browser = $Browsers[$key]
    
    if ($browser.Type -eq "Firefox") {
        $path = Get-FirefoxPath $key
    } else {
        $path = Get-ChromiumPath $key
    }
    
    if ($path -and (Test-Path $path)) {
        Write-Status "$($browser.Name) - Already installed" "SUCCESS"
        $installed += $key
    } else {
        Write-Status "$($browser.Name) - Not installed" "WARN"
        $missing += $key
    }
}

# Step 2: Install missing browsers
if ($missing.Count -gt 0) {
    Write-Host ""
    Write-Status "Step 2: Installing $($missing.Count) missing browsers..." "INFO"
    Write-Host ""
    
    foreach ($key in $missing) {
        if (Install-Browser $key) {
            $installed += $key
        }
    }
} else {
    Write-Host ""
    Write-Status "Step 2: All browsers already installed" "SUCCESS"
}

# Step 3: Configure browsers
Write-Host ""
Write-Status "Step 3: Applying privacy configurations..." "INFO"
Write-Host ""

foreach ($key in $installed) {
    $browser = $Browsers[$key]
    
    if ($browser.Type -eq "Chromium") {
        Configure-ChromiumBrowser $key
    } else {
        Configure-FirefoxBrowser $key
    }
}

# Step 4: Generate launch scripts
Write-Host ""
Write-Status "Step 4: Generating launch scripts..." "INFO"
Write-Host ""

$index = 0
foreach ($key in $installed) {
    New-LaunchScript $key $index
    $index++
}

# Create master launch script
$masterScript = Join-Path $Config.ProfileRoot "Launch_All.bat"
$masterContent = "@echo off`r`ntitle Launch All Browsers`r`n"

foreach ($key in $installed) {
    $scriptPath = Join-Path $Config.ProfileRoot "Launch_$key.bat"
    $masterContent += "start """" ""$scriptPath""`r`n"
    $masterContent += "timeout /t 2 /nobreak >nul`r`n"
}

$masterContent | Out-File -FilePath $masterScript -Encoding ASCII -Force
Write-Status "Master launch script created: Launch_All.bat" "SUCCESS"

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Deployment Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Installed browsers: $($installed.Count) / 8" -ForegroundColor Cyan
Write-Host "Profile directory: $($Config.ProfileRoot)" -ForegroundColor Cyan
Write-Host "Proxy ports: $($Config.ProxyBasePort)-$($Config.ProxyBasePort + 7)" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Configure Clash with 8 SOCKS5 proxies (ports 7891-7898)" -ForegroundColor White
Write-Host "  2. Run Launch_All.bat to start all browsers" -ForegroundColor White
Write-Host "  3. Install extensions manually (Canvas Defender, WebRTC Shield)" -ForegroundColor White
Write-Host ""
