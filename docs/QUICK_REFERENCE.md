# 🚀 快速参考

## 一键部署

```powershell
# 以管理员身份运行
.\DEPLOY_8_BROWSERS.ps1
```

## 启动浏览器

```batch
# 启动所有
C:\BrowserProfiles\Launch_All.bat

# 单独启动
C:\BrowserProfiles\Launch_Chrome.bat
C:\BrowserProfiles\Launch_Firefox.bat
C:\BrowserProfiles\Launch_Edge.bat
# ... 等等
```

## 验证效果

| 检查项目 | 网址 | 预期结果 |
|---------|------|---------|
| IP地址 | https://ip.sb | 8个不同的美国IP |
| Canvas指纹 | https://browserleaks.com/canvas | 8个不同的指纹 |
| WebGL指纹 | https://browserleaks.com/webgl | 8个不同的GPU |
| WebRTC泄漏 | https://browserleaks.com/webrtc | 只显示代理IP |
| 设备信息 | https://www.deviceinfo.me/ | 真实的美国用户配置 |

## 代理端口分配

| 浏览器 | 端口 | 时区 |
|--------|------|------|
| Chrome | 7891 | America/New_York |
| Chromium | 7892 | America/Chicago |
| Firefox | 7893 | America/Denver |
| Edge | 7894 | America/Los_Angeles |
| Brave | 7895 | America/Phoenix |
| Opera | 7896 | America/Anchorage |
| Vivaldi | 7897 | Pacific/Honolulu |
| LibreWolf | 7898 | America/Boise |

## 已优化的功能

### ✅ 用户体验
- 书签栏默认显示
- 主页和新标签页为空白页
- 书签在新标签页打开
- 禁用默认浏览器检查弹窗
- 关闭所有新闻、广告、促销

### ✅ 隐私保护
- 阻止第三方Cookie
- WebRTC IP泄漏防护
- 禁用所有遥测
- 禁用DNS预取
- 第一方隔离（Firefox/LibreWolf）

### ✅ 指纹伪装
- Canvas指纹随机化
- WebGL指纹随机化
- AudioContext指纹随机化
- 8种不同的真实屏幕分辨率
- 8种不同的真实硬件配置
- 隐藏webdriver特征

### ✅ 性能优化
- 硬件加速
- V8引擎优化（Chrome）
- WebRender加速（Firefox/LibreWolf）
- 缓存优化

## 常用命令

```powershell
# 重新应用所有优化
.\DEPLOY_8_BROWSERS.ps1

# 只应用架构级优化
.\OPTIMIZE_ARCHITECTURE.ps1

# 启用双击关闭标签页
.\ENABLE_DOUBLE_CLICK_CLOSE.ps1

# 生成指纹配置
.\FINGERPRINT_RANDOMIZER.ps1
```

## 文件位置

```
配置目录: C:\BrowserProfiles\
启动脚本: C:\BrowserProfiles\Launch_*.bat
HTML报告: C:\BrowserProfiles\8浏览器部署报告.html
```

## 故障排除

### 浏览器无法启动
```powershell
.\DEPLOY_8_BROWSERS.ps1
```

### 代理不工作
检查Clash是否运行，端口是否正确（7891-7898）

### 书签栏不显示
按 `Ctrl + Shift + B` 或重新运行优化脚本

### Canvas指纹相同
检查 `C:\BrowserProfiles\*\fingerprint_protection.js` 是否存在

## 最佳实践

1. ✅ 每个浏览器使用不同的美国IP
2. ✅ 不要在多个浏览器登录同一账号
3. ✅ 模拟真实用户行为
4. ✅ 定期更新浏览器
5. ✅ 定期清理Cookie

## 获取帮助

- 详细文档: `README.md`
- 使用指南: `USAGE_GUIDE.md`
- 优化总结: `OPTIMIZATION_SUMMARY.md`
- GitHub Issues: https://github.com/vpn3288/multi-browser-antidetect/issues

---

**记住：最好的伪装是看起来像真实用户！** 🎭
