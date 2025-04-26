module.exports = {
  // Authentication Configuration
  authentication: {
    enabled: true,
    providers: [
      {
        name: 'github',
        clientId: 'YOUR_GITHUB_CLIENT_ID',
        clientSecret: 'YOUR_GITHUB_CLIENT_SECRET'
      },
      {
        name: 'google',
        clientId: 'YOUR_GOOGLE_CLIENT_ID',
        clientSecret: 'YOUR_GOOGLE_CLIENT_SECRET'
      }
    ],
    session: {
      secret: 'YOUR_SESSION_SECRET',
      maxAge: 86400,
      secure: true,
      httpOnly: true
    }
  },

  // Authorization Configuration
  authorization: {
    enabled: true,
    roles: [
      {
        name: 'admin',
        permissions: ['read', 'write', 'delete', 'manage']
      },
      {
        name: 'editor',
        permissions: ['read', 'write']
      },
      {
        name: 'viewer',
        permissions: ['read']
      }
    ],
    policies: [
      {
        resource: '/api/*',
        roles: ['admin', 'editor']
      },
      {
        resource: '/admin/*',
        roles: ['admin']
      }
    ]
  },

  // Security Headers
  headers: {
    enabled: true,
    contentSecurityPolicy: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "'unsafe-inline'", "'unsafe-eval'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", 'data:', 'https:'],
      connectSrc: ["'self'"],
      fontSrc: ["'self'"],
      objectSrc: ["'none'"],
      mediaSrc: ["'self'"],
      frameSrc: ["'none'"]
    },
    strictTransportSecurity: {
      maxAge: 31536000,
      includeSubDomains: true,
      preload: true
    },
    xFrameOptions: 'DENY',
    xContentTypeOptions: 'nosniff',
    xXSSProtection: '1; mode=block',
    referrerPolicy: 'strict-origin-when-cross-origin'
  },

  // Rate Limiting
  rateLimiting: {
    enabled: true,
    windowMs: 900000,
    max: 100,
    message: 'Too many requests, please try again later.'
  },

  // CORS Configuration
  cors: {
    enabled: true,
    origin: [
      'https://docs.plantarium.com',
      'https://api.plantarium.com'
    ],
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    exposedHeaders: ['Content-Range', 'X-Content-Range'],
    credentials: true,
    maxAge: 86400
  },

  // Input Validation
  validation: {
    enabled: true,
    sanitize: {
      html: true,
      sql: true,
      xss: true
    },
    validate: {
      json: true,
      xml: true,
      form: true
    }
  },

  // Logging Configuration
  logging: {
    enabled: true,
    level: 'info',
    format: 'json',
    transports: [
      {
        type: 'file',
        filename: 'security.log',
        maxsize: 5242880,
        maxFiles: 5
      },
      {
        type: 'console'
      }
    ]
  },

  // Monitoring Configuration
  monitoring: {
    enabled: true,
    tools: [
      {
        name: 'sentry',
        dsn: 'YOUR_SENTRY_DSN'
      },
      {
        name: 'datadog',
        apiKey: 'YOUR_DATADOG_API_KEY'
      }
    ],
    alerts: {
      enabled: true,
      channels: [
        {
          type: 'email',
          recipients: ['security@plantarium.com']
        },
        {
          type: 'slack',
          webhook: 'YOUR_SLACK_WEBHOOK'
        }
      ]
    }
  },

  // Backup Configuration
  backup: {
    enabled: true,
    schedule: '0 0 * * *',
    retention: 30,
    storage: {
      type: 's3',
      bucket: 'plantarium-docs-backup',
      region: 'us-east-1'
    },
    encryption: {
      enabled: true,
      algorithm: 'aes-256-gcm'
    }
  },

  // Incident Response
  incidentResponse: {
    enabled: true,
    procedures: [
      {
        type: 'security_breach',
        steps: [
          'Identify the breach',
          'Contain the breach',
          'Assess the damage',
          'Notify affected parties',
          'Implement fixes',
          'Review and improve'
        ]
      },
      {
        type: 'dos_attack',
        steps: [
          'Detect the attack',
          'Block malicious traffic',
          'Scale resources',
          'Monitor the situation',
          'Implement additional protections'
        ]
      }
    ],
    contacts: [
      {
        role: 'security_lead',
        name: 'Security Lead',
        email: 'security@plantarium.com',
        phone: '+1234567890'
      },
      {
        role: 'incident_manager',
        name: 'Incident Manager',
        email: 'incidents@plantarium.com',
        phone: '+1234567891'
      }
    ]
  }
}; 