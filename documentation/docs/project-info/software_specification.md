# Specification: Plantarium

## 1. Introduction & Goals

**Purpose**: Plantarium is a cross-platform desktop application designed to help home gardeners and small-scale growers plan, manage, and optimize their crop cultivation efficiently.

**Problem Solved**: It addresses the complexity of garden planning by simplifying layout design, providing timely, location-aware reminders for crucial tasks (planting, fertilizing, harvesting), and integrating best practices like companion planting and crop rotation to improve garden health and yield.

**High-Level Goals**:
- Offer an intuitive graphical interface for designing and visualizing garden layouts (beds, plants).
- Deliver personalized planting schedules based on local climate and real-time weather data.
- Automate notifications for key gardening activities.
- Guide users in implementing beneficial planting strategies (companion planting, crop rotation).
- Ensure a seamless user experience across major desktop operating systems (Windows, macOS, Linux).

## 2. Target Audience

**Primary**: Home gardeners (ranging from beginners needing guidance to intermediate users seeking better organization).

**Secondary**: Allotment holders, community garden members, small-scale hobby farmers.

Users seeking a digital alternative or supplement to paper-based garden planning methods.

## 3. Functional Requirements (Elaborated Features)

### 3.1 Garden Layout & Visualization:
- Users can define one or more distinct garden areas (e.g., "Backyard", "Front Patch").
- Within each area, users can create, name, resize, and position garden beds using a visual editor (using Flutter's canvas capabilities). Support for basic shapes (rectangles, squares) is essential; polygons are a potential enhancement.
- Users can drag and drop specific plants (from the database or custom entries) onto the beds in the layout view.
- The layout should visually represent the plants, potentially showing approximate spacing or icons.
- Ability to save, load, and potentially duplicate garden layouts.
- (Adding non-plant elements like paths is not planned for the initial version).

### 3.2 Plant Database Integration & Management:
- Seamless integration with the Permapeople API for searching and retrieving detailed plant information (e.g., planting times, spacing needs, light/water requirements, companion planting data, family).
- Robust search and filtering capabilities within the plant database.
- Users can add plants from the API results to a personal "My Plants" library for quick access.
- Crucial: Ability for users to add custom plants with key details (name, family, planting notes, etc.) if not found in the API.
- The application will implement caching for frequently accessed plant data from the Permapeople API to improve performance and handle potential API downtime.

### 3.3 Climate-Adapted Planting Schedules & Calendar:
- Calculates suggested planting windows (sow indoors, transplant, direct sow) based on:
  - User's specified location (e.g., postal code, city).
  - General climate data associated with the location.
  - Specific plant requirements (from Permapeople API or custom entry).
- (Optional Enhancement) Fine-tuning based on short-term OpenWeather API forecasts (e.g., delaying planting if frost is imminent).
- Provides an integrated calendar view displaying scheduled tasks: planting, fertilizing, watering reminders, projected harvest windows, user-added custom tasks.
- Ability to filter the calendar by task type or plant.

### 3.4 Notifications & Alerts System:
- Task Reminders: Timely alerts for planting, transplanting, fertilizing, and potentially user-defined tasks based on the schedule.
- Crop Rotation Warnings: If a user attempts to place a plant in a bed, the system checks the planting history (see 3.6) and warns if it violates rotation principles (e.g., planting brassicas where legumes were last season, if that's undesirable based on rules).
- Companion Planting Feedback: (Optional) Subtle alerts or indicators if incompatible plants are placed adjacent in the layout.
- Weather Alerts (Configurable): Notifications for significant weather events affecting the garden, like first/last frost warnings based on OpenWeather data.
- Delivery: Configurable notification methods (in-app messages, platform-specific notifications via Flutter's local notification system).

### 3.5 Companion Planting Guidance:
- When a plant is selected or being placed in the layout, the UI should provide clear information about its beneficial and detrimental companions.
- This could be a sidebar list, visual highlighting of compatible/incompatible plants already in the layout, or tooltips.
- Data sourced primarily from the Permapeople API, potentially supplemented by an internal ruleset.

### 3.6 Crop Rotation Tracking:
- The application must automatically log which plant (and importantly, its family) was grown in which bed for each growing season/year.
- This history is used by the Crop Rotation Warnings feature (3.4).
- Users should be able to view the planting history for a specific bed.
- The number of years of history stored for rotation purposes will be configurable by the user (e.g., defaulting to 3 or 4 years).

### 3.7 Weather Integration (OpenWeather API):
- Requires user to input location or grant location access.
- Fetches current conditions and forecasts (temperature, precipitation, frost probability).
- Used primarily for frost warnings and potentially adjusting planting date suggestions or generating watering advice.

### 3.8 Garden Notes System:
- Implement a dual-storage system for garden notes:
  - SQLite database for fast querying and app integration
  - Markdown files for user accessibility and external editing
- Core Features:
  - Create, edit, and delete garden notes
  - Link notes to specific plants, beds, or general observations
  - Support for markdown formatting
  - Automatic synchronization between database and files
  - Real-time file system monitoring for external edits
- Advanced Features:
  - Tagging system for note organization
  - Weather data integration
  - Media attachments (images, progress photos)
  - Version control integration
  - Export/import functionality
- Integration Points:
  - Link notes to calendar events
  - Include in plant and bed detail views
  - Search across all notes
  - Generate reports from note data

## 4. Non-Functional Requirements

- **Platform Compatibility**: Must run natively on Windows, macOS, and Linux via Flutter's desktop support.
- **Performance**: Smooth and responsive UI, especially the Flutter canvas for layout rendering. Asynchronous operations for API calls and background tasks to prevent UI freezes. Efficient data handling.
- **Usability**: High priority on an intuitive, visually clear, and easy-to-navigate interface. Minimal learning curve for the target audience.
- **Reliability**: Stable operation with minimal crashes. Graceful handling of errors (e.g., network down, API unavailable) with informative messages to the user. Robust data saving.
- **Data Persistence**: User data (layouts, plant lists, settings, history, garden notes) must be stored locally and reliably using SQLite and markdown files. Ensure data integrity and provide backup/restore options if feasible.
- **Offline Functionality**: Core features (viewing/editing layouts, viewing cached data/schedules, garden notes) must work without an internet connection. Features requiring live data (weather forecast, new plant searches) should be disabled gracefully when offline.
- **Security**: Protect user data. Securely store API keys (OpenWeather, Permapeople) – avoid embedding directly in code. Ensure secure connection when accessing external APIs and secure access to the local SQLite database.

## 5. Technical Specifications

- **Application Framework**: Flutter
- **UI Rendering**: Flutter's built-in canvas/widget system
- **External APIs**: Permapeople API (Plants), OpenWeather API (Weather)
- **Local Data Storage**: SQLite
- **Code Management**: Git / Version Control System

## 6. UI/UX Considerations

- **Visual Design**: Clean, uncluttered aesthetic. Consider themes (light/dark) or subtle garden-inspired visuals. Prioritize clarity and readability.
- **Interaction**: Intuitive drag-and-drop for layout. Clear forms for data entry. Consistent navigation patterns.
- **Feedback**: Provide visual feedback for actions (saving, loading, API calls). Use loading indicators.
- **Accessibility**: Adhere to basic accessibility guidelines (sufficient color contrast, keyboard navigability, screen reader support where appropriate).

## 7. Future Considerations (Potential Roadmap)

- Mobile companion app (read-only or full-featured) - easier to implement with Flutter's cross-platform capabilities.
- Cloud sync option for multi-device access.
- Advanced reporting/analytics (e.g., yield tracking per bed/plant).
- Integration with smart garden sensors.
- Community features (sharing layouts, tips, plant reviews).
- Pest and disease logging/management features.