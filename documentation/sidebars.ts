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
        'getting-started/project-overview',
        'getting-started/architecture-overview',
      ],
    },
    {
      type: 'category',
      label: 'Development',
      items: [
        'development/development_phases',
        'development/documentation_gaps',
        'development/documentation_tasks',
      ],
    },
    {
      type: 'category',
      label: 'Contributing',
      items: [
        'contributing/contribution_guidelines',
        'contributing/documentation_guidelines',
        'contributing/documentation_style_guide',
        'contributing/review_guidelines',
      ],
    },
    {
      type: 'category',
      label: 'Project Information',
      items: [
        'project-info/software_specification',
        'project-info/documentation_structure',
        'project-info/roadmap',
        'project-info/maintenance_plan',
      ],
    },
    {
      type: 'category',
      label: 'Templates',
      items: [
        'templates/feature-template',
        'templates/introduction-style-guide',
        'templates/template-guide',
      ],
    },
  ],
};

export default sidebars;
