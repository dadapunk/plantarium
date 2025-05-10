# Plantarium MVP Core Features

This document outlines the core features implemented in the Plantarium MVP.

## Garden Notes

### Note Creation
- Simple interface for creating new garden notes
- Basic title and content fields
- Date tracking (creation and last modified)
- Save functionality with visual confirmation

### Note Viewing
- List view of all garden notes
- Basic sorting by date (newest first)
- Simple note preview in list
- Full note viewing with markdown rendering

### Note Editing
- Basic markdown editor
- Essential formatting options (headers, lists, bold, italic)
- Auto-save functionality
- Edit history tracking

### Offline Capability
- Basic caching of notes for offline access
- Simple persistence of new notes created offline
- Basic conflict resolution

## Data Management

### Repository Implementation
- Simple repository pattern
- API data source for online access
- Local data source for offline functionality
- Basic error handling and recovery

### State Management
- Riverpod implementation for state
- Basic loading, success, and error states
- Simple state transitions
- Minimal dependency injection

## User Interface

### Garden Notes List
- Clean, minimal list design
- Basic loading indicators
- Simple error handling with retry option
- Create new note button

### Note Editor
- Basic markdown editor
- Essential formatting toolbar
- Save status indicator
- Simple validation

## Technical Implementation

### API Client
- Basic API interface
- Simple error handling
- Minimal logging
- Essential endpoints only

### Local Storage
- Basic caching functionality
- Simple data persistence
- Minimal schema

## User Experience

### Error Handling
- User-friendly error messages
- Basic recovery options
- Offline mode indicator
- Simple retry mechanisms

### Performance
- Focus on essential operations
- Minimal loading times for core functions
- Basic optimization for critical paths 

## Related Documents

- For the MVP scope and goals, see [MVP Overview](mvp_overview.md)
- For implementation tasks, see [Implementation Plan](implementation_plan.md)
- For the long-term feature vision, see the [Roadmap Documentation](../roadmap/README.md)
- For an overview of all documentation, see the [MVP Documentation README](README.md) 