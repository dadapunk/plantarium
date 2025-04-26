module.exports = {
  // Performance Monitoring
  performance: {
    enabled: true,
    metrics: {
      pageLoadTime: {
        threshold: 3000, // 3 seconds
        alert: true
      },
      timeToFirstByte: {
        threshold: 1000, // 1 second
        alert: true
      },
      firstContentfulPaint: {
        threshold: 2000, // 2 seconds
        alert: true
      }
    },
    tools: [
      {
        name: 'lighthouse',
        config: {
          performance: 90,
          accessibility: 90,
          bestPractices: 90,
          seo: 90
        }
      }
    ]
  },

  // Error Tracking
  errorTracking: {
    enabled: true,
    tools: [
      {
        name: 'sentry',
        dsn: 'YOUR_SENTRY_DSN',
        environment: process.env.NODE_ENV || 'development',
        release: process.env.VERSION || 'latest'
      }
    ],
    alerting: {
      email: ['devops@plantarium.com'],
      slack: 'YOUR_SLACK_WEBHOOK'
    }
  },

  // Usage Analytics
  analytics: {
    enabled: true,
    tools: [
      {
        name: 'google-analytics',
        trackingId: 'YOUR_GA_TRACKING_ID'
      },
      {
        name: 'plausible',
        domain: 'docs.plantarium.com'
      }
    ],
    metrics: [
      'pageViews',
      'uniqueVisitors',
      'averageTimeOnPage',
      'bounceRate',
      'searchQueries'
    ]
  },

  // Health Checks
  healthChecks: {
    enabled: true,
    endpoints: [
      {
        path: '/health',
        interval: 300000, // 5 minutes
        timeout: 5000,
        retries: 3
      },
      {
        path: '/api/health',
        interval: 300000,
        timeout: 5000,
        retries: 3
      }
    ],
    notifications: {
      email: ['devops@plantarium.com'],
      slack: 'YOUR_SLACK_WEBHOOK'
    }
  },

  // Monitoring Dashboard
  dashboard: {
    enabled: true,
    tools: [
      {
        name: 'grafana',
        url: 'YOUR_GRAFANA_URL',
        apiKey: 'YOUR_GRAFANA_API_KEY'
      },
      {
        name: 'datadog',
        apiKey: 'YOUR_DATADOG_API_KEY',
        appKey: 'YOUR_DATADOG_APP_KEY'
      }
    ],
    metrics: [
      'performance',
      'errors',
      'traffic',
      'search',
      'userFeedback'
    ]
  },

  // Logging
  logging: {
    enabled: true,
    level: 'info',
    format: 'json',
    transports: [
      {
        type: 'file',
        filename: 'monitoring.log',
        maxsize: 5242880, // 5MB
        maxFiles: 5
      },
      {
        type: 'console'
      }
    ]
  },

  // Alerting
  alerting: {
    enabled: true,
    channels: [
      {
        type: 'email',
        recipients: ['devops@plantarium.com']
      },
      {
        type: 'slack',
        webhook: 'YOUR_SLACK_WEBHOOK'
      },
      {
        type: 'pagerduty',
        serviceKey: 'YOUR_PAGERDUTY_SERVICE_KEY'
      }
    ],
    rules: [
      {
        metric: 'errorRate',
        threshold: 0.01, // 1%
        duration: '5m',
        severity: 'critical'
      },
      {
        metric: 'responseTime',
        threshold: 3000, // 3 seconds
        duration: '5m',
        severity: 'warning'
      }
    ]
  }
}; 