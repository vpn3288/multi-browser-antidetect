#Requires -RunAsAdministrator

# ============================================================================
# 全浏览器配置诊断脚本
# ============================================================================

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "全浏览器配置诊断" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# 浏览器配置
$browsers = @{
    "Chrome" = @{
        Paths = @(
            "C:\Program Files\Google\Chrome\Application\chrome.exe",
            "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
        )
        PolicyPath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
        ProfilePath = "C:\BrowserProfiles\Chrome"
        ExpectedExtensions = 4
    }
    "Edge" = @{
        Paths = @(
            "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
            "C:\Program Files\Microsoft\Edge\Application\msedge.exe"
        )
        PolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
        ProfilePath = "C:\BrowserProfiles\Edge"
        ExpectedExtensions = 4
    }
    "Firefox" = @{
        Paths = @(
            "C:\Program Files\Mozilla Firefox\firefox.exe",
            "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
        )
        PolicyPath = "HKLM:\SOFTWARE\Policies\Mozilla\Firefox"
        ProfilePath = "C:\BrowserProfiles\Firefox"
        ExpectedExtensions = 4
        UsesJSON = $true
        JSONPath = "C:\Program Files\Mozilla Firefox\distribution\policies.json"
    }
    "Brave" = @{
        Paths = @(
            "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe",
            "C:\Program Files (x86)\BraveSoftware\Brave-Browser\Application\brave.exe"
        )
        PolicyPath = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"
        ProfilePath = "C:\BrowserProfiles\Brave"
        ExpectedExtensions = 4
    }
    "Vivaldi" = @{
        Paths = @(
            "$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe",
            "C:\Program Files\Vivaldi\Application\vivaldi.exe",
            "C:\Program Files (x86)\Vivaldi\Application\vivaldi.exe"
        )
        PolicyPath = "HKLM:\SOFTWARE\Policies\Vivaldi"
        ProfilePath = "C:\BrowserProfiles\Vivaldi"
        ExpectedExtensions = 4
    }
    "Opera" = @{
        Paths = @(
            "$env:LOCALAPPDATA\Programs\Opera\opera.exe",
            "C:\Program Files\Opera\launcher.exe",
            "C:\Program Files (x86)\Opera\launcher.exe"
        )
        PolicyPath = "HKLM:\SOFTWARE\Policies\Opera Software\Opera"
        ProfilePath = "C:\BrowserProfiles\Opera"
        ExpectedExtensions = 4
    }
    "Chromium" = @{
        Paths = @(
            "$env:LOCALAPPDATA\Chromium\Application\chrome.exe",
            "C:\Program Files\Chromium\Application\chrome.exe",
            "C:\Program Files (x86)\Chromium\Application\chrome.exe"
        )
        PolicyPath = "HKLM:\SOFTWARE\Policies\Chromium"
        ProfilePath = "C:\BrowserProfiles\Chromium"
        ExpectedExtensions = 4
    }
    "LibreWolf" = @{
        Paths = @(
            "C:\Program Files\LibreWolf\librewolf.exe",
            "C:\Program Files (x86)\LibreWolf\librewolf.exe"
        )
        PolicyPath = "HKLM:\SOFTWARE\Policies\LibreWolf"
        ProfilePath = "C:\BrowserProfiles\LibreWolf"
        ExpectedExtensions = 4
        UsesJSON = $true
        JSONPath = "C:\Program Files\LibreWolf\distribution\policies.json"
    }
}

$results = @{}
$totalBrowsers = $browsers.Count
$installedCount = 0
$configuredCount = 0
$extensionsOkCount = 0

foreach ($browserName in $browsers.Keys) {
    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "检查 $browserName" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    
    $browser = $browsers[$browserName]
    $result = @{
        Installed = $false
        InstallPath = $null
        PolicyConfigured = $false
        ExtensionsConfigured = $false
        ExtensionCount = 0
        ProfileExists = $false
        ProcessRunning = $false
        Issues = @()
    }
    
    # 1. 检查安装
    Write-Host "`n[1/5] 检查安装..." -ForegroundColor Yellow
    foreach ($path in $browser.Paths) {
        if (Test-Path $path) {
            $result.Installed = $true
            $result.InstallPath = $path
            Write-Host "  [✓] 已安装: $path" -ForegroundColor Green
            $installedCount++
            break
        }
    }
    
    if (-not $result.Installed) {
        Write-Host "  [✗] 未安装" -ForegroundColor Red
        $result.Issues += "浏览器未安装"
        $results[$browserName] = $result
        continue
    }
    
    # 2. 检查策略配置
    Write-Host "`n[2/5] 检查策略配置..." -ForegroundColor Yellow
    
    if ($browser.UsesJSON) {
        # Firefox 系浏览器检查 JSON 文件
        if (Test-Path $browser.JSONPath) {
            try {
                $policiesJson = Get-Content $browser.JSONPath -Raw | ConvertFrom-Json
                if ($policiesJson.policies) {
                    $result.PolicyConfigured = $true
                    $policyCount = ($policiesJson.policies.PSObject.Properties).Count
                    Write-Host "  [✓] 策略已配置: $($browser.JSONPath)" -ForegroundColor Green
                    Write-Host "  [i] 策略数量: $policyCount" -ForegroundColor Cyan
                } else {
                    Write-Host "  [✗] policies.json 格式错误" -ForegroundColor Red
                    $result.Issues += "policies.json 格式错误"
                }
            } catch {
                Write-Host "  [✗] 无法解析 policies.json: $($_.Exception.Message)" -ForegroundColor Red
                $result.Issues += "policies.json 解析失败"
            }
        } else {
            Write-Host "  [✗] policies.json 不存在" -ForegroundColor Red
            $result.Issues += "policies.json 不存在"
        }
    } else {
        # Chromium 系浏览器检查注册表
        if (Test-Path $browser.PolicyPath) {
            $result.PolicyConfigured = $true
            Write-Host "  [✓] 策略已配置: $($browser.PolicyPath)" -ForegroundColor Green
            
            # 列出关键策略
            $policies = Get-ItemProperty -Path $browser.PolicyPath -ErrorAction SilentlyContinue
            if ($policies) {
                $policyCount = ($policies.PSObject.Properties | Where-Object { $_.Name -notlike "PS*" }).Count
                Write-Host "  [i] 策略数量: $policyCount" -ForegroundColor Cyan
            }
        } else {
            Write-Host "  [✗] 策略未配置" -ForegroundColor Red
            $result.Issues += "注册表策略未配置"
        }
    }
    
    # 3. 检查扩展配置
    Write-Host "`n[3/5] 检查扩展配置..." -ForegroundColor Yellow
    
    if ($browser.UsesJSON) {
        # Firefox 系浏览器检查 JSON 文件中的 ExtensionSettings
        if (Test-Path $browser.JSONPath) {
            try {
                $policiesJson = Get-Content $browser.JSONPath -Raw | ConvertFrom-Json
                if ($policiesJson.policies.ExtensionSettings) {
                    # 计算强制安装的扩展数量（排除 "*" 通配符）
                    $extensionCount = 0
                    $policiesJson.policies.ExtensionSettings.PSObject.Properties | ForEach-Object {
                        if ($_.Name -ne "*" -and $_.Value.installation_mode -eq "force_installed") {
                            $extensionCount++
                        }
                    }
                    
                    $result.ExtensionCount = $extensionCount
                    $result.ExtensionsConfigured = $true
                    Write-Host "  [✓] 扩展已配置: $extensionCount 个" -ForegroundColor Green
                    
                    if ($extensionCount -eq $browser.ExpectedExtensions) {
                        Write-Host "  [✓] 扩展数量正确" -ForegroundColor Green
                        $extensionsOkCount++
                    } else {
                        Write-Host "  [!] 扩展数量不匹配: 期望 $($browser.ExpectedExtensions), 实际 $extensionCount" -ForegroundColor Yellow
                        $result.Issues += "扩展数量不匹配"
                    }
                    
                    # 列出扩展
                    Write-Host "  [i] 已配置的扩展：" -ForegroundColor Cyan
                    $policiesJson.policies.ExtensionSettings.PSObject.Properties | ForEach-Object {
                        if ($_.Name -ne "*") {
                            Write-Host "      $($_.Name)" -ForegroundColor Gray
                        }
                    }
                } else {
                    Write-Host "  [✗] ExtensionSettings 未配置" -ForegroundColor Red
                    $result.Issues += "扩展未配置"
                }
            } catch {
                Write-Host "  [✗] 无法解析扩展配置" -ForegroundColor Red
                $result.Issues += "扩展配置解析失败"
            }
        } else {
            Write-Host "  [✗] policies.json 不存在" -ForegroundColor Red
            $result.Issues += "扩展配置文件不存在"
        }
    } else {
        # Chromium 系浏览器检查注册表
        $extensionPath = "$($browser.PolicyPath)\ExtensionInstallForcelist"
        
        if (Test-Path $extensionPath) {
            $extensions = Get-ItemProperty -Path $extensionPath -ErrorAction SilentlyContinue
            if ($extensions) {
                $result.ExtensionCount = ($extensions.PSObject.Properties | Where-Object { $_.Name -notlike "PS*" }).Count
                $result.ExtensionsConfigured = $true
                Write-Host "  [✓] 扩展已配置: $($result.ExtensionCount) 个" -ForegroundColor Green
                
                if ($result.ExtensionCount -eq $browser.ExpectedExtensions) {
                    Write-Host "  [✓] 扩展数量正确" -ForegroundColor Green
                    $extensionsOkCount++
                } else {
                    Write-Host "  [!] 扩展数量不匹配: 期望 $($browser.ExpectedExtensions), 实际 $($result.ExtensionCount)" -ForegroundColor Yellow
                    $result.Issues += "扩展数量不匹配"
                }
                
                # 列出扩展
                Write-Host "  [i] 已配置的扩展：" -ForegroundColor Cyan
                $extensions.PSObject.Properties | Where-Object { $_.Name -notlike "PS*" } | ForEach-Object {
                    $extId = ($_.Value -split ";")[0]
                    Write-Host "      $($_.Name): $extId" -ForegroundColor Gray
                }
            }
        } else {
            Write-Host "  [✗] 扩展策略未配置" -ForegroundColor Red
            $result.Issues += "扩展策略未配置"
        }
    }
    
    # 4. 检查配置文件目录
    Write-Host "`n[4/5] 检查配置文件..." -ForegroundColor Yellow
    if (Test-Path $browser.ProfilePath) {
        $result.ProfileExists = $true
        Write-Host "  [✓] 配置目录存在: $($browser.ProfilePath)" -ForegroundColor Green
    } else {
        Write-Host "  [!] 配置目录不存在: $($browser.ProfilePath)" -ForegroundColor Yellow
        $result.Issues += "配置目录不存在"
    }
    
    # 5. 检查进程
    Write-Host "`n[5/5] 检查进程..." -ForegroundColor Yellow
    $processName = [System.IO.Path]::GetFileNameWithoutExtension($result.InstallPath)
    $process = Get-Process $processName -ErrorAction SilentlyContinue
    
    if ($process) {
        $result.ProcessRunning = $true
        Write-Host "  [!] 浏览器正在运行 (PID: $($process.Id))" -ForegroundColor Yellow
        Write-Host "      建议关闭后重新配置" -ForegroundColor Gray
    } else {
        Write-Host "  [✓] 浏览器未运行" -ForegroundColor Green
    }
    
    # 统计配置完整性
    if ($result.PolicyConfigured -and $result.ExtensionsConfigured -and $result.ExtensionCount -eq $browser.ExpectedExtensions) {
        $configuredCount++
    }
    
    $results[$browserName] = $result
}

# ============================================================================
# 生成总结报告
# ============================================================================

Write-Host "`n`n" -NoNewline
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "诊断总结" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "浏览器安装情况: $installedCount / $totalBrowsers" -ForegroundColor $(if ($installedCount -eq $totalBrowsers) { "Green" } else { "Yellow" })
Write-Host "配置完整性: $configuredCount / $installedCount" -ForegroundColor $(if ($configuredCount -eq $installedCount) { "Green" } else { "Yellow" })
Write-Host "扩展配置正确: $extensionsOkCount / $installedCount" -ForegroundColor $(if ($extensionsOkCount -eq $installedCount) { "Green" } else { "Yellow" })
Write-Host ""

# 详细问题列表
$browsersWithIssues = $results.GetEnumerator() | Where-Object { $_.Value.Issues.Count -gt 0 }

if ($browsersWithIssues) {
    Write-Host "发现的问题：" -ForegroundColor Yellow
    Write-Host ""
    
    foreach ($item in $browsersWithIssues) {
        Write-Host "  $($item.Key):" -ForegroundColor White
        foreach ($issue in $item.Value.Issues) {
            Write-Host "    • $issue" -ForegroundColor Red
        }
    }
    Write-Host ""
}

# 未安装的浏览器
$notInstalled = $results.GetEnumerator() | Where-Object { -not $_.Value.Installed }
if ($notInstalled) {
    Write-Host "未安装的浏览器：" -ForegroundColor Yellow
    foreach ($item in $notInstalled) {
        Write-Host "  • $($item.Key)" -ForegroundColor Gray
    }
    Write-Host ""
}

# 建议操作
Write-Host "建议操作：" -ForegroundColor Cyan
Write-Host ""

if ($configuredCount -lt $installedCount) {
    Write-Host "  1. 运行 .\CONFIGURE_ALL_BROWSERS.ps1 重新配置所有浏览器" -ForegroundColor White
}

$runningBrowsers = $results.GetEnumerator() | Where-Object { $_.Value.ProcessRunning }
if ($runningBrowsers) {
    Write-Host "  2. 关闭以下正在运行的浏览器：" -ForegroundColor White
    foreach ($item in $runningBrowsers) {
        Write-Host "     • $($item.Key)" -ForegroundColor Gray
    }
}

if ($extensionsOkCount -lt $installedCount) {
    Write-Host "  3. 检查扩展配置，确保每个浏览器都有 4 个标准扩展" -ForegroundColor White
}

Write-Host "  4. 启动浏览器并访问扩展页面验证：" -ForegroundColor White
Write-Host "     • Chrome/Edge/Chromium/Vivaldi/Opera/Brave: chrome://extensions/" -ForegroundColor Gray
Write-Host "     • Firefox/LibreWolf: about:addons" -ForegroundColor Gray

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
