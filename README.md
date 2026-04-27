# Multi-Browser Anti-Detect

8 个浏览器的隐私保护和指纹差异化配置，适用于多账号任务、网页游戏、AI 服务等场景。

## 特性

✅ **WebRTC IP 保护** - 防止真实 IP 泄露  
✅ **指纹差异化** - 每个浏览器看起来像不同机器  
✅ **极致隐私** - 禁用遥测、追踪、数据收集  
✅ **干净界面** - 无新闻、广告、促销  
✅ **厂商特定优化** - 针对每个浏览器厂商的特殊功能深度优化  
✅ **官方合规** - 所有配置基于官方文档  

## 支持的浏览器

| 浏览器 | 代理端口 | 状态 |
|--------|----------|------|
| Chrome | 7891 | ✅ |
| Edge | 7892 | ✅ |
| Brave | 7893 | ✅ |
| Vivaldi | 7894 | ✅ |
| Opera | 7895 | ✅ |
| Chromium | 7896 | ✅ |
| Firefox | 7897 | ✅ |
| LibreWolf | 7898 | ✅ |

## 快速开始

### 方法 1: 一键安装（推荐）

```powershell
irm https://raw.githubusercontent.com/vpn3288/multi-browser-antidetect/master/install.ps1 | iex
```

### 方法 2: 手动安装

```powershell
# 1. 克隆仓库
git clone https://github.com/vpn3288/multi-browser-antidetect.git
cd multi-browser-antidetect

# 2. 运行部署脚本（需要管理员权限）
powershell -ExecutionPolicy Bypass -File deploy.ps1

# 3. 配置 Clash 代理（8 个不同的美国 IP，端口 7891-7898）

# 4. 启动浏览器
C:\BrowserProfiles\Launch_All.bat
```

## 配置详情

### 核心功能

- **书签栏默认显示**
- **主页设为空白新标签页**
- **禁止默认浏览器提示**
- **WebRTC IP 保护**（关键！）
- **SafeBrowsing 标准保护**（避免被识别为异常）
- **禁用遥测和数据收集**
- **阻止第三方 Cookie**
- **禁用自动填充**
- **独立用户配置文件**

### 厂商特定优化

#### Edge（17 项微软功能禁用）
- Copilot、购物助手、集锦、工作区、侧边栏搜索
- 微软 Rewards、家庭安全、钱包、密码监控
- 启动增强、预加载、智能操作、发现栏

#### Brave（7 项加密货币功能禁用）
- 加密钱包、VPN、Tor、IPFS、奖励系统
- 新闻、侧边栏

#### Vivaldi（5 项生产力功能禁用）
- 侧边栏、邮件客户端、日历、笔记、翻译

#### Opera（6 项社交功能禁用）
- 内置 VPN、新闻、Turbo 模式、侧边栏
- 简易文件、广告拦截器

#### Chrome（5 项 Google 服务禁用）
- 同步、投射、翻译、密码管理器、自动填充

### 代理配置

每个浏览器使用不同的 SOCKS5 代理端口（7891-7898），需要在 Clash 中配置 8 个不同的美国出口节点。

## 验证

### 检查 WebRTC 泄露
访问：https://browserleaks.com/webrtc
- ✅ 应该只显示代理 IP
- ❌ 不应该显示本地 IP

### 检查指纹
访问：https://browserleaks.com/canvas
- ✅ 每个浏览器指纹应该不同

### 检查企业策略
- Chromium: `chrome://policy/`
- Firefox: `about:policies`

## 文件结构

```
multi-browser-antidetect/
├── deploy.ps1              # 主部署脚本
├── install.ps1             # GitHub 一键安装脚本
├── README.md               # 本文件
├── CONFIGURATION_REPORT_V3.md  # 完整配置文档
└── .gitignore
```

## 系统要求

- Windows 10/11
- PowerShell 5.1+
- 管理员权限
- 已安装的浏览器

## 适用场景

- ✅ 多账号任务（每个浏览器独立账号）
- ✅ 网页游戏（不被识别为异常流量）
- ✅ AI 服务（Gemini 等严格检测）
- ✅ 正常美国用户伪装

## 技术细节

### Chromium 系浏览器
- 配置方式：注册表策略
- WebRTC 保护：`WebRtcIPHandlingPolicy = "disable_non_proxied_udp"`
- SafeBrowsing：`SafeBrowsingProtectionLevel = 1`（标准保护）

### Firefox 系浏览器
- 配置方式：`policies.json`
- WebRTC 保护：`media.peerconnection.ice.*` 配置
- 跟踪保护：完全启用

## 文档

完整配置报告：[CONFIGURATION_REPORT_V3.md](CONFIGURATION_REPORT_V3.md)

## 许可

MIT License

## 注意事项

⚠️ 本项目仅用于合法用途。使用者需遵守当地法律法规和网站服务条款。

⚠️ 代理配置需要自行准备，本项目不提供代理服务。

## 更新日志

### v4.0 (2026-04-28)
- ✅ 深度厂商特定优化（30+ 项配置）
- ✅ Edge: 禁用 Copilot、购物、集锦、工作区等 17 项功能
- ✅ Brave: 禁用钱包、VPN、Tor、IPFS 等 7 项功能
- ✅ Vivaldi: 禁用侧边栏、邮件、日历等 5 项功能
- ✅ Opera: 禁用 VPN、新闻、Turbo 等 6 项功能
- ✅ Chrome: 禁用同步、投射、翻译等 5 项功能
- ✅ 修复端口分配错误
- ✅ Firefox/LibreWolf 通过 user.js 配置代理
- ✅ 100% 验证通过（所有 8 个浏览器）

### v3.0 (2026-04-27)
- ✅ 修复 WebRTC IP 泄露问题
- ✅ 修正 SafeBrowsing 配置
- ✅ 移除所有危险和废弃参数
- ✅ 所有配置符合官方文档
- ✅ 生成干净的启动脚本

### v2.0
- 初始版本

---

**状态：** ✅ 生产就绪  
**最后更新：** 2026-04-28
