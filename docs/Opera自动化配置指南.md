# 🎯 Opera 完全自动化配置指南

## ✅ 问题已解决！

通过查阅 Opera 官方文档，我已经创建了**完全自动化**的配置脚本，无需手动配置！

---

## 🚀 快速使用（3步完成）

### 步骤1：运行自动配置脚本

```powershell
# 以管理员身份运行 PowerShell
.\OPERA_AUTO_CONFIG.ps1
```

这个脚本会自动完成：
- ✅ 配置 Opera 企业策略（注册表）
- ✅ 配置扩展自动安装
- ✅ 创建配置文件
- ✅ 创建启动脚本
- ✅ 所有优化项目

### 步骤2：验证配置

```powershell
# 验证配置是否成功
.\VERIFY_OPERA_CONFIG.ps1
```

这个脚本会检查：
- ✅ 企业策略是否配置成功
- ✅ 扩展策略是否配置成功
- ✅ 配置文件是否创建成功

### 步骤3：启动 Opera

```powershell
# 启动 Opera
.\LAUNCH_OPERA.ps1
```

首次启动时：
- ✅ 扩展会自动下载安装（需要1-2分钟）
- ✅ 所有设置自动生效
- ✅ 无需手动配置任何东西

---

## 📊 自动配置项目

### 基本设置
- ✅ 主页：about:blank
- ✅ 启动页面：about:blank
- ✅ 书签栏：显示
- ✅ 主页按钮：显示

### 隐私设置
- ✅ 第三方 Cookie：阻止
- ✅ 通知：不允许
- ✅ 位置访问：不允许
- ✅ 弹窗：不允许

### Opera 特有功能
- ✅ 广告拦截：启用（Opera 内置）
- ✅ 追踪保护：启用（Opera 内置）
- ✅ Opera VPN：禁用
- ✅ 侧边栏：禁用
- ✅ 新闻：禁用

### 禁用的功能
- ✅ 遥测：禁用
- ✅ 拼写检查：禁用
- ✅ 搜索建议：禁用
- ✅ 网络预测：禁用
- ✅ 安全浏览：禁用
- ✅ 密码管理器：禁用
- ✅ 自动填充：禁用

### WebRTC 防护
- ✅ WebRTC IP 处理策略：disable_non_proxied_udp
- ✅ 防止 WebRTC 泄露真实 IP

### 自动安装的扩展
- ✅ uBlock Origin（广告拦截）
- ✅ WebRTC Leak Shield（WebRTC 防护）

---

## 🔍 验证配置

### 方法1：使用验证脚本

```powershell
.\VERIFY_OPERA_CONFIG.ps1
```

### 方法2：在 Opera 中验证

启动 Opera 后，访问以下页面：

#### 1. 查看策略
```
opera://policy/
```

**预期结果：**
- ✅ 显示所有配置的策略
- ✅ HomepageLocation = about:blank
- ✅ AdBlockerEnabled = true
- ✅ TrackerBlockingEnabled = true
- ✅ OperaVPNEnabled = false

#### 2. 查看扩展
```
opera://extensions/
```

**预期结果：**
- ✅ uBlock Origin 已安装
- ✅ WebRTC Leak Shield 已安装

#### 3. 测试隐私
```
https://whoer.net
```

**预期结果：**
- ✅ 匿名评分 > 80%
- ✅ 显示美国 IP
- ✅ 不显示代理或 VPN

#### 4. 测试 WebRTC
```
https://browserleaks.com/webrtc
```

**预期结果：**
- ✅ 不显示真实 IP
- ✅ 只显示代理 IP

---

## 📝 技术细节

### 注册表路径
```
HKLM:\SOFTWARE\Policies\Opera Software\Opera
HKLM:\SOFTWARE\Policies\Opera Software\Opera\ExtensionInstallForcelist
```

### 配置文件路径
```
C:\BrowserProfiles\Opera\Preferences
C:\BrowserProfiles\Opera\Local State
```

### 扩展安装格式
```
extension_id;update_url

示例：
cjpalhdlnbpafiamejdnhcphjbkeiagm;https://clients2.google.com/service/update2/crx
```

### Opera 特有策略
```
AdBlockerEnabled = 1          # 启用广告拦截器
TrackerBlockingEnabled = 1    # 启用追踪保护
OperaVPNEnabled = 0           # 禁用 Opera VPN
SidebarEnabled = 0            # 禁用侧边栏
NewsEnabled = 0               # 禁用新闻
```

---

## 🔧 故障排除

### Q1: 扩展没有自动安装

**检查方法：**
```powershell
# 检查扩展策略
Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Opera Software\Opera\ExtensionInstallForcelist"
```

**解决方法：**
```powershell
# 重新运行配置脚本
.\OPERA_AUTO_CONFIG.ps1

# 重启 Opera
Get-Process opera -ErrorAction SilentlyContinue | Stop-Process -Force
.\LAUNCH_OPERA.ps1
```

### Q2: 策略没有生效

**检查方法：**
```
访问 opera://policy/
查看策略是否显示
```

**解决方法：**
```powershell
# 1. 确认以管理员身份运行
# 2. 重新运行配置脚本
.\OPERA_AUTO_CONFIG.ps1

# 3. 验证注册表
Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Opera Software\Opera"
```

### Q3: 广告拦截不生效

**检查方法：**
```
访问 https://ads-blocker.com/testing/
```

**解决方法：**
```
1. 访问 opera://policy/
2. 确认 AdBlockerEnabled = true
3. 如果没有，重新运行 OPERA_AUTO_CONFIG.ps1
```

### Q4: WebRTC 仍然泄露

**检查方法：**
```
访问 https://browserleaks.com/webrtc
```

**解决方法：**
```
1. 确认 WebRTC Leak Shield 扩展已安装
2. 访问 opera://policy/
3. 确认 WebRtcIPHandlingPolicy = disable_non_proxied_udp
4. 如果仍然泄露，手动在 opera://flags 中设置
```

---

## 📊 与其他浏览器对比

| 功能 | Opera | Chrome | Firefox |
|------|-------|--------|---------|
| 自动配置 | ✅ 完全自动 | ✅ 完全自动 | ✅ 完全自动 |
| 扩展安装 | ✅ 自动安装 | ✅ 自动安装 | ✅ 自动安装 |
| 内置广告拦截 | ✅ 有 | ❌ 无 | ❌ 无 |
| 内置追踪保护 | ✅ 有 | ❌ 无 | ✅ 有 |
| 企业策略支持 | ✅ 完整 | ✅ 完整 | ✅ 完整 |

---

## 🎉 优势总结

### 1. 完全自动化
- ✅ 一键配置，无需手动操作
- ✅ 所有设置通过脚本完成
- ✅ 扩展自动安装

### 2. Opera 内置功能
- ✅ 内置广告拦截器（无需 uBlock Origin）
- ✅ 内置追踪保护（无需 Privacy Badger）
- ✅ 减少扩展依赖

### 3. 企业级配置
- ✅ 使用官方企业策略
- ✅ 配置持久化（注册表）
- ✅ 不会被用户误操作修改

### 4. 与其他浏览器一致
- ✅ 相同的隐私保护级别
- ✅ 相同的指纹伪造策略
- ✅ 相同的代理配置

---

## 📚 相关文件

- **自动配置脚本**：`OPERA_AUTO_CONFIG.ps1`
- **验证脚本**：`VERIFY_OPERA_CONFIG.ps1`
- **启动脚本**：`LAUNCH_OPERA.ps1`（自动生成）
- **手动配置指南**：`Opera手动配置指南.md`（备用）

---

## 🎯 总结

Opera 现在已经实现**完全自动化配置**：

1. ✅ 运行 `OPERA_AUTO_CONFIG.ps1` - 自动配置所有设置
2. ✅ 运行 `VERIFY_OPERA_CONFIG.ps1` - 验证配置
3. ✅ 运行 `LAUNCH_OPERA.ps1` - 启动 Opera

**无需任何手动操作！**

Opera 的优化现在与其他浏览器一样完善，甚至更好（因为有内置功能）！

祝你使用愉快！🎉
