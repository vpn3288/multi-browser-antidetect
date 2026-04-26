# Multi-Browser Anti-Detect Setup

养号专用浏览器部署工具 - 终极反检测方案

## 特性

- ✅ **完整指纹隔离**：Canvas / WebGL / Audio / 硬件信息 / 屏幕参数
- ✅ **反自动化检测**：隐藏 webdriver / 修改 navigator 属性
- ✅ **WebRTC 防护**：防止真实 IP 泄漏
- ✅ **指纹持久化**：每个浏览器指纹保持一致
- ✅ **代理分流**：每个浏览器独立 IP（配合 Clash Verge）
- ✅ **风险控制**：间隔启动 / 养号指南 / 渐进式部署

## 快速开始

### 1. 部署浏览器

```powershell
.\deploy-ultimate.ps1
```

默认部署 3 个浏览器实例。

### 2. 配置代理

编辑 Clash Verge 配置文件，添加：

```yaml
listeners:
  - name: browser-1
    type: mixed
    port: 7891
    proxy: 节点1
  
  - name: browser-2
    type: mixed
    port: 7892
    proxy: 节点2
  
  - name: browser-3
    type: mixed
    port: 7893
    proxy: 节点3
```

### 3. 启动验证

```cmd
C:\BrowserProfiles\Launch-All.bat
```

访问以下网站验证：
- https://ip.sb - 确认不同 IP
- https://browserleaks.com/canvas - 确认不同指纹
- https://pixelscan.net - 综合检测（评分应 > 75）

## 高级配置

### 自定义浏览器数量

```powershell
.\deploy-ultimate.ps1 -BrowserCount 5
```

### 自定义 Chrome 路径

```powershell
.\deploy-ultimate.ps1 -ChromePath "D:\Chrome\chrome.exe"
```

### 自定义代理端口

```powershell
.\deploy-ultimate.ps1 -StartPort 8000
```

## 反检测技术

### Canvas 指纹

- 修改 `toDataURL` 和 `getImageData`
- 注入像素级噪声
- 每个浏览器噪声值不同

### WebGL 指纹

- 修改 Vendor / Renderer 参数
- 修改 WebGL 版本字符串
- 修改着色器语言版本

### 音频指纹

- 修改 `AudioBuffer.getChannelData`
- 注入随机噪声
- 每个浏览器噪声值不同

### 硬件信息

- 修改 CPU 核心数（4/8/12/16）
- 修改内存大小（4/8/16 GB）
- 修改屏幕分辨率

### WebRTC 防护

- 完全禁用 `navigator.mediaDevices`
- 禁用 `RTCPeerConnection`
- 防止真实 IP 泄漏

### 其他防护

- 隐藏 `navigator.webdriver`
- 修改 `navigator.plugins`
- 修改 Battery / Connection / Permissions API
- 清理 `Function.prototype.toString` 痕迹

## 养号策略

### 第一周（建立信任）

- **只启动 1 个浏览器**
- 每天登录 1 次，停留 5-10 分钟
- 只浏览，不操作
- 浏览路径要自然

### 第二周（逐步扩展）

- 增加到 2 个浏览器
- 第 1 个浏览器开始轻度互动
- 第 2 个浏览器重复第一周流程

### 第三周（稳定运营）

- 可以启动第 3 个浏览器
- 每个浏览器固定活跃时间段
- 开始执行任务（控制频率）

详细策略见部署后生成的 `养号指南.txt`

## 风险提示

### ⚠️ 局限性

此方案基于 JavaScript 注入，无法修改：
- GPU 驱动签名
- 字体渲染引擎
- TLS 指纹

### ✅ 适用场景

- 中小型平台（无专业反作弊团队）
- 任务平台（问卷调查、点击广告）
- 社交媒体养号

### ❌ 不适用场景

- 高价值账号（已有收益 > $100/月）
- 金融平台
- 大型电商平台

**建议：高价值账号使用专业指纹浏览器（AdsPower / Multilogin）**

## 文件结构

```
browser-setup/
├── deploy-ultimate.ps1           # 部署脚本
├── clash-config-template.yaml    # Clash 配置模板
├── README.md                      # 本文件
├── README-ULTIMATE.md             # 详细说明
└── README-ENHANCED.md             # 增强版说明（已废弃）
```

部署后生成：

```
C:\BrowserProfiles/
├── Chrome1/
│   ├── Default/Preferences
│   ├── fingerprint.json
│   └── anti-detect.js
├── Chrome2/
├── Chrome3/
├── Launch-All.bat
├── Launch-Single.bat
└── 养号指南.txt
```

## 故障排查

### 浏览器无法启动

```powershell
Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe"
```

### 代理不生效

```powershell
netstat -ano | findstr "7891"
```

### 指纹未生效

在浏览器控制台应该看到：
```
[AntiDetect] Fingerprint loaded successfully
```

## 许可证

MIT License

## 免责声明

本工具仅供学习研究使用。使用本工具进行任何违反平台服务条款的行为，后果自负。

## 贡献

欢迎提交 Issue 和 Pull Request。

## 相关项目

- [AdsPower](https://www.adspower.com/) - 专业指纹浏览器
- [Multilogin](https://multilogin.com/) - 企业级指纹浏览器
- [Clash Verge](https://github.com/zzzgydi/clash-verge) - 代理工具
