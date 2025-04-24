# Plantarium 🌱

**A cross-platform desktop application for garden planning and management**

*(Replace the banner image URL with your actual image)*  
![Plantarium Banner](https://via.placeholder.com/1200x400?text=Plantarium+Garden+Planner)

## Table of Contents
- [About](#about)
- [Features](#features)
- [Screenshots](#screenshots)
- [Installation](#installation)
- [Usage](#usage)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## About

Plantarium is a desktop application designed to help home gardeners and small-scale growers:

- Plan garden layouts visually
- Get personalized planting schedules
- Receive timely gardening reminders
- Implement companion planting and crop rotation strategies

Built with Flutter and SQLite, Plantarium runs on Windows, macOS, and Linux.

## Features

### 🌿 Garden Planning
- Drag-and-drop garden layout designer
- Visual representation of plants and spacing
- Multiple garden areas and beds management

### 📅 Smart Scheduling
- Location-based planting calendar
- Automatic task reminders (planting, fertilizing, harvesting)
- Weather-integrated suggestions (frost alerts)

### 🌱 Plant Management
- Integrated plant database (Permapeople API)
- Custom plant entries
- Companion planting guidance
- Crop rotation tracking

### 🔔 Notifications
- Desktop alerts for gardening tasks
- Rotation warnings
- Weather alerts

## Screenshots

*(Replace with actual screenshot URLs)*  
![Layout Designer](https://via.placeholder.com/600x400?text=Garden+Layout+Designer)  
![Plant Calendar](https://via.placeholder.com/600x400?text=Planting+Calendar)  
![Plant Database](https://via.placeholder.com/600x400?text=Plant+Database)

## Installation

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK (comes with Flutter)
- Git

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/plantarium.git
   cd plantarium
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure environment variables (create .env file):
   ```env
   PERMAPEOPLE_API_KEY=your_api_key
   OPENWEATHER_API_KEY=your_api_key
   ```

4. Run the application:
   ```bash
   flutter run -d windows  # or macos, linux
   ```

## Usage

### Create a Garden
- Start by defining your garden areas and beds
- Set your location for climate-specific recommendations

### Add Plants
- Search the plant database or add custom plants
- Drag and drop plants onto your garden layout

### Plan Your Season
- View recommended planting dates
- Set up reminders for garden tasks

### Maintain Your Garden
- Track plant growth and rotations
- Receive notifications for upcoming tasks

## Development

### Tech Stack
- Framework: Flutter
- Database: SQLite
- APIs: Permapeople (plants), OpenWeather (weather)

### Documentation
- [Software Specification](software_specification.md) - Detailed technical requirements and specifications

### Scripts
```bash
flutter run         # Run development version
flutter build       # Build application
flutter test        # Run tests
flutter analyze     # Run linter
```

### Folder Structure
```
plantarium/
├── lib/
│   ├── main.dart         # Entry point
│   ├── models/           # Data models
│   ├── screens/          # UI screens
│   ├── widgets/          # Reusable widgets
│   ├── services/         # API & database services
│   └── utils/            # Helper functions
├── assets/               # Static assets
└── test/                 # Tests
```

## Contributing
We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a new branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Open a Pull Request

Please ensure your code follows our coding standards and includes appropriate tests.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

Happy Gardening! 🌻