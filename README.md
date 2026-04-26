# 🌐 多浏览器反检测系统

**真实美国用户指纹伪装 + 极致隐私保护 + 8浏览器独立配置**

支持：Chrome、Chromium、Firefox、Edge、Brave、Opera、Vivaldi、LibreWolf

---

## ✨ 核心特性

### 🎭 真实指纹伪装
- ✅ **8种真实屏幕分辨率** - 基于StatCounter 2024真实数据
- ✅ **Canvas指纹随机化** - 微小噪声，肉眼不可见
- ✅ **WebGL指纹随机化** - 真实GPU型号（NVIDIA RTX 3060、Intel UHD 630等）
- ✅ **AudioContext指纹随机化** - 微小频率偏移
- ✅ **隐藏webdriver特征** - 完全隐藏自动化控制
- ✅ **每个浏览器唯一指纹** - 8个浏览器看起来像8台不同的真实电脑

### 🔒 极致隐私保护
- ✅ 阻止第三方Cookie
- ✅ WebRTC IP泄漏防护（仅显示代理IP）
- ✅ 禁用所有遥测和数据收集
- ✅ 禁用DNS预取和链接预取
- ✅ 追踪保护启用
- ✅ 第一方隔离（Firefox/LibreWolf）

### 🎯 完美用户体验
- ✅ 书签栏默认显示
- ✅ 主页和新标签页设置为空白页
- ✅ 书签在新标签页打开
- ✅ 禁用默认浏览器检查弹窗
- ✅ 关闭所有新闻、广告、促销内容

### ⚡ 性能优化
- ✅ 硬件加速启用
- ✅ V8引擎代码缓存（Chrome）
- ✅ WebRender加速（Firefox/LibreWolf）
- ✅ 缓存优化（100MB磁盘 + 50MB内存）
- ✅ 网络连接优化（256最大连接）

---

## 📥 快速安装（推荐）

### 方法1：一键下载安装（最简单，无需Git）

**复制以下命令到PowerShell（管理员）：**

```powershell
# 下载项目
Invoke-WebRequest -Uri "https://github.com/vpn3288/multi-browser-antidetect/archive/refs/heads/master.zip" -OutFile "$env:USERPROFILE\Desktop\multi-browser-antidetect.zip"

# 解压
Expand-Archive -Path "$env:USERPROFILE\Desktop\multi-browser-antidetect.zip" -DestinationPath "$env:USERPROFILE\Desktop" -Force

# 进入目录
cd "$env:USERPROFILE\Desktop\multi-browser-antidetect-master"

# 运行部署脚本
.\DEPLOY_8_BROWSERS.ps1
```

---

### 方法2：使用Git克隆（需要先安装Git）

```powershell
# 克隆仓库
git clone https://github.com/vpn3288/multi-browser-antidetect.git
cd multi-browser-antidetect

# 运行部署脚本
.\DEPLOY_8_BROWSERS.ps1
```

---

## 🔧 安装依赖（可选）

**如果你的系统没有 winget 或 Git，可以单独安装：**

### 安装 winget（Windows Package Manager）

```powershell
# 以管理员身份运行
$progressPreference = 'silentlyContinue'

# 安装 VCLibs
Invoke-WebRequest -Uri "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx" -OutFile "$env:TEMP\VCLibs.appx"
Add-AppxPackage -Path "$env:TEMP\VCLibs.appx"

# 安装 UI.Xaml
Invoke-WebRequest -Uri "https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx" -OutFile "$env:TEMP\UIXaml.appx"
Add-AppxPackage -Path "$env:TEMP\UIXaml.appx"

# 安装 App Installer (winget)
Invoke-WebRequest -Uri "https://aka.ms/getwinget" -OutFile "$env:TEMP\AppInstaller.msixbundle"
Add-AppxPackage -Path "$env:TEMP\AppInstaller.msixbundle"

# 清理
Remove-Item "$env:TEMP\VCLibs.appx", "$env:TEMP\UIXaml.appx", "$env:TEMP\AppInstaller.msixbundle" -Force

# 重启PowerShell后winget可用
```

### 安装 Git

```powershell
# 方法1：使用winget（推荐）
winget install --id Git.Git -e --silent

# 方法2：直接下载安装
Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe" -OutFile "$env:TEMP\GitInstaller.exe"
Start-Process -FilePath "$env:TEMP\GitInstaller.exe" -ArgumentList "/VERYSILENT /NORESTART" -Wait
Remove-Item "$env:TEMP\GitInstaller.exe" -Force

# 重启PowerShell后Git可用
```

**或者使用一键脚本：**

```powershell
.\INSTALL_DEPENDENCIES.ps1
```

---

## 🔧 详细安装步骤

### 步骤1：下载项目

**以管理员身份打开PowerShell：**
- 按 `Win + X`
- 选择 "Windows PowerShell (管理员)" 或 "终端 (管理员)"

**下载并解压：**

```powershell
# 下载
Invoke-WebRequest -Uri "https://github.com/vpn3288/multi-browser-antidetect/archive/refs/heads/master.zip" -OutFile "$env:USERPROFILE\Desktop\multi-browser-antidetect.zip"

# 解压
Expand-Archive -Path "$env:USERPROFILE\Desktop\multi-browser-antidetect.zip" -DestinationPath "$env:USERPROFILE\Desktop" -Force

# 进入目录
cd "$env:USERPROFILE\Desktop\multi-browser-antidetect-master"
```

---

### 步骤2：部署浏览器

**运行部署脚本：**

```powershell
.\DEPLOY_8_BROWSERS.ps1
```

**脚本会：**
1. 显示浏览器列表，让你选择要安装哪些
2. 自动下载并安装选中的浏览器
3. 应用所有优化配置
4. 生成启动脚本
5. 创建HTML报告

**选择示例：**
- 直接回车 = 安装所有8个浏览器
- 输入 `1,2,3` = 只安装 Chrome、Firefox、Edge
- 输入 `1` = 只安装 Chrome

---

### 步骤3：配置Clash代理

**编辑 `clash-config-template.yaml`，为每个端口分配不同的美国IP：**

```yaml
proxies:
  - name: "US-1"
    type: vmess
    server: your-server-1.com
    port: 443
    # ... 你的代理配置

  - name: "US-2"
    type: vmess
    server: your-server-2.com
    port: 443
    # ... 你的代理配置

proxy-groups:
  - name: "Chrome-7891"
    type: select
    proxies:
      - US-1
  
  - name: "Chromium-7892"
    type: select
    proxies:
      - US-2
  
  # ... 为每个端口配置不同的代理
```

**端口分配：**
- Chrome: 7891 (America/New_York)
- Chromium: 7892 (America/Chicago)
- Firefox: 7893 (America/Denver)
- Edge: 7894 (America/Los_Angeles)
- Brave: 7895 (America/Phoenix)
- Opera: 7896 (America/Anchorage)
- Vivaldi: 7897 (Pacific/Honolulu)
- LibreWolf: 7898 (America/Boise)

---

### 步骤4：启动浏览器

**方法1：使用批处理文件**

```batch
C:\BrowserProfiles\Launch_All.bat
```

**方法2：单独启动**

```batch
C:\BrowserProfiles\Launch_Chrome.bat
C:\BrowserProfiles\Launch_Firefox.bat
# ... 等等
```

---

## 🧪 验证效果

访问以下网站检查配置是否生效：

| 检查项目 | 网址 | 预期结果 |
|---------|------|---------|
| IP地址 | https://ip.sb | 显示代理IP（美国） |
| Canvas指纹 | https://browserleaks.com/canvas | 每个浏览器不同 |
| WebGL指纹 | https://browserleaks.com/webgl | 每个浏览器不同 |
| WebRTC泄漏 | https://browserleaks.com/webrtc | 仅显示代理IP |
| 设备信息 | https://www.deviceinfo.me/ | 真实的硬件配置 |
| 时区 | https://browserleaks.com/javascript | 美国时区 |

---

## 📁 文件结构

```
multi-browser-antidetect/
├── INSTALL_DEPENDENCIES.ps1          # 依赖安装脚本（新增）
├── DEPLOY_8_BROWSERS.ps1             # 主部署脚本（支持选择浏览器）
├── canvas_fingerprint_protection.js  # Canvas/WebGL/AudioContext指纹保护
├── FINGERPRINT_RANDOMIZER.ps1        # 指纹随机化配置生成器
├── LAUNCH_BROWSERS.ps1               # 浏览器启动脚本
├── clash-config-template.yaml        # Clash代理配置模板
├── README.md                         # 本文档
├── USAGE_GUIDE.md                    # 详细使用指南
├── OPTIMIZATION_SUMMARY.md           # 优化总结
├── QUICK_REFERENCE.md                # 快速参考
├── CHANGELOG.md                      # 更新日志
└── CODE_QUALITY_REPORT.md            # 代码质量检查报告
```

---

## 🎯 核心原理

### 为什么这个方案有效？

**传统方案的问题：**
- ❌ 使用 `privacy.resistFingerprinting` 让所有用户看起来一样（反而更可疑）
- ❌ 完全禁用WebGL会影响网站功能
- ❌ 使用假的硬件信息（999核CPU）一眼就能看出

**我们的方案：**
- ✅ **基于真实数据** - 所有参数来自2024年真实美国用户统计
- ✅ **微小差异** - Canvas噪声肉眼不可见，但改变指纹
- ✅ **合理配置** - 硬件在真实范围内（4-16核，8-32GB）
- ✅ **真实屏幕** - 使用真实常见分辨率
- ✅ **每个浏览器唯一** - 8个浏览器8种不同但都真实的配置
- ✅ **稳定指纹** - 同一浏览器指纹保持一致，不会频繁变化

---

## 🛠️ 故障排除

### 问题1：PowerShell执行策略错误

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 问题2：浏览器安装失败

**手动下载安装：**
- Chrome: https://www.google.com/chrome/
- Firefox: https://www.mozilla.org/firefox/
- Brave: https://brave.com/download/
- Opera: https://www.opera.com/download
- Vivaldi: https://vivaldi.com/download/
- LibreWolf: https://librewolf.net/installation/windows/

安装后重新运行 `DEPLOY_8_BROWSERS.ps1`，脚本会检测到已安装的浏览器并跳过安装步骤。

### 问题3：代理不工作

1. 确认Clash正在运行
2. 检查端口是否正确（7891-7898）
3. 访问 https://ip.sb 确认IP是否为代理IP

### 问题4：指纹没有变化

1. 清除浏览器缓存和Cookie
2. 重新运行 `DEPLOY_8_BROWSERS.ps1`
3. 确认 `canvas_fingerprint_protection.js` 已复制到配置目录

---

## 📊 优化项目清单

### Chromium系浏览器（Chrome、Chromium、Edge、Brave、Opera、Vivaldi）
- ✅ 注册表策略配置（50+项）
- ✅ 书签栏显示
- ✅ 空白主页和新标签页
- ✅ 禁用新闻、广告、促销
- ✅ 禁用默认浏览器检查
- ✅ 第三方Cookie阻止
- ✅ WebRTC IP泄漏防护
- ✅ 禁用遥测和数据收集

### Firefox系浏览器（Firefox、LibreWolf）
- ✅ user.js 配置（40+项）
- ✅ 书签栏显示
- ✅ 空白主页和新标签页
- ✅ 书签在新标签页打开
- ✅ 禁用新闻、广告、推荐
- ✅ 追踪保护启用
- ✅ 第一方隔离
- ✅ WebRTC禁用

### 所有浏览器
- ✅ Canvas/WebGL/AudioContext指纹随机化
- ✅ 真实屏幕分辨率和DPI缩放
- ✅ 真实硬件配置
- ✅ 美国时区
- ✅ 英语语言设置
- ✅ 隐藏webdriver特征

---

## 🔄 更新日志

查看 [CHANGELOG.md](CHANGELOG.md) 了解详细的版本更新历史。

---

## 📝 许可证

MIT License - 详见 [LICENSE](LICENSE)

---

## 🤝 贡献

欢迎提交Issue和Pull Request！

---

## ⚠️ 免责声明

本项目仅供学习和研究使用。请遵守当地法律法规，不要用于非法用途。

---

## 📞 支持

- GitHub Issues: https://github.com/vpn3288/multi-browser-antidetect/issues
- 文档: [USAGE_GUIDE.md](USAGE_GUIDE.md)
- 快速参考: [QUICK_REFERENCE.md](QUICK_REFERENCE.md)

---

**🎉 享受你的8个独立浏览器身份！**
