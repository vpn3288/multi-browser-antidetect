// ═══════════════════════════════════════════════════════════
//  增强指纹伪造脚本 - 针对高级检测
// ═══════════════════════════════════════════════════════════

(function() {
    'use strict';
    
    console.log('[指纹伪造] 开始注入增强指纹保护...');
    
    // ═══════════════════════════════════════════════════════════
    //  1. 硬件信息伪造（根据代理节点）
    // ═══════════════════════════════════════════════════════════
    
    const HARDWARE_PROFILES = {
        'US': {
            hardwareConcurrency: 8,
            deviceMemory: 16,
            platform: 'Win32',
            vendor: 'Google Inc.',
            maxTouchPoints: 0
        },
        'JP': {
            hardwareConcurrency: 4,
            deviceMemory: 8,
            platform: 'Win32',
            vendor: 'Google Inc.',
            maxTouchPoints: 0
        },
        'SG': {
            hardwareConcurrency: 16,
            deviceMemory: 32,
            platform: 'Win32',
            vendor: 'Google Inc.',
            maxTouchPoints: 0
        },
        'UK': {
            hardwareConcurrency: 8,
            deviceMemory: 16,
            platform: 'Win32',
            vendor: 'Google Inc.',
            maxTouchPoints: 0
        },
        'DE': {
            hardwareConcurrency: 12,
            deviceMemory: 16,
            platform: 'Win32',
            vendor: 'Google Inc.',
            maxTouchPoints: 0
        },
        'CA': {
            hardwareConcurrency: 8,
            deviceMemory: 16,
            platform: 'Win32',
            vendor: 'Google Inc.',
            maxTouchPoints: 0
        },
        'AU': {
            hardwareConcurrency: 16,
            deviceMemory: 32,
            platform: 'Win32',
            vendor: 'Google Inc.',
            maxTouchPoints: 0
        }
    };
    
    // 从环境变量获取当前代理节点
    const CURRENT_PROXY = window.BROWSER_PROXY_NODE || 'US';
    const hwProfile = HARDWARE_PROFILES[CURRENT_PROXY] || HARDWARE_PROFILES['US'];
    
    // CPU 核心数
    Object.defineProperty(navigator, 'hardwareConcurrency', {
        get: () => hwProfile.hardwareConcurrency,
        configurable: true
    });
    
    // 设备内存
    Object.defineProperty(navigator, 'deviceMemory', {
        get: () => hwProfile.deviceMemory,
        configurable: true
    });
    
    // 平台信息
    Object.defineProperty(navigator, 'platform', {
        get: () => hwProfile.platform,
        configurable: true
    });
    
    // 触摸点数
    Object.defineProperty(navigator, 'maxTouchPoints', {
        get: () => hwProfile.maxTouchPoints,
        configurable: true
    });
    
    console.log('[指纹伪造] 硬件信息已伪造:', hwProfile);
    
    // ═══════════════════════════════════════════════════════════
    //  2. Canvas 指纹混淆（微小噪声）
    // ═══════════════════════════════════════════════════════════
    
    const originalToDataURL = HTMLCanvasElement.prototype.toDataURL;
    const originalToBlob = HTMLCanvasElement.prototype.toBlob;
    const originalGetImageData = CanvasRenderingContext2D.prototype.getImageData;
    
    // 添加微小噪声函数
    function addNoise(imageData) {
        const data = imageData.data;
        for (let i = 0; i < data.length; i += 4) {
            // 添加 ±1 的随机噪声（肉眼不可见）
            data[i] += Math.floor(Math.random() * 3) - 1;     // R
            data[i+1] += Math.floor(Math.random() * 3) - 1;   // G
            data[i+2] += Math.floor(Math.random() * 3) - 1;   // B
            // Alpha 通道不变
        }
        return imageData;
    }
    
    HTMLCanvasElement.prototype.toDataURL = function() {
        const context = this.getContext('2d');
        if (context) {
            const imageData = context.getImageData(0, 0, this.width, this.height);
            addNoise(imageData);
            context.putImageData(imageData, 0, 0);
        }
        return originalToDataURL.apply(this, arguments);
    };
    
    HTMLCanvasElement.prototype.toBlob = function() {
        const context = this.getContext('2d');
        if (context) {
            const imageData = context.getImageData(0, 0, this.width, this.height);
            addNoise(imageData);
            context.putImageData(imageData, 0, 0);
        }
        return originalToBlob.apply(this, arguments);
    };
    
    CanvasRenderingContext2D.prototype.getImageData = function() {
        const imageData = originalGetImageData.apply(this, arguments);
        return addNoise(imageData);
    };
    
    console.log('[指纹伪造] Canvas 指纹混淆已启用');
    
    // ═══════════════════════════════════════════════════════════
    //  3. WebGL 指纹伪造
    // ═══════════════════════════════════════════════════════════
    
    const getParameter = WebGLRenderingContext.prototype.getParameter;
    WebGLRenderingContext.prototype.getParameter = function(parameter) {
        // 37445 = UNMASKED_VENDOR_WEBGL
        if (parameter === 37445) {
            return 'Google Inc. (NVIDIA)';
        }
        // 37446 = UNMASKED_RENDERER_WEBGL
        if (parameter === 37446) {
            const renderers = [
                'ANGLE (NVIDIA, NVIDIA GeForce RTX 3060 Direct3D11 vs_5_0 ps_5_0)',
                'ANGLE (Intel, Intel(R) UHD Graphics 630 Direct3D11 vs_5_0 ps_5_0)',
                'ANGLE (NVIDIA, NVIDIA GeForce GTX 1660 Ti Direct3D11 vs_5_0 ps_5_0)',
                'ANGLE (AMD, AMD Radeon RX 580 Direct3D11 vs_5_0 ps_5_0)'
            ];
            // 根据浏览器选择不同的 GPU
            const index = Math.abs(CURRENT_PROXY.charCodeAt(0)) % renderers.length;
            return renderers[index];
        }
        return getParameter.apply(this, arguments);
    };
    
    console.log('[指纹伪造] WebGL 指纹已伪造');
    
    // ═══════════════════════════════════════════════════════════
    //  4. AudioContext 指纹混淆
    // ═══════════════════════════════════════════════════════════
    
    const AudioContext = window.AudioContext || window.webkitAudioContext;
    if (AudioContext) {
        const originalCreateOscillator = AudioContext.prototype.createOscillator;
        AudioContext.prototype.createOscillator = function() {
            const oscillator = originalCreateOscillator.apply(this, arguments);
            const originalStart = oscillator.start;
            oscillator.start = function() {
                // 添加微小频率偏移
                oscillator.frequency.value += Math.random() * 0.001;
                return originalStart.apply(this, arguments);
            };
            return oscillator;
        };
        console.log('[指纹伪造] AudioContext 指纹混淆已启用');
    }
    
    // ═══════════════════════════════════════════════════════════
    //  5. 屏幕分辨率伪造（真实常见分辨率）
    // ═══════════════════════════════════════════════════════════
    
    const SCREEN_RESOLUTIONS = [
        { width: 1920, height: 1080 },  // Full HD
        { width: 2560, height: 1440 },  // 2K
        { width: 1366, height: 768 },   // 常见笔记本
        { width: 1440, height: 900 },   // 16:10
        { width: 3840, height: 2160 }   // 4K
    ];
    
    const selectedResolution = SCREEN_RESOLUTIONS[Math.abs(CURRENT_PROXY.charCodeAt(0)) % SCREEN_RESOLUTIONS.length];
    
    Object.defineProperty(screen, 'width', {
        get: () => selectedResolution.width,
        configurable: true
    });
    
    Object.defineProperty(screen, 'height', {
        get: () => selectedResolution.height,
        configurable: true
    });
    
    Object.defineProperty(screen, 'availWidth', {
        get: () => selectedResolution.width,
        configurable: true
    });
    
    Object.defineProperty(screen, 'availHeight', {
        get: () => selectedResolution.height - 40,  // 减去任务栏高度
        configurable: true
    });
    
    console.log('[指纹伪造] 屏幕分辨率已伪造:', selectedResolution);
    
    // ═══════════════════════════════════════════════════════════
    //  6. 电池信息伪造（防止电池指纹）
    // ═══════════════════════════════════════════════════════════
    
    if (navigator.getBattery) {
        navigator.getBattery = async function() {
            return {
                charging: true,
                chargingTime: 0,
                dischargingTime: Infinity,
                level: 1.0,
                addEventListener: function() {},
                removeEventListener: function() {}
            };
        };
        console.log('[指纹伪造] 电池信息已伪造');
    }
    
    // ═══════════════════════════════════════════════════════════
    //  7. 媒体设备伪造
    // ═══════════════════════════════════════════════════════════
    
    if (navigator.mediaDevices && navigator.mediaDevices.enumerateDevices) {
        const originalEnumerateDevices = navigator.mediaDevices.enumerateDevices;
        navigator.mediaDevices.enumerateDevices = async function() {
            const devices = await originalEnumerateDevices.apply(this, arguments);
            // 随机化设备 ID
            return devices.map(device => ({
                ...device,
                deviceId: 'random-' + Math.random().toString(36).substr(2, 16),
                groupId: 'random-' + Math.random().toString(36).substr(2, 16)
            }));
        };
        console.log('[指纹伪造] 媒体设备已伪造');
    }
    
    // ═══════════════════════════════════════════════════════════
    //  8. 字体指纹防护
    // ═══════════════════════════════════════════════════════════
    
    const originalOffsetWidth = Object.getOwnPropertyDescriptor(HTMLElement.prototype, 'offsetWidth');
    const originalOffsetHeight = Object.getOwnPropertyDescriptor(HTMLElement.prototype, 'offsetHeight');
    
    Object.defineProperty(HTMLElement.prototype, 'offsetWidth', {
        get: function() {
            const width = originalOffsetWidth.get.call(this);
            // 添加微小偏移
            return width + (Math.random() > 0.5 ? 0.1 : -0.1);
        }
    });
    
    Object.defineProperty(HTMLElement.prototype, 'offsetHeight', {
        get: function() {
            const height = originalOffsetHeight.get.call(this);
            // 添加微小偏移
            return height + (Math.random() > 0.5 ? 0.1 : -0.1);
        }
    });
    
    console.log('[指纹伪造] 字体指纹防护已启用');
    
    // ═══════════════════════════════════════════════════════════
    //  9. 隐藏 webdriver 特征
    // ═══════════════════════════════════════════════════════════
    
    Object.defineProperty(navigator, 'webdriver', {
        get: () => undefined,
        configurable: true
    });
    
    // 删除 automation 相关属性
    delete window.cdc_adoQpoasnfa76pfcZLmcfl_Array;
    delete window.cdc_adoQpoasnfa76pfcZLmcfl_Promise;
    delete window.cdc_adoQpoasnfa76pfcZLmcfl_Symbol;
    
    console.log('[指纹伪造] webdriver 特征已隐藏');
    
    // ═══════════════════════════════════════════════════════════
    //  10. 时间戳混淆
    // ═══════════════════════════════════════════════════════════
    
    const originalNow = Date.now;
    const originalGetTime = Date.prototype.getTime;
    const offset = Math.floor(Math.random() * 100);
    
    Date.now = function() {
        return originalNow() + offset;
    };
    
    Date.prototype.getTime = function() {
        return originalGetTime.call(this) + offset;
    };
    
    console.log('[指纹伪造] 时间戳混淆已启用');
    
    // ═══════════════════════════════════════════════════════════
    //  完成
    // ═══════════════════════════════════════════════════════════
    
    console.log('[指纹伪造] ✓ 所有增强指纹保护已启用');
    console.log('[指纹伪造] 当前配置:', {
        proxy: CURRENT_PROXY,
        hardware: hwProfile,
        screen: selectedResolution
    });
    
})();
