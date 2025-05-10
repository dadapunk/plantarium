# Plantarium Documentation

This directory contains the documentation for the Plantarium project, organized into two main sections:

## Documentation Structure

### [MVP Documentation](./mvp/)
The MVP documentation focuses on the current development phase, providing essential information for the Minimum Viable Product. This documentation is:
- **Minimal**: Covers only what's needed for the current phase
- **Implementation-focused**: Documents what is actually being built now
- **Essential**: Provides critical information for developers and users

Key MVP documents:
- [MVP Overview](./mvp/mvp_overview.md) - Scope and goals of the MVP
- [Core Features](./mvp/core_features.md) - Essential functionality in the MVP
- [Implementation Plan](./mvp/implementation_plan.md) - Simplified refactoring plan for MVP

### [Roadmap Documentation](./roadmap/)
The roadmap documentation preserves the comprehensive vision for the full product. This documentation:
- **Comprehensive**: Covers all planned aspects of the final product
- **Future-oriented**: Describes the target architecture and features
- **Reference material**: Serves as a north star for future development

Key roadmap documents:
- [Architecture Overview](./roadmap/architecture_overview.md) - Complete architectural vision

## Documentation Versioning

Documentation is marked with version indicators to clarify implementation timing:
- **v1.0 (MVP)**: Currently being implemented
- **v1.x**: Near-term enhancements after MVP
- **v2.0+**: Longer-term features and improvements

## Development Approach

This two-tier documentation approach supports our development strategy:
1. Deliver a functional MVP quickly with simplified architecture
2. Gather user feedback to validate core functionality
3. Incrementally enhance the product toward the full vision
4. Maintain architectural clarity throughout the process

## Using This Documentation

- **Current development**: Refer to the MVP documentation
- **Planning future work**: Refer to the roadmap documentation
- **Onboarding new team members**: Start with MVP, then explore the roadmap
- **Stakeholder communication**: Use MVP docs for current state, roadmap for vision

# Website

This website is built using [Docusaurus](https://docusaurus.io/), a modern static website generator.

### Installation

```
$ yarn
```

### Local Development

```
$ yarn start
```

This command starts a local development server and opens up a browser window. Most changes are reflected live without having to restart the server.

### Build

```
$ yarn build
```

This command generates static content into the `build` directory and can be served using any static contents hosting service.

### Deployment

Using SSH:

```
$ USE_SSH=true yarn deploy
```

Not using SSH:

```
$ GIT_USER=<Your GitHub username> yarn deploy
```

If you are using GitHub pages for hosting, this command is a convenient way to build the website and push to the `gh-pages` branch.
