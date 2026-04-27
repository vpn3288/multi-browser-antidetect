#Requires -RunAsAdministrator

# ============================================================================
# Opera 配置诊断脚本
# ============================================================================

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Opera 配置诊断" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# 1. 检查 Opera 安装
Write-Host "[1/5] 检查 Opera 安装..." -ForegroundColor Yellow

$operaExePaths = @(
    "$env:LOCALAPPDATA\Programs\Opera\opera.exe",
    "C:\Program Files\Opera\launcher.exe",
    "C:\Program Files (x86)\Opera\launcher.exe"
)

$operaExe = $null
foreach ($path in $operaExePaths) {
    if (Test-Path $path) {
        $operaExe = $path
        Write-Host "  [✓] 找到 Opera: $path" -ForegroundColor Green
        break
    } else {
        Write-Host "  [✗] 未找到: $path" -ForegroundColor Gray
    }
}

if (-not $operaExe) {
    Write-Host "`n[✗] Opera 未安装" -ForegroundColor Red
    exit 1
}

# 2. 检查注册表策略路径
Write-Host "`n[2/5] 检查注册表策略..." -ForegroundColor Yellow

$operaPolicyPath = "HKLM:\SOFTWARE\Policies\Opera Software\Opera"

if (Test-Path $operaPolicyPath) {
    Write-Host "  [✓] 策略路径存在" -ForegroundColor Green
    
    # 列出所有策略
    $policies = Get-ItemProperty -Path $operaPolicyPath -ErrorAction SilentlyContinue
    if ($policies) {
        Write-Host "  [i] 已配置的策略：" -ForegroundColor Cyan
        $policies.PSObject.Properties | Where-Object { $_.Name -notlike "PS*" } | ForEach-Object {
            Write-Host "      $($_.Name) = $($_.Value)" -ForegroundColor Gray
        }
    }
} else {
    Write-Host "  [✗] 策略路径不存在" -ForegroundColor Red
}

# 3. 检查扩展配置
Write-Host "`n[3/5] 检查扩展配置..." -ForegroundColor Yellow

$extensionPolicyPath = "$operaPolicyPath\ExtensionInstallForcelist"

if (Test-Path $extensionPolicyPath) {
    Write-Host "  [✓] 扩展策略路径存在" -ForegroundColor Green
    
    $extensions = Get-ItemProperty -Path $extensionPolicyPath -ErrorAction SilentlyContinue
    if ($extensions) {
        Write-Host "  [i] 已配置的扩展：" -ForegroundColor Cyan
        $extensions.PSObject.Properties | Where-Object { $_.Name -notlike "PS*" } | ForEach-Object {
            Write-Host "      $($_.Name): $($_.Value)" -ForegroundColor Gray
        }
    } else {
        Write-Host "  [!] 扩展策略路径存在但为空" -ForegroundColor Yellow
    }
} else {
    Write-Host "  [✗] 扩展策略路径不存在" -ForegroundColor Red
}

# 4. 检查配置文件
Write-Host "`n[4/5] 检查配置文件..." -ForegroundColor Yellow

$operaProfile = "C:\BrowserProfiles\Opera"
$operaStableProfile = "$env:APPDATA\Opera Software\Opera Stable"

if (Test-Path $operaProfile) {
    Write-Host "  [✓] 自定义配置目录存在: $operaProfile" -ForegroundColor Green
    
    $preferencesPath = "$operaProfile\Preferences"
    if (Test-Path $preferencesPath) {
        Write-Host "  [✓] Preferences 文件存在" -ForegroundColor Green
    } else {
        Write-Host "  [!] Preferences 文件不存在" -ForegroundColor Yellow
    }
} else {
    Write-Host "  [!] 自定义配置目录不存在: $operaProfile" -ForegroundColor Yellow
}

if (Test-Path $operaStableProfile) {
    Write-Host "  [✓] Opera 默认配置目录存在: $operaStableProfile" -ForegroundColor Green
} else {
    Write-Host "  [!] Opera 默认配置目录不存在" -ForegroundColor Yellow
}

# 5. 检查 Opera 进程
Write-Host "`n[5/5] 检查 Opera 进程..." -ForegroundColor Yellow

$operaProcess = Get-Process opera -ErrorAction SilentlyContinue

if ($operaProcess) {
    Write-Host "  [!] Opera 正在运行（PID: $($operaProcess.Id)）" -ForegroundColor Yellow
    Write-Host "      需要关闭 Opera 才能应用配置" -ForegroundColor Gray
} else {
    Write-Host "  [✓] Opera 未运行" -ForegroundColor Green
}

# 总结
Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "诊断完成" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "建议操作：" -ForegroundColor Yellow

if (-not (Test-Path $operaPolicyPath)) {
    Write-Host "  1. 运行 .\OPERA_AUTO_CONFIG.ps1 创建策略配置" -ForegroundColor White
}

if ($operaProcess) {
    Write-Host "  2. 关闭 Opera 浏览器" -ForegroundColor White
}

Write-Host "  3. 重新运行 .\OPERA_AUTO_CONFIG.ps1" -ForegroundColor White
Write-Host "  4. 启动 Opera 并访问 opera://extensions/ 验证扩展" -ForegroundColor White
Write-Host ""
