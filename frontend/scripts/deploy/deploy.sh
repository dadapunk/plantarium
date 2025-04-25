#!/bin/bash

# Deployment script for Plantarium Frontend
# This script handles deploying the Flutter application to different environments

# Exit on error
set -e

# Default values
ENV="dev"
PLATFORM="web"
VERSION=$(date +%Y%m%d_%H%M%S)

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
if [ "$PLATFORM" != "web" ] && [ "$PLATFORM" != "android" ] && [ "$PLATFORM" != "ios" ]; then
    echo "Invalid platform. Use 'web', 'android', or 'ios'"
    exit 1
fi

# Function to deploy web build
deploy_web() {
    local env=$1
    echo "Deploying web build to $env environment..."
    # Add your web deployment logic here
    # Example: firebase deploy --only hosting:$env
}

# Function to deploy Android build
deploy_android() {
    local env=$1
    echo "Deploying Android build to $env environment..."
    # Add your Android deployment logic here
    # Example: fastlane android deploy --env $env
}

# Function to deploy iOS build
deploy_ios() {
    local env=$1
    echo "Deploying iOS build to $env environment..."
    # Add your iOS deployment logic here
    # Example: fastlane ios deploy --env $env
}

# Create deployment directory if it doesn't exist
DEPLOY_DIR="frontend/build/deploy/$ENV/$VERSION"
mkdir -p "$DEPLOY_DIR"

# Execute deployment based on platform selection
case $PLATFORM in
    "web")
        deploy_web "$ENV"
        ;;
    "android")
        deploy_android "$ENV"
        ;;
    "ios")
        if [[ "$OSTYPE" == "darwin"* ]]; then
            deploy_ios "$ENV"
        else
            echo "iOS deployment can only be performed on macOS"
            exit 1
        fi
        ;;
esac

echo "Deployment completed successfully!"
echo "Version: $VERSION"
echo "Environment: $ENV"
echo "Platform: $PLATFORM" 