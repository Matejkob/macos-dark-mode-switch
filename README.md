# Dark Mode Switch

A macOS menu bar application that improves control over dark mode switching with custom time scheduling.

[![codecov](https://codecov.io/github/Matejkob/macos-dark-mode-switch/graph/badge.svg?token=384SIN89WR)](https://codecov.io/github/Matejkob/macos-dark-mode-switch)
[![CI](https://github.com/Matejkob/macos-dark-mode-switch/actions/workflows/ci.yml/badge.svg)](https://github.com/Matejkob/macos-dark-mode-switch/actions/workflows/ci.yml)
![macOS](https://img.shields.io/badge/macOS-10.15+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.1-orange.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

DarkModeSwitch solves a common macOS limitation: the system doesn't offers automatic dark/light mode switching, users cannot set custom times for when these switches occur. This lightweight menu bar app gives you full control over your appearance schedule.

## Features

- 🌙 **Menu Bar Integration**: Lives discretely in your menu bar
- ⚡ **Quick Toggle**: Instantly switch between dark and light modes with a click or keyboard shortcut (⌘⇧A)
- ⏰ **Custom Scheduling**: Set your own times for automatic dark/light mode switching

## Requirements

- macOS 10.15 (Catalina) or later

## Installation

### Option 1: Download Pre-built Release

1. Download the latest release from the [Releases](https://github.com/MatejkoB/DarkModeSwitch/releases) page
2. Move `DarkModeSwitch.app` to your Applications folder
3. Launch the app - you'll see the icon appear in your menu bar
4. Grant the necessary permissions when prompted

### Option 2: Build from Source

1. Clone the repository:
   ```bash
   git clone https://github.com/MatejkoB/DarkModeSwitch.git
   cd DarkModeSwitch
   ```

2. Open the project in Xcode:
   ```bash
   open DarkModeSwitch.xcodeproj
   ```

3. Build and run the app (⌘R) or build from command line:
   ```bash
   xcodebuild -project DarkModeSwitch.xcodeproj -scheme App -configuration Release build
   ```

## Usage

### Manual Mode Switching

- Click the menu bar icon to reveal the menu
- Select "Toggle Appearance" or use the keyboard shortcut ⌘⇧A
- The system appearance will switch immediately

### Automatic Scheduling

1. Click the menu bar icon and select "Settings..."
2. Enable "Automatic switching"
3. Set your preferred times:
   - **Dark mode time**: When to switch to dark mode
   - **Light mode time**: When to switch to light mode
4. The app will automatically switch modes at the specified times

## Architecture

DarkModeSwitch is built with modern Swift and SwiftUI, following clean architecture principles:

- **Modular Design**: Core functionality is separated into Swift packages
- **MVVM Pattern**: Clear separation between views and business logic
- **Comprehensive Testing**: Includes unit tests with spy objects for all major components

## Development

### Building the Project

```bash
# Debug build
xcodebuild -project DarkModeSwitch.xcodeproj -scheme App -configuration Debug build

# Run tests
xcodebuild -project DarkModeSwitch.xcodeproj -scheme Tests test
```

### Project Structure

```
DarkModeSwitch/
├── Sources/              # Main application code
│   ├── Features/         # Feature modules (DarkMode, MenuBar, Scheduling, Settings)
│   └── Core/             # Shared models and utilities
├── LaunchAgent/          # Background scheduler for automatic switching
├── Packages/             # Local Swift packages
│   ├── AppearanceSwitcher/   # Core appearance switching logic
│   └── Utilities/            # Shared utilities and preferences
└── Tests/                # Test suite with spies and mocks
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) for our code of conduct.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter any issues or have suggestions, please [open an issue](https://github.com/MatejkoB/DarkModeSwitch/issues) on GitHub.

---

Made with ❤️ by [Mateusz Bąk](https://github.com/MatejkoB)
