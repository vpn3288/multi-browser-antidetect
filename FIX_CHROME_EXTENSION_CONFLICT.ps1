#Requires -RunAsAdministrator

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "修复 Chrome 扩展配置冲突" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/3] 检测配置冲突..." -ForegroundColor Yellow

# 检查 ExtensionSettings
$extSettings = Get-ChildItem "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionSettings" -ErrorAction SilentlyContinue

if ($extSettings) {
    Write-Host "  [!] 发现 ExtensionSettings 配置（可能与 ExtensionInstallForcelist 冲突）" -ForegroundColor Yellow
    
    foreach ($ext in $extSettings) {
        $props = Get-ItemProperty -Path $ext.PSPath
        if ($props.installation_mode -eq "blocked") {
            Write-Host "    [✗] $($ext.PSChildName): blocked（阻止安装）" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "[2/3] 清理冲突配置..." -ForegroundColor Yellow

# 删除 ExtensionSettings（使用 ExtensionInstallForcelist 更简单可靠）
if (Test-Path "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionSettings") {
    Remove-Item "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionSettings" -Recurse -Force
    Write-Host "  [✓] 已删除 ExtensionSettings" -ForegroundColor Green
}

# 删除可能存在的阻止列表
if (Test-Path "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallBlocklist") {
    Remove-Item "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallBlocklist" -Recurse -Force
    Write-Host "  [✓] 已删除 ExtensionInstallBlocklist" -ForegroundColor Green
}

Write-Host ""
Write-Host "[3/3] 验证 ExtensionInstallForcelist 配置..." -ForegroundColor Yellow

$forcelist = Get-ItemProperty "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist" -ErrorAction SilentlyContinue

if ($forcelist) {
    $count = ($forcelist.PSObject.Properties | Where-Object { $_.Name -notlike "PS*" }).Count
    Write-Host "  [✓] ExtensionInstallForcelist 配置正确（$count 个扩展）" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "  已配置的扩展：" -ForegroundColor Cyan
    $forcelist.PSObject.Properties | Where-Object { $_.Name -notlike "PS*" } | ForEach-Object {
        $extId = ($_.Value -split ";")[0]
        Write-Host "    $($_.Name). $extId" -ForegroundColor Gray
    }
} else {
    Write-Host "  [✗] ExtensionInstallForcelist 未配置" -ForegroundColor Red
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "修复完成！" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步操作：" -ForegroundColor Yellow
Write-Host "  1. 完全关闭 Chrome（包括后台进程）" -ForegroundColor White
Write-Host "  2. 重新启动 Chrome" -ForegroundColor White
Write-Host "  3. 等待 2-3 分钟让扩展自动下载" -ForegroundColor White
Write-Host "  4. 访问 chrome://extensions/ 查看扩展" -ForegroundColor White
Write-Host ""
Write-Host "如果扩展仍未安装，可能是：" -ForegroundColor Yellow
Write-Host "  • 代理阻止了 Chrome Web Store 访问" -ForegroundColor White
Write-Host "  • 需要首次启动时有网络连接" -ForegroundColor White
Write-Host "  • Chrome 版本过旧或过新" -ForegroundColor White
Write-Host ""
Write-Host "验证配置：访问 chrome://policy/ 查看策略" -ForegroundColor Cyan
Write-Host ""
