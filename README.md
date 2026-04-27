# Multi-Browser Anti-Detect

**一键部署 8 个隐私浏览器，配置企业级隐私策略和独立指纹。**

适用于多账号任务、网页游戏、AI 服务（Gemini 等）。

---

## 特性

✅ **8 个浏览器**：Chrome, Edge, Brave, Firefox, LibreWolf, Chromium, Vivaldi, Opera  
✅ **自动安装**：通过 winget 一键安装所有浏览器  
✅ **隐私优先**：40+ 企业级策略配置（禁用追踪、遥测、广告）  
✅ **独立指纹**：每个浏览器独立配置文件 + SOCKS5 代理  
✅ **官方合规**：仅使用官方支持的配置项，无废弃参数  
✅ **一键启动**：生成启动脚本，支持单独或批量启动  

---

## 快速开始

### 方法 1：从 GitHub 直接安装（推荐）

```powershell
# 以管理员身份运行 PowerShell
irm https://raw.githubusercontent.com/vpn3288/multi-browser-antidetect/master/install.ps1 | iex
```

### 方法 2：克隆仓库后安装

```powershell
# 克隆仓库
git clone https://github.com/vpn3288/multi-browser-antidetect.git
cd multi-browser-antidetect

# 以管理员身份运行部署脚本
.\deploy.ps1
```

---

## 系统要求

- **操作系统**：Windows 10/11
- **权限**：管理员权限（用于配置注册表策略）
- **依赖**：winget（Windows 应用安装程序）
- **代理**：Clash 或其他 SOCKS5 代理（端口 7891-7898）

---

## 配置说明

### 浏览器配置

所有浏览器自动应用以下配置：

**UI 设置**
- ✅ 默认显示书签栏
- ✅ 主页设为空白新标签页
- ✅ 禁用默认浏览器提示

**隐私设置**
- ✅ 禁用遥测和数据收集
- ✅ 禁用搜索建议
- ✅ 阻止第三方 Cookie
- ✅ 禁用自动填充（地址、信用卡、密码）
- ✅ 启用跟踪保护（Firefox）

**性能设置**
- ✅ 启用硬件加速
- ✅ 禁用后台模式

**反广告/促销**
- ✅ 禁用促销标签页
- ✅ 禁用 Edge 购物助手、集锦、侧边栏
- ✅ 禁用 Firefox Pocket、推荐

### 代理配置

每个浏览器分配独立的 SOCKS5 代理端口：

| 浏览器 | 端口 |
|--------|------|
| Chrome | 7891 |
| Edge | 7892 |
| Brave | 7893 |
| Firefox | 7894 |
| LibreWolf | 7895 |
| Chromium | 7896 |
| Vivaldi | 7897 |
| Opera | 7898 |

**Clash 配置示例**：

```yaml
mixed-port: 7890
socks-port: 7891  # Chrome
# 在 Clash 中配置 8 个不同的 SOCKS5 端口，每个端口使用不同的出口节点
```

---

## 使用方法

### 启动浏览器

部署完成后，在 `C:\BrowserProfiles\` 目录下会生成启动脚本：

```batch
# 启动单个浏览器
Launch_Chrome.bat
Launch_Edge.bat
Launch_Brave.bat
...

# 启动所有浏览器
Launch_All.bat
```

### 安装扩展（可选）

由于 GFW 限制，扩展需要手动安装：

1. **Canvas Defender**（Canvas 指纹保护）
   - 下载：https://github.com/kkapsner/CanvasBlocker/releases
   - 安装：拖拽 .crx 文件到浏览器扩展页面

2. **WebRTC Leak Shield**（WebRTC IP 保护）
   - 下载：https://github.com/aghorler/WebRTC-Leak-Shield/releases
   - 安装：拖拽 .crx 文件到浏览器扩展页面

---

## 目录结构

```
C:\Browsers\              # 浏览器安装目录（可选）
C:\BrowserProfiles\       # 浏览器配置文件和启动脚本
  ├── Chrome\             # Chrome 独立配置文件
  ├── Edge\               # Edge 独立配置文件
  ├── ...
  ├── Launch_Chrome.bat   # Chrome 启动脚本
  ├── Launch_Edge.bat     # Edge 启动脚本
  └── Launch_All.bat      # 批量启动脚本
```

---

## 故障排除

### 浏览器未安装成功

```powershell
# 手动安装单个浏览器
winget install Google.Chrome
winget install Microsoft.Edge
winget install Brave.Brave
# ...
```

### 配置未生效

1. 确认以管理员身份运行脚本
2. 重启浏览器
3. 检查注册表：`HKLM:\SOFTWARE\Policies\`

### 扩展无法安装

- 原因：GFW 阻止访问 Chrome Web Store
- 解决：手动下载 .crx 文件后安装（见上方"安装扩展"）

---

## 安全说明

### 已移除的不安全配置

本项目 v2.0 版本已移除以下不安全或废弃的配置：

❌ `--disable-web-security`（极度危险）  
❌ `--disable-site-isolation-trials`（降低安全性）  
❌ `--disable-blink-features=AutomationControlled`（已废弃）  
❌ `SafeBrowsingEnabled=0`（禁用安全浏览）  

### 隐私建议

- ✅ 使用不同的代理 IP 访问不同账号
- ✅ 定期清理浏览器配置文件
- ✅ 不要在同一浏览器登录多个账号
- ✅ 使用虚拟机或容器进一步隔离

---

## 许可证

MIT License

---

## 贡献

欢迎提交 Issue 和 Pull Request。

---

## 致谢

- [CanvasBlocker](https://github.com/kkapsner/CanvasBlocker) - Canvas 指纹保护
- [WebRTC Leak Shield](https://github.com/aghorler/WebRTC-Leak-Shield) - WebRTC IP 保护
- [Clash](https://github.com/Dreamacro/clash) - 代理工具

---

**⚠️ 免责声明**：本项目仅供学习和研究使用。使用者需遵守当地法律法规和网站服务条款。作者不对任何滥用行为负责。
