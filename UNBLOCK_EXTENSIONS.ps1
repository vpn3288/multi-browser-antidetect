# ══════════════════════════════════════════════════════════════════
#  解除浏览器扩展安装策略限制
#  需要管理员权限
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

# 检查管理员权限
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[错误] 需要管理员权限" -ForegroundColor Red
    Write-Host "[提示] 右键点击脚本 -> 以管理员身份运行" -ForegroundColor Yellow
    exit 1
}

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  解除浏览器扩展安装策略限制" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

# ══════════════════════════════════════════════════════════════════
#  Chrome / Brave / Vivaldi
# ══════════════════════════════════════════════════════════════════

$ChromePaths = @(
    "HKLM:\SOFTWARE\Policies\Google\Chrome",
    "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave",
    "HKLM:\SOFTWARE\Policies\Vivaldi"
)

foreach ($path in $ChromePaths) {
    if (Test-Path $path) {
        Write-Host "`n[*] 检查 $path" -ForegroundColor Gray
        
        # 删除阻止扩展安装的策略
        $blockKeys = @(
            "ExtensionInstallBlocklist",
            "ExtensionInstallForcelist",
            "ExtensionInstallWhitelist",
            "ExtensionSettings"
        )
        
        foreach ($key in $blockKeys) {
            if (Get-ItemProperty -Path $path -Name $key -ErrorAction SilentlyContinue) {
                Remove-ItemProperty -Path $path -Name $key -Force
                Write-Host "  [✓] 已删除 $key" -ForegroundColor Green
            }
        }
    }
}

# ══════════════════════════════════════════════════════════════════
#  Edge
# ══════════════════════════════════════════════════════════════════

$EdgePath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
if (Test-Path $EdgePath) {
    Write-Host "`n[*] 检查 $EdgePath" -ForegroundColor Gray
    
    $blockKeys = @(
        "ExtensionInstallBlocklist",
        "ExtensionInstallForcelist",
        "ExtensionInstallAllowlist",
        "ExtensionSettings"
    )
    
    foreach ($key in $blockKeys) {
        if (Get-ItemProperty -Path $EdgePath -Name $key -ErrorAction SilentlyContinue) {
            Remove-ItemProperty -Path $EdgePath -Name $key -Force
            Write-Host "  [✓] 已删除 $key" -ForegroundColor Green
        }
    }
}

# ══════════════════════════════════════════════════════════════════
#  Opera
# ══════════════════════════════════════════════════════════════════

$OperaPath = "HKLM:\SOFTWARE\Policies\Opera Software\Opera Stable"
if (Test-Path $OperaPath) {
    Write-Host "`n[*] 检查 $OperaPath" -ForegroundColor Gray
    
    $blockKeys = @(
        "ExtensionInstallBlocklist",
        "ExtensionInstallForcelist"
    )
    
    foreach ($key in $blockKeys) {
        if (Get-ItemProperty -Path $OperaPath -Name $key -ErrorAction SilentlyContinue) {
            Remove-ItemProperty -Path $OperaPath -Name $key -Force
            Write-Host "  [✓] 已删除 $key" -ForegroundColor Green
        }
    }
}

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  完成！请重启浏览器后再安装扩展" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
