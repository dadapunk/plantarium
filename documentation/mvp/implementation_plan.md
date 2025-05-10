# Plantarium MVP Refactoring Plan

This document outlines a simplified plan to refactor the Plantarium application for an MVP (Minimum Viable Product) or proof of concept version.

## 1. Streamlined Project Structure

### 1.1 Feature Organization
- [x] 1.1.1 Move garden note model to a logical location
- [x] 1.1.2 Set up basic API and local data sources
- [x] 1.1.3 Implement simple entity and data models
- [x] 1.1.4 Create basic repository pattern
- [x] 1.1.5 Fix critical UI bugs (like duplicate markdown headers)

### 1.2 Core Functionality
- [x] 1.2.1 Set up basic API client
- [x] 1.2.2 Implement minimal HTTP client
- [x] 1.2.3 Add basic error handling
- [x] 1.2.4 Support environment configuration

### 1.3 Shared Components
- [x] 1.3.1 Create minimal shared widget library
- [x] 1.3.2 Implement basic loading and error states
- [x] 1.3.3 Set up simple dependency injection

## 2. State Management

### 2.1 Riverpod Setup
- [x] 2.1.1 Add Riverpod dependencies
- [x] 2.1.2 Configure basic Riverpod in main.dart
- [x] 2.1.3 Implement simple state classes

### 2.2 Garden Notes State
- [x] 2.2.1 Create basic state classes
- [x] 2.2.2 Implement state notifier
- [x] 2.2.3 Set up core providers

## 3. Simplified Data Layer

### 3.1 API Client
- [x] 3.1.1 Implement basic API interface
- [x] 3.1.2 Add simple error handling for network failures
- [x] 3.1.3 Add minimal logging

### 3.2 Local Storage
- [x] 3.2.1 Implement basic caching functionality
- [x] 3.2.2 Support simple offline access

### 3.3 Garden Notes Repository
- [ ] 3.3.1 Implement repository pattern
- [ ] 3.3.2 Connect API and local data sources
- [ ] 3.3.3 Add basic error handling

## 4. Essential UI Features

### 4.1 Garden Notes List
- [ ] 4.1.1 Refactor to use Riverpod
- [ ] 4.1.2 Add basic loading states
- [ ] 4.1.3 Implement error handling
- [ ] 4.1.4 Improve basic UI elements

### 4.2 Note Editor
- [ ] 4.2.1 Implement basic markdown editor
- [ ] 4.2.2 Add essential markdown functions
- [ ] 4.2.3 Implement save functionality

## 5. Minimal Testing

### 5.1 Core Tests
- [ ] 5.1.1 Set up basic testing framework
- [ ] 5.1.2 Write tests for critical functionality
- [ ] 5.1.3 Test main user flows

## 6. Basic Documentation

### 6.1 MVP Documentation
- [ ] 6.1.1 Document core APIs and patterns
- [ ] 6.1.2 Create simple user guide for key features

## Acceptance Criteria for MVP

- Basic functional garden notes feature
- Simple offline capability for essential functions
- Clean, usable UI
- Stable performance on target devices
- Documented core functionality and user flows

**Progress Tracking**: Mark tasks as [x] when completed 