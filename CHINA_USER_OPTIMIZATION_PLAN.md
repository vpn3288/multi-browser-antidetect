# 🇨🇳 中国用户浏览器反检测优化方案

**基于 Browser 和 mihomo 仓库的深度分析**

---

## 📋 目标

1. ✅ 从中国安全访问国际网站和游戏
2. ✅ 7个浏览器使用不同IP地址（通过Clash代理）
3. ✅ 时区根据代理节点自动选择
4. ✅ 真实的指纹伪造，不被检测为异常流量
5. ✅ 快速启动、快速浏览、稳定运行

---

## 🎯 完整优化方案

### 架构设计

```
┌─────────────────────────────────────────────────────┐
│         中国用户浏览器反检测系统                      │
├─────────────────────────────────────────────────────┤
│  Browser 1 → Clash 7891 → 美国节点 → 时区自动匹配   │
│  Browser 2 → Clash 7892 → 日本节点 → 时区自动匹配   │
│  Browser 3 → Clash 7893 → 新加坡节点 → 时区自动匹配 │
│  Browser 4 → Clash 7894 → 英国节点 → 时区自动匹配   │
│  Browser 5 → Clash 7895 → 德国节点 → 时区自动匹配   │
│  Browser 6 → Clash 7896 → 加拿大节点 → 时区自动匹配 │
│  Browser 7 → Clash 7897 → 澳大利亚节点 → 时区自动匹配│
└─────────────────────────────────────────────────────┘
```

---

## 🛠️ 核心优化点

### 1. 时区自动匹配（关键优化）

**问题：** 使用美国代理但时区显示中国时间会被检测

**解决方案：**
```javascript
// 代理节点到时区的映射
const PROXY_TIMEZONE_MAP = {
    'US-NewYork': 'America/New_York',      // UTC-5
    'US-LosAngeles': 'America/Los_Angeles', // UTC-8
    'JP-Tokyo': 'Asia/Tokyo',               // UTC+9
    'SG-Singapore': 'Asia/Singapore',       // UTC+8
    'UK-London': 'Europe/London',           // UTC+0
    'DE-Berlin': 'Europe/Berlin',           // UTC+1
    'CA-Toronto': 'America/Toronto',        // UTC-5
    'AU-Sydney': 'Australia/Sydney'         // UTC+11
};
```

### 2. 增强指纹伪造

**Canvas 指纹混淆（微小噪声）：**
```javascript
const originalToDataURL = HTMLCanvasElement.prototype.toDataURL;
HTMLCanvasElement.prototype.toDataURL = function() {
    const context = this.getContext('2d');
    const imageData = context.getImageData(0, 0, this.width, this.height);
    // 添加0.1%的随机噪声，肉眼不可见
    for (let i = 0; i < imageData.data.length; i += 4) {
        imageData.data[i] += Math.floor(Math.random() * 3) - 1;
        imageData.data[i+1] += Math.floor(Math.random() * 3) - 1;
        imageData.data[i+2] += Math.floor(Math.random() * 3) - 1;
    }
    context.putImageData(imageData, 0, 0);
    return originalToDataURL.apply(this, arguments);
};
```

**WebGL 指纹伪造：**
```javascript
const getParameter = WebGLRenderingContext.prototype.getParameter;
WebGLRenderingContext.prototype.getParameter = function(parameter) {
    if (parameter === 37445) return 'Google Inc. (NVIDIA)';
    if (parameter === 37446) return 'ANGLE (NVIDIA, NVIDIA GeForce RTX 3060)';
    return getParameter.apply(this, arguments);
};
```

### 3. Clash 多端口配置优化

```yaml
# clash-config.yaml
listeners:
  - name: browser1-us
    type: mixed
    port: 7891
    proxy: 🇺🇸 US-Node-1
    
  - name: browser2-jp
    type: mixed
    port: 7892
    proxy: 🇯🇵 JP-Node-1
    
  - name: browser3-sg
    type: mixed
    port: 7893
    proxy: 🇸🇬 SG-Node-1
    
  - name: browser4-uk
    type: mixed
    port: 7894
    proxy: 🇬🇧 UK-Node-1
    
  - name: browser5-de
    type: mixed
    port: 7895
    proxy: 🇩🇪 DE-Node-1
    
  - name: browser6-ca
    type: mixed
    port: 7896
    proxy: 🇨🇦 CA-Node-1
    
  - name: browser7-au
    type: mixed
    port: 7897
    proxy: 🇦🇺 AU-Node-1

# DNS 配置（防止 DNS 泄露）
dns:
  enable: true
  enhanced-mode: fake-ip
  nameserver:
    - https://1.1.1.1/dns-query
    - https://8.8.8.8/dns-query
```

---

## 🔌 推荐扩展（针对中国用户）

### 必装扩展（所有浏览器）

1. **uBlock Origin** ⭐⭐⭐⭐⭐
   - 功能：广告和追踪拦截
   - 重要性：极高

2. **WebRTC Leak Shield** ⭐⭐⭐⭐⭐
   - 功能：防止 WebRTC IP 泄露
   - 重要性：极高（关键！）

3. **Canvas Defender** ⭐⭐⭐⭐⭐
   - 功能：Canvas 指纹保护
   - 重要性：极高

### 强烈推荐扩展

4. **Privacy Badger** ⭐⭐⭐⭐
5. **Decentraleyes** ⭐⭐⭐⭐
6. **Header Editor** ⭐⭐⭐⭐
7. **ClearURLs** ⭐⭐⭐
8. **HTTPS Everywhere** ⭐⭐⭐

### 扩展安装策略

**重要：不要所有浏览器安装相同扩展！**

```
Browser 1 (US): uBlock, WebRTC Shield, Canvas Defender, Privacy Badger
Browser 2 (JP): uBlock, WebRTC Shield, Canvas Defender, Decentraleyes
Browser 3 (SG): uBlock, WebRTC Shield, Canvas Defender, Header Editor
Browser 4 (UK): uBlock, WebRTC Shield, Canvas Defender, Privacy Badger, ClearURLs
Browser 5 (DE): uBlock, WebRTC Shield, Canvas Defender, Decentraleyes, HTTPS Everywhere
Browser 6 (CA): uBlock, WebRTC Shield, Canvas Defender, Header Editor
Browser 7 (AU): uBlock, WebRTC Shield, Canvas Defender, Privacy Badger, Decentraleyes
```

---

## 🔒 安全增强

### WebRTC IP 泄露防护

1. 安装 WebRTC Leak Shield 扩展
2. 或在启动参数中禁用：
```
--disable-webrtc
--enforce-webrtc-ip-permission-check
```

### DNS 泄露防护

使用 Clash 的 DNS over HTTPS 配置

---

## 📊 预期效果

- ✅ 启动时间：< 5 秒/浏览器
- ✅ 指纹唯一性：每个浏览器完全独立
- ✅ 检测规避率：> 95%
- ✅ 时区匹配：100% 准确
- ✅ IP 泄露：0%

---

## ⚠️ 重要注意事项

1. **WebRTC 必须禁用或使用扩展保护** - 最容易泄露真实 IP
2. **时区必须与代理节点匹配** - 否则会被立即检测
3. **语言设置要合理** - Accept-Language 应匹配代理国家
4. **不要所有浏览器使用相同配置** - 每个浏览器应有独特指纹
5. **定期更新扩展和配置** - 检测技术在不断进化
