# Opera 启动脚本（自动配置版）
$operaExe = "C:\Users\Newby\AppData\Local\Programs\Opera\opera.exe"
$operaProfile = "C:\BrowserProfiles\Opera"
$proxy = "socks5://127.0.0.1:7890"

$args = @(
    "--user-data-dir=$operaProfile",
    "--proxy-server=$proxy",
    "--disable-blink-features=AutomationControlled",
    "--disable-background-networking",
    "--disable-background-timer-throttling",
    "--disable-backgrounding-occluded-windows",
    "--disable-breakpad",
    "--disable-component-extensions-with-background-pages",
    "--disable-features=TranslateUI",
    "--disable-ipc-flooding-protection",
    "--disable-renderer-backgrounding",
    "--enable-features=NetworkService,NetworkServiceInProcess",
    "--no-first-run",
    "--password-store=basic",
    "--disable-hang-monitor",
    "--disable-prompt-on-repost",
    "--disable-sync",
    "--metrics-recording-only",
    "--force-webrtc-ip-handling-policy=disable_non_proxied_udp"
)

Write-Host "启动 Opera..." -ForegroundColor Cyan
Write-Host "  代理: $proxy" -ForegroundColor White
Write-Host "  配置: $operaProfile" -ForegroundColor White

Start-Process $operaExe -ArgumentList $args
