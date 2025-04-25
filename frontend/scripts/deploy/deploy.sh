#!/bin/bash

# Deployment script for Plantarium Frontend
# This script handles deploying the Flutter application to different environments

# Exit on error
set -e

# Default values
ENV="dev"
PLATFORM="web"
VERSION=$(date +%Y%m%d_%H:%M:%S)
BUILD_DIR="frontend/build/$ENV"
DEPLOY_DIR="frontend/deploy/$ENV/$VERSION"
VERBOSE=false
SKIP_BUILD=false

# Parse command line arguments
while [ "$1" != "" ]; do
    case $1 in
        --env=*)
            ENV="${1#*=}"
            ;;
        --platform=*)
            PLATFORM="${1#*=}"
            ;;
        --version=*)
            VERSION="${1#*=}"
            ;;
        --verbose)
            VERBOSE=true
            ;;
        --skip-build)
            SKIP_BUILD=true
            ;;
        *)
            echo "Unknown parameter: $1"
            exit 1
            ;;
    esac
    shift
done

# Validate environment
if [ "$ENV" != "dev" ] && [ "$ENV" != "prod" ]; then
    echo "Invalid environment. Use 'dev' or 'prod'"
    exit 1
fi

# Validate platform
if [ "$PLATFORM" != "web" ] && [ "$PLATFORM" != "android" ] && [ "$PLATFORM" != "ios" ] && [ "$PLATFORM" != "windows" ] && [ "$PLATFORM" != "linux" ] && [ "$PLATFORM" != "macos" ]; then
    echo "Invalid platform. Use 'web', 'android', 'ios', 'windows', 'linux', or 'macos'"
    exit 1
fi

# Function to run build script if needed
run_build() {
    if [ "$SKIP_BUILD" = false ]; then
        echo "Running build script..."
        ./frontend/scripts/build/build.sh --env="$ENV" --platform="$PLATFORM"
        if [ $? -ne 0 ]; then
            echo "Build failed. Aborting deployment."
            exit 1
        fi
    fi
}

# Function to deploy web build
deploy_web() {
    local env=$1
    local version=$2
    echo "Deploying web build to $env environment..."
    
    # Create deployment directory
    mkdir -p "$DEPLOY_DIR/web"
    
    # Copy web build files
    cp -r "$BUILD_DIR/web/*" "$DEPLOY_DIR/web/"
    
    # Add deployment-specific configuration
    cat > "$DEPLOY_DIR/web/config.js" << EOL
window.APP_CONFIG = {
    environment: '$env',
    version: '$version',
    apiUrl: '${env}_api_url_here'
};
EOL
    
    # Example: Deploy to Firebase Hosting
    # firebase deploy --only hosting:$env --project plantarium-$env
}

# Function to deploy Android build
deploy_android() {
    local env=$1
    local version=$2
    echo "Deploying Android build to $env environment..."
    
    # Create deployment directory
    mkdir -p "$DEPLOY_DIR/android"
    
    # Copy APK
    cp "$BUILD_DIR/app/outputs/flutter-apk/app-$env.apk" "$DEPLOY_DIR/android/"
    
    # Example: Deploy to Google Play Store
    # fastlane android deploy --env $env --version $version
}

# Function to deploy iOS build
deploy_ios() {
    local env=$1
    local version=$2
    echo "Deploying iOS build to $env environment..."
    
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo "iOS deployment can only be performed on macOS"
        return 1
    fi
    
    # Create deployment directory
    mkdir -p "$DEPLOY_DIR/ios"
    
    # Copy IPA
    cp "$BUILD_DIR/ios/ipa/plantarium.ipa" "$DEPLOY_DIR/ios/"
    
    # Example: Deploy to App Store
    # fastlane ios deploy --env $env --version $version
}

# Function to deploy desktop build
deploy_desktop() {
    local platform=$1
    local env=$2
    local version=$3
    echo "Deploying $platform build to $env environment..."
    
    # Create deployment directory
    mkdir -p "$DEPLOY_DIR/$platform"
    
    # Copy build files
    case $platform in
        "windows")
            cp -r "$BUILD_DIR/windows/runner/Release/*" "$DEPLOY_DIR/windows/"
            ;;
        "linux")
            cp -r "$BUILD_DIR/linux/release/bundle/*" "$DEPLOY_DIR/linux/"
            ;;
        "macos")
            cp -r "$BUILD_DIR/macos/Build/Products/Release/plantarium.app" "$DEPLOY_DIR/macos/"
            ;;
    esac
    
    # Create deployment package
    cd "$DEPLOY_DIR/$platform"
    case $platform in
        "windows")
            zip -r "../plantarium-${version}-windows.zip" .
            ;;
        "linux")
            tar czf "../plantarium-${version}-linux.tar.gz" .
            ;;
        "macos")
            zip -r "../plantarium-${version}-macos.zip" .
            ;;
    esac
    cd -
}

# Run build if needed
run_build

# Create deployment directory
mkdir -p "$DEPLOY_DIR"

# Execute deployment based on platform selection
case $PLATFORM in
    "web")
        deploy_web "$ENV" "$VERSION"
        ;;
    "android")
        deploy_android "$ENV" "$VERSION"
        ;;
    "ios")
        deploy_ios "$ENV" "$VERSION"
        ;;
    "windows"|"linux"|"macos")
        deploy_desktop "$PLATFORM" "$ENV" "$VERSION"
        ;;
esac

# Generate deployment report
cat > "$DEPLOY_DIR/DEPLOYMENT_REPORT.md" << EOL
# Plantarium Deployment Report

**Environment:** $ENV
**Version:** $VERSION
**Platform:** $PLATFORM
**Deployment Date:** $(date '+%Y-%m-%d %H:%M:%S')

## Deployment Details
- Environment: $ENV
- Version: $VERSION
- Platform: $PLATFORM
- Build Directory: $BUILD_DIR
- Deployment Directory: $DEPLOY_DIR

## Deployment Artifacts
EOL

# List deployment artifacts
find "$DEPLOY_DIR" -type f \( -name "*.zip" -o -name "*.tar.gz" -o -name "*.apk" -o -name "*.ipa" \) | while read -r artifact; do
    echo "- $(basename "$artifact")" >> "$DEPLOY_DIR/DEPLOYMENT_REPORT.md"
done

echo "Deployment completed successfully!"
echo "Deployment artifacts are located in: $DEPLOY_DIR"
echo "Deployment report generated: $DEPLOY_DIR/DEPLOYMENT_REPORT.md" 