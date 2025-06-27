# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A simple macOS menu bar application that provides enhanced control over dark mode switching with custom time scheduling.

### Problem Statement

macOS offers automatic dark/light mode switching, but users cannot set custom times for when these switches occur. This app addresses that limitation by providing user-configurable scheduling.

## Build and Development Commands

### Building the App
- **Command line build**: `xcodebuild -project DarkModeSwitch.xcodeproj -scheme App -configuration Debug build`

### Testing
- **Run all tests**: Use the `Tests` scheme in Xcode or `xcodebuild -project DarkModeSwitch.xcodeproj -scheme Tests test`
- **Test plan**: Uses `TestPlans/UnitTests.xctestplan` for comprehensive test coverage

### Package Development
- **Utilities package**: Located in `Packages/Utilities/` - contains shared utilities like ProcessRunner and PreferencesRepository
- **AppearanceSwitcher package**: Located in `Packages/AppearanceSwitcher/` - core appearance switching logic
- **Package tests**: Each package has its own test suite that can be run independently

## Architecture Overview

This is a macOS menu bar application that switches between light and dark appearance modes. The app uses a modular Swift Package Manager architecture with dependency injection.

### Core Structure
- **App Target**: Main SwiftUI application with menu bar interface
- **LaunchAgent**: Separate command-line tool for scheduled appearance switching
- **Local Packages**: Two SPM packages for modular code organization

### Key Architectural Patterns
- **MVVM Pattern**: ViewModels handle business logic, Views are purely declarative SwiftUI
- **Dependency Injection**: Services are injected into ViewModels for testability
- **Protocol-Oriented Design**: Core services use protocols for easy mocking in tests
- **Repository Pattern**: PreferencesRepository abstracts UserDefaults access

### Module Breakdown
- **Features/**: Contains feature-specific code organized by domain (DarkMode, MenuBar, Scheduling, Settings)
- **Core/**: Shared models, utilities, and window management code
- **Packages/Utilities/**: ProcessRunner for shell commands, PreferencesRepository for settings storage
- **Packages/AppearanceSwitcher/**: Core appearance switching logic and time calculations
- **Tests/**: Comprehensive test suite with spy objects for all major services

### Key Services
- **DarkModeService**: Manages system appearance switching via `osascript` commands
- **SchedulingService**: Handles automated appearance switching at specified times
- **PreferencesRepository**: Manages app preferences storage and retrieval
- **ProcessRunner**: Executes shell commands with error handling

### Testing Strategy
- **Spy Pattern**: All external dependencies have spy implementations for testing
- **Protocol Mocking**: Services implement protocols to enable easy test doubles
- **Comprehensive Coverage**: Tests cover ViewModels, Services, and Utilities
- **Test Doubles**: Located in `Tests/Spies/` for consistent mocking approach

## Code Style Rules

- **Separation by Domain/Feature**: Prefer organizing code by domain or functionality (feature) rather than by structure or architectural layer. Group related types and logic together by what they represent or do, not just by their technical role.
- **One Type per File**: Prefer having one type (class, struct, enum, protocol, etc.) per file. Only include additional types in the same file if there is a very strong, explicit reason (such as a tightly coupled helper or private nested type).
- **Async Functions**: Do not mark functions or methods as `async` unless it is necessary for concurrency or to await asynchronous work. Prefer synchronous functions when possible for clarity and simplicity.
- **Value Types Preferred**: Prefer value types (`struct`) over reference types (`class`) unless reference semantics are required. Use `class` only when identity, inheritance, or reference sharing is necessary.
- Use Swift Testing framework for unit tests.
- Use `@Observable` macro for ViewModels. 
