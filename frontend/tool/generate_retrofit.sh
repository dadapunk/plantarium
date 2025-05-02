#!/bin/bash

echo "Generating Retrofit API clients..."
flutter pub run build_runner build --delete-conflicting-outputs

echo "Retrofit code generation complete!" 