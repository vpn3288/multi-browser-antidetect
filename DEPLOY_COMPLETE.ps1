# ══════════════════════════════════════════════════════════════════
#  完整自动化部署脚本 v1.0
#  整合：Browser安装 + Clash Verge配置 + 反检测优化
#  目标：7个浏览器独立IP + 极致隐私 + 正常美国人流量特征
# ══════════════════════════════════════════════════════════════════

#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# ══════════════════════════════════════════════════════════════════
#  第一步：安装所有浏览器
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[步骤 1/4] 安装7个浏览器..." -ForegroundColor Cyan

try {
    irm https://raw.githubusercontent.com/vpn3288/Browser/main/install_all_browsers.ps1 | iex
    Write-Host "[✓] 浏览器安装完成" -ForegroundColor Green
} catch {
    Write-Host "[✗] 浏览器安装失败: $_" -ForegroundColor Red
    exit 1
}

# ══════════════════════════════════════════════════════════════════
#  第二步：配置Clash Verge
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[步骤 2/4] 配置Clash Verge..." -ForegroundColor Cyan

$clashConfigPath = "$env:USERPROFILE\.config\clash-verge\profiles"
$mihomoCfgUrl = "https://raw.githubusercontent.com/vpn3288/mihomo/main/%E5%AE%8C%E7%BE%8E%E7%89%88clash-verge-config-v2.2.js"

if (-not (Test-Path $clashConfigPath)) {
    New-Item -ItemType Directory -Path $clashConfigPath -Force | Out-Null
}

try {
    $cfgContent = Invoke-RestMethod -Uri $mihomoCfgUrl -UseBasicParsing
    $cfgContent | Out-File -FilePath "$clashConfigPath\config.js" -Encoding UTF8 -Force
    Write-Host "[✓] Clash Verge配置已下载" -ForegroundColor Green
} catch {
    Write-Host "[✗] 配置下载失败: $_" -ForegroundColor Red
    exit 1
}

# ══════════════════════════════════════════════════════════════════
#  第三步：部署反检测脚本（终极版）
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[步骤 3/4] 部署反检测优化..." -ForegroundColor Cyan

$browsers = @(
    @{Name="Chrome";    Path="C:\Program Files\Google\Chrome\Application\chrome.exe";           Port=7891; TZ="America/New_York"},
    @{Name="Firefox";   Path="C:\Program Files\Mozilla Firefox\firefox.exe";                    Port=7892; TZ="America/Chicago"},
    @{Name="Edge";      Path="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe";    Port=7893; TZ="America/Denver"},
    @{Name="Brave";     Path="C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"; Port=7894; TZ="America/Los_Angeles"},
    @{Name="Opera";     Path="C:\Users\$env:USERNAME\AppData\Local\Programs\Opera\opera.exe";   Port=7895; TZ="America/Phoenix"},
    @{Name="Vivaldi";   Path="C:\Users\$env:USERNAME\AppData\Local\Vivaldi\Application\vivaldi.exe"; Port=7896; TZ="America/Anchorage"},
    @{Name="LibreWolf"; Path="C:\Program Files\LibreWolf\librewolf.exe";                        Port=7897; TZ="Pacific/Honolulu"}
)

$antiDetectJS = @'
// Canvas指纹随机化
const originalToDataURL = HTMLCanvasElement.prototype.toDataURL;
HTMLCanvasElement.prototype.toDataURL = function() {
    const ctx = this.getContext('2d');
    const imageData = ctx.getImageData(0, 0, this.width, this.height);
    for (let i = 0; i < imageData.data.length; i += 4) {
        imageData.data[i] += Math.floor(Math.random() * 3) - 1;
    }
    ctx.putImageData(imageData, 0, 0);
    return originalToDataURL.apply(this, arguments);
};

// WebGL指纹修改
const getParameter = WebGLRenderingContext.prototype.getParameter;
WebGLRenderingContext.prototype.getParameter = function(param) {
    if (param === 37445) return 'Intel Inc.';
    if (param === 37446) return 'Intel Iris OpenGL Engine';
    return getParameter.apply(this, arguments);
};

// AudioContext指纹噪声注入
const createOscillator = AudioContext.prototype.createOscillator;
AudioContext.prototype.createOscillator = function() {
    const osc = createOscillator.apply(this, arguments);
    const originalStart = osc.start;
    osc.start = function() {
        osc.frequency.value += Math.random() * 0.001;
        return originalStart.apply(this, arguments);
    };
    return osc;
};

// WebRTC禁用（防止真实IP泄漏）
Object.defineProperty(navigator, 'mediaDevices', {
    get: () => undefined
});

// Battery API伪造
Object.defineProperty(navigator, 'getBattery', {
    value: () => Promise.resolve({
        charging: true,
        chargingTime: 0,
        dischargingTime: Infinity,
        level: 1
    })
});

// 清理Function.toString痕迹
const nativeToString = Function.prototype.toString;
Function.prototype.toString = function() {
    if (this === HTMLCanvasElement.prototype.toDataURL ||
        this === WebGLRenderingContext.prototype.getParameter ||
        this === AudioContext.prototype.createOscillator) {
        return nativeToString.call(Function.prototype.toString);
    }
    return nativeToString.apply(this, arguments);
};
'@

$userDataBase = "$env:LOCALAPPDATA\BrowserProfiles"
if (-not (Test-Path $userDataBase)) {
    New-Item -ItemType Directory -Path $userDataBase -Force | Out-Null
}

foreach ($browser in $browsers) {
    $userDataDir = "$userDataBase\$($browser.Name)"
    if (-not (Test-Path $userDataDir)) {
        New-Item -ItemType Directory -Path $userDataDir -Force | Out-Null
    }
    
    # 保存反检测脚本
    $antiDetectJS | Out-File -FilePath "$userDataDir\antidetect.js" -Encoding UTF8 -Force
    
    Write-Host "[✓] $($browser.Name) 反检测脚本已部署" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════
#  第四步：生成启动脚本
# ══════════════════════════════════════════════════════════════════

Write-Host "`n[步骤 4/4] 生成启动脚本..." -ForegroundColor Cyan

$launchScript = @'
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
'@

$launchScript | Out-File -FilePath "$PSScriptRoot\LAUNCH_BROWSERS.ps1" -Encoding UTF8 -Force

Write-Host "`n[✓] 启动脚本已生成: LAUNCH_BROWSERS.ps1" -ForegroundColor Green

# ══════════════════════════════════════════════════════════════════
#  完成提示
# ══════════════════════════════════════════════════════════════════

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  部署完成！接下来的步骤：" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "1. 配置VPS节点（使用 Agent-Proxy 脚本）" -ForegroundColor Yellow
Write-Host "   - 部署7个美国IP的落地机" -ForegroundColor Gray
Write-Host "   - 配置CN2 GIA中转机" -ForegroundColor Gray
Write-Host ""
Write-Host "2. 修改Clash Verge配置中的订阅链接" -ForegroundColor Yellow
Write-Host "   - 编辑: $env:USERPROFILE\.config\clash-verge\profiles\config.js" -ForegroundColor Gray
Write-Host "   - 替换所有 YOUR_*_SUBSCRIPTION_URL 为实际订阅链接" -ForegroundColor Gray
Write-Host ""
Write-Host "3. 启动Clash Verge并导入配置" -ForegroundColor Yellow
Write-Host ""
Write-Host "4. 运行启动脚本测试" -ForegroundColor Yellow
Write-Host "   .\LAUNCH_BROWSERS.ps1" -ForegroundColor Cyan
Write-Host ""
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
