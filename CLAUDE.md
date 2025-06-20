# DarkModeSwitch - macOS Menu Bar App

## Project Overview
A simple macOS menu bar application that provides enhanced control over dark mode switching with custom time scheduling.

## Problem Statement
macOS offers automatic dark/light mode switching, but users cannot set custom times for when these switches occur. This app addresses that limitation by providing user-configurable scheduling.

## Core Features

### Menu Bar Interface
- Toggle switch for manual dark/light mode switching
- Quick access from menu bar icon
- Status indicator showing current mode

### Settings Panel
- Time picker for automatic dark mode activation
- Time picker for automatic light mode activation
- Enable/disable automatic switching
- Override system preferences when active

## Technical Requirements
- macOS native app (Swift/SwiftUI)
- Menu bar application (NSStatusItem)
- System appearance control via NSApplication.shared.appearance
- Local preferences storage
- Background scheduling for automatic mode switching

## User Experience
1. Install and launch app
2. App appears in menu bar with current mode indicator
3. Click menu bar icon to access quick toggle and settings
4. Configure custom switch times in settings panel
5. App automatically switches modes at specified times

## Development Approach
- Start with basic menu bar app structure
- Implement manual toggle functionality
- Add settings panel with time pickers
- Integrate background scheduling
- Polish UI and add status indicators

## Code Style Rules

- **Separation by Domain/Feature**: Prefer organizing code by domain or functionality (feature) rather than by structure or architectural layer. Group related types and logic together by what they represent or do, not just by their technical role.
- **One Type per File**: Prefer having one type (class, struct, enum, protocol, etc.) per file. Only include additional types in the same file if there is a very strong, explicit reason (such as a tightly coupled helper or private nested type).
- **Async Functions**: Do not mark functions or methods as `async` unless it is necessary for concurrency or to await asynchronous work. Prefer synchronous functions when possible for clarity and simplicity.
- **Value Types Preferred**: Prefer value types (`struct`) over reference types (`class`) unless reference semantics are required. Use `class` only when identity, inheritance, or reference sharing is necessary.
- Use Swift Testing framework for unit tests.
- Use `@Observable` macro for ViewModels. 
