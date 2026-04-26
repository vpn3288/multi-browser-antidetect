# 完整自动化部署方案

## 概述

整合三个工具链实现7个浏览器的独立IP分流和极致隐私保护：

1. **Browser** - 自动安装和优化7款浏览器
2. **mihomo** - Clash Verge配置实现进程级IP隔离
3. **multi-browser-antidetect** - 反检测指纹随机化

## 核心特性

- ✅ 7个浏览器独立IP（通过Clash Verge进程名分流）
- ✅ Canvas/WebGL/Audio指纹随机化
- ✅ WebRTC禁用（防止真实IP泄漏）
- ✅ QUIC协议阻断（消除UDP流量指纹）
- ✅ 独立User-Agent和时区
- ✅ 间隔启动（避免批量操作特征）
- ✅ 流量特征正常化（表现为正常美国人）

## 快速开始

### 前置条件

1. Windows 10/11 + PowerShell 5.1+
2. 管理员权限
3. 已部署VPS节点（使用 [Agent-Proxy](https://github.com/vpn3288/Agent-Proxy)）
4. 已安装Clash Verge

### 一键部署

```powershell
# 以管理员身份运行PowerShell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# 下载并运行完整部署脚本
irm https://raw.githubusercontent.com/vpn3288/multi-browser-antidetect/main/DEPLOY_COMPLETE.ps1 | iex
```

### 手动部署

```powershell
# 克隆仓库
git clone https://github.com/vpn3288/multi-browser-antidetect.git
cd multi-browser-antidetect

# 运行部署脚本
.\DEPLOY_COMPLETE.ps1
```

## 配置步骤

### 1. VPS节点部署

使用 [Agent-Proxy](https://github.com/vpn3288/Agent-Proxy) 部署：

- 7个美国IP的落地机（不同地区）
- CN2 GIA线路的中转机
- 推荐协议：Hysteria2 / TUIC / Shadowsocks

### 2. 修改订阅链接

编辑Clash Verge配置文件：

```
%USERPROFILE%\.config\clash-verge\profiles\config.js
```

替换以下占位符为实际订阅链接：

```javascript
const SUB = {
  Edge:      "https://YOUR_EDGE_SUBSCRIPTION_URL",      // 替换为实际链接
  Chrome:    "https://YOUR_CHROME_SUBSCRIPTION_URL",    // 替换为实际链接
  Firefox:   "https://YOUR_FIREFOX_SUBSCRIPTION_URL",   // 替换为实际链接
  Brave:     "https://YOUR_BRAVE_SUBSCRIPTION_URL",     // 替换为实际链接
  LibreWolf: "https://YOUR_LIBREWOLF_SUBSCRIPTION_URL", // 替换为实际链接
  Vivaldi:   "https://YOUR_VIVALDI_SUBSCRIPTION_URL",   // 替换为实际链接
  Opera:     "https://YOUR_OPERA_SUBSCRIPTION_URL",     // 替换为实际链接
  Default:   "https://YOUR_DEFAULT_SUBSCRIPTION_URL",   // 替换为实际链接
};
```

### 3. 启动Clash Verge

1. 打开Clash Verge
2. 导入配置文件（config.js）
3. 启用TUN模式
4. 确认7个代理组已激活

### 4. 启动浏览器

```powershell
.\LAUNCH_BROWSERS.ps1
```

每个浏览器会：
- 间隔10秒启动（避免批量特征）
- 自动访问 https://ip.sb 验证IP
- 使用独立的User Data目录
- 加载反检测脚本

## 浏览器与IP映射

| 浏览器 | 代理端口 | 时区 | Client Fingerprint |
|--------|---------|------|-------------------|
| Chrome | 7891 | America/New_York | chrome |
| Firefox | 7892 | America/Chicago | firefox |
| Edge | 7893 | America/Denver | edge |
| Brave | 7894 | America/Los_Angeles | chrome |
| Opera | 7895 | America/Phoenix | chrome |
| Vivaldi | 7896 | America/Anchorage | chrome |
| LibreWolf | 7897 | Pacific/Honolulu | firefox |

## 验证清单

### IP隔离验证

在每个浏览器中访问以下网站，确认显示不同IP：

- https://ip.sb
- https://ipinfo.io
- https://ifconfig.me

### 指纹隔离验证

访问以下测试网站，确认每个浏览器指纹不同：

- https://browserleaks.com/canvas
- https://browserleaks.com/webgl
- https://whoer.net

### WebRTC泄漏检测

- https://browserleaks.com/webrtc
- 确认不显示真实IP

## 养号建议

### 启动策略

- 每天固定时间启动（模拟真实作息）
- 不要同时启动所有浏览器
- 每个浏览器间隔10-30分钟

### 使用模式

- 每个浏览器保持独立的登录状态
- 不要在多个浏览器登录同一账号
- 模拟真实浏览行为（搜索、阅读、停留）

### 流量特征

- 避免短时间大量请求
- 定期清理Cookie和缓存
- 使用不同的User-Agent

## 故障排查

### 浏览器无法启动

```powershell
# 检查浏览器是否安装
Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe"

# 手动启动测试
Start-Process chrome.exe -ArgumentList "--version"
```

### IP未隔离

1. 检查Clash Verge是否启用TUN模式
2. 确认订阅链接已正确配置
3. 查看Clash日志：`%USERPROFILE%\.config\clash-verge\logs`

### 指纹未随机化

1. 确认反检测脚本已加载：
   ```powershell
   Get-Content "$env:LOCALAPPDATA\BrowserProfiles\Chrome\antidetect.js"
   ```

2. 检查浏览器启动参数是否包含 `--user-data-dir`

### Clash配置错误

```powershell
# 验证配置文件语法
node -c "%USERPROFILE%\.config\clash-verge\profiles\config.js"
```

## 高级配置

### 自定义代理端口

编辑 `LAUNCH_BROWSERS.ps1`，修改 `Port` 字段：

```powershell
@{Name="Chrome"; Path="..."; Port=8891; TZ="America/New_York"}
```

### 添加更多浏览器

1. 在 `DEPLOY_COMPLETE.ps1` 的 `$browsers` 数组中添加新条目
2. 在 Clash 配置中添加对应的订阅链接和策略组

### 自定义反检测脚本

编辑 `$antiDetectJS` 变量，添加自定义指纹修改逻辑。

## 安全建议

- 定期更新浏览器和Clash Verge
- 不要在公共网络使用
- 定期更换VPS节点IP
- 使用强密码和2FA

## 相关项目

- [Browser](https://github.com/vpn3288/Browser) - 浏览器自动安装脚本
- [mihomo](https://github.com/vpn3288/mihomo) - Clash Verge配置
- [Agent-Proxy](https://github.com/vpn3288/Agent-Proxy) - VPS节点部署

## 许可证

MIT License

## 支持

- Issues: https://github.com/vpn3288/multi-browser-antidetect/issues
- Discussions: https://github.com/vpn3288/multi-browser-antidetect/discussions
