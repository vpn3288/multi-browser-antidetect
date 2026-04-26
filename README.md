# 🌐 8浏览器反检测部署方案

**完整的多浏览器隔离部署工具 - 专为账号养号、隐私保护、反指纹追踪设计**

---

## 📦 支持的浏览器（8个）

| 浏览器 | 渲染引擎 | JS引擎 | 代理端口 | 时区 |
|--------|---------|--------|---------|------|
| **Chrome** | Blink | V8 | 7891 | America/New_York |
| **Chromium** | Blink | V8 | 7892 | America/Chicago |
| **Firefox** | Gecko | SpiderMonkey | 7893 | America/Denver |
| **Edge** | Blink | V8 | 7894 | America/Los_Angeles |
| **Brave** | Blink | V8 | 7895 | America/Phoenix |
| **Opera** | Blink | V8 | 7896 | America/Anchorage |
| **Vivaldi** | Blink | V8 | 7897 | Pacific/Honolulu |
| **LibreWolf** | Gecko | SpiderMonkey | 7898 | America/Boise |

---

## ✨ 核心特性

### 🔒 极致隐私保护
- ✅ 完全独立的用户数据目录
- ✅ 独立代理端口（7891-7898）
- ✅ 不同美国时区分配
- ✅ **真实的Canvas/WebGL/AudioContext指纹随机化**
- ✅ **每个浏览器不同但真实的硬件指纹**
- ✅ WebRTC IP泄漏防护（仅显示代理IP）
- ✅ 第三方Cookie完全阻止
- ✅ 禁用所有遥测和数据收集
- ✅ 真实的美国用户屏幕分辨率和DPI

### 🎯 用户体验优化
- ✅ **书签栏默认显示**
- ✅ **主页和新标签页设为空白页**
- ✅ **书签在新标签页打开**
- ✅ **禁用默认浏览器检查弹窗**
- ✅ **关闭所有新闻、广告、促销内容**
- ✅ 双击标签页关闭（5个浏览器原生支持）

### ⚡ 性能优化
- ✅ 硬件加速启用
- ✅ 缓存优化（100MB 磁盘 + 50MB 内存）
- ✅ 网络连接优化（256 最大连接）
- ✅ 禁用后台模式

### 🎭 真实指纹伪装
- ✅ **基于2024年真实美国用户数据的指纹**
- ✅ **8种不同的真实屏幕分辨率（1366x768到4K）**
- ✅ **8种不同的真实硬件配置（Intel/AMD/Apple/NVIDIA）**
- ✅ **真实的美国常见语言设置**
- ✅ **Canvas指纹添加微小噪声（肉眼不可见但改变指纹）**
- ✅ **WebGL渲染器随机化（真实GPU型号）**
- ✅ **不是一眼假的伪装，而是真实用户级别**

### 🖱️ 架构级定制
- ✅ **Chromium系**（Chrome/Chromium/Edge/Brave/Opera/Vivaldi）→ 注册表策略
- ✅ **Gecko系**（Firefox/LibreWolf）→ user.js 配置文件
- ✅ 每个浏览器使用专属优化方法

---

## 🚀 快速开始

### 1️⃣ 克隆仓库

```powershell
git clone https://github.com/vpn3288/multi-browser-antidetect.git
cd multi-browser-antidetect
```

### 2️⃣ 运行部署脚本（需要管理员权限）

```powershell
# 右键 PowerShell → 以管理员身份运行
.\DEPLOY_8_BROWSERS.ps1
```

**脚本会自动：**
- 检查并安装缺失的浏览器
- 应用架构级优化
- 配置独立代理端口和时区
- **为每个浏览器生成真实的美国用户指纹**
- **注入Canvas/WebGL指纹保护脚本**
- 生成启动脚本
- 打开 HTML 部署报告

### 3️⃣ 配置 Clash Verge

为每个代理端口分配不同的美国 IP：

```yaml
# clash-config-template.yaml
proxies:
  - name: "US-NY"
    type: vmess
    server: your-vps-ip
    port: 10001
    # ... 其他配置

proxy-groups:
  - name: "Chrome-7891"
    type: select
    proxies: ["US-NY"]
```

### 4️⃣ 启动浏览器

```batch
# 启动所有浏览器
C:\BrowserProfiles\Launch_All.bat

# 或单独启动
C:\BrowserProfiles\Launch_Chrome.bat
```

---

## 📂 项目结构

```
multi-browser-antidetect/
├── DEPLOY_8_BROWSERS.ps1              # 主部署脚本（自动安装+优化）
├── OPTIMIZE_ARCHITECTURE.ps1          # 架构级优化脚本
├── ENABLE_DOUBLE_CLICK_CLOSE.ps1      # 双击关闭标签页配置
├── LAUNCH_BROWSERS.ps1                # 浏览器启动脚本
├── FINGERPRINT_RANDOMIZER.ps1         # 指纹随机化脚本
├── canvas_fingerprint_protection.js   # Canvas/WebGL指纹保护
├── clash-config-template.yaml         # Clash Verge 配置模板
├── README.md                          # 本文档
└── LICENSE                            # MIT 许可证
```

---

## 🔧 高级配置

### 单独运行架构级优化

如果浏览器已安装，只需优化：

```powershell
.\OPTIMIZE_ARCHITECTURE.ps1
```

### 启用双击关闭标签页

```powershell
.\ENABLE_DOUBLE_CLICK_CLOSE.ps1
```

**原生支持：**
- Edge、Vivaldi、Firefox、LibreWolf、Chromium

**需要扩展：**
- Chrome、Brave、Opera
- 推荐扩展：[Double Click Closes Tab](https://chromewebstore.google.com/detail/double-click-closes-tab/gkdnokhgbgbkbfnhfnbpnfhpnmjfpnlj)

---

## 🧪 验证隔离效果

### 1. 验证不同 IP

在每个浏览器访问：https://ip.sb

应该显示不同的美国 IP 地址。

### 2. 验证指纹隔离

访问：https://browserleaks.com/canvas

每个浏览器应该显示不同的 Canvas 指纹。

### 3. 验证 WebRTC 防护

访问：https://browserleaks.com/webrtc

应该显示 "WebRTC is disabled" 或只显示代理 IP。

### 4. 验证真实性

访问：https://www.deviceinfo.me/

检查你的设备信息是否看起来像真实的美国用户（屏幕分辨率、硬件、语言等）。

---

## 📋 优化详情

### 所有浏览器通用优化

**隐私保护：**
- 禁用默认浏览器检查弹窗
- 书签栏默认显示
- 主页和新标签页设为空白页（about:blank）
- 书签在新标签页打开
- 禁用所有新闻、广告、促销内容
- 阻止第三方Cookie
- WebRTC IP泄漏防护
- 禁用DNS预取
- 禁用所有遥测和数据收集

**指纹保护：**
- Canvas指纹添加微小噪声
- WebGL渲染器随机化
- AudioContext指纹随机化
- 真实的屏幕分辨率和DPI
- 真实的硬件配置（CPU核心数、内存、GPU）
- 隐藏自动化控制特征（webdriver）

### Chromium 系浏览器（Chrome/Chromium/Edge/Brave/Opera/Vivaldi）

**优化方法：** 注册表策略

```powershell
HKLM:\SOFTWARE\Policies\[Browser]\
├── BackgroundModeEnabled = 0          # 禁用后台模式
├── HardwareAccelerationModeEnabled = 1 # 启用硬件加速
├── DiskCacheSize = 104857600          # 100MB 缓存
├── MetricsReportingEnabled = 0        # 禁用遥测
├── BookmarkBarEnabled = 1             # 显示书签栏
├── HomepageIsNewTabPage = 1           # 主页为新标签页
├── NewTabPageLocation = "about:blank" # 新标签页为空白
├── BlockThirdPartyCookies = 1         # 阻止第三方Cookie
└── WebRtcIPHandling = "default_public_interface_only" # WebRTC防护
```

**Edge 特有：**
- 禁用 StartupBoost
- 禁用购物助手
- 禁用 Microsoft Rewards
- 禁用集合功能
- 启用双击关闭标签页

**Vivaldi 特有：**
- 自定义 CSS 优化
- 双击关闭标签页配置

### Gecko 系浏览器（Firefox/LibreWolf）

**优化方法：** user.js 配置文件

```javascript
// 性能优化
user_pref("browser.cache.disk.capacity", 102400);
user_pref("gfx.webrender.all", true);              // WebRender 加速
user_pref("layers.acceleration.force-enabled", true);

// 用户体验
user_pref("browser.toolbars.bookmarks.visibility", "always");
user_pref("browser.startup.homepage", "about:blank");
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.tabs.loadBookmarksInTabs", true);

// 隐私优化
user_pref("privacy.resistFingerprinting", false);  // 关闭以避免过度保护
user_pref("privacy.firstparty.isolate", true);     // 第一方隔离（Firefox 独有）
user_pref("webgl.disabled", false);                // 保持WebGL以看起来真实
user_pref("media.peerconnection.enabled", false);  // 禁用 WebRTC

// 禁用新闻和广告
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);

// 双击关闭
user_pref("browser.tabs.closeTabByDblclick", true);
```

---

## 🛡️ 安全建议

1. **定期更新浏览器**：保持最新版本以获得安全补丁
2. **使用不同的代理 IP**：确保每个浏览器使用独立的美国IP
3. **避免登录相同账号**：不要在多个浏览器登录同一账号
4. **定期清理 Cookie**：防止跨浏览器追踪
5. **模拟真实用户行为**：不要机械化操作，保持自然的浏览模式
6. **每个浏览器使用不同的指纹**：脚本已自动配置

---

## 🎯 为什么这个方案有效？

### 传统方案的问题
- ❌ 使用 `privacy.resistFingerprinting` 会让所有用户看起来一样（反而更可疑）
- ❌ 完全禁用 WebGL 会让网站无法正常工作
- ❌ 使用假的硬件信息（如999核CPU）一眼就能看出是伪造的

### 我们的方案
- ✅ **基于真实数据**：所有指纹参数都来自2024年真实美国用户统计数据
- ✅ **微小差异**：Canvas添加肉眼不可见的噪声，而不是完全改变
- ✅ **合理配置**：硬件配置都在真实范围内（4-16核，8-32GB内存）
- ✅ **真实屏幕**：使用真实的常见分辨率（1920x1080, 1366x768等）
- ✅ **每个浏览器唯一**：8个浏览器有8种不同但都真实的配置
- ✅ **稳定指纹**：同一浏览器的指纹保持一致，不会每次都变

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE)

---

## 🔗 相关链接

- **Clash Verge**：https://github.com/clash-verge-rev/clash-verge-rev
- **LibreWolf**：https://librewolf.net/
- **Chromium**：https://www.chromium.org/
- **BrowserLeaks**：https://browserleaks.com/
- **DeviceInfo**：https://www.deviceinfo.me/

---

## ⚠️ 免责声明

本项目仅供学习和研究使用。请遵守当地法律法规，不得用于非法用途。

---

**⭐ 如果这个项目对你有帮助，请给个 Star！**
