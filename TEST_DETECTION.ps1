# ══════════════════════════════════════════════════════════════════
#  自动化检测测试脚本 - 验证指纹伪造和隐私保护
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  自动化检测测试 - 验证指纹和隐私保护" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

# 测试网站列表
$testSites = @(
    @{
        Name = "IP 泄露检测"
        URL = "https://browserleaks.com/ip"
        Description = "检测真实 IP 是否泄露"
    },
    @{
        Name = "WebRTC 泄露检测"
        URL = "https://browserleaks.com/webrtc"
        Description = "检测 WebRTC IP 泄露"
    },
    @{
        Name = "DNS 泄露检测"
        URL = "https://browserleaks.com/dns"
        Description = "检测 DNS 查询泄露"
    },
    @{
        Name = "Canvas 指纹检测"
        URL = "https://browserleaks.com/canvas"
        Description = "检测 Canvas 指纹"
    },
    @{
        Name = "WebGL 指纹检测"
        URL = "https://browserleaks.com/webgl"
        Description = "检测 WebGL 指纹"
    },
    @{
        Name = "综合检测 (Whoer)"
        URL = "https://whoer.net"
        Description = "综合隐私评分"
    },
    @{
        Name = "综合检测 (IPLeak)"
        URL = "https://ipleak.net"
        Description = "全面泄露检测"
    },
    @{
        Name = "设备信息检测"
        URL = "https://www.deviceinfo.me"
        Description = "检测设备指纹"
    }
)

Write-Host "`n[*] 测试网站列表：" -ForegroundColor Cyan
for ($i = 0; $i -lt $testSites.Count; $i++) {
    Write-Host "  $($i+1). $($testSites[$i].Name) - $($testSites[$i].Description)" -ForegroundColor White
}

Write-Host "`n[*] 检查 Clash 代理状态..." -ForegroundColor Cyan

$proxyPorts = 7891..7897
$proxyStatus = @{}

foreach ($port in $proxyPorts) {
    try {
        $tcpClient = New-Object System.Net.Sockets.TcpClient
        $tcpClient.Connect("127.0.0.1", $port)
        $tcpClient.Close()
        $proxyStatus[$port] = $true
        Write-Host "  ✓ 端口 $port 可用" -ForegroundColor Green
    } catch {
        $proxyStatus[$port] = $false
        Write-Host "  ✗ 端口 $port 不可用" -ForegroundColor Red
    }
}

$availablePorts = ($proxyStatus.GetEnumerator() | Where-Object { $_.Value -eq $true }).Count
Write-Host "`n[*] 可用代理端口: $availablePorts / 7" -ForegroundColor $(if ($availablePorts -eq 7) { "Green" } else { "Yellow" })

if ($availablePorts -eq 0) {
    Write-Host "`n[!] 错误：没有可用的代理端口，请先启动 Clash" -ForegroundColor Red
    exit 1
}

Write-Host "`n[*] 测试代理连接..." -ForegroundColor Cyan

foreach ($port in $proxyPorts) {
    if ($proxyStatus[$port]) {
        Write-Host "`n  测试端口 $port..." -ForegroundColor Yellow
        
        try {
            # 使用 curl 测试代理
            $result = curl.exe --proxy socks5://127.0.0.1:$port --max-time 10 -s https://ipinfo.io/json 2>$null
            
            if ($result) {
                $ipInfo = $result | ConvertFrom-Json
                Write-Host "    ✓ IP: $($ipInfo.ip)" -ForegroundColor Green
                Write-Host "    ✓ 国家: $($ipInfo.country)" -ForegroundColor Green
                Write-Host "    ✓ 城市: $($ipInfo.city)" -ForegroundColor Green
                Write-Host "    ✓ 组织: $($ipInfo.org)" -ForegroundColor Green
            } else {
                Write-Host "    ✗ 无法获取 IP 信息" -ForegroundColor Red
            }
        } catch {
            Write-Host "    ✗ 连接失败: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  手动测试指南" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

Write-Host "`n[1] IP 泄露检测" -ForegroundColor Yellow
Write-Host "  访问: https://browserleaks.com/ip" -ForegroundColor White
Write-Host "  检查项:" -ForegroundColor White
Write-Host "    ✓ 显示的 IP 应该是代理 IP，不是你的真实 IP" -ForegroundColor Gray
Write-Host "    ✓ 国家/城市应该匹配代理节点" -ForegroundColor Gray

Write-Host "`n[2] WebRTC 泄露检测" -ForegroundColor Yellow
Write-Host "  访问: https://browserleaks.com/webrtc" -ForegroundColor White
Write-Host "  检查项:" -ForegroundColor White
Write-Host "    ✓ 不应该显示你的真实 IP" -ForegroundColor Gray
Write-Host "    ✓ 如果显示真实 IP，说明 WebRTC 泄露了" -ForegroundColor Gray
Write-Host "    ✓ 解决方法：安装 WebRTC Leak Shield 扩展" -ForegroundColor Gray

Write-Host "`n[3] DNS 泄露检测" -ForegroundColor Yellow
Write-Host "  访问: https://browserleaks.com/dns" -ForegroundColor White
Write-Host "  检查项:" -ForegroundColor White
Write-Host "    ✓ DNS 服务器应该是代理国家的 DNS" -ForegroundColor Gray
Write-Host "    ✓ 不应该显示中国的 DNS 服务器" -ForegroundColor Gray

Write-Host "`n[4] Canvas 指纹检测" -ForegroundColor Yellow
Write-Host "  访问: https://browserleaks.com/canvas" -ForegroundColor White
Write-Host "  检查项:" -ForegroundColor White
Write-Host "    ✓ 每次刷新页面，Canvas 指纹应该略有不同" -ForegroundColor Gray
Write-Host "    ✓ 如果完全相同，说明指纹混淆未生效" -ForegroundColor Gray

Write-Host "`n[5] WebGL 指纹检测" -ForegroundColor Yellow
Write-Host "  访问: https://browserleaks.com/webgl" -ForegroundColor White
Write-Host "  检查项:" -ForegroundColor White
Write-Host "    ✓ GPU 信息应该显示常见的 GPU 型号" -ForegroundColor Gray
Write-Host "    ✓ 不同浏览器应该显示不同的 GPU" -ForegroundColor Gray

Write-Host "`n[6] 综合检测 (Whoer)" -ForegroundColor Yellow
Write-Host "  访问: https://whoer.net" -ForegroundColor White
Write-Host "  检查项:" -ForegroundColor White
Write-Host "    ✓ 匿名评分应该 > 80%" -ForegroundColor Gray
Write-Host "    ✓ IP、DNS、时区应该匹配代理国家" -ForegroundColor Gray
Write-Host "    ✓ 不应该检测到代理或 VPN" -ForegroundColor Gray

Write-Host "`n[7] 时区检测" -ForegroundColor Yellow
Write-Host "  在浏览器控制台运行:" -ForegroundColor White
Write-Host "    console.log(Intl.DateTimeFormat().resolvedOptions().timeZone)" -ForegroundColor Gray
Write-Host "  检查项:" -ForegroundColor White
Write-Host "    ✓ 时区应该匹配代理国家" -ForegroundColor Gray
Write-Host "    ✓ 美国代理 → America/New_York 或 America/Los_Angeles" -ForegroundColor Gray
Write-Host "    ✓ 日本代理 → Asia/Tokyo" -ForegroundColor Gray
Write-Host "    ✓ 新加坡代理 → Asia/Singapore" -ForegroundColor Gray

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  快速测试命令" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

Write-Host "`n# 测试所有代理端口的 IP" -ForegroundColor Yellow
Write-Host "foreach (`$port in 7891..7897) {" -ForegroundColor Gray
Write-Host "    Write-Host `"端口 `$port:`"" -ForegroundColor Gray
Write-Host "    curl.exe --proxy socks5://127.0.0.1:`$port -s https://ipinfo.io/json | ConvertFrom-Json" -ForegroundColor Gray
Write-Host "}" -ForegroundColor Gray

Write-Host "`n# 测试 DNS 泄露" -ForegroundColor Yellow
Write-Host "curl.exe --proxy socks5://127.0.0.1:7891 -s https://www.dnsleaktest.com" -ForegroundColor Gray

Write-Host "`n# 测试 WebRTC 泄露" -ForegroundColor Yellow
Write-Host "# 在浏览器中访问: https://ipleak.net" -ForegroundColor Gray

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  ✓ 测试准备完成！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green

Write-Host "`n[!] 重要提示：" -ForegroundColor Yellow
Write-Host "  1. 确保所有浏览器都已启动" -ForegroundColor White
Write-Host "  2. 确保 Clash 正在运行且配置正确" -ForegroundColor White
Write-Host "  3. 逐个浏览器访问测试网站" -ForegroundColor White
Write-Host "  4. 记录每个浏览器的测试结果" -ForegroundColor White
Write-Host "  5. 如果发现泄露，检查配置并重新测试" -ForegroundColor White

Write-Host "`n[*] 是否打开测试网站？(Y/N)" -ForegroundColor Cyan
$openSites = Read-Host

if ($openSites -eq "Y" -or $openSites -eq "y") {
    Write-Host "`n[*] 打开测试网站..." -ForegroundColor Cyan
    foreach ($site in $testSites) {
        Write-Host "  → $($site.Name)" -ForegroundColor Yellow
        Start-Process $site.URL
        Start-Sleep -Seconds 2
    }
    Write-Host "`n[*] 所有测试网站已打开" -ForegroundColor Green
}

Write-Host "`n[*] 完成！" -ForegroundColor Green
