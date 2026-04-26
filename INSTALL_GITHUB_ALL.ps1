# ══════════════════════════════════════════════════════════════════
#  GitHub 开源扩展自动安装脚本 - 全自动版
#  为所有浏览器安装精选开源反检测扩展
# ══════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"

# ══════════════════════════════════════════════════════════════════
#  精选 GitHub 开源扩展
# ══════════════════════════════════════════════════════════════════

$GitHubExtensions = @(
    @{
        Name = "Chameleon"
        Repo = "ghostwords/chameleon"
        Branch = "master"
        Description = "让 Chrome 伪装成 Tor Browser，检测并阻止指纹追踪"
        Stars = "1.2k+"
    },
    @{
        Name = "Canvas-FP-Defender"
        Repo = "sarperavci/canvas-fp-defender"
        Branch = "main"
        Description = "Canvas 指纹噪声注入，每次访问生成不同指纹"
        Stars = "200+"
    },
    @{
        Name = "WebRTC-Leak-Prevent"
        Repo = "aghorler/WebRTC-Leak-Prevent"
        Branch = "master"
        Description = "防止 WebRTC 泄漏真实 IP，支持 VPN/代理"
        Stars = "350+"
    },
    @{
        Name = "uBlock"
        Repo = "gorhill/uBlock"
        Branch = "master"
        Description = "最强广告拦截器，开源无后门"
        Stars = "45k+"
    }
)

# ══════════════════════════════════════════════════════════════════
#  下载并安装扩展
# ══════════════════════════════════════════════════════════════════

function Install-GitHubExtension {
    param(
        [hashtable]$Extension,
        [string]$TargetDir
    )
    
    $repoName = $Extension.Repo.Split("/")[1]
    $downloadDir = "$env:TEMP\github-extensions"
    $zipFile = "$downloadDir\$repoName.zip"
    $downloadUrl = "https://github.com/$($Extension.Repo)/archive/refs/heads/$($Extension.Branch).zip"
    
    Write-Host "`n[*] 下载 $($Extension.Name)..." -ForegroundColor Cyan
    Write-Host "    仓库: $($Extension.Repo) (⭐ $($Extension.Stars))" -ForegroundColor Gray
    
    # 创建临时目录
    if (-not (Test-Path $downloadDir)) {
        New-Item -Path $downloadDir -ItemType Directory -Force | Out-Null
    }
    
    # 下载 ZIP
    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFile -UseBasicParsing -TimeoutSec 60
        Write-Host "    [✓] 下载完成" -ForegroundColor Green
    } catch {
        Write-Host "    [✗] 下载失败: $_" -ForegroundColor Red
        return $false
    }
    
    # 解压
    $extractDir = "$downloadDir\$repoName"
    if (Test-Path $extractDir) {
        Remove-Item -Path $extractDir -Recurse -Force
    }
    Expand-Archive -Path $zipFile -DestinationPath $extractDir -Force
    
    # 查找 manifest.json
    $manifestPath = Get-ChildItem -Path $extractDir -Recurse -Filter "manifest.json" | Select-Object -First 1
    
    if (-not $manifestPath) {
        Write-Host "    [✗] 未找到 manifest.json" -ForegroundColor Red
        return $false
    }
    
    $sourceDir = $manifestPath.DirectoryName
    
    # 复制到目标目录
    $finalDir = "$TargetDir\$repoName"
    if (Test-Path $finalDir) {
        Remove-Item -Path $finalDir -Recurse -Force
    }
    Copy-Item -Path $sourceDir -Destination $finalDir -Recurse -Force
    
    Write-Host "    [✓] 已安装到: $finalDir" -ForegroundColor Green
    
    # 清理
    Remove-Item -Path $zipFile -Force -ErrorAction SilentlyContinue
    
    return $true
}

# ══════════════════════════════════════════════════════════════════
#  为浏览器安装所有扩展
# ══════════════════════════════════════════════════════════════════

function Install-ForBrowser {
    param(
        [string]$BrowserName,
        [string]$BrowserPath,
        [string]$ExtensionDir
    )
    
    if (-not (Test-Path $BrowserPath)) {
        Write-Host "`n[跳过] $BrowserName 未安装" -ForegroundColor Yellow
        return
    }
    
    Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  为 $BrowserName 安装 GitHub 开源扩展" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    
    if (-not (Test-Path $ExtensionDir)) {
        New-Item -Path $ExtensionDir -ItemType Directory -Force | Out-Null
    }
    
    $successCount = 0
    foreach ($ext in $GitHubExtensions) {
        if (Install-GitHubExtension -Extension $ext -TargetDir $ExtensionDir) {
            $successCount++
        }
        Start-Sleep -Seconds 1
    }
    
    Write-Host "`n[✓] 成功安装 $successCount/$($GitHubExtensions.Count) 个扩展" -ForegroundColor Green
    
    # 生成加载说明
    $instructionsFile = "$ExtensionDir\如何加载扩展.txt"
    $instructions = @"
═══════════════════════════════════════════════════════════════
  $BrowserName - 扩展加载说明
═══════════════════════════════════════════════════════════════

已下载的扩展位置：
$ExtensionDir

加载步骤：

1. 打开 $BrowserName

2. 访问扩展管理页面：
   - Chrome:   chrome://extensions/
   - Edge:     edge://extensions/
   - Brave:    brave://extensions/
   - Opera:    opera://extensions/
   - Vivaldi:  vivaldi://extensions/

3. 启用右上角的 [开发者模式]

4. 点击 [加载已解压的扩展程序]

5. 依次选择以下目录：
$(foreach ($ext in $GitHubExtensions) { "   - $ExtensionDir\$($ext.Repo.Split('/')[1])`n" })

═══════════════════════════════════════════════════════════════
  已安装的扩展功能说明
═══════════════════════════════════════════════════════════════

$(foreach ($ext in $GitHubExtensions) { 
"✓ $($ext.Name)
  $($ext.Description)
  GitHub: https://github.com/$($ext.Repo)
  Stars: $($ext.Stars)

" })
═══════════════════════════════════════════════════════════════
"@
    
    $instructions | Out-File -FilePath $instructionsFile -Encoding UTF8 -Force
    Write-Host "`n[!] 加载说明已保存到: $instructionsFile" -ForegroundColor Yellow
}

# ══════════════════════════════════════════════════════════════════
#  主程序
# ══════════════════════════════════════════════════════════════════

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  GitHub 开源扩展自动安装脚本 - 全自动版" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

Write-Host "`n将为所有浏览器安装以下精选开源扩展：" -ForegroundColor White
foreach ($ext in $GitHubExtensions) {
    Write-Host "  ✓ $($ext.Name) (⭐ $($ext.Stars))" -ForegroundColor Gray
}

$browsers = @(
    @{Name="Chrome";  Path="C:\Program Files\Google\Chrome\Application\chrome.exe";                      Dir="$env:LOCALAPPDATA\Google\Chrome\GithubExtensions"},
    @{Name="Edge";    Path="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe";                Dir="$env:LOCALAPPDATA\Microsoft\Edge\GithubExtensions"},
    @{Name="Brave";   Path="C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe";          Dir="$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\GithubExtensions"},
    @{Name="Opera";   Path="$env:LOCALAPPDATA\Programs\Opera\opera.exe";                                  Dir="$env:APPDATA\Opera Software\Opera Stable\GithubExtensions"},
    @{Name="Vivaldi"; Path="$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe";                           Dir="$env:LOCALAPPDATA\Vivaldi\GithubExtensions"}
)

foreach ($browser in $browsers) {
    Install-ForBrowser -BrowserName $browser.Name -BrowserPath $browser.Path -ExtensionDir $browser.Dir
    Start-Sleep -Seconds 2
}

Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  完成！" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "`n下一步：按照各浏览器目录下的说明文件加载扩展" -ForegroundColor Yellow
