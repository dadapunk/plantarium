module.exports = {
  // Google Analytics configuration
  googleAnalytics: {
    trackingID: 'G-XXXXXXXXXX', // Replace with your Google Analytics tracking ID
    anonymizeIP: true,
  },

  // Documentation metrics
  metrics: {
    // Page view metrics
    pageViews: {
      enabled: true,
      trackPageViews: true,
      trackPageViewOnRouteUpdate: true,
    },

    // User interaction metrics
    userInteractions: {
      enabled: true,
      trackClicks: true,
      trackForms: true,
      trackScroll: true,
    },

    // Search metrics
    search: {
      enabled: true,
      trackSearchQueries: true,
      trackSearchResults: true,
    },

    // Performance metrics
    performance: {
      enabled: true,
      trackPageLoadTime: true,
      trackResourceLoadTime: true,
      trackFirstContentfulPaint: true,
    },

    // Custom events
    customEvents: {
      enabled: true,
      events: [
        {
          name: 'documentation_feedback',
          category: 'Feedback',
          action: 'Submit',
        },
        {
          name: 'code_example_usage',
          category: 'Code',
          action: 'Copy',
        },
        {
          name: 'documentation_share',
          category: 'Social',
          action: 'Share',
        },
      ],
    },
  },

  // Documentation quality metrics
  qualityMetrics: {
    // Content metrics
    content: {
      enabled: true,
      trackOutdatedContent: true,
      trackMissingSections: true,
      trackBrokenLinks: true,
    },

    // Code example metrics
    codeExamples: {
      enabled: true,
      trackExampleUsage: true,
      trackExampleErrors: true,
      trackExampleCompleteness: true,
    },

    // User feedback metrics
    userFeedback: {
      enabled: true,
      trackRatings: true,
      trackComments: true,
      trackHelpfulness: true,
    },

    // Search metrics
    searchMetrics: {
      enabled: true,
      trackSearchEffectiveness: true,
      trackSearchCompleteness: true,
      trackSearchRelevance: true,
    },
  },

  // Documentation monitoring
  monitoring: {
    // Error tracking
    errorTracking: {
      enabled: true,
      trackConsoleErrors: true,
      trackNetworkErrors: true,
      trackRenderErrors: true,
    },

    // Performance monitoring
    performanceMonitoring: {
      enabled: true,
      trackPageLoadTime: true,
      trackResourceLoadTime: true,
      trackRenderTime: true,
    },

    // User experience monitoring
    userExperience: {
      enabled: true,
      trackPageScroll: true,
      trackUserJourney: true,
      trackInteractionTime: true,
    },
  },

  // Documentation dashboard configuration
  dashboard: {
    enabled: true,
    metrics: [
      'pageViews',
      'userInteractions',
      'searchMetrics',
      'performanceMetrics',
      'qualityMetrics',
    ],
    refreshInterval: 300000, // 5 minutes
  },
}; 