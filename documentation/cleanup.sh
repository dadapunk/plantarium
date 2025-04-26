#!/bin/bash

# Remove default documentation content
echo "Removing default documentation content..."
rm -rf docs/tutorial-basics
rm -rf docs/tutorial-extras
rm docs/intro.md

# Remove default assets
echo "Removing default assets..."
rm -rf static/img/docusaurus-social-card.jpg
rm -rf static/img/logo.svg
rm -rf static/img/favicon.ico

# Remove default blog posts
echo "Removing default blog posts..."
rm -rf blog/*

# Create new directory structure
echo "Creating new directory structure..."
mkdir -p docs/getting-started
mkdir -p docs/core-features
mkdir -p docs/technical
mkdir -p docs/development
mkdir -p docs/contributing
mkdir -p docs/project-info

echo "Cleanup complete!" 