# Plantarium Docusaurus Setup

## Overview

This document provides detailed instructions for setting up the Plantarium documentation site using Docusaurus. This setup will allow us to maintain comprehensive, versioned documentation for both users and developers.

## Prerequisites

- Node.js 16.14 or above (preferably using nvm for version management)
- Yarn package manager (recommended) or npm
- Git for version control

## Project Initialization

### 1. Create the Documentation Directory

```bash
# Navigate to the project root
cd plantarium

# Create a dedicated documentation directory
mkdir -p documentation
cd documentation
```

### 2. Initialize Docusaurus Project

```bash
# Using npx to run the initialization command
npx @docusaurus/init@latest init . classic

# OR if using Yarn
yarn create docusaurus . classic
```

### 3. Directory Structure

After initialization, you should have the following structure:

```
documentation/
├── blog/
├── docs/
├── src/
│   ├── css/
│   └── pages/
├── static/
│   └── img/
├── docusaurus.config.js
├── package.json
├── sidebars.js
└── README.md
```

## Configuration

### 1. Update Site Metadata

Edit `docusaurus.config.js` to customize the site configuration:

```javascript
module.exports = {
  title: 'Plantarium Documentation',
  tagline: 'Your personal garden companion',
  url: 'https://docs.plantarium.app',
  baseUrl: '/',
  favicon: 'img/favicon.ico',
  organizationName: 'plantarium',
  projectName: 'plantarium-docs',
  
  // ... other configuration ...
}
```

### 2. Configure GitHub Pages Deployment

Add GitHub Pages deployment configuration to `docusaurus.config.js`:

```javascript
module.exports = {
  // ... existing configuration ...
  
  deploymentBranch: 'gh-pages',
  trailingSlash: false,
  
  // GitHub Pages deployment config
  organizationName: 'plantarium', // GitHub org/user name
  projectName: 'plantarium', // GitHub repo name
  
  // ... other configuration ...
}
```

### 3. Setup Custom Domain (If Required)

If using a custom domain:

1. Create a `static/CNAME` file with your domain:
   ```
   docs.plantarium.app
   ```

2. Configure DNS settings with your domain provider

## Development Environment Setup

### 1. Install Dependencies

```bash
# Using npm
npm install

# OR using Yarn
yarn install
```

### 2. Configure Local Development Scripts

Ensure your `package.json` has the following scripts:

```json
{
  "scripts": {
    "start": "docusaurus start",
    "build": "docusaurus build",
    "swizzle": "docusaurus swizzle",
    "deploy": "docusaurus deploy",
    "clear": "docusaurus clear",
    "serve": "docusaurus serve",
    "write-translations": "docusaurus write-translations",
    "write-heading-ids": "docusaurus write-heading-ids"
  }
}
```

### 3. Setup Documentation Linting

Install ESLint and Prettier for documentation code quality:

```bash
# Using npm
npm install --save-dev eslint eslint-plugin-markdown prettier eslint-config-prettier

# OR using Yarn
yarn add --dev eslint eslint-plugin-markdown prettier eslint-config-prettier
```

Create `.eslintrc.js` in the documentation directory:

```javascript
module.exports = {
  extends: ['eslint:recommended', 'plugin:markdown/recommended', 'prettier'],
  plugins: ['markdown'],
  rules: {
    // Custom rules here
  },
};
```

## Version Control Integration

### 1. Branch Strategy

Create a dedicated branch strategy for documentation:

- `main` - Production documentation
- `develop` - Development documentation
- `docs/feature-name` - Feature-specific documentation changes

### 2. GitHub Actions Workflow

Create `.github/workflows/documentation.yml` in the repository root:

```yaml
name: Documentation

on:
  push:
    branches: [main]
    paths:
      - 'documentation/**'
  pull_request:
    branches: [main]
    paths:
      - 'documentation/**'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 16
          cache: yarn
          cache-dependency-path: documentation/yarn.lock
      
      - name: Install dependencies
        run: yarn install --frozen-lockfile
        working-directory: ./documentation
      
      - name: Build documentation
        run: yarn build
        working-directory: ./documentation
      
      - name: Deploy to GitHub Pages
        if: github.event_name != 'pull_request'
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./documentation/build
```

## Documentation Structure Setup

Follow the structure defined in `documentation_structure.md` to organize content:

```
docs/
├── getting-started/
│   ├── introduction.md
│   ├── installation.md
│   └── quick-start.md
├── core-features/
│   ├── garden-layout/
│   ├── plant-database/
│   ├── garden-notes/
│   ├── climate-weather/
│   ├── companion-planting/
│   ├── crop-rotation/
│   └── calendar-scheduling/
├── technical/
│   ├── api-reference/
│   ├── database-schema/
│   ├── file-system/
│   └── integration-points/
└── contributing/
    ├── for-users.md
    └── for-developers.md
```

## Running the Documentation Site

### 1. Development Mode

```bash
# Navigate to the documentation directory
cd documentation

# Start the development server
npm start

# OR using Yarn
yarn start
```

This will start a local development server at http://localhost:3000.

### 2. Building for Production

```bash
# Build the documentation site
npm run build

# OR using Yarn
yarn build
```

The built files will be in the `build` directory.

### 3. Deploying to GitHub Pages

```bash
# Deploy to GitHub Pages
npm run deploy

# OR using Yarn
yarn deploy
```

## Next Steps

After the initial setup:

1. Create the sidebar configuration in `sidebars.js`
2. Set up the landing page in `src/pages/index.js`
3. Configure search functionality
4. Begin creating documentation content following the structure in `documentation_structure.md` 