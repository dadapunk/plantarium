#!/bin/bash

# Default values
VERSION=""
ENV="dev"
PLATFORM="all"

# Help message
show_help() {
    echo "Usage: $0 --version=X.Y.Z [--env=dev|prod] [--platform=windows|linux|macos|all]"
    echo
    echo "Options:"
    echo "  --version=X.Y.Z     Specify the release version (required)"
    echo "  --env=dev|prod      Specify the deployment environment (default: dev)"
    echo "  --platform=PLAT     Specify the platform to package (default: all)"
    echo "                      Valid platforms: windows, linux, macos, all"
    exit 1
}

# Parse command line arguments
for i in "$@"; do
    case $i in
        --version=*)
            VERSION="${i#*=}"
            shift
            ;;
        --env=*)
            ENV="${i#*=}"
            shift
            ;;
        --platform=*)
            PLATFORM="${i#*=}"
            shift
            ;;
        --help|-h)
            show_help
            ;;
        *)
            echo "Unknown option: $i"
            show_help
            ;;
    esac
done

# Validate required parameters
if [ -z "$VERSION" ]; then
    echo "Error: Version is required"
    show_help
fi

# Validate environment
if [ "$ENV" != "dev" ] && [ "$ENV" != "prod" ]; then
    echo "Error: Environment must be either 'dev' or 'prod'"
    show_help
fi

# Validate platform
case $PLATFORM in
    windows|linux|macos|all) ;;
    *)
        echo "Error: Invalid platform. Must be one of: windows, linux, macos, all"
        show_help
        ;;
esac

# Function to package a specific platform
package_platform() {
    local platform=$1
    local build_dir=""
    local package_name=""
    
    case $platform in
        windows)
            build_dir="build/windows/x64/runner/Release"
            if [ -d "$build_dir" ]; then
                package_name="plantarium-${VERSION}-windows"
                zip -r "releases/v${VERSION}/${package_name}.zip" "$build_dir"/*
                return 0
            fi
            ;;
        linux)
            build_dir="build/linux/x64/release/bundle"
            if [ -d "$build_dir" ]; then
                package_name="plantarium-${VERSION}-linux"
                tar czf "releases/v${VERSION}/${package_name}.tar.gz" -C "$build_dir" .
                return 0
            fi
            ;;
        macos)
            build_dir="build/macos/Build/Products/Release/plantarium.app"
            if [ -d "$build_dir" ]; then
                package_name="plantarium-${VERSION}-macos"
                zip -r "releases/v${VERSION}/${package_name}.zip" "$build_dir"
                return 0
            fi
            ;;
    esac
    
    echo "Warning: Build directory for $platform not found at $build_dir"
    return 1
}

# Create release directory
RELEASE_DIR="releases/v${VERSION}"
mkdir -p "$RELEASE_DIR"

# Initialize release notes
cat > "${RELEASE_DIR}/RELEASE_NOTES.md" << EOL
# Plantarium Release v${VERSION}

**Environment:** ${ENV}
**Release Date:** $(date '+%Y-%m-%d %H:%M:%S')

## Included Platforms
EOL

# Package builds based on platform selection
PACKAGED_PLATFORMS=()

if [ "$PLATFORM" = "all" ] || [ "$PLATFORM" = "windows" ]; then
    if package_platform "windows"; then
        PACKAGED_PLATFORMS+=("Windows")
    fi
fi

if [ "$PLATFORM" = "all" ] || [ "$PLATFORM" = "linux" ]; then
    if package_platform "linux"; then
        PACKAGED_PLATFORMS+=("Linux")
    fi
fi

if [ "$PLATFORM" = "all" ] || [ "$PLATFORM" = "macos" ]; then
    if package_platform "macos"; then
        PACKAGED_PLATFORMS+=("macOS")
    fi
fi

# Update release notes with packaged platforms
for platform in "${PACKAGED_PLATFORMS[@]}"; do
    echo "- $platform" >> "${RELEASE_DIR}/RELEASE_NOTES.md"
done

if [ ${#PACKAGED_PLATFORMS[@]} -eq 0 ]; then
    echo "Error: No platforms were successfully packaged"
    exit 1
fi

echo "Release v${VERSION} has been created in ${RELEASE_DIR}"
echo "Packaged platforms: ${PACKAGED_PLATFORMS[*]}" 