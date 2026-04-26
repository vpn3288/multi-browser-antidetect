# 一键安装所有扩展 - 简化版
# 只打开一个浏览器，安装完成后自动打开下一个

$Browsers = @(
    @{Name="Chrome";  Path="C:\Program Files\Google\Chrome\Application\chrome.exe"},
    @{Name="Edge";    Path="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"},
    @{Name="Brave";   Path="C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"},
    @{Name="Opera";   Path="$env:LOCALAPPDATA\Programs\Opera\opera.exe"},
    @{Name="Vivaldi"; Path="$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe"}
)

$Extensions = @(
    "https://chromewebstore.google.com/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm",
    "https://chromewebstore.google.com/detail/canvas-defender/obdbgnebcljmgkoljcdddaopadkifnpm",
    "https://chromewebstore.google.com/detail/webrtc-leak-shield/bppamachkoflopbagkdoflbgfjflfnfl",
    "https://chromewebstore.google.com/detail/user-agent-switcher-and-manager/bhchdcejhohfmigjafbampogmaanbfkg",
    "https://chromewebstore.google.com/detail/cookie-autodelete/fhcgjolkccmbidfldomjliifgaodjagh"
)

Write-Host "一键安装扩展助手" -ForegroundColor Cyan
Write-Host "将依次为每个浏览器安装5个扩展`n" -ForegroundColor Gray

foreach ($browser in $Browsers) {
    if (-not (Test-Path $browser.Path)) {
        Write-Host "[跳过] $($browser.Name) 未安装" -ForegroundColor Yellow
        continue
    }
    
    Write-Host "`n[*] 启动 $($browser.Name)..." -ForegroundColor Cyan
    Write-Host "    请在浏览器中点击 [添加] 按钮安装所有扩展" -ForegroundColor Gray
    Write-Host "    安装完成后关闭浏览器，脚本会自动继续" -ForegroundColor Gray
    
    # 启动浏览器
    $process = Start-Process -FilePath $browser.Path -ArgumentList $Extensions -PassThru
    
    # 等待浏览器关闭
    $process.WaitForExit()
    
    Write-Host "[✓] $($browser.Name) 完成" -ForegroundColor Green
}

Write-Host "`n所有浏览器扩展安装完成！" -ForegroundColor Green
