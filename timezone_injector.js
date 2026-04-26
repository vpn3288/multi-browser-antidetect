// 时区自动匹配注入脚本
// 根据代理节点自动设置浏览器时区

(function() {
    'use strict';
    
    // 代理节点到时区的映射
    const PROXY_TIMEZONE_MAP = {
        'US': {
            timezone: 'America/New_York',
            offset: -300,  // UTC-5
            locale: 'en-US',
            language: 'en-US,en;q=0.9'
        },
        'JP': {
            timezone: 'Asia/Tokyo',
            offset: 540,   // UTC+9
            locale: 'ja-JP',
            language: 'ja-JP,ja;q=0.9,en-US;q=0.8,en;q=0.7'
        },
        'SG': {
            timezone: 'Asia/Singapore',
            offset: 480,   // UTC+8
            locale: 'en-SG',
            language: 'en-SG,en;q=0.9,zh-CN;q=0.8'
        },
        'UK': {
            timezone: 'Europe/London',
            offset: 0,     // UTC+0
            locale: 'en-GB',
            language: 'en-GB,en;q=0.9'
        },
        'DE': {
            timezone: 'Europe/Berlin',
            offset: 60,    // UTC+1
            locale: 'de-DE',
            language: 'de-DE,de;q=0.9,en;q=0.8'
        },
        'CA': {
            timezone: 'America/Toronto',
            offset: -300,  // UTC-5
            locale: 'en-CA',
            language: 'en-CA,en;q=0.9,fr-CA;q=0.8'
        },
        'AU': {
            timezone: 'Australia/Sydney',
            offset: 660,   // UTC+11
            locale: 'en-AU',
            language: 'en-AU,en;q=0.9'
        }
    };
    
    // 从环境变量或配置中获取当前代理节点
    const CURRENT_PROXY = window.BROWSER_PROXY_NODE || 'US';
    const config = PROXY_TIMEZONE_MAP[CURRENT_PROXY];
    
    if (!config) {
        console.warn('未知的代理节点:', CURRENT_PROXY);
        return;
    }
    
    console.log('应用时区配置:', config.timezone);
    
    // 1. 伪造 Date.prototype.getTimezoneOffset
    const originalGetTimezoneOffset = Date.prototype.getTimezoneOffset;
    Date.prototype.getTimezoneOffset = function() {
        return -config.offset;  // 注意：返回值是负的
    };
    
    // 2. 伪造 Intl.DateTimeFormat
    const originalDateTimeFormat = Intl.DateTimeFormat;
    Intl.DateTimeFormat = function(locales, options) {
        if (!locales) {
            locales = config.locale;
        }
        if (options && !options.timeZone) {
            options.timeZone = config.timezone;
        }
        return new originalDateTimeFormat(locales, options);
    };
    
    // 3. 伪造 navigator.language 和 navigator.languages
    Object.defineProperty(navigator, 'language', {
        get: function() {
            return config.locale;
        }
    });
    
    Object.defineProperty(navigator, 'languages', {
        get: function() {
            return config.language.split(',').map(l => l.split(';')[0].trim());
        }
    });
    
    // 4. 伪造 Accept-Language 请求头（需要配合扩展）
    console.log('时区注入完成:', {
        timezone: config.timezone,
        offset: config.offset,
        locale: config.locale,
        language: navigator.language,
        languages: navigator.languages
    });
    
})();
