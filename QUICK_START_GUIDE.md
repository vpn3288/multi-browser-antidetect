# 🚀 快速使用指南

## 📦 你现在拥有的脚本

### 1. **DEPLOY_8_BROWSERS.ps1** - 主部署脚本
一键安装和配置所有8个浏览器

```powershell
.\DEPLOY_8_BROWSERS.ps1
```

**功能：**
- ✅ 安装 Chrome, Chromium, Firefox, Edge, Brave, Opera, Vivaldi, LibreWolf
- ✅ 应用基础优化配置
- ✅ 配置指纹随机化
- ✅ 可选择安装哪些浏览器

---

### 2. **FIX_BLANK_HOMEPAGE.ps1** - 修复空白主页 ⭐ 推荐运行
修复 Opera、Vivaldi、Brave 不显示空白标签页的问题

```powershell
.\FIX_BLANK_HOMEPAGE.ps1
```

**修复内容：**
- ✅ 正确配置 `HomepageIsNewTabPage = 0`
- ✅ 正确配置 `RestoreOnStartup = 4`
- ✅ 添加 `RestoreOnStartupURLs = ["about:blank"]`
- ✅ 确保所有浏览器显示空白主页

**重要：** 这个脚本使用官方验证的正确参数，解决了主脚本中的配置错误

---

### 3. **INSTALL_EXTENSIONS.ps1** - 自动安装隐私扩展 ⭐ 强烈推荐
自动安装5个隐私和安全扩展到所有浏览器

```powershell
.\INSTALL_EXTENSIONS.ps1
```

**安装的扩展：**
- 🛡️ **uBlock Origin** - 广告和追踪拦截
- 🔒 **Privacy Badger** - 智能追踪保护
- 📦 **Decentraleyes** - 本地 CDN 模拟（防止 CDN 追踪）
- 🎨 **Canvas Defender** - Canvas 指纹保护（Chromium 系）
- 🔗 **ClearURLs** - 清理 URL 追踪参数

**工作原理：**
- Chromium 系：通过 `ExtensionInstallForcelist` 注册表策略
- Firefox 系：通过 `distribution/policies.json` 企业策略
- 首次启动浏览器时自动下载和安装
- 扩展会自动更新

---

### 4. **BROWSER_OPTIMIZATION_VERIFIED.ps1** - 完整优化配置
应用所有官方验证的优化配置（独立脚本，可单独运行）

```powershell
.\BROWSER_OPTIMIZATION_VERIFIED.ps1
```

**包含：**
- ✅ 所有浏览器的完整优化配置
- ✅ 每个配置都经过官方文档验证
- ✅ 详细的配置说明和注释

---

## 🎯 推荐使用流程

### 方案A：完整部署（推荐）

```powershell
# 1. 安装所有浏览器
.\DEPLOY_8_BROWSERS.ps1

# 2. 修复空白主页配置
.\FIX_BLANK_HOMEPAGE.ps1

# 3. 安装隐私扩展
.\INSTALL_EXTENSIONS.ps1

# 4. 重启所有浏览器
```

### 方案B：已安装浏览器，只需优化

```powershell
# 1. 修复空白主页配置
.\FIX_BLANK_HOMEPAGE.ps1

# 2. 安装隐私扩展
.\INSTALL_EXTENSIONS.ps1

# 3. 重启所有浏览器
```

---

## ⚠️ 重要提示

### 1. 管理员权限
所有脚本都需要管理员权限运行：
```powershell
# 右键点击 PowerShell → "以管理员身份运行"
```

### 2. 重启浏览器
配置修改后必须重启浏览器才能生效：
```powershell
# 关闭所有浏览器进程
Get-Process chrome,chromium,firefox,msedge,brave,opera,vivaldi,librewolf -ErrorAction SilentlyContinue | Stop-Process -Force
```

### 3. Opera 和 Vivaldi 特殊说明
如果 Opera/Vivaldi 仍显示 Speed Dial：
1. 打开浏览器设置
2. 找到"启动时"或"主页"设置
3. 选择"打开特定页面"
4. 输入 `about:blank`

### 4. 书签在新标签页打开
只有 Firefox 和 LibreWolf 支持此功能（通过 `browser.tabs.loadBookmarksInTabs` 配置）

Chromium 系浏览器不支持此策略，用户需要：
- 按住 Ctrl + 点击书签
- 或使用鼠标中键点击书签

---

## 📊 配置效果验证

### 检查空白主页是否生效

**Chromium 系浏览器：**
```powershell
# 检查注册表配置（以 Chrome 为例）
Get-ItemProperty "HKLM:\SOFTWARE\Policies\Google\Chrome" | Select-Object HomepageLocation, HomepageIsNewTabPage, RestoreOnStartup
Get-ItemProperty "HKLM:\SOFTWARE\Policies\Google\Chrome\RestoreOnStartupURLs" | Select-Object 1
```

**Firefox：**
```powershell
# 检查 user.js 文件
$profile = Get-ChildItem "$env:APPDATA\Mozilla\Firefox\Profiles" | Where-Object { $_.Name -like "*.default*" } | Select-Object -First 1
Get-Content "$($profile.FullName)\user.js"
```

### 检查扩展是否安装

**Chromium 系浏览器：**
```powershell
# 检查扩展策略（以 Chrome 为例）
Get-ItemProperty "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist"
```

**Firefox：**
```powershell
# 检查 policies.json
Get-Content "C:\Program Files\Mozilla Firefox\distribution\policies.json" | ConvertFrom-Json
```

---

## 🔍 故障排除

### 问题1：空白主页不生效

**解决方案：**
```powershell
# 1. 运行修复脚本
.\FIX_BLANK_HOMEPAGE.ps1

# 2. 完全关闭浏览器
Get-Process chrome,brave,opera,vivaldi -ErrorAction SilentlyContinue | Stop-Process -Force

# 3. 重新启动浏览器
```

### 问题2：扩展没有自动安装

**解决方案：**
```powershell
# 1. 确认策略已配置
Get-ItemProperty "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist"

# 2. 完全关闭浏览器
Get-Process chrome -ErrorAction SilentlyContinue | Stop-Process -Force

# 3. 清除浏览器缓存（可选）
Remove-Item "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache" -Recurse -Force -ErrorAction SilentlyContinue

# 4. 重新启动浏览器，等待扩展下载
```

### 问题3：Brave 安装失败

**解决方案：**
```powershell
# 手动下载安装
$url = "https://laptop-updates.brave.com/latest/winx64"
$output = "$env:TEMP\BraveSetup.exe"
Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing
Start-Process -FilePath $output -ArgumentList "/silent /install" -Wait
```

---

## 📚 文档

### OPTIMIZATION_VERIFICATION_REPORT.md
完整的验证报告，包含：
- ✅ 所有8个浏览器的配置验证结果
- ✅ 每个策略的官方文档链接
- ✅ 扩展 ID 和下载链接
- ✅ 最佳隐私浏览器排名
- ✅ 配置对比表

---

## 🎯 最佳实践

### 1. 隐私保护最大化

**推荐浏览器组合：**
- 🥇 **LibreWolf** - 日常浏览（最强隐私）
- 🥈 **Brave** - 备用浏览器（内置保护）
- 🥉 **Firefox** - 需要定制时使用

### 2. 指纹伪装

每个浏览器使用不同的 Clash 代理端口（7891-7898），配合脚本中的指纹随机化：
- 不同的屏幕分辨率
- 不同的时区
- 不同的语言设置
- Canvas/WebGL 噪声注入

### 3. 定期更新

```powershell
# 更新仓库
cd ~/multi-browser-antidetect
git pull origin master

# 重新运行优化脚本
.\FIX_BLANK_HOMEPAGE.ps1
.\INSTALL_EXTENSIONS.ps1
```

---

## 🆘 需要帮助？

查看详细文档：
- `OPTIMIZATION_VERIFICATION_REPORT.md` - 完整验证报告
- `README.md` - 项目说明
- `CHANGELOG.md` - 更新日志

---

**最后更新：** 2026年4月27日  
**版本：** 2.0 - 官方验证版
