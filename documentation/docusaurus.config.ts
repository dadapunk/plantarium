import { themes as prismThemes } from 'prism-react-renderer';
import type { Config } from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';
import { securityConfig, optimizationConfig, analyticsConfig } from './config';
import monitoringConfig from './config/monitoring.config.js';

const config: Config = {
  title: 'Plantarium Documentation',
  tagline: 'Your Digital Garden Companion',
  favicon: 'img/favicon.ico',

  // GitHub Pages deployment config
  url: 'https://dadapunk.github.io',  // GitHub Pages URL
  baseUrl: '/plantarium/',    // Repository name
  trailingSlash: false,       // Remove trailing slashes from URLs
  deploymentBranch: 'gh-pages', // Branch for GitHub Pages

  // Organization and project information
  organizationName: 'dadapunk',  // GitHub organization or username
  projectName: 'plantarium',       // GitHub repository name

  // Custom fields for security, optimization, and monitoring
  customFields: {
    security: {
      ...securityConfig,
      headers: {
        'Content-Security-Policy': "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; connect-src 'self'; font-src 'self'; object-src 'none'; media-src 'self'; frame-src 'none'",
        'Strict-Transport-Security': 'max-age=31536000; includeSubDomains; preload',
        'X-Frame-Options': 'DENY',
        'X-Content-Type-Options': 'nosniff',
        'X-XSS-Protection': '1; mode=block',
        'Referrer-Policy': 'strict-origin-when-cross-origin'
      },
      rateLimiting: {
        enabled: true,
        windowMs: 900000,
        max: 100
      },
      validation: {
        enabled: true,
        sanitize: {
          html: true,
          sql: true,
          xss: true
        }
      }
    },
    optimization: optimizationConfig,
    analytics: analyticsConfig,
    monitoring: monitoringConfig
  },

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          editUrl: 'https://github.com/dadapunk/plantarium/tree/main/documentation/',
          versions: {
            current: {
              label: 'Next 🚧',
            },
          },
        },
        blog: {
          showReadingTime: true,
          editUrl: 'https://github.com/dadapunk/plantarium/tree/main/documentation/',
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    image: 'img/plantarium-social-card.jpg',
    navbar: {
      title: 'Plantarium',
      logo: {
        alt: 'Plantarium Logo',
        src: 'img/logo.svg',
        srcDark: 'img/logo-dark.svg',
      },
      style: 'dark',
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'docsSidebar',
          position: 'left',
          label: 'Documentation',
        },
        {
          to: '/docs/getting-started',
          label: 'Getting Started',
          position: 'left',
        },
        {
          to: '/docs/core-features',
          label: 'Features',
          position: 'left',
        },
        {
          to: '/docs/technical',
          label: 'Technical',
          position: 'left',
        },
        {
          href: 'https://github.com/dadapunk/plantarium',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {
              label: 'Getting Started',
              to: '/docs/getting-started',
            },
            {
              label: 'Core Features',
              to: '/docs/core-features',
            },
            {
              label: 'Technical Docs',
              to: '/docs/technical',
            },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/dadapunk/plantarium',
            },
            {
              label: 'Discord',
              href: 'https://discord.gg/plantarium',
            },
            {
              label: 'Twitter',
              href: 'https://twitter.com/plantarium',
            },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'Blog',
              to: '/blog',
            },
            {
              label: 'GitHub',
              href: 'https://github.com/dadapunk/plantarium',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Plantarium. Built with Docusaurus.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
