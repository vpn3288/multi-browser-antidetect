# 养号浏览器增强版部署指南

## 快速开始

### 1. 部署浏览器
```powershell
cd C:\Users\Newby\.openclaw\workspace\browser-setup
.\deploy-enhanced.ps1
```

### 2. 配置 Clash Verge
将 `clash-config-template.yaml` 的内容追加到 Clash 配置文件，替换节点名称后重启 Clash。

### 3. 启动验证
```cmd
C:\BrowserProfiles\Launch-All.bat
```

在每个浏览器访问：
- https://ip.sb （验证 IP）
- https://browserleaks.com/canvas （验证 Canvas 指纹）
- https://browserleaks.com/webgl （验证 WebGL 指纹）

---

## 增强功能

### 指纹随机化

每个浏览器具有独立且持久的指纹：

| 特征 | 实现方式 |
|------|---------|
| Canvas 指纹 | 注入噪声，每个浏览器不同 |
| WebGL 指纹 | 修改 Vendor/Renderer 参数 |
| 硬件信息 | 随机化 CPU 核心数、内存大小 |
| 屏幕分辨率 | 每个浏览器不同分辨率 |
| User-Agent | 轮换不同 Chrome 版本 |
| 时区 | 匹配美国不同时区 |

### 反检测措施

- 隐藏 `navigator.webdriver` 特征
- 修改 `navigator.plugins` 列表
- 禁用自动化控制特征
- 禁用域名可靠性追踪
- 禁用客户端钓鱼检测

### 指纹持久化

每个浏览器的指纹配置保存在：
```
C:\BrowserProfiles\Chrome[1-7]\fingerprint.json
```

重启浏览器后指纹保持一致，确保账号不会因指纹变化被检测。

---

## 时区分配

| 浏览器 | 时区 | 代表城市 |
|--------|------|---------|
| Chrome1 | America/New_York | 纽约 (EST) |
| Chrome2 | America/Chicago | 芝加哥 (CST) |
| Chrome3 | America/Denver | 丹佛 (MST) |
| Chrome4 | America/Los_Angeles | 洛杉矶 (PST) |
| Chrome5 | America/Phoenix | 凤凰城 (MST) |
| Chrome6 | America/Detroit | 底特律 (EST) |
| Chrome7 | America/Indianapolis | 印第安纳波利斯 (EST) |

---

## 养号建议

### 登录时间
- 每个账号固定时间段登录（模拟真人作息）
- 避免 7 个浏览器同时操作
- 建议间隔 5-10 分钟启动

### 操作行为
- 登录后先浏览首页 30-60 秒
- 随机点击 2-3 个链接
- 操作间隔 3-10 秒（模拟真人思考）
- 每次会话 10-30 分钟

### IP 管理
- 每个账号绑定固定 IP（不要频繁切换）
- 确保 IP 干净（未被其他人用过）
- 定期检查 IP 是否被封（访问目标平台）

### 风险控制
- 新账号前 7 天只浏览不操作
- 逐步增加活跃度（第 1 周 10 分钟/天，第 2 周 20 分钟/天）
- 避免批量操作（点赞、评论、关注）
- 定期更换头像、昵称（模拟真人）

---

## 验证清单

### 基础验证
- [ ] 7 个浏览器显示 7 个不同的美国 IP
- [ ] 每个浏览器的 Canvas 哈希值不同
- [ ] 每个浏览器的 WebGL 参数不同
- [ ] 每个浏览器的屏幕分辨率不同

### 高级验证
- [ ] https://pixelscan.net 综合评分 > 80
- [ ] https://abrahamjuliot.github.io/creepjs/ 无异常标记
- [ ] https://bot.sannysoft.com/ 无红色警告

### 持久化验证
- [ ] 重启浏览器后指纹保持一致
- [ ] 清除缓存后指纹保持一致
- [ ] 隔天登录后指纹保持一致

---

## 故障排查

### 指纹未生效
检查反检测脚本是否加载：
```powershell
Get-Content C:\BrowserProfiles\Chrome1\anti-detect.js
```

### 代理不生效
1. 确认 Clash Verge 正在运行
2. 检查端口 7891-7897 是否被占用：
```powershell
netstat -ano | findstr "789"
```

### 浏览器启动失败
检查 Chrome 路径：
```powershell
Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe"
```

---

## 高级配置

### 修改指纹参数
编辑 `deploy-enhanced.ps1` 中的 `New-BrowserFingerprint` 函数，调整随机范围。

### 添加更多浏览器
修改脚本中的 `1..7` 为 `1..10`，并在 Clash 配置中添加对应端口。

### 自定义时区
修改 `$Timezones` 数组，添加其他美国时区。

---

## 注意事项

⚠️ **重要警告**

1. **指纹隔离有限**：此方案基于 JavaScript 注入，无法修改底层硬件特征（如 GPU 驱动签名、字体渲染引擎）
2. **检测风险**：高级平台（Google/Facebook/Amazon）可能仍能检测到批量操作
3. **专业工具对比**：专业指纹浏览器（AdsPower/Multilogin）的隔离能力更强

**建议**：
- 小规模养号（< 10 个账号）可用此方案
- 大规模养号（> 20 个账号）建议使用专业工具
- 高价值账号（已有收益）建议迁移到专业工具

---

## 文件结构

```
C:\BrowserProfiles\
├── Chrome1\
│   ├── Default\
│   │   └── Preferences
│   ├── fingerprint.json
│   └── anti-detect.js
├── Chrome2\
│   └── ...
├── ...
├── Launch-Chrome1.bat
├── Launch-Chrome2.bat
├── ...
├── Launch-All.bat
└── Verify-Fingerprints.bat
```

---

**部署完成后，建议先用 1-2 个浏览器测试 3-7 天，确认无封号风险后再扩展到全部 7 个。**
