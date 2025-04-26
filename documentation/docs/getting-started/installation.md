---
sidebar_position: 4
---

# Installation Guide

This guide will help you install Plantarium on your preferred platform. Choose your platform below to get started.

## System Requirements

### Desktop (Windows, macOS, Linux)
- Operating System: Windows 10+, macOS 10.15+, or Linux (Ubuntu 20.04+)
- RAM: 4GB minimum (8GB recommended)
- Storage: 500MB available space
- Internet connection for updates and weather data

### Mobile (iOS, Android)
- iOS 13.0+ or Android 8.0+
- 2GB RAM minimum
- 200MB available storage
- Internet connection for updates and weather data

## Desktop Installation

### Windows
1. Download the Windows installer from our [releases page](https://github.com/plantarium/plantarium/releases)
2. Run the installer (Plantarium-Setup.exe)
3. Follow the installation wizard
4. Launch Plantarium from the Start menu

### macOS
1. Download the macOS package from our [releases page](https://github.com/plantarium/plantarium/releases)
2. Open the downloaded .dmg file
3. Drag Plantarium to your Applications folder
4. Launch Plantarium from your Applications folder

### Linux
```bash
# Add our repository
sudo add-apt-repository ppa:plantarium/stable

# Update package list
sudo apt update

# Install Plantarium
sudo apt install plantarium
```

## Mobile Installation

### iOS
1. Open the App Store
2. Search for "Plantarium"
3. Tap "Get" to download
4. Open the app and sign in

### Android
1. Open the Google Play Store
2. Search for "Plantarium"
3. Tap "Install"
4. Open the app and sign in

## First-Time Setup

After installation, follow these steps to set up Plantarium:

1. **Create an Account**
   - Open Plantarium
   - Click "Sign Up"
   - Enter your email and create a password
   - Verify your email address

2. **Set Your Location**
   - Allow location access when prompted
   - Or manually enter your location
   - This enables weather and climate features

3. **Configure Preferences**
   - Select your preferred units (metric/imperial)
   - Choose your notification preferences
   - Set up your gardening zone

4. **Import Existing Data** (Optional)
   - Import garden plans from other apps
   - Sync with existing calendars
   - Transfer plant databases

## Troubleshooting

### Common Issues

#### Installation Fails
- Ensure you have sufficient disk space
- Check your internet connection
- Verify system requirements are met
- Try running the installer as administrator

#### App Crashes on Launch
- Clear app cache and data
- Reinstall the application
- Check for system updates
- Contact support with crash logs

#### Sync Issues
- Verify internet connection
- Check account credentials
- Ensure app is up to date
- Try logging out and back in

### Getting Help

If you encounter any issues:

1. Check our [FAQ](../project-info/faq)
2. Visit our [GitHub Issues](https://github.com/plantarium/plantarium/issues)
3. Join our [Discord Support](https://discord.gg/plantarium)
4. Email support@plantarium.com

## Updating Plantarium

### Automatic Updates
- Desktop: Updates are checked on launch
- Mobile: Updates are handled by app stores

### Manual Updates
1. Visit our [releases page](https://github.com/plantarium/plantarium/releases)
2. Download the latest version
3. Follow installation instructions

## Uninstallation

### Windows
1. Open Settings > Apps
2. Find Plantarium
3. Click "Uninstall"

### macOS
1. Open Applications folder
2. Drag Plantarium to Trash
3. Empty Trash

### Linux
```bash
sudo apt remove plantarium
sudo apt autoremove
```

### Mobile
1. Long press the app icon
2. Select "Uninstall" or "Delete"
3. Confirm removal

## Next Steps

Now that you have Plantarium installed:

1. [Take the Quick Start Guide](./quickstart)
2. [Create Your First Garden](../core-features/garden-layout)
3. [Explore the Plant Database](../core-features/plant-database)

---

<div style={{textAlign: 'center', marginTop: '2rem'}}>
  <p>Ready to start gardening?</p>
  <a href="./quickstart" className="button button--primary button--lg">
    Take the Quick Start Guide
  </a>
</div> 