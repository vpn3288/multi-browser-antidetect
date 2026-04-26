// ══════════════════════════════════════════════════════════════════
//  Canvas/WebGL 指纹随机化 - 真实但唯一的指纹
//  注入到每个浏览器，使其看起来像真实的美国用户
// ══════════════════════════════════════════════════════════════════

(function() {
    'use strict';
    
    // 为每个浏览器生成一个稳定但唯一的随机种子
    const browserSeed = Math.floor(Math.random() * 1000000);
    
    // 伪随机数生成器（基于种子，确保同一浏览器每次结果一致）
    function seededRandom(seed) {
        const x = Math.sin(seed++) * 10000;
        return x - Math.floor(x);
    }
    
    // 生成微小的噪声（不会被肉眼察觉，但会改变指纹）
    function addNoise(value, seed) {
        const noise = (seededRandom(seed) - 0.5) * 0.0001;
        return value + noise;
    }
    
    // ══════════════════════════════════════════════════════════════════
    //  Canvas 指纹保护
    // ══════════════════════════════════════════════════════════════════
    
    const originalToDataURL = HTMLCanvasElement.prototype.toDataURL;
    const originalToBlob = HTMLCanvasElement.prototype.toBlob;
    const originalGetImageData = CanvasRenderingContext2D.prototype.getImageData;
    
    // 拦截 toDataURL
    HTMLCanvasElement.prototype.toDataURL = function() {
        const context = this.getContext('2d');
        if (context) {
            const imageData = context.getImageData(0, 0, this.width, this.height);
            const data = imageData.data;
            
            // 在像素数据中添加微小噪声
            for (let i = 0; i < data.length; i += 4) {
                data[i] = Math.min(255, Math.max(0, addNoise(data[i], browserSeed + i)));
                data[i+1] = Math.min(255, Math.max(0, addNoise(data[i+1], browserSeed + i + 1)));
                data[i+2] = Math.min(255, Math.max(0, addNoise(data[i+2], browserSeed + i + 2)));
            }
            
            context.putImageData(imageData, 0, 0);
        }
        return originalToDataURL.apply(this, arguments);
    };
    
    // 拦截 getImageData
    CanvasRenderingContext2D.prototype.getImageData = function() {
        const imageData = originalGetImageData.apply(this, arguments);
        const data = imageData.data;
        
        // 添加微小噪声
        for (let i = 0; i < data.length; i += 4) {
            data[i] = Math.min(255, Math.max(0, addNoise(data[i], browserSeed + i)));
            data[i+1] = Math.min(255, Math.max(0, addNoise(data[i+1], browserSeed + i + 1)));
            data[i+2] = Math.min(255, Math.max(0, addNoise(data[i+2], browserSeed + i + 2)));
        }
        
        return imageData;
    };
    
    // ══════════════════════════════════════════════════════════════════
    //  WebGL 指纹保护
    // ══════════════════════════════════════════════════════════════════
    
    const getParameter = WebGLRenderingContext.prototype.getParameter;
    WebGLRenderingContext.prototype.getParameter = function(parameter) {
        // 随机化 WebGL 参数（但保持在合理范围内）
        if (parameter === 37445) { // UNMASKED_VENDOR_WEBGL
            const vendors = ['Intel Inc.', 'NVIDIA Corporation', 'AMD', 'Apple Inc.'];
            return vendors[browserSeed % vendors.length];
        }
        if (parameter === 37446) { // UNMASKED_RENDERER_WEBGL
            const renderers = [
                'Intel(R) UHD Graphics 630',
                'NVIDIA GeForce RTX 3060',
                'AMD Radeon RX 6700 XT',
                'Apple M1',
                'NVIDIA GeForce GTX 1660',
                'Intel(R) Iris(R) Xe Graphics'
            ];
            return renderers[browserSeed % renderers.length];
        }
        return getParameter.apply(this, arguments);
    };
    
    // ══════════════════════════════════════════════════════════════════
    //  AudioContext 指纹保护
    // ══════════════════════════════════════════════════════════════════
    
    const AudioContext = window.AudioContext || window.webkitAudioContext;
    if (AudioContext) {
        const originalCreateOscillator = AudioContext.prototype.createOscillator;
        AudioContext.prototype.createOscillator = function() {
            const oscillator = originalCreateOscillator.apply(this, arguments);
            const originalStart = oscillator.start;
            oscillator.start = function() {
                // 添加微小的频率偏移
                if (this.frequency) {
                    this.frequency.value = addNoise(this.frequency.value, browserSeed);
                }
                return originalStart.apply(this, arguments);
            };
            return oscillator;
        };
    }
    
    // ══════════════════════════════════════════════════════════════════
    //  Navigator 属性保护
    // ══════════════════════════════════════════════════════════════════
    
    // 隐藏自动化控制特征
    Object.defineProperty(navigator, 'webdriver', {
        get: () => undefined
    });
    
    // 随机化硬件并发数（但保持合理）
    const cores = [4, 6, 8, 10, 12, 16];
    Object.defineProperty(navigator, 'hardwareConcurrency', {
        get: () => cores[browserSeed % cores.length]
    });
    
    // 随机化设备内存（但保持合理）
    const memories = [4, 8, 16, 32];
    Object.defineProperty(navigator, 'deviceMemory', {
        get: () => memories[browserSeed % memories.length]
    });
    
    // ══════════════════════════════════════════════════════════════════
    //  Screen 属性保护
    // ══════════════════════════════════════════════════════════════════
    
    const realScreens = [
        {width: 1920, height: 1080, colorDepth: 24},
        {width: 1366, height: 768, colorDepth: 24},
        {width: 2560, height: 1440, colorDepth: 24},
        {width: 1536, height: 864, colorDepth: 24},
        {width: 1440, height: 900, colorDepth: 24},
        {width: 1600, height: 900, colorDepth: 24},
        {width: 3840, height: 2160, colorDepth: 30},
        {width: 2880, height: 1800, colorDepth: 24}
    ];
    
    const selectedScreen = realScreens[browserSeed % realScreens.length];
    
    Object.defineProperty(screen, 'width', {
        get: () => selectedScreen.width
    });
    
    Object.defineProperty(screen, 'height', {
        get: () => selectedScreen.height
    });
    
    Object.defineProperty(screen, 'colorDepth', {
        get: () => selectedScreen.colorDepth
    });
    
    // ══════════════════════════════════════════════════════════════════
    //  Plugins 和 MimeTypes 保护
    // ══════════════════════════════════════════════════════════════════
    
    // 使 plugins 和 mimeTypes 看起来真实
    Object.defineProperty(navigator, 'plugins', {
        get: () => {
            return {
                length: 3,
                0: {name: 'PDF Viewer', description: 'Portable Document Format', filename: 'internal-pdf-viewer'},
                1: {name: 'Chrome PDF Viewer', description: 'Portable Document Format', filename: 'internal-pdf-viewer'},
                2: {name: 'Chromium PDF Viewer', description: 'Portable Document Format', filename: 'internal-pdf-viewer'}
            };
        }
    });
    
    console.log('[指纹保护] Canvas/WebGL/Audio 指纹随机化已激活 (种子: ' + browserSeed + ')');
    
})();
