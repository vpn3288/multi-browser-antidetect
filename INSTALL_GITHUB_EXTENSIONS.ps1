# GitHub 开源扩展安装脚本（适用于所有 Chromium 浏览器）
# 使用开发者模式加载未打包的扩展

$ErrorActionPreference = "Stop"

# ══════════════════════════════════════════════════════════════════
#  GitHub 开源扩展列表
# ══════════════════════════════════════════════════════════════════

$GitHubExtensions = @(
    @{
        Name = "Canvas Fingerprint Defender"
        Repo = "joue-quroi/canvas-fingerprint-defender"
        Branch = "master"
        Description = "Canvas 指纹防护"
    },
    @{
        Name = "WebRTC Leak Prevent"
        Repo = "aghorler/WebRTC-Leak-Prevent"
        Branch = "master"
        Description = "WebRTC IP 泄漏防护"
    },
    @{
        Name = "User-Agent Switcher"
        Repo = "ray-lothian/UserAgent-Switcher"
        Branch = "master"
        Description = "User-Agent 切换器"
    }
)

# ══════════════════════════════════════════════════════════════════
#  下载并安装 GitHub 扩展
# ══════════════════════════════════════════════════════════════════

function Install-GitHubExtension {
    param(
        [string]$Repo,
        [string]$Branch,
        [string]$Name,
        [string]$BrowserName,
        [string]$ExtensionDir
    )
    
    $repoName = $Repo.Split("/")[1]
    $downloadDir = "$env:TEMP\github-extensions\$repoName"
    $zipFile = "$env:TEMP\$repoName.zip"
    $downloadUrl = "https://github.com/$Repo/archive/refs/heads/$Branch.zip"
    
    Write-Host "`n[*] 下载 $Name..." -ForegroundColor Cyan
    
    # 下载 ZIP
    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFile -UseBasicParsing
        Write-Host "    [✓] 下载完成" -ForegroundColor Green
    } catch {
        Write-Host "    [!] 下载失败: $_" -ForegroundColor Red
        return $false
    }
    
    # 解压
    if (Test-Path $downloadDir) {
        Remove-Item -Path $downloadDir -Recurse -Force
    }
    Expand-Archive -Path $zipFile -DestinationPath $downloadDir -Force
    
    # 查找扩展目录（通常在解压后的第一层）
    $extractedFolder = Get-ChildItem -Path $downloadDir -Directory | Select-Object -First 1
    $sourceDir = $extractedFolder.FullName
    
    # 检查是否有 manifest.json
    if (-not (Test-Path "$sourceDir\manifest.json")) {
        # 尝试在子目录中查找
        $manifestPath = Get-ChildItem -Path $sourceDir -Recurse -Filter "manifest.json" | Select-Object -First 1
        if ($manifestPath) {
            $sourceDir = $manifestPath.DirectoryName
        } else {
            Write-Host "    [!] 未找到 manifest.json" -ForegroundColor Red
            return $false
        }
    }
    
    # 复制到浏览器扩展目录
    $targetDir = "$ExtensionDir\$repoName"
    if (Test-Path $targetDir) {
        Remove-Item -Path $targetDir -Recurse -Force
    }
    Copy-Item -Path $sourceDir -Destination $targetDir -Recurse -Force
    
    Write-Host "    [✓] 已安装到: $targetDir" -ForegroundColor Green
    Write-Host "    [!] 请在浏览器中启用开发者模式并加载此目录" -ForegroundColor Yellow
    
    # 清理
    Remove-Item -Path $zipFile -Force -ErrorAction SilentlyContinue
    
    return $true
}

# ══════════════════════════════════════════════════════════════════
#  为指定浏览器安装所有扩展
# ══════════════════════════════════════════════════════════════════

function Install-ForBrowser {
    param(
        [string]$BrowserName,
        [string]$ExtensionBaseDir
    )
    
    Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  为 $BrowserName 安装 GitHub 扩展" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    
    if (-not (Test-Path $ExtensionBaseDir)) {
        New-Item -Path $ExtensionBaseDir -ItemType Directory -Force | Out-Null
    }
    
    $successCount = 0
    foreach ($ext in $GitHubExtensions) {
        if (Install-GitHubExtension -Repo $ext.Repo -Branch $ext.Branch -Name $ext.Name -BrowserName $BrowserName -ExtensionDir $ExtensionBaseDir) {
            $successCount++
        }
    }
    
    Write-Host "`n[✓] 成功安装 $successCount/$($GitHubExtensions.Count) 个扩展" -ForegroundColor Green
    Write-Host "`n[!] 下一步操作：" -ForegroundColor Yellow
    Write-Host "    1. 打开 $BrowserName" -ForegroundColor Gray
    Write-Host "    2. 访问扩展管理页面（chrome://extensions 或类似）" -ForegroundColor Gray
    Write-Host "    3. 启用 [开发者模式]" -ForegroundColor Gray
    Write-Host "    4. 点击 [加载已解压的扩展程序]" -ForegroundColor Gray
    Write-Host "    5. 选择目录: $ExtensionBaseDir\<扩展名>" -ForegroundColor Gray
}

# ══════════════════════════════════════════════════════════════════
#  主菜单
# ══════════════════════════════════════════════════════════════════

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  GitHub 开源扩展安装脚本" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

Write-Host "`n选择目标浏览器：" -ForegroundColor White
Write-Host "  1. Chrome" -ForegroundColor Gray
Write-Host "  2. Edge" -ForegroundColor Gray
Write-Host "  3. Brave" -ForegroundColor Gray
Write-Host "  4. Opera" -ForegroundColor Gray
Write-Host "  5. Vivaldi" -ForegroundColor Gray
Write-Host "  6. 所有浏览器" -ForegroundColor Gray
Write-Host ""

$choice = Read-Host "请选择 (1-6)"

$browsers = @{
    "1" = @{Name="Chrome";  Dir="$env:LOCALAPPDATA\Google\Chrome\User Data\GithubExtensions"}
    "2" = @{Name="Edge";    Dir="$env:LOCALAPPDATA\Microsoft\Edge\User Data\GithubExtensions"}
    "3" = @{Name="Brave";   Dir="$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\GithubExtensions"}
    "4" = @{Name="Opera";   Dir="$env:APPDATA\Opera Software\Opera Stable\GithubExtensions"}
    "5" = @{Name="Vivaldi"; Dir="$env:LOCALAPPDATA\Vivaldi\User Data\GithubExtensions"}
}

switch ($choice) {
    "1" { Install-ForBrowser -BrowserName $browsers["1"].Name -ExtensionBaseDir $browsers["1"].Dir }
    "2" { Install-ForBrowser -BrowserName $browsers["2"].Name -ExtensionBaseDir $browsers["2"].Dir }
    "3" { Install-ForBrowser -BrowserName $browsers["3"].Name -ExtensionBaseDir $browsers["3"].Dir }
    "4" { Install-ForBrowser -BrowserName $browsers["4"].Name -ExtensionBaseDir $browsers["4"].Dir }
    "5" { Install-ForBrowser -BrowserName $browsers["5"].Name -ExtensionBaseDir $browsers["5"].Dir }
    "6" { 
        foreach ($key in $browsers.Keys) {
            Install-ForBrowser -BrowserName $browsers[$key].Name -ExtensionBaseDir $browsers[$key].Dir
            Start-Sleep -Seconds 2
        }
    }
    default { Write-Host "无效选择" -ForegroundColor Red }
}

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  完成！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
