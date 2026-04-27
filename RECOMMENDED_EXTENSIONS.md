# 推荐扩展文档

**版本：** v1.0  
**日期：** 2026-04-28  
**适用于：** 所有 8 个浏览器

---

## 核心功能扩展

### 1. 书签在新标签页打开 ⭐ 必装

#### Chromium 系（Chrome/Edge/Brave/Vivaldi/Opera/Chromium）

**扩展名称：** Bookmark Tab Opener  
**功能：** 强制所有书签在新标签页打开并自动跳转  
**安装方式：**
- Chrome Web Store 搜索 "Bookmark Tab Opener"
- 或搜索 "Open Bookmarks in New Tab"

**推荐扩展：**
1. **Bookmark Tab Opener** - 最简单直接
2. **Open Bookmarks in New Tab** - 功能更丰富
3. **Tab for a Cause** - 附带公益功能

**配置建议：**
- 启用"自动跳转到新标签页"
- 启用"关闭当前标签页"（可选）

#### Firefox 系（Firefox/LibreWolf）

**内置功能：** Firefox 支持通过设置实现

**手动设置：**
1. 在地址栏输入：`about:config`
2. 搜索：`browser.tabs.loadBookmarksInTabs`
3. 设置为：`true`

**或使用扩展：**
- **Open Bookmarks in New Tab** - 与 Chromium 版本类似

---

## 隐私增强扩展

### 2. 广告拦截 ⭐ 强烈推荐

#### uBlock Origin

**功能：**
- 拦截广告、追踪器、恶意软件
- 轻量级，不影响性能
- 开源，无隐私问题

**安装：**
- Chrome Web Store / Firefox Add-ons
- 搜索 "uBlock Origin"

**配置建议：**
- 启用所有默认过滤列表
- 启用"我是高级用户"模式（可选）
- 禁用"允许可接受的广告"

**注意：** Brave 浏览器内置广告拦截，可不安装

---

### 3. 追踪保护 ⭐ 推荐

#### Privacy Badger

**功能：**
- 自动学习并阻止追踪器
- 由 EFF（电子前沿基金会）开发
- 与 uBlock Origin 互补

**安装：**
- Chrome Web Store / Firefox Add-ons
- 搜索 "Privacy Badger"

**配置建议：**
- 保持默认设置
- 允许它自动学习

---

### 4. Canvas 指纹保护 ⭐ 推荐

#### Canvas Defender / Canvas Blocker

**功能：**
- 防止 Canvas 指纹追踪
- 为每个网站生成不同的 Canvas 指纹
- 增强匿名性

**推荐：**
- **Canvas Defender**（Chromium 系）
- **CanvasBlocker**（Firefox 系）

**配置建议：**
- 模式：随机噪声（Fake）
- 不要选择"阻止"模式（会被检测）

---

## 实用工具扩展

### 5. 代理切换器（可选）

#### Proxy SwitchyOmega

**功能：**
- 快速切换代理配置
- 支持多个代理配置文件
- 自动切换规则

**使用场景：**
- 如果你需要在不同代理之间快速切换
- 如果你使用多个代理服务

**注意：** 你已经通过启动脚本配置了代理，此扩展为可选

---

### 6. 用户代理切换器（可选）

#### User-Agent Switcher

**功能：**
- 修改浏览器 User-Agent
- 伪装成不同设备和浏览器

**使用场景：**
- 某些网站需要特定 User-Agent
- 进一步增强指纹差异化

**配置建议：**
- 设置为真实的美国常见 User-Agent
- 不要使用过于罕见的 User-Agent

---

### 7. Cookie 管理器（可选）

#### Cookie AutoDelete

**功能：**
- 关闭标签页后自动删除 Cookie
- 白名单管理
- 防止跨站追踪

**配置建议：**
- 启用"标签页关闭时删除"
- 添加常用网站到白名单

---

## 多账号管理扩展

### 8. 会话管理器 ⭐ 推荐（多账号任务）

#### Session Buddy / Session Manager

**功能：**
- 保存和恢复浏览器会话
- 管理多个账号的标签页组
- 快速切换工作环境

**使用场景：**
- 你提到的"多账号任务"
- 需要同时管理多个账号

**推荐：**
- **Session Buddy**（Chromium 系）
- **Session Manager**（Firefox 系）

---

### 9. 多账号容器（Firefox 专用）⭐ 强烈推荐

#### Firefox Multi-Account Containers

**功能：**
- 在同一浏览器中隔离不同账号
- 每个容器独立 Cookie 和登录状态
- 防止跨账号追踪

**使用场景：**
- 在 Firefox/LibreWolf 中管理多个账号
- 比开多个浏览器更方便

**配置建议：**
- 为每个任务创建独立容器
- 使用不同颜色标识

---

## 游戏相关扩展

### 10. 自动刷新器（可选）

#### Auto Refresh Plus / Tab Reloader

**功能：**
- 自动刷新页面
- 设置刷新间隔

**使用场景：**
- 网页游戏需要定时刷新
- 监控任务状态

---

## AI 使用相关（Gemini 等）

### 11. 请求头修改器（高级）

#### ModHeader

**功能：**
- 修改 HTTP 请求头
- 添加自定义 Header

**使用场景：**
- 某些 AI 服务检测请求头
- 需要伪装特定来源

**注意：** 仅在必要时使用，可能影响网站功能

---

## 扩展安装优先级

### 必装（解决你的核心需求）
1. ⭐⭐⭐ **Bookmark Tab Opener** - 书签在新标签页打开
2. ⭐⭐⭐ **uBlock Origin** - 广告拦截（Brave 除外）

### 强烈推荐（增强隐私和安全）
3. ⭐⭐ **Privacy Badger** - 追踪保护
4. ⭐⭐ **Canvas Defender** - 指纹保护
5. ⭐⭐ **Session Buddy** - 多账号管理（如果需要）

### 可选（根据需求）
6. ⭐ **Cookie AutoDelete** - Cookie 管理
7. ⭐ **User-Agent Switcher** - UA 切换
8. ⭐ **Auto Refresh Plus** - 自动刷新

---

## 扩展安装注意事项

### 1. 来源安全
- ✅ 只从官方商店安装
- ✅ 检查开发者和评分
- ❌ 不要从第三方网站下载

### 2. 权限审查
- 查看扩展请求的权限
- 避免安装请求过多权限的扩展
- 定期审查已安装扩展

### 3. 数量控制
- 不要安装过多扩展（影响性能）
- 建议每个浏览器不超过 10 个扩展
- 禁用不常用的扩展

### 4. 指纹考虑
- 扩展会影响浏览器指纹
- 每个浏览器安装不同的扩展组合
- 或者所有浏览器安装相同扩展（模拟真实用户）

---

## 不同浏览器的扩展策略

### Chrome
- 安装：uBlock Origin + Privacy Badger + Canvas Defender + Bookmark Tab Opener

### Edge
- 安装：uBlock Origin + Privacy Badger + Canvas Defender + Bookmark Tab Opener
- 可从 Chrome Web Store 或 Edge Add-ons 安装

### Brave
- **不需要** uBlock Origin（内置广告拦截）
- 安装：Privacy Badger + Canvas Defender + Bookmark Tab Opener

### Vivaldi
- 安装：uBlock Origin + Privacy Badger + Canvas Defender + Bookmark Tab Opener
- Vivaldi 内置一些功能，可减少扩展

### Opera
- 安装：uBlock Origin + Privacy Badger + Canvas Defender + Bookmark Tab Opener
- 可从 Chrome Web Store 安装

### Chromium
- 安装：uBlock Origin + Privacy Badger + Canvas Defender + Bookmark Tab Opener

### Firefox
- **不需要** Bookmark Tab Opener（使用 about:config 设置）
- 安装：uBlock Origin + Privacy Badger + CanvasBlocker
- **强烈推荐：** Multi-Account Containers（多账号管理）

### LibreWolf
- **不需要** uBlock Origin（内置 uBlock Origin）
- **不需要** Bookmark Tab Opener（使用 about:config 设置）
- 安装：Privacy Badger + CanvasBlocker
- **强烈推荐：** Multi-Account Containers（多账号管理）

---

## Firefox 书签设置（无需扩展）

### 启用书签在新标签页打开

1. 在地址栏输入：`about:config`
2. 点击"接受风险并继续"
3. 搜索：`browser.tabs.loadBookmarksInTabs`
4. 双击设置为：`true`
5. 重启浏览器

**完成！** Firefox/LibreWolf 现在会在新标签页打开书签。

---

## 扩展配置脚本（可选）

如果你想自动化扩展安装，可以使用以下方法：

### Chromium 系浏览器
```powershell
# 通过命令行安装扩展（需要扩展 ID）
# 示例：uBlock Origin
$extensionId = "cjpalhdlnbpafiamejdnhcphjbkeiagm"
$registryPath = "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist"
Set-ItemProperty -Path $registryPath -Name "1" -Value $extensionId
```

**注意：** 这会强制安装扩展，用户无法卸载。建议手动安装。

---

## 总结

### 最小化安装（解决核心需求）
- **Chromium 系：** Bookmark Tab Opener + uBlock Origin
- **Firefox 系：** about:config 设置 + uBlock Origin（LibreWolf 已内置）

### 推荐安装（最佳隐私保护）
- **Chromium 系：** Bookmark Tab Opener + uBlock Origin + Privacy Badger + Canvas Defender
- **Firefox 系：** about:config 设置 + Privacy Badger + CanvasBlocker + Multi-Account Containers

### 完整安装（最大功能）
- 上述所有 + Session Buddy + Cookie AutoDelete + User-Agent Switcher

---

**文档版本：** v1.0  
**最后更新：** 2026-04-28  
**维护者：** W (老教授级代码审查专家)
