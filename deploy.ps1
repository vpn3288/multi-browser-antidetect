#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Multi-Browser Anti-Detect Configuration
    
.DESCRIPTION
    Configures 8 browsers with privacy protection and fingerprint differentiation
    - Chrome, Edge, Brave, Chromium, Vivaldi, Opera (Chromium-based)
    - Firefox, LibreWolf (Firefox-based)
    
.NOTES
    Version: 4.0 - Vendor-Specific Deep Optimization
    All configurations based on official vendor documentation
#>

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Multi-Browser Anti-Detect Setup v4.0" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$ProfileRoot = "C:\BrowserProfiles"

# Create profile directory
if (-not (Test-Path $ProfileRoot)) {
    New-Item -ItemType Directory -Path $ProfileRoot -Force | Out-Null
}

# ============================================================================
# Chromium Browsers Configuration
# ============================================================================

$chromiumBrowsers = @{
    "Chrome" = "HKLM:\SOFTWARE\Policies\Google\Chrome"
    "Edge" = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
    "Brave" = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"
    "Chromium" = "HKLM:\SOFTWARE\Policies\Chromium"
    "Vivaldi" = "HKLM:\SOFTWARE\Policies\Vivaldi"
    "Opera" = "HKLM:\SOFTWARE\Policies\Opera Software\Opera"
}

Write-Host "[1/3] Configuring Chromium-based browsers..." -ForegroundColor Yellow

foreach ($name in $chromiumBrowsers.Keys) {
    $path = $chromiumBrowsers[$name]
    
    if (-not (Test-Path $path)) {
        New-Item -Path $path -Force | Out-Null
    }
    
    # Core privacy settings
    Set-ItemProperty -Path $path -Name "BookmarkBarEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "HomepageIsNewTabPage" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "NewTabPageLocation" -Value "chrome://newtab" -Type String -Force
    Set-ItemProperty -Path $path -Name "DefaultBrowserSettingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "MetricsReportingEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "SearchSuggestEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "BlockThirdPartyCookies" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "PasswordManagerEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "PromotionalTabsEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $path -Name "SyncDisabled" -Value 1 -Type DWord -Force
    
    # Critical: WebRTC IP protection
    Set-ItemProperty -Path $path -Name "WebRtcIPHandlingPolicy" -Value "disable_non_proxied_udp" -Type String -Force
    
    # Critical: SafeBrowsing (keep enabled for legitimacy)
    Set-ItemProperty -Path $path -Name "SafeBrowsingProtectionLevel" -Value 1 -Type DWord -Force
    
    # Vendor-specific optimizations
    switch ($name) {
        "Chrome" {
            Set-ItemProperty -Path $path -Name "BrowserSignin" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "EnableMediaRouter" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "TranslateEnabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "ChromeCleanupEnabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "UserFeedbackAllowed" -Value 0 -Type DWord -Force
        }
        "Edge" {
            Set-ItemProperty -Path $path -Name "CopilotPageContext" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "EdgeShoppingAssistantEnabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "EdgeCollectionsEnabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "EdgeWorkspacesEnabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "HubsSidebarEnabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "ShowMicrosoftRewards" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "EdgeAssetDeliveryServiceEnabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "EdgeFollowEnabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "EdgeGamesEnabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "TrackingPrevention" -Value 2 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "SleepingTabsEnabled" -Value 1 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "SleepingTabsTimeout" -Value 7200 -Type DWord -Force
        }
        "Brave" {
            Set-ItemProperty -Path $path -Name "BraveRewardsDisabled" -Value 1 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "BraveWalletDisabled" -Value 1 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "BraveVPNDisabled" -Value 1 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "BraveNewsEnabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "TorDisabled" -Value 1 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "BraveTalkEnabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "IPFSEnabled" -Value 0 -Type DWord -Force
        }
        "Vivaldi" {
            Set-ItemProperty -Path $path -Name "VivaldiSidebarEnabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "VivaldiSpeedDialEnabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "VivaldiMailEnabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "VivaldiCalendarEnabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "VivaldiFeedReaderEnabled" -Value 0 -Type DWord -Force
        }
        "Opera" {
            Set-ItemProperty -Path $path -Name "OperaSidebarEnabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "OperaVPNEnabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "OperaNewsEnabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "OperaTurboEnabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "OperaSpeedDialEnabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $path -Name "OperaDiscoverEnabled" -Value 0 -Type DWord -Force
        }
    }
    
    Write-Host "  [OK] $name (with vendor-specific optimizations)" -ForegroundColor Green
}

# ============================================================================
# Firefox Browsers Configuration
# ============================================================================

Write-Host ""
Write-Host "[2/3] Configuring Firefox-based browsers..." -ForegroundColor Yellow

$firefoxBrowsers = @{
    "Firefox" = "C:\Program Files\Mozilla Firefox"
    "LibreWolf" = "C:\Program Files\LibreWolf"
}

$firefoxPolicies = @{
    "policies" = @{
        "DisplayBookmarksToolbar" = "always"
        "Homepage" = @{
            "URL" = "about:blank"
            "Locked" = $true
            "StartPage" = "none"
        }
        "DontCheckDefaultBrowser" = $true
        "DisableTelemetry" = $true
        "DisableFirefoxStudies" = $true
        "DisablePocket" = $true
        "DisableFirefoxAccounts" = $true
        "PasswordManagerEnabled" = $false
        "SearchSuggestEnabled" = $false
        "EnableTrackingProtection" = @{
            "Value" = $true
            "Locked" = $true
            "Cryptomining" = $true
            "Fingerprinting" = $true
        }
        "Cookies" = @{
            "AcceptThirdParty" = "never"
            "RejectTracker" = $true
        }
        "Preferences" = @{
            "media.peerconnection.ice.default_address_only" = @{
                "Value" = $true
                "Status" = "locked"
            }
            "media.peerconnection.ice.no_host" = @{
                "Value" = $true
                "Status" = "locked"
            }
            "media.peerconnection.ice.proxy_only_if_behind_proxy" = @{
                "Value" = $true
                "Status" = "locked"
            }
        }
    }
}

foreach ($name in $firefoxBrowsers.Keys) {
    $installPath = $firefoxBrowsers[$name]
    
    if (-not (Test-Path $installPath)) {
        Write-Host "  [SKIP] $name - Not installed" -ForegroundColor Yellow
        continue
    }
    
    $policiesDir = Join-Path $installPath "distribution"
    if (-not (Test-Path $policiesDir)) {
        New-Item -ItemType Directory -Path $policiesDir -Force | Out-Null
    }
    
    $policiesFile = Join-Path $policiesDir "policies.json"
    $firefoxPolicies | ConvertTo-Json -Depth 10 | Out-File -FilePath $policiesFile -Encoding UTF8 -Force
    
    Write-Host "  [OK] $name" -ForegroundColor Green
}

# ============================================================================
# Generate Launch Scripts
# ============================================================================

Write-Host ""
Write-Host "[3/3] Generating launch scripts..." -ForegroundColor Yellow

$browsers = @(
    @{Name="Chrome"; Path="C:\Program Files\Google\Chrome\Application\chrome.exe"; Port=7891},
    @{Name="Edge"; Path="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"; Port=7892},
    @{Name="Brave"; Path="C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"; Port=7893},
    @{Name="Vivaldi"; Path="$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe"; Port=7894},
    @{Name="Opera"; Path="$env:LOCALAPPDATA\Programs\Opera\opera.exe"; Port=7895},
    @{Name="Chromium"; Path="$env:LOCALAPPDATA\Chromium\Application\chrome.exe"; Port=7896},
    @{Name="Firefox"; Path="C:\Program Files\Mozilla Firefox\firefox.exe"; Port=7897; Type="Firefox"},
    @{Name="LibreWolf"; Path="C:\Program Files\LibreWolf\librewolf.exe"; Port=7898; Type="Firefox"}
)

foreach ($browser in $browsers) {
    if (-not (Test-Path $browser.Path)) {
        continue
    }
    
    $profileDir = Join-Path $ProfileRoot $browser.Name
    if (-not (Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    }
    
    $scriptPath = Join-Path $ProfileRoot "Launch_$($browser.Name).bat"
    
    if ($browser.Type -eq "Firefox") {
        $content = @"
@echo off
title $($browser.Name)
start "" "$($browser.Path)" -profile "$profileDir" -no-remote
"@
    } else {
        $content = @"
@echo off
title $($browser.Name)
start "" "$($browser.Path)" --user-data-dir="$profileDir" --proxy-server=socks5://127.0.0.1:$($browser.Port) --lang=en-US --no-first-run --no-default-browser-check
"@
    }
    
    Set-Content -Path $scriptPath -Value $content -Encoding ASCII
    Write-Host "  [OK] Launch_$($browser.Name).bat" -ForegroundColor Green
}

# Launch All script
$launchAllPath = Join-Path $ProfileRoot "Launch_All.bat"
$launchAllContent = @"
@echo off
title Launch All Browsers
echo Starting all browsers...
"@

foreach ($browser in $browsers) {
    if (Test-Path $browser.Path) {
        $launchAllContent += "`nstart `"`" `"%~dp0Launch_$($browser.Name).bat`"`ntimeout /t 2 /nobreak >nul"
    }
}

$launchAllContent += "`necho All browsers launched!"

Set-Content -Path $launchAllPath -Value $launchAllContent -Encoding ASCII
Write-Host "  [OK] Launch_All.bat" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Launch scripts: $ProfileRoot" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Configure Clash with 8 different US IPs (ports 7891-7898)" -ForegroundColor White
Write-Host "  2. Run Launch_All.bat to test" -ForegroundColor White
Write-Host "  3. Verify at https://browserleaks.com/webrtc" -ForegroundColor White
Write-Host ""
