# 多浏览器反检测优化配置

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PowerShell](https://img.shields.io/badge/PowerShell-7.6.1+-blue.svg)](https://github.com/PowerShell/PowerShell)
[![Windows](https://img.shields.io/badge/Windows-11-0078D6.svg)](https://www.microsoft.com/windows)

为 Windows 11 系统配置 8 款主流浏览器的企业级隐私保护和反检测优化。

## ✨ 核心功能

- 🛡️ **反自动化检测** - 隐藏 `navigator.webdriver` 和自动化特征
- 🔒 **WebRTC IP 防护** - 防止真实 IP 通过 WebRTC 泄露
- 🎭 **指纹识别防护** - Canvas/WebGL 指纹随机化
- 🚫 **隐私保护** - 禁用遥测、追踪和数据收集
- 🌐 **强制代理** - 所有流量通过 SOCKS5 代理
- 🧩 **扩展管理** - 自动安装 4 个隐私保护扩展
- 📁 **独立配置** - 每个浏览器使用独立配置文件

## 🎯 支持的浏览器

| 浏览器 | 配置方式 | 状态 |
|--------|----------|------|
| Chrome | 注册表策略 | ✅ 完美 |
| Edge | 注册表策略 | ✅ 完美 |
| Firefox | JSON 策略 | ✅ 完美 |
| Brave | 注册表策略 | ✅ 完美 |
| Chromium | 注册表策略 | ✅ 完美 |
| Vivaldi | 注册表策略 | ✅ 完美 |
| Opera | 注册表策略 | ✅ 完美 |
| LibreWolf | JSON 策略 | ✅ 完美 |

## 🚀 快速开始

### 前置要求

- Windows 11
- PowerShell 7.6.1+
- 管理员权限
- 代理服务运行在 `127.0.0.1:7890`

### 一键配置

```powershell
# 克隆项目
git clone https://github.com/vpn3288/multi-browser-antidetect.git
cd multi-browser-antidetect

# 配置所有浏览器（以管理员身份运行）
.\CONFIGURE_ALL_BROWSERS.ps1

# 验证配置
.\DIAGNOSE_ALL_BROWSERS.ps1

# 启动浏览器
.\LAUNCH_CHROME.ps1
```

详细步骤请查看 [快速开始指南](QUICK_START.md)

## 📋 主要脚本

### 配置脚本
- `CONFIGURE_ALL_BROWSERS.ps1` - 一键配置所有浏览器
- `FIX_EXTENSIONS.ps1` - 修复扩展配置
- `FIX_FIREFOX_JSON.ps1` - 修复 Firefox/LibreWolf JSON 配置
- `FIX_OPERA_EXTENSIONS.ps1` - Opera 扩展配置修复

### 诊断脚本
- `DIAGNOSE_ALL_BROWSERS.ps1` - 全浏览器配置诊断

### 启动脚本
- `LAUNCH_CHROME.ps1` - 启动 Chrome
- `LAUNCH_EDGE.ps1` - 启动 Edge
- `LAUNCH_FIREFOX.ps1` - 启动 Firefox
- `LAUNCH_BRAVE.ps1` - 启动 Brave
- `LAUNCH_CHROMIUM.ps1` - 启动 Chromium
- `LAUNCH_VIVALDI.ps1` - 启动 Vivaldi
- `LAUNCH_OPERA.ps1` - 启动 Opera
- `LAUNCH_LIBREWOLF.ps1` - 启动 LibreWolf

## 🔧 配置详情

### 反检测优化

```powershell
# 隐藏自动化特征
--disable-blink-features=AutomationControlled
--disable-automation

# WebRTC IP 防护
WebRtcIPHandling: disable_non_proxied_udp

# 指纹防护
EnableTrackingProtection: Fingerprinting: true
```

### 隐私保护扩展

| 扩展 | 功能 |
|------|------|
| uBlock Origin | 广告拦截 |
| Privacy Badger | 追踪器拦截 |
| HTTPS Everywhere | 强制 HTTPS |
| Decentraleyes | CDN 本地化 |

### 代理配置

所有浏览器强制使用 SOCKS5 代理：
```
socks5://127.0.0.1:7890
```

### 独立配置文件

```
C:\BrowserProfiles\
├── Chrome\
├── Edge\
├── Firefox\
├── Brave\
├── Chromium\
├── Vivaldi\
├── Opera\
└── LibreWolf\
```

## 📊 验证配置

### 检查企业策略

**Chromium 系：** 访问 `chrome://policy/`

**Firefox 系：** 访问 `about:policies`

### 检查扩展

**Chromium 系：** 访问 `chrome://extensions/`

**Firefox 系：** 访问 `about:addons`

### 检查代理和 IP 泄露

- 代理测试：https://whoer.net
- WebRTC 泄露测试：https://browserleaks.com/webrtc
- 指纹测试：https://browserleaks.com/canvas

## 📖 文档

- [快速开始指南](QUICK_START.md) - 详细安装和配置步骤
- [优化总结](OPTIMIZATION_SUMMARY.md) - 完整的优化功能说明
- [故障排除](QUICK_START.md#常见问题) - 常见问题解决方案

## 🔍 诊断输出示例

```
============================================
全浏览器配置诊断
============================================

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
检查 Chrome
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1/5] 检查安装...
  [✓] 已安装: C:\Program Files\Google\Chrome\Application\chrome.exe

[2/5] 检查策略配置...
  [✓] 策略已配置: HKLM:\SOFTWARE\Policies\Google\Chrome
  [i] 策略数量: 57

[3/5] 检查扩展配置...
  [✓] 扩展已配置: 4 个
  [✓] 扩展数量正确

[4/5] 检查配置文件...
  [✓] 配置目录存在: C:\BrowserProfiles\Chrome

[5/5] 检查进程...
  [✓] 浏览器未运行

============================================
诊断总结
============================================

浏览器安装情况: 8 / 8
配置完整性: 8 / 8
扩展配置正确: 8 / 8
```

## ⚠️ 已知问题

### Opera 扩展自动安装
Opera 对 Chromium 企业策略的扩展强制安装支持不完整。

**解决方案：**
```powershell
.\INSTALL_OPERA_EXTENSIONS_MANUAL.ps1
```

### Firefox/LibreWolf 诊断误报
诊断脚本可能显示"策略未配置"，但实际配置已生效。

**验证方法：** 访问 `about:policies`

## 🛠️ 高级配置

### 修改代理地址

编辑启动脚本：
```powershell
$proxy = "socks5://your-proxy-ip:port"
```

### 添加更多扩展

编辑配置脚本中的扩展列表：
```powershell
Set-ItemProperty -Path "$extensionPath" -Name "5" -Value "扩展ID;https://clients2.google.com/service/update2/crx"
```

### 自定义浏览器参数

编辑启动脚本中的 `$args` 数组。

## 🔄 更新日志

### 2026-04-27
- ✅ 修复浏览器路径检测（支持用户目录安装）
- ✅ 统一扩展配置为 4 个标准扩展
- ✅ 修复 Firefox/LibreWolf JSON 注释问题
- ✅ 优化诊断脚本（支持 JSON 策略检查）
- ✅ 添加 Opera 扩展手动安装脚本
- ✅ 完善文档和配置验证

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 🔗 相关资源

- [Chrome 企业策略文档](https://chromeenterprise.google/policies/)
- [Firefox 企业策略文档](https://github.com/mozilla/policy-templates)
- [浏览器指纹检测工具](https://browserleaks.com/)
- [代理测试工具](https://whoer.net/)

## ⚡ 性能影响

- **启动时间：** +1-2 秒（首次启动）
- **内存占用：** +50-100MB/浏览器
- **网络延迟：** 取决于代理性能
- **扩展影响：** 可忽略

## 🔐 安全建议

1. 定期更新浏览器和扩展
2. 验证代理连接安全性
3. 定期运行诊断脚本
4. 备份配置文件

## 📞 技术支持

- **GitHub Issues:** [提交问题](https://github.com/vpn3288/multi-browser-antidetect/issues)
- **文档:** 查看 [OPTIMIZATION_SUMMARY.md](OPTIMIZATION_SUMMARY.md)
- **诊断:** 运行 `DIAGNOSE_ALL_BROWSERS.ps1`

---

**注意：** 本项目仅用于合法的隐私保护和安全测试目的。请遵守当地法律法规。
