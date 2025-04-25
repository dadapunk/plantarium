#!/bin/bash

# Navigate to the frontend directory
cd "$(dirname "$0")/../.."

# Run build_runner to generate JSON serialization code
echo "Generating JSON serialization code..."
flutter pub run build_runner build --delete-conflicting-outputs

echo "Generation complete!" 