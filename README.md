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

Plantarium is a comprehensive plant management application designed to help gardeners, plant enthusiasts, and permaculture practitioners manage their green spaces effectively. The application provides tools for tracking plants, designing garden layouts, and recording observations.

## Key Features (MVP)

- **Garden Notes**: Create, edit, and manage markdown notes about your garden
- **Simple Local Storage**: Lightweight caching with SharedPreferences
- **Markdown Support**: Format your notes with basic markdown
- **Offline Capability**: Basic access to your notes even when offline

## Technical Implementation

### Architecture

Plantarium follows a clean architecture pattern with the following layers:

- **Presentation**: UI components and state management
- **Domain**: Business logic and entities
- **Data**: Data sources, repositories, and DTOs

### Technologies

- **Flutter**: Cross-platform UI framework
- **Riverpod**: State management
- **Dio**: HTTP client for API requests
- **SharedPreferences**: Simple local storage solution
- **Markdown**: Markdown rendering for notes

## Development Setup

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- IDE (VS Code, Android Studio, or IntelliJ IDEA)

### Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/plantarium.git
   ```

2. Navigate to the project directory:
   ```bash
   cd plantarium
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Implementation Notes

### Local Storage Strategy

For the MVP, we've implemented a simplified local storage approach using SharedPreferences instead of a more complex SQLite solution with connectivity tracking. This decision was made following the YAGNI principle to focus on delivering essential functionality with minimal complexity.

Key aspects of our implementation:
- SharedPreferences for lightweight data persistence
- Simple JSON serialization for garden notes
- Basic caching with minimal error handling
- Graceful fallback to cached data when network is unavailable

For more details on implementation decisions, see the [Implementation Notes](documentation/mvp/implementation_notes.md).

## Project Structure

```
lib/
├── core/              # Core utilities, services, and configurations
├── features/          # Feature modules
│   └── garden_notes/  # Garden notes feature
│       ├── data/      # Data layer (repositories, models, data sources)
│       ├── domain/    # Domain layer (entities, use cases)
│       └── presentation/ # UI layer (screens, widgets, providers)
└── shared/            # Shared components, widgets, and utilities
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Thanks to all contributors who have helped shape this project
- Special thanks to the Flutter and Dart teams for their amazing frameworks

Happy Gardening! 🌻