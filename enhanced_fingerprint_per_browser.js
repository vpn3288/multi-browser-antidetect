// ═══════════════════════════════════════════════════════════
//  针对每个浏览器的增强指纹伪造脚本
//  根据 fingerprint_config_per_browser.json 配置注入
// ═══════════════════════════════════════════════════════════

(function() {
    'use strict';
    
    // 从环境变量或配置中获取当前浏览器名称
    const BROWSER_NAME = window.BROWSER_NAME || detectBrowserName();
    
    // 浏览器指纹配置
    const FINGERPRINT_CONFIG = {
        "Chrome": {
            screen: { width: 1920, height: 1080, availWidth: 1920, availHeight: 1040 },
            hardware: { hardwareConcurrency: 8, deviceMemory: 16, platform: "Win32", maxTouchPoints: 0 },
            gpu: { vendor: "Google Inc. (NVIDIA)", renderer: "ANGLE (NVIDIA, NVIDIA GeForce RTX 3060 Direct3D11 vs_5_0 ps_5_0)" },
            timezone: "America/New_York",
            timezoneOffset: -300
        },
        "Firefox": {
            screen: { width: 2560, height: 1440, availWidth: 2560, availHeight: 1400 },
            hardware: { hardwareConcurrency: 4, deviceMemory: 8, platform: "Win32", maxTouchPoints: 0 },
            gpu: { vendor: "Intel", renderer: "Intel(R) UHD Graphics 630" },
            timezone: "America/Los_Angeles",
            timezoneOffset: -480
        },
        "Edge": {
            screen: { width: 1366, height: 768, availWidth: 1366, availHeight: 728 },
            hardware: { hardwareConcurrency: 16, deviceMemory: 32, platform: "Win32", maxTouchPoints: 0 },
            gpu: { vendor: "Google Inc. (AMD)", renderer: "ANGLE (AMD, AMD Radeon RX 580 Direct3D11 vs_5_0 ps_5_0)" },
            timezone: "America/Chicago",
            timezoneOffset: -360
        },
        "Brave": {
            screen: { width: 1440, height: 900, availWidth: 1440, availHeight: 860 },
            hardware: { hardwareConcurrency: 6, deviceMemory: 16, platform: "Win32", maxTouchPoints: 0 },
            gpu: { vendor: "Google Inc. (NVIDIA)", renderer: "ANGLE (NVIDIA, NVIDIA GeForce GTX 1660 Ti Direct3D11 vs_5_0 ps_5_0)" },
            timezone: "America/Denver",
            timezoneOffset: -420
        },
        "Opera": {
            screen: { width: 1920, height: 1200, availWidth: 1920, availHeight: 1160 },
            hardware: { hardwareConcurrency: 8, deviceMemory: 16, platform: "Win32", maxTouchPoints: 0 },
            gpu: { vendor: "Google Inc. (NVIDIA)", renderer: "ANGLE (NVIDIA, NVIDIA GeForce RTX 2060 Direct3D11 vs_5_0 ps_5_0)" },
            timezone: "America/Phoenix",
            timezoneOffset: -420
        },
        "Vivaldi": {
            screen: { width: 2560, height: 1600, availWidth: 2560, availHeight: 1560 },
            hardware: { hardwareConcurrency: 12, deviceMemory: 32, platform: "Win32", maxTouchPoints: 0 },
            gpu: { vendor: "Google Inc. (NVIDIA)", renderer: "ANGLE (NVIDIA, NVIDIA GeForce RTX 3080 Direct3D11 vs_5_0 ps_5_0)" },
            timezone: "America/Los_Angeles",
            timezoneOffset: -480
        },
        "LibreWolf": {
            screen: { width: 1680, height: 1050, availWidth: 1680, availHeight: 1010 },
            hardware: { hardwareConcurrency: 4, deviceMemory: 8, platform: "Win32", maxTouchPoints: 0 },
            gpu: { vendor: "Intel", renderer: "Intel(R) Iris(R) Xe Graphics" },
            timezone: "America/New_York",
            timezoneOffset: -300
        },
        "Chromium": {
            screen: { width: 3840, height: 2160, availWidth: 3840, availHeight: 2120 },
            hardware: { hardwareConcurrency: 16, deviceMemory: 64, platform: "Win32", maxTouchPoints: 0 },
            gpu: { vendor: "Google Inc. (NVIDIA)", renderer: "ANGLE (NVIDIA, NVIDIA GeForce RTX 4090 Direct3D11 vs_5_0 ps_5_0)" },
            timezone: "America/Chicago",
            timezoneOffset: -360
        }
    };
    
    // 检测浏览器名称
    function detectBrowserName() {
        const ua = navigator.userAgent;
        if (ua.includes('Edg/')) return 'Edge';
        if (ua.includes('OPR/') || ua.includes('Opera/')) return 'Opera';
        if (ua.includes('Vivaldi/')) return 'Vivaldi';
        if (ua.includes('Brave/')) return 'Brave';
        if (ua.includes('Firefox/') && ua.includes('LibreWolf')) return 'LibreWolf';
        if (ua.includes('Firefox/')) return 'Firefox';
        if (ua.includes('Chrome/') && !ua.includes('Edg/') && !ua.includes('OPR/') && !ua.includes('Vivaldi/')) {
            // 区分 Chrome 和 Chromium
            return window.chrome && window.chrome.runtime ? 'Chrome' : 'Chromium';
        }
        return 'Chrome'; // 默认
    }
    
    const config = FINGERPRINT_CONFIG[BROWSER_NAME];
    
    if (!config) {
        console.warn('[指纹伪造] 未找到浏览器配置:', BROWSER_NAME);
        return;
    }
    
    console.log('[指纹伪造] 开始注入指纹保护 -', BROWSER_NAME);
    
    // ═══════════════════════════════════════════════════════════
    //  1. 硬件信息伪造
    // ═══════════════════════════════════════════════════════════
    
    Object.defineProperty(navigator, 'hardwareConcurrency', {
        get: () => config.hardware.hardwareConcurrency,
        configurable: true
    });
    
    Object.defineProperty(navigator, 'deviceMemory', {
        get: () => config.hardware.deviceMemory,
        configurable: true
    });
    
    Object.defineProperty(navigator, 'platform', {
        get: () => config.hardware.platform,
        configurable: true
    });
    
    Object.defineProperty(navigator, 'maxTouchPoints', {
        get: () => config.hardware.maxTouchPoints,
        configurable: true
    });
    
    console.log('[指纹伪造] 硬件信息已伪造:', config.hardware);
    
    // ═══════════════════════════════════════════════════════════
    //  2. 屏幕分辨率伪造
    // ═══════════════════════════════════════════════════════════
    
    Object.defineProperty(screen, 'width', {
        get: () => config.screen.width,
        configurable: true
    });
    
    Object.defineProperty(screen, 'height', {
        get: () => config.screen.height,
        configurable: true
    });
    
    Object.defineProperty(screen, 'availWidth', {
        get: () => config.screen.availWidth,
        configurable: true
    });
    
    Object.defineProperty(screen, 'availHeight', {
        get: () => config.screen.availHeight,
        configurable: true
    });
    
    console.log('[指纹伪造] 屏幕分辨率已伪造:', config.screen);
    
    // ═══════════════════════════════════════════════════════════
    //  3. WebGL 指纹伪造
    // ═══════════════════════════════════════════════════════════
    
    const getParameter = WebGLRenderingContext.prototype.getParameter;
    WebGLRenderingContext.prototype.getParameter = function(parameter) {
        if (parameter === 37445) return config.gpu.vendor;
        if (parameter === 37446) return config.gpu.renderer;
        return getParameter.apply(this, arguments);
    };
    
    console.log('[指纹伪造] WebGL 指纹已伪造:', config.gpu);
    
    // ═══════════════════════════════════════════════════════════
    //  4. 时区伪造
    // ═══════════════════════════════════════════════════════════
    
    const originalGetTimezoneOffset = Date.prototype.getTimezoneOffset;
    Date.prototype.getTimezoneOffset = function() {
        return config.timezoneOffset;
    };
    
    // 伪造 Intl.DateTimeFormat
    const originalDateTimeFormat = Intl.DateTimeFormat;
    Intl.DateTimeFormat = function(locales, options) {
        if (options && !options.timeZone) {
            options.timeZone = config.timezone;
        }
        return new originalDateTimeFormat(locales, options);
    };
    
    console.log('[指纹伪造] 时区已伪造:', config.timezone);
    
    // ═══════════════════════════════════════════════════════════
    //  5. Canvas 指纹混淆（添加微小噪声）
    // ═══════════════════════════════════════════════════════════
    
    const originalToDataURL = HTMLCanvasElement.prototype.toDataURL;
    const originalToBlob = HTMLCanvasElement.prototype.toBlob;
    const originalGetImageData = CanvasRenderingContext2D.prototype.getImageData;
    
    // 根据浏览器名称生成不同的噪声种子
    const noiseSeed = BROWSER_NAME.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0);
    
    function addNoise(imageData) {
        const data = imageData.data;
        for (let i = 0; i < data.length; i += 4) {
            // 使用浏览器特定的噪声种子
            const noise = ((i + noiseSeed) % 3) - 1;
            data[i] += noise;     // R
            data[i+1] += noise;   // G
            data[i+2] += noise;   // B
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
    
    console.log('[指纹伪造] Canvas 指纹混淆已启用 (种子:', noiseSeed, ')');
    
    // ═══════════════════════════════════════════════════════════
    //  6. AudioContext 指纹混淆
    // ═══════════════════════════════════════════════════════════
    
    const AudioContext = window.AudioContext || window.webkitAudioContext;
    if (AudioContext) {
        const originalCreateOscillator = AudioContext.prototype.createOscillator;
        AudioContext.prototype.createOscillator = function() {
            const oscillator = originalCreateOscillator.apply(this, arguments);
            const originalStart = oscillator.start;
            oscillator.start = function() {
                // 根据浏览器添加不同的频率偏移
                oscillator.frequency.value += (noiseSeed % 10) * 0.0001;
                return originalStart.apply(this, arguments);
            };
            return oscillator;
        };
        console.log('[指纹伪造] AudioContext 指纹混淆已启用');
    }
    
    // ═══════════════════════════════════════════════════════════
    //  7. 电池信息伪造
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
    //  8. 媒体设备伪造
    // ═══════════════════════════════════════════════════════════
    
    if (navigator.mediaDevices && navigator.mediaDevices.enumerateDevices) {
        const originalEnumerateDevices = navigator.mediaDevices.enumerateDevices;
        navigator.mediaDevices.enumerateDevices = async function() {
            const devices = await originalEnumerateDevices.apply(this, arguments);
            return devices.map(device => ({
                ...device,
                deviceId: BROWSER_NAME + '-' + Math.random().toString(36).substr(2, 16),
                groupId: BROWSER_NAME + '-' + Math.random().toString(36).substr(2, 16)
            }));
        };
        console.log('[指纹伪造] 媒体设备已伪造');
    }
    
    // ═══════════════════════════════════════════════════════════
    //  9. 隐藏 webdriver 特征
    // ═══════════════════════════════════════════════════════════
    
    Object.defineProperty(navigator, 'webdriver', {
        get: () => undefined,
        configurable: true
    });
    
    delete window.cdc_adoQpoasnfa76pfcZLmcfl_Array;
    delete window.cdc_adoQpoasnfa76pfcZLmcfl_Promise;
    delete window.cdc_adoQpoasnfa76pfcZLmcfl_Symbol;
    
    console.log('[指纹伪造] webdriver 特征已隐藏');
    
    // ═══════════════════════════════════════════════════════════
    //  10. 时间戳混淆
    // ═══════════════════════════════════════════════════════════
    
    const originalNow = Date.now;
    const originalGetTime = Date.prototype.getTime;
    const timeOffset = noiseSeed % 100;
    
    Date.now = function() {
        return originalNow() + timeOffset;
    };
    
    Date.prototype.getTime = function() {
        return originalGetTime.call(this) + timeOffset;
    };
    
    console.log('[指纹伪造] 时间戳混淆已启用 (偏移:', timeOffset, 'ms)');
    
    // ═══════════════════════════════════════════════════════════
    //  完成
    // ═══════════════════════════════════════════════════════════
    
    console.log('[指纹伪造] ✓ 所有指纹保护已启用 -', BROWSER_NAME);
    console.log('[指纹伪造] 配置摘要:', {
        browser: BROWSER_NAME,
        screen: config.screen.width + 'x' + config.screen.height,
        cpu: config.hardware.hardwareConcurrency + ' cores',
        memory: config.hardware.deviceMemory + ' GB',
        gpu: config.gpu.renderer,
        timezone: config.timezone
    });
    
})();
