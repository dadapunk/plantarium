import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

/**
 * Creating a sidebar enables you to:
 - create an ordered group of docs
 - render a sidebar for each doc of that group
 - provide next/previous navigation

 The sidebars can be generated from the filesystem, or explicitly defined here.

 Create as many sidebars as you want.
 */
const sidebars: SidebarsConfig = {
  docsSidebar: [
    {
      type: 'category',
      label: 'Getting Started',
      items: [
        'getting-started/introduction',
        'getting-started/installation',
        'getting-started/quickstart',
        'getting-started/architecture',
      ],
    },
    {
      type: 'category',
      label: 'Core Features',
      items: [
        'core-features/garden-layout',
        'core-features/plant-database',
        'core-features/garden-notes',
        'core-features/climate-weather',
        'core-features/companion-planting',
        'core-features/crop-rotation',
        'core-features/calendar-scheduling',
      ],
    },
    {
      type: 'category',
      label: 'Technical Documentation',
      items: [
        'technical/api-reference',
        'technical/database-schema',
        'technical/file-system',
        'technical/integration-points',
      ],
    },
    {
      type: 'category',
      label: 'Development Guide',
      items: [
        'development/getting-started',
        'development/workflow',
        'development/architecture',
        'development/testing',
      ],
    },
    {
      type: 'category',
      label: 'Contributing',
      items: [
        'contributing/guidelines',
        'contributing/development',
        'contributing/documentation',
        'contributing/code-of-conduct',
      ],
    },
    {
      type: 'category',
      label: 'Project Information',
      items: [
        'project-info/roadmap',
        'project-info/releases',
        'project-info/community',
        'project-info/license',
      ],
    },
  ],
};

export default sidebars;
