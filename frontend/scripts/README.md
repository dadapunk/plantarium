# Build and Deployment Automation

This directory contains scripts for automating the build and deployment process of the Plantarium Flutter application.

## Directory Structure

```
scripts/
├── build/
│   └── build.sh      # Main build script
├── deploy/
│   └── deploy.sh     # Main deployment script
└── README.md         # This file
```

## Build Script (`build.sh`)

The build script handles building the Flutter application for different platforms and environments.

### Usage

```bash
./frontend/scripts/build/build.sh [options]
```

### Options

- `--platform=<platform>`: Target platform (web, android, ios, windows, linux, macos, or all)
- `--env=<env>`: Build environment (dev or prod)
- `--clean`: Clean build directory before building
- `--verbose`: Enable verbose output
- `--skip-tests`: Skip running tests before building

### Examples

```bash
# Build for web in development mode
./frontend/scripts/build/build.sh --platform=web --env=dev

# Build for all platforms in production mode
./frontend/scripts/build/build.sh --platform=all --env=prod

# Clean build for Android
./frontend/scripts/build/build.sh --platform=android --env=dev --clean
```

## Deployment Script (`deploy.sh`)

The deployment script handles deploying the built application to different environments.

### Usage

```bash
./frontend/scripts/deploy/deploy.sh [options]
```

### Options

- `--platform=<platform>`: Target platform (web, android, ios, windows, linux, or macos)
- `--env=<env>`: Deployment environment (dev or prod)
- `--version=<version>`: Version number for deployment
- `--verbose`: Enable verbose output
- `--skip-build`: Skip building before deployment

### Examples

```bash
# Deploy web version to development environment
./frontend/scripts/deploy/deploy.sh --platform=web --env=dev

# Deploy Android version to production
./frontend/scripts/deploy/deploy.sh --platform=android --env=prod --version=1.0.0

# Deploy without rebuilding
./frontend/scripts/deploy/deploy.sh --platform=web --env=dev --skip-build
```

## Build and Deployment Process

1. **Build Process**:
   - Validates environment and platform
   - Runs tests (unless skipped)
   - Gets dependencies
   - Runs code generation
   - Builds for specified platform(s)
   - Generates build report

2. **Deployment Process**:
   - Runs build script (unless skipped)
   - Creates deployment directory
   - Copies build artifacts
   - Adds environment-specific configuration
   - Packages deployment artifacts
   - Generates deployment report

## Output Files

### Build Output
- Build artifacts in `frontend/build/<env>/`
- Build report in `frontend/build/<env>/BUILD_REPORT.md`

### Deployment Output
- Deployment artifacts in `frontend/deploy/<env>/<version>/`
- Deployment report in `frontend/deploy/<env>/<version>/DEPLOYMENT_REPORT.md`

## Best Practices

1. Always run tests before deploying to production
2. Use version numbers for production deployments
3. Clean build before major releases
4. Check deployment reports for successful completion
5. Keep deployment artifacts organized by version

## Integration with CI/CD

These scripts can be integrated with CI/CD pipelines:

```yaml
# Example GitHub Actions workflow
name: Build and Deploy
on:
  push:
    branches: [ main ]
jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: ./frontend/scripts/build/build.sh --platform=all --env=prod
      - run: ./frontend/scripts/deploy/deploy.sh --platform=web --env=prod --version=${{ github.sha }}
``` 