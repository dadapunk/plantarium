#!/bin/bash

# Build configuration script for Plantarium

# Default values
ENV="dev"
PLATFORM="all"
CLEAN=false

# Parse command line arguments
for arg in "$@"; do
  case $arg in
    --env=*)
      ENV="${arg#*=}"
      ;;
    --platform=*)
      PLATFORM="${arg#*=}"
      ;;
    --clean)
      CLEAN=true
      ;;
    *)
      echo "Unknown argument: $arg"
      exit 1
      ;;
  esac
done

# Validate environment
if [[ "$ENV" != "dev" && "$ENV" != "prod" ]]; then
  echo "Invalid environment. Use 'dev' or 'prod'"
  exit 1
fi

# Validate platform
if [[ "$PLATFORM" != "all" && "$PLATFORM" != "windows" && "$PLATFORM" != "linux" && "$PLATFORM" != "macos" ]]; then
  echo "Invalid platform. Use 'windows', 'linux', 'macos', or 'all'"
  exit 1
fi

# Clean build if requested
if [ "$CLEAN" = true ]; then
  echo "Cleaning build directory..."
  flutter clean
fi

# Get Flutter dependencies
echo "Getting dependencies..."
flutter pub get

# Run code generation if needed
echo "Running code generation..."
flutter pub run build_runner build --delete-conflicting-outputs

# Build function
build_platform() {
  local platform=$1
  local build_mode=$2
  
  echo "Building for $platform in $build_mode mode..."
  
  case $platform in
    "windows")
      flutter build windows --$build_mode
      ;;
    "linux")
      flutter build linux --$build_mode
      ;;
    "macos")
      flutter build macos --$build_mode
      ;;
  esac
}

# Set build mode based on environment
BUILD_MODE="debug"
if [ "$ENV" = "prod" ]; then
  BUILD_MODE="release"
fi

# Build for specified platform(s)
if [ "$PLATFORM" = "all" ]; then
  if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    build_platform "windows" "$BUILD_MODE"
  fi
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    build_platform "linux" "$BUILD_MODE"
  fi
  if [[ "$OSTYPE" == "darwin"* ]]; then
    build_platform "macos" "$BUILD_MODE"
  fi
else
  build_platform "$PLATFORM" "$BUILD_MODE"
fi

echo "Build completed successfully!" 