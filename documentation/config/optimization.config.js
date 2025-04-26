module.exports = {
  // CDN Configuration
  cdn: {
    enabled: true,
    provider: 'cloudflare',
    domains: [
      'docs.plantarium.com',
      'cdn.plantarium.com'
    ],
    cacheControl: {
      default: 'public, max-age=3600',
      images: 'public, max-age=86400',
      static: 'public, max-age=31536000'
    }
  },

  // Caching Configuration
  caching: {
    enabled: true,
    strategies: {
      // Browser caching
      browser: {
        enabled: true,
        maxAge: 3600,
        staleWhileRevalidate: 86400
      },
      // Server-side caching
      server: {
        enabled: true,
        type: 'redis',
        ttl: 3600
      },
      // CDN caching
      cdn: {
        enabled: true,
        ttl: 86400
      }
    }
  },

  // Compression Configuration
  compression: {
    enabled: true,
    algorithms: ['gzip', 'brotli'],
    minSize: 1024,
    exclude: [
      '*.jpg',
      '*.png',
      '*.gif',
      '*.zip',
      '*.gz'
    ]
  },

  // Minification Configuration
  minification: {
    enabled: true,
    html: {
      enabled: true,
      removeComments: true,
      collapseWhitespace: true,
      removeAttributeQuotes: true
    },
    css: {
      enabled: true,
      level: 2
    },
    js: {
      enabled: true,
      compress: true,
      mangle: true
    }
  },

  // Image Optimization
  images: {
    enabled: true,
    formats: ['webp', 'avif'],
    quality: 80,
    sizes: [
      {
        width: 320,
        suffix: '-small'
      },
      {
        width: 640,
        suffix: '-medium'
      },
      {
        width: 1024,
        suffix: '-large'
      }
    ]
  },

  // Resource Optimization
  resources: {
    enabled: true,
    inline: {
      css: true,
      js: false
    },
    concatenate: {
      css: true,
      js: true
    },
    lazyLoad: {
      images: true,
      iframes: true
    }
  },

  // Performance Monitoring
  monitoring: {
    enabled: true,
    metrics: [
      'first-contentful-paint',
      'largest-contentful-paint',
      'first-input-delay',
      'cumulative-layout-shift'
    ],
    thresholds: {
      fcp: 2000,
      lcp: 2500,
      fid: 100,
      cls: 0.1
    }
  },

  // Security Headers
  security: {
    enabled: true,
    headers: {
      'Content-Security-Policy': "default-src 'self'",
      'X-Content-Type-Options': 'nosniff',
      'X-Frame-Options': 'DENY',
      'X-XSS-Protection': '1; mode=block',
      'Strict-Transport-Security': 'max-age=31536000; includeSubDomains'
    }
  },

  // Error Handling
  errorHandling: {
    enabled: true,
    customErrorPages: true,
    logging: true,
    monitoring: true
  },

  // Analytics
  analytics: {
    enabled: true,
    providers: [
      {
        name: 'google-analytics',
        trackingId: 'G-XXXXXXXXXX'
      },
      {
        name: 'plausible',
        domain: 'docs.plantarium.com'
      }
    ]
  }
}; 