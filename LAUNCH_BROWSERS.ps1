# 启动所有浏览器（间隔10秒，避免批量操作特征）
$browsers = @(
    @{Name="Chrome";    Path="C:\Program Files\Google\Chrome\Application\chrome.exe";           Port=7891; TZ="America/New_York"},
    @{Name="Firefox";   Path="C:\Program Files\Mozilla Firefox\firefox.exe";                    Port=7892; TZ="America/Chicago"},
    @{Name="Edge";      Path="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe";    Port=7893; TZ="America/Denver"},
    @{Name="Brave";     Path="C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"; Port=7894; TZ="America/Los_Angeles"},
    @{Name="Opera";     Path="C:\Users\$env:USERNAME\AppData\Local\Programs\Opera\opera.exe";   Port=7895; TZ="America/Phoenix"},
    @{Name="Vivaldi";   Path="C:\Users\$env:USERNAME\AppData\Local\Vivaldi\Application\vivaldi.exe"; Port=7896; TZ="America/Anchorage"},
    @{Name="LibreWolf"; Path="C:\Program Files\LibreWolf\librewolf.exe";                        Port=7897; TZ="Pacific/Honolulu"}
)

$userDataBase = "$env:LOCALAPPDATA\BrowserProfiles"

foreach ($browser in $browsers) {
    if (-not (Test-Path $browser.Path)) {
        Write-Host "[跳过] $($browser.Name) 未安装" -ForegroundColor Yellow
        continue
    }
    
    $userDataDir = "$userDataBase\$($browser.Name)"
    $proxyServer = "127.0.0.1:$($browser.Port)"
    
    $args = @(
        "--user-data-dir=`"$userDataDir`""
        "--proxy-server=`"$proxyServer`""
        "--disable-blink-features=AutomationControlled"
        "--disable-features=IsolateOrigins,site-per-process"
        "--disable-web-security"
        "--disable-site-isolation-trials"
        "--no-first-run"
        "--no-default-browser-check"
        "https://ip.sb"
    )
    
    Start-Process -FilePath $browser.Path -ArgumentList $args
    Write-Host "[✓] 已启动 $($browser.Name) (代理端口: $($browser.Port))" -ForegroundColor Green
    
    Start-Sleep -Seconds 10
}

Write-Host "`n所有浏览器已启动，请在每个浏览器中访问 https://ip.sb 确认不同IP" -ForegroundColor Cyan
