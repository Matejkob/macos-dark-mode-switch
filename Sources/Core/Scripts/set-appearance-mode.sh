#!/bin/bash

# DarkModeSwitch - Appearance Mode Setter Script
# This script is called by Launch Agents to set system appearance mode
# Usage: ./set-appearance-mode.sh [dark|light]

if [ $# -eq 0 ]; then
    echo "Usage: $0 [dark|light]"
    exit 1
fi

MODE="$1"

case "$MODE" in
    "dark")
        DARK_MODE_VALUE="true"
        ;;
    "light")
        DARK_MODE_VALUE="false"
        ;;
    *)
        echo "Error: Invalid mode '$MODE'. Use 'dark' or 'light'"
        exit 1
        ;;
esac

# Use AppleScript to set system appearance (same logic as DarkModeService)
osascript -e "
tell application \"System Events\"
    tell appearance preferences
        set dark mode to $DARK_MODE_VALUE
    end tell
end tell
"

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo "Successfully set appearance mode to $MODE"
else
    echo "Failed to set appearance mode to $MODE (exit code: $EXIT_CODE)"
fi

exit $EXIT_CODE