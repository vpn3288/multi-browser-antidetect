# 🌐 多浏览器反检测系统

**企业级配置 + 极致隐私保护 + 8浏览器独立指纹 + 完全自动化**

支持：Chrome、Chromium、Firefox、Edge、Brave、Opera、Vivaldi、LibreWolf

---

## 🆕 最新更新（v4.0 - 基于官方文档的完整优化版）

- ✅ **深入研究官方文档** - 每个浏览器都基于官方企业部署文档优化
- ✅ **企业级配置** - 使用企业策略（注册表），配置持久化
- ✅ **500+ 策略配置** - Chrome 100+、Edge 120+、Firefox 80+、Brave 90+ 策略
- ✅ **完全自动化** - 一键配置所有浏览器，扩展自动安装
- ✅ **详细中文文档** - 完整的使用指南和技术文档
- ✅ **一劳永逸** - 配置一次，长期有效

---

## ✨ 核心特性

### 🎭 真实指纹伪装
- ✅ **每个浏览器唯一指纹** - 8个浏览器看起来像8台不同的真实电脑
- ✅ **基于真实数据** - 所有参数来自真实美国用户统计
- ✅ **Canvas指纹随机化** - 微小噪声，肉眼不可见
- ✅ **WebGL指纹随机化** - 真实GPU型号
- ✅ **AudioContext指纹随机化** - 微小频率偏移
- ✅ **隐藏webdriver特征** - 完全隐藏自动化控制

### 🔒 极致隐私保护
- ✅ **禁用所有遥测** - Chrome、Edge、Firefox、Brave 所有数据收集
- ✅ **WebRTC IP泄漏防护** - 仅显示代理IP，禁用非代理UDP
- ✅ **DNS-over-HTTPS** - 使用 Google DNS，防止DNS泄漏
- ✅ **阻止第三方Cookie** - 完全阻止跨站追踪
- ✅ **追踪保护** - 禁用所有追踪、广告、促销
- ✅ **第一方隔离** - Firefox/LibreWolf 完全隔离
- ✅ **自动安装隐私扩展** - uBlock Origin、Privacy Badger 等

### 🛡️ 自动安装的隐私扩展
- 🛡️ **uBlock Origin** - 广告和追踪拦截
- 🔒 **Privacy Badger** - 智能追踪保护
- 📦 **Decentraleyes** - 本地 CDN 模拟（防止 CDN 追踪）
- 🌐 **WebRTC Leak Shield** - WebRTC 泄漏防护（Chromium 系）
- 🔗 **ClearURLs** - 清理 URL 追踪参数（Firefox 系）

### 🎯 完美用户体验
- ✅ **书签栏默认显示** - 所有浏览器
- ✅ **空白主页和新标签页** - 干净简洁
- ✅ **书签在新标签页打开** - Firefox/LibreWolf
- ✅ **禁用默认浏览器检查** - 无弹窗干扰
- ✅ **关闭所有新闻、广告、促销** - 纯净体验

### ⚡ 性能优化
- ✅ **Edge 性能优化** - Startup Boost、Sleeping Tabs、Efficiency Mode
- ✅ **硬件加速** - 所有浏览器启用
- ✅ **V8引擎优化** - Chrome/Chromium 代码缓存
- ✅ **WebRender加速** - Firefox/LibreWolf GPU加速
- ✅ **缓存优化** - 合理的磁盘和内存缓存

### 🚀 浏览器特色优化

#### Chrome (13.8 KB 配置)
- 100+ 企业策略配置
- 禁用所有 Google 服务遥测
- WebRTC 防护、DNS-over-HTTPS
- 扩展自动安装

#### Chromium (15.7 KB 配置)
- 完全去除 Google 服务依赖
- 所有 Chrome 策略 + 去 Google 化
- 默认搜索引擎配置

#### Edge (17.4 KB 配置)
- 禁用所有 Microsoft 服务（Shopping, Collections, Workspaces, Sidebar, Bing, Rewards）
- 性能优化（Startup Boost, Sleeping Tabs, Efficiency Mode）
- 120+ 企业策略

#### Firefox (21.1 KB 配置)
- policies.json + user.js 双重配置
- Resist Fingerprinting（最强反指纹）
- 禁用所有 Mozilla 服务（Pocket, Firefox Suggest, Studies）
- 80+ 配置项

#### Brave (16.8 KB 配置)
- Brave Shields 配置（内置广告拦截）
- 禁用所有 Brave 服务（Rewards, Wallet, VPN, News, Talk, IPFS, Tor）
- 90+ 企业策略

#### Vivaldi (5.1 KB 配置)
- 基于 Chromium 策略
- 4个扩展自动安装

#### LibreWolf (4.2 KB 配置)
- Firefox 隐私增强版
- 默认最大隐私保护
- 4个扩展自动安装

#### Opera (11.5 KB 配置)
- 完全自动化配置
- 企业策略配置

---

## 📥 快速开始（3步）

### 🚀 方法1：统一配置管理（推荐）⭐

**步骤1：克隆仓库**

```powershell
# 以管理员身份打开 PowerShell
git clone https://github.com/vpn3288/multi-browser-antidetect.git
cd multi-browser-antidetect
```

**步骤2：运行统一配置脚本**

```powershell
# 一键配置所有浏览器
.\CONFIGURE_ALL_BROWSERS.ps1
```

**步骤3：重启浏览器**

```powershell
# 关闭所有浏览器
Get-Process chrome,chromium,firefox,msedge,brave,opera,vivaldi,librewolf -ErrorAction SilentlyContinue | Stop-Process -Force

# 然后手动打开浏览器，配置会自动生效
```

**就这么简单！** 🎉

---

### 方法2：单独配置每个浏览器

如果你只想配置特定浏览器，可以运行单独的配置脚本：

```powershell
# Chrome
.\CHROME_ENTERPRISE_CONFIG.ps1

# Chromium
.\CHROMIUM_ENTERPRISE_CONFIG.ps1

# Edge
.\EDGE_ENTERPRISE_CONFIG.ps1

# Firefox
.\FIREFOX_ENTERPRISE_CONFIG.ps1

# Brave
.\BRAVE_ENTERPRISE_CONFIG.ps1

# Vivaldi
.\VIVALDI_ENTERPRISE_CONFIG.ps1

# LibreWolf
.\LIBREWOLF_ENTERPRISE_CONFIG.ps1

# Opera
.\OPERA_AUTO_CONFIG.ps1
```

---

### 方法3：使用下载的ZIP文件

如果你没有 Git：

```powershell
# 下载
Invoke-WebRequest -Uri "https://github.com/vpn3288/multi-browser-antidetect/archive/refs/heads/master.zip" -OutFile "$env:USERPROFILE\Desktop\multi-browser-antidetect.zip"

# 解压
Expand-Archive -Path "$env:USERPROFILE\Desktop\multi-browser-antidetect.zip" -DestinationPath "$env:USERPROFILE\Desktop" -Force

# 进入目录
cd "$env:USERPROFILE\Desktop\multi-browser-antidetect-master"

# 运行配置脚本
.\CONFIGURE_ALL_BROWSERS.ps1
```

---

## 📚 完整文档

### 中文文档（推荐阅读）⭐
- **[中文使用指南.md](中文使用指南.md)** - 完整的中文使用文档
  - 快速开始指南
  - 验证配置方法
  - 启动浏览器教程
  - 隐私测试指南
  - 浏览器对比和推荐
  - 常见问题解答
  - 进阶使用技巧

### 技术文档
- **[基于官方文档的完整浏览器优化总结.md](基于官方文档的完整浏览器优化总结.md)** - 详细的技术文档
  - 所有浏览器的详细配置说明
  - 配置对比表
  - 使用方法和验证方法
  - 重要注意事项

- **[项目完成总结报告.md](项目完成总结报告.md)** - 项目总结
  - 项目概览和统计
  - 完成的工作详解
  - 技术细节说明

- **[项目展示.md](项目展示.md)** - 项目展示
  - 核心特性展示
  - 快速开始指南
  - 使用场景推荐

---

## 🧪 验证效果

### 1. 验证配置是否生效

**Chromium 系浏览器（Chrome、Chromium、Edge、Brave、Opera、Vivaldi）：**
```
chrome://policy
edge://policy
brave://policy
opera://policy
vivaldi://policy
```

**Firefox 系浏览器（Firefox、LibreWolf）：**
```
about:policies
```

### 2. 隐私测试网站

访问以下网站检查隐私保护是否生效：

| 检查项目 | 网址 | 预期结果 |
|---------|------|---------|
| IP地址 | https://ip.sb | 显示代理IP（美国） |
| WebRTC泄漏 | https://browserleaks.com/webrtc | 仅显示代理IP |
| DNS泄漏 | https://dnsleaktest.com/ | 显示代理DNS |
| Canvas指纹 | https://browserleaks.com/canvas | 每个浏览器不同 |
| WebGL指纹 | https://browserleaks.com/webgl | 每个浏览器不同 |
| 设备信息 | https://www.deviceinfo.me/ | 真实的硬件配置 |
| 指纹追踪 | https://coveryourtracks.eff.org/ | 强保护 |
| IP泄漏检测 | https://ipleak.net/ | 无泄漏 |

---

## 📊 项目统计

### 文件统计
- **总文件数：** 46 个
- **配置脚本：** 10 个（每个浏览器 + 统一管理 + 验证）
- **启动脚本：** 8 个（自动生成）
- **文档文件：** 16 个（中文 + 英文）

### 代码统计
- **总代码行数：** 2,334+ 行
- **总文件大小：** ~400 KB
- **配置的策略：** 500+ 个

### 浏览器配置
- **Chrome：** 100+ 企业策略（13.8 KB）
- **Chromium：** 100+ 策略 + 去 Google 化（15.7 KB）
- **Edge：** 120+ 企业策略（17.4 KB）
- **Firefox：** 80+ 配置项（21.1 KB）
- **Brave：** 90+ 企业策略（16.8 KB）
- **Vivaldi：** 基于 Chromium 策略（5.1 KB）
- **LibreWolf：** Firefox 隐私增强版（4.2 KB）
- **Opera：** 企业策略配置（11.5 KB）

### 扩展安装
- **Chrome：** 2 个扩展
- **Chromium：** 2 个扩展
- **Edge：** 2 个扩展
- **Brave：** 4 个扩展（内置广告拦截，无需 uBlock Origin）
- **Firefox：** 4 个扩展
- **LibreWolf：** 4 个扩展
- **Vivaldi：** 4 个扩展
- **Opera：** 2 个扩展

---

## 📁 项目结构

```
multi-browser-antidetect/
├── CONFIGURE_ALL_BROWSERS.ps1          ⭐ 统一配置管理（推荐使用）
├── CHROME_ENTERPRISE_CONFIG.ps1        # Chrome 企业级配置
├── CHROMIUM_ENTERPRISE_CONFIG.ps1      # Chromium 配置
├── EDGE_ENTERPRISE_CONFIG.ps1          # Edge 企业级配置
├── FIREFOX_ENTERPRISE_CONFIG.ps1       # Firefox 完整配置
├── BRAVE_ENTERPRISE_CONFIG.ps1         # Brave 企业级配置
├── VIVALDI_ENTERPRISE_CONFIG.ps1       # Vivaldi 配置
├── LIBREWOLF_ENTERPRISE_CONFIG.ps1     # LibreWolf 配置
├── OPERA_AUTO_CONFIG.ps1               # Opera 自动化配置
├── VERIFY_CHROME_CONFIG.ps1            # Chrome 验证脚本
├── VERIFY_OPERA_CONFIG.ps1             # Opera 验证脚本
├── LAUNCH_*.ps1                        # 启动脚本（8个，自动生成）
├── 中文使用指南.md                     ⭐ 中文文档（推荐阅读）
├── 基于官方文档的完整浏览器优化总结.md  ⭐ 技术文档
├── 项目完成总结报告.md                 ⭐ 总结报告
├── 项目展示.md                         ⭐ 项目展示
├── README.md                           # 本文档
└── ... 更多文档和脚本
```

---

## 🎯 核心原理

### 为什么这个方案有效？

**传统方案的问题：**
- ❌ 使用 `privacy.resistFingerprinting` 让所有用户看起来一样（反而更可疑）
- ❌ 完全禁用WebGL会影响网站功能
- ❌ 使用假的硬件信息（999核CPU）一眼就能看出
- ❌ 配置不持久，容易被误操作修改

**我们的方案：**
- ✅ **基于官方文档** - 每个浏览器都深入研究官方企业部署文档
- ✅ **企业级配置** - 使用企业策略（注册表），配置持久化
- ✅ **基于真实数据** - 所有参数来自真实美国用户统计
- ✅ **微小差异** - Canvas噪声肉眼不可见，但改变指纹
- ✅ **合理配置** - 硬件在真实范围内
- ✅ **每个浏览器唯一** - 8个浏览器8种不同但都真实的配置
- ✅ **稳定指纹** - 同一浏览器指纹保持一致
- ✅ **完全自动化** - 一键配置，扩展自动安装
- ✅ **一劳永逸** - 配置一次，长期有效

---

## 🏆 项目亮点

### 1. 基于官方文档
每个浏览器都深入研究了官方企业部署文档，确保配置的准确性和有效性。

### 2. 企业级配置
使用企业策略（注册表），配置持久化，不会被误操作修改。

### 3. 完全自动化
一键配置所有浏览器，扩展自动安装，无需手动操作。

### 4. 详细文档
提供完整的中文使用指南和技术文档，易于理解和使用。

### 5. 浏览器特色优化
- **Edge：** 睡眠标签页、效率模式、启动加速
- **Brave：** 内置广告拦截（无需 uBlock Origin）
- **Firefox：** Resist Fingerprinting（最强反指纹）
- **LibreWolf：** 默认最大隐私保护

### 6. 一劳永逸
配置一次，长期有效，无需重复配置。

---

## 🛠️ 故障排除

### 问题1：PowerShell执行策略错误

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 问题2：配置没有生效

1. 确认以管理员身份运行 PowerShell
2. 重启浏览器
3. 访问 `chrome://policy` 或 `about:policies` 检查配置

### 问题3：扩展没有自动安装

1. 确认浏览器已完全关闭
2. 重新打开浏览器
3. 首次启动时扩展会自动下载和安装（需要几秒钟）

### 问题4：代理不工作

1. 确认 Clash 正在运行
2. 检查端口是否正确（127.0.0.1:7890）
3. 访问 https://ip.sb 确认IP是否为代理IP

### 问题5：指纹没有变化

1. 清除浏览器缓存和Cookie
2. 重新运行配置脚本
3. 确认配置已生效（访问 `chrome://policy`）

---

## 🌟 使用场景推荐

### 场景1：日常隐私保护
**推荐浏览器：** Firefox + LibreWolf
- Firefox 有最强的 Resist Fingerprinting
- LibreWolf 默认最大隐私保护
- 两者都是开源，社区审计

### 场景2：访问国际网站
**推荐浏览器：** Chrome + Edge
- Chrome 兼容性最好
- Edge 性能优化（Sleeping Tabs、Efficiency Mode）
- 两者都有完整的企业策略支持

### 场景3：玩国际游戏
**推荐浏览器：** Brave + Vivaldi
- Brave 内置广告拦截，性能好
- Vivaldi 功能丰富，可定制性强
- 两者都基于 Chromium，兼容性好

### 场景4：极致隐私
**推荐浏览器：** LibreWolf + Brave
- LibreWolf 默认最大隐私保护
- Brave 内置 Shields，无需额外扩展
- 两者都专注于隐私保护

### 场景5：多账号管理
**推荐浏览器：** 所有8个浏览器
- 每个浏览器使用不同的指纹
- 配合不同的代理IP
- 完全隔离，互不影响

---

## 📝 许可证

MIT License - 详见 [LICENSE](LICENSE)

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

## 📞 支持

如果你遇到问题或有建议，请：
1. 查看 [中文使用指南.md](中文使用指南.md)
2. 查看 [常见问题解答](中文使用指南.md#常见问题解答)
3. 提交 Issue：https://github.com/vpn3288/multi-browser-antidetect/issues

---

## 🎊 致谢

感谢所有浏览器的官方文档和开源社区的贡献！

---

**版本：** v4.0 - 基于官方文档的完整优化版

**完成时间：** 2026-04-27

**GitHub 仓库：** https://github.com/vpn3288/multi-browser-antidetect

**祝你使用愉快！** 🎉
