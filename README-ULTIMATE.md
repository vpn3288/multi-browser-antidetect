# 养号浏览器终极版 - 部署说明

## 快速开始

```powershell
cd C:\Users\Newby\.openclaw\workspace\browser-setup
.\deploy-ultimate.ps1
```

默认部署 **3 个浏览器**（降低风险）。

---

## 与增强版的区别

### 新增反检测功能

| 特征 | 增强版 v2.0 | 终极版 v3.0 |
|------|------------|------------|
| Canvas 指纹 | toDataURL 修改 | toDataURL + getImageData 双重修改 |
| WebGL 指纹 | 基础参数修改 | 完整参数 + 版本字符串修改 |
| 音频指纹 | ❌ 未处理 | ✅ AudioContext 噪声注入 |
| WebRTC | ❌ 未处理 | ✅ 完全禁用（防止 IP 泄漏）|
| Battery API | ❌ 未处理 | ✅ 伪造电池信息 |
| Connection API | ❌ 未处理 | ✅ 随机化网络延迟 |
| Permissions API | ❌ 未处理 | ✅ 修改权限查询结果 |
| Plugins/MIME | 简单列表 | 完整模拟真实插件 |
| Function.toString | ❌ 未处理 | ✅ 清理修改痕迹 |

### 指纹配置优化

- **真实的 GPU 配置池**（Intel UHD 620 / GTX 1060 / RX 580 / Iris Xe）
- **真实的屏幕分辨率池**（1920x1080 / 2560x1440 / 1366x768 等）
- **真实的 User-Agent**（Chrome 129/130/131）
- **更强的随机种子算法**（避免指纹碰撞）

### 风险控制

- **默认只部署 3 个浏览器**（而非 7 个）
- **间隔 10 秒启动**（避免批量操作特征）
- **附带完整的养号指南**（`养号指南.txt`）

---

## 使用流程

### 1. 部署浏览器

```powershell
.\deploy-ultimate.ps1
```

可选参数：
```powershell
# 部署 5 个浏览器
.\deploy-ultimate.ps1 -BrowserCount 5

# 自定义 Chrome 路径
.\deploy-ultimate.ps1 -ChromePath "D:\Chrome\chrome.exe"

# 自定义代理端口起始值
.\deploy-ultimate.ps1 -StartPort 8000
```

### 2. 配置 Clash Verge

将 `clash-config-template.yaml` 的内容追加到 Clash 配置文件：

```yaml
listeners:
  - name: browser-1
    type: mixed
    port: 7891
    proxy: 美国节点1  # 替换为实际节点名称
  
  - name: browser-2
    type: mixed
    port: 7892
    proxy: 美国节点2
  
  - name: browser-3
    type: mixed
    port: 7893
    proxy: 美国节点3
```

### 3. 启动浏览器

**首次使用（强烈建议）：**
```cmd
C:\BrowserProfiles\Launch-Single.bat
```
选择 `1`，只启动第一个浏览器测试。

**测试通过后：**
```cmd
C:\BrowserProfiles\Launch-All.bat
```

### 4. 验证指纹

在每个浏览器访问：
- https://ip.sb （确认不同 IP）
- https://browserleaks.com/canvas （确认不同 Canvas 哈希）
- https://browserleaks.com/webgl （确认不同 WebGL 参数）
- https://pixelscan.net （综合评分应 > 75）

---

## 养号策略（重要）

### 第一周：只用 1 个浏览器

**目标：建立账号信任度**

- 每天登录 1 次，停留 5-10 分钟
- 只浏览，不操作
- 浏览路径要自然（首页 → 热门 → 随机点击）

### 第二周：增加到 2 个浏览器

**目标：逐步提升活跃度**

- 第 1 个浏览器：开始轻度互动（点赞 1-2 次）
- 第 2 个浏览器：重复第一周流程
- 两个浏览器不要同时在线

### 第三周：稳定运营

**目标：开始执行任务**

- 可以启动第 3 个浏览器
- 每个浏览器固定活跃时间段
- 控制任务频率（不要贪多）

详细策略见 `C:\BrowserProfiles\养号指南.txt`

---

## 风险提示

### ⚠️ 此方案的局限性

1. **无法修改底层硬件特征**
   - GPU 驱动签名
   - 字体渲染引擎
   - TLS 指纹

2. **JavaScript 注入的时机问题**
   - 某些检测可能在脚本加载前执行
   - 页面刷新后需要重新注入

3. **高级平台仍可能检测**
   - Google/Facebook/Amazon 等有专业反作弊团队
   - 行为分析比指纹检测更难规避

### ✅ 适用场景

- 中小型平台（无专业反作弊团队）
- 任务平台（问卷调查、点击广告等）
- 社交媒体养号（Twitter/Instagram/TikTok 等）

### ❌ 不适用场景

- 高价值账号（已有收益 > $100/月）
- 金融平台（银行/支付/交易所）
- 大型电商平台（Amazon/eBay 等）

---

## 故障排查

### 浏览器无法启动

检查 Chrome 路径：
```powershell
Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe"
```

### 代理不生效

1. 确认 Clash Verge 正在运行
2. 检查端口占用：
```powershell
netstat -ano | findstr "7891"
```

### 指纹未生效

检查反检测脚本：
```powershell
Get-Content C:\BrowserProfiles\Chrome1\anti-detect.js
```

在浏览器控制台应该看到：
```
[AntiDetect] Fingerprint loaded successfully
```

### IP 相同

1. 确认 Clash 配置中的节点名称正确
2. 重启 Clash Verge
3. 在浏览器访问 https://ip.sb 确认

---

## 文件结构

```
C:\BrowserProfiles\
├── Chrome1\
│   ├── Default\
│   │   └── Preferences
│   ├── fingerprint.json       # 指纹配置
│   └── anti-detect.js          # 反检测脚本
├── Chrome2\
├── Chrome3\
├── Launch-Chrome1.bat          # 单独启动脚本
├── Launch-Chrome2.bat
├── Launch-Chrome3.bat
├── Launch-All.bat              # 全部启动（间隔 10 秒）
├── Launch-Single.bat           # 交互式单独启动
└── 养号指南.txt                # 风险控制指南
```

---

## 下一步

1. **阅读养号指南**（`C:\BrowserProfiles\养号指南.txt`）
2. **只启动 1 个浏览器测试 3-7 天**
3. **确认无封号风险后再扩展**

**记住：养号是长期工程，不要急于求成。一个稳定的老号 > 十个新号。**
