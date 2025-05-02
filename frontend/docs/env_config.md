# Environment Configuration

This project uses `.env` files for environment-specific configuration. This document explains how to set up and use these configuration files.

## Environment Files

The application supports three environments:

- **Development**: Used for local development
- **Staging**: Used for testing in a pre-production environment
- **Production**: Used for the production environment

## File Structure

Environment files should be placed in the `assets/env/` directory with the following naming pattern:

- `.env.development` - Development environment settings
- `.env.staging` - Staging environment settings
- `.env.production` - Production environment settings

## Template Format

Here's an example of what your environment file should look like:

```
# API Configuration
API_BASE_URL=http://localhost:3002

# Application Settings
ENABLE_LOGGING=true
TIMEOUT_DURATION=30
MAX_RETRIES=3

# External Services
WEATHER_API_KEY=your_api_key_here
```

## Setup Instructions

1. Create a new directory `assets/env/` in the root of the project
2. Create environment files for each environment you need
3. Update the files with appropriate values for each environment
4. Add the files to your `.gitignore` to avoid committing sensitive information

## Using Environment Variables

The application loads environment variables using the `flutter_dotenv` package and makes them available through the `AppConfig` class:

```dart
// Get the API base URL
final apiUrl = AppConfig.current.apiBaseUrl;

// Check if logging is enabled
if (AppConfig.current.enableLogging) {
  logger.info('Request completed');
}
```

## Default Values

If an environment file is missing or a specific variable isn't defined, the application will use default values based on the environment:

- Development: Local services with extensive logging
- Staging: Remote services with moderate logging
- Production: Remote services with minimal logging

## Running with Specific Environment

To run the application with a specific environment:

```bash
# Development
flutter run --dart-define=ENVIRONMENT=development

# Staging
flutter run --dart-define=ENVIRONMENT=staging

# Production
flutter run --dart-define=ENVIRONMENT=production
```

If no environment is specified, the application will default to the development environment. 