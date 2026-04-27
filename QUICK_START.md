# 快速开始指南

## 一键配置所有浏览器

### 前置要求
- ✅ Windows 11
- ✅ PowerShell 7.6.1+
- ✅ 管理员权限
- ✅ 已安装目标浏览器
- ✅ 代理服务运行在 `127.0.0.1:7890`

### 步骤 1：克隆项目

```powershell
# 以管理员身份打开 PowerShell
git clone https://github.com/vpn3288/multi-browser-antidetect.git
cd multi-browser-antidetect
```

### 步骤 2：配置所有浏览器

```powershell
# 运行主配置脚本
.\CONFIGURE_ALL_BROWSERS.ps1
```

选择配置模式：
- **选项 1：** 配置所有已安装的浏览器（推荐）
- **选项 2：** 选择要配置的浏览器

### 步骤 3：验证配置

```powershell
# 运行诊断脚本
.\DIAGNOSE_ALL_BROWSERS.ps1
```

预期结果：
```
浏览器安装情况: 8 / 8
配置完整性: 8 / 8
扩展配置正确: 8 / 8
```

### 步骤 4：启动浏览器

```powershell
# 启动 Chrome
.\LAUNCH_CHROME.ps1

# 启动 Firefox
.\LAUNCH_FIREFOX.ps1

# 启动其他浏览器
.\LAUNCH_EDGE.ps1
.\LAUNCH_BRAVE.ps1
.\LAUNCH_CHROMIUM.ps1
.\LAUNCH_VIVALDI.ps1
.\LAUNCH_OPERA.ps1
.\LAUNCH_LIBREWOLF.ps1
```

## 验证优化效果

### 1. 检查企业策略

**Chromium 系浏览器：**
- 访问 `chrome://policy/`
- 查找以下策略：
  - `WebRtcIPHandling`: `disable_non_proxied_udp`
  - `ProxyMode`: `fixed_servers`
  - `ExtensionInstallForcelist`: 4 个扩展

**Firefox 系浏览器：**
- 访问 `about:policies`
- 查找以下策略：
  - `DisableTelemetry`: `true`
  - `EnableTrackingProtection`: `Fingerprinting: true`
  - `ExtensionSettings`: 4 个扩展

### 2. 检查扩展

**Chromium 系：** 访问 `chrome://extensions/`

**Firefox 系：** 访问 `about:addons`

应该看到 4 个扩展：
- ✅ uBlock Origin
- ✅ Privacy Badger
- ✅ HTTPS Everywhere
- ✅ Decentraleyes

### 3. 检查代理

访问 https://ipinfo.io 或 https://whoer.net

应该显示代理 IP，而不是真实 IP。

### 4. 检查 WebRTC 泄露

访问 https://browserleaks.com/webrtc

应该只显示代理 IP，不显示本地 IP。

## 常见问题

### Q1: 浏览器检测失败？

**A:** 检查浏览器安装路径

```powershell
# 手动检查路径
Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe"
Test-Path "$env:LOCALAPPDATA\Chromium\Application\chrome.exe"
```

如果路径不同，编辑 `CONFIGURE_ALL_BROWSERS.ps1` 中的路径。

### Q2: 扩展未自动安装？

**A:** 运行扩展修复脚本

```powershell
# Chromium 系浏览器
.\FIX_EXTENSIONS.ps1

# Opera 特殊处理
.\FIX_OPERA_EXTENSIONS.ps1
.\INSTALL_OPERA_EXTENSIONS_MANUAL.ps1
```

### Q3: Firefox 显示"策略未配置"？

**A:** 这是诊断脚本的误报。验证方法：

```powershell
# 检查 JSON 文件
Test-Path "C:\Program Files\Mozilla Firefox\distribution\policies.json"
Get-Content "C:\Program Files\Mozilla Firefox\distribution\policies.json" | Select-String "policies"
```

在 Firefox 中访问 `about:policies` 应该能看到配置。

### Q4: Git 无法连接 GitHub？

**A:** 临时禁用代理

```powershell
$env:HTTP_PROXY = ""
$env:HTTPS_PROXY = ""
git pull
```

### Q5: 代理不工作？

**A:** 检查代理服务

```powershell
# 测试代理连接
Test-NetConnection -ComputerName 127.0.0.1 -Port 7890

# 检查代理配置
Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" | Select-Object ProxyServer
```

## 高级配置

### 修改代理地址

编辑启动脚本中的代理配置：

```powershell
# 例如：LAUNCH_CHROME.ps1
$proxy = "socks5://127.0.0.1:7890"  # 修改为你的代理地址
```

### 添加更多扩展

编辑配置脚本中的扩展列表：

```powershell
# 例如：CHROME_ENTERPRISE_CONFIG.ps1
Set-ItemProperty -Path "$extensionPath" -Name "5" -Value "扩展ID;https://clients2.google.com/service/update2/crx"
```

### 自定义浏览器参数

编辑启动脚本中的 `$args` 数组：

```powershell
$args = @(
    "--user-data-dir=$profilePath",
    "--proxy-server=$proxy",
    # 添加更多参数
    "--your-custom-flag"
)
```

## 维护建议

### 定期检查配置

```powershell
# 每周运行一次诊断
.\DIAGNOSE_ALL_BROWSERS.ps1
```

### 更新浏览器后重新配置

```powershell
# 浏览器更新后可能重置某些配置
.\CONFIGURE_ALL_BROWSERS.ps1
```

### 备份配置

```powershell
# 备份配置文件
Copy-Item "C:\BrowserProfiles" "D:\Backup\BrowserProfiles" -Recurse
```

## 卸载

### 移除企业策略

```powershell
# 删除注册表策略
Remove-Item "HKLM:\SOFTWARE\Policies\Google\Chrome" -Recurse -Force
Remove-Item "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Recurse -Force
Remove-Item "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -Recurse -Force
Remove-Item "HKLM:\SOFTWARE\Policies\Chromium" -Recurse -Force
Remove-Item "HKLM:\SOFTWARE\Policies\Vivaldi" -Recurse -Force
Remove-Item "HKLM:\SOFTWARE\Policies\Opera Software\Opera" -Recurse -Force

# 删除 Firefox JSON 配置
Remove-Item "C:\Program Files\Mozilla Firefox\distribution\policies.json" -Force
Remove-Item "C:\Program Files\LibreWolf\distribution\policies.json" -Force
```

### 删除配置文件

```powershell
# 删除独立配置目录
Remove-Item "C:\BrowserProfiles" -Recurse -Force
```

## 技术支持

- **GitHub Issues:** https://github.com/vpn3288/multi-browser-antidetect/issues
- **文档:** 查看 `OPTIMIZATION_SUMMARY.md`
- **诊断:** 运行 `DIAGNOSE_ALL_BROWSERS.ps1`

## 相关资源

- [Chrome 企业策略文档](https://chromeenterprise.google/policies/)
- [Firefox 企业策略文档](https://github.com/mozilla/policy-templates)
- [浏览器指纹检测工具](https://browserleaks.com/)
- [代理测试工具](https://whoer.net/)
