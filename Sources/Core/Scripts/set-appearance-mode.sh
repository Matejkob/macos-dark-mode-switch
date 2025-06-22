#!/bin/bash

# DarkModeSwitch - Smart Appearance Mode Manager Script
# This script is called periodically by a Launch Agent to manage system appearance mode
# It reads user preferences and switches mode only when needed

# Function to get current system appearance mode
get_current_mode() {
    osascript -e "tell application \"System Events\" to tell appearance preferences to return dark mode" 2>/dev/null
}

# Function to set system appearance mode
set_appearance_mode() {
    local mode="$1"
    local dark_mode_value
    
    case "$mode" in
        "dark")
            dark_mode_value="true"
            ;;
        "light")
            dark_mode_value="false"
            ;;
        *)
            echo "Error: Invalid mode '$mode'. Use 'dark' or 'light'"
            return 1
            ;;
    esac
    
    osascript -e "tell app \"System Events\" to tell appearance preferences to set dark mode to $dark_mode_value" 2>/dev/null
}

# Function to read user preferences from UserDefaults
read_user_preferences() {
    local enabled=$(defaults read com.darkmodeswitch.preferences automaticSwitchingEnabled 2>/dev/null || echo "false")
    local dark_time=$(defaults read com.darkmodeswitch.preferences darkModeTime 2>/dev/null || echo "")
    local light_time=$(defaults read com.darkmodeswitch.preferences lightModeTime 2>/dev/null || echo "")
    
    echo "$enabled|$dark_time|$light_time"
}

# Function to extract hour and minute from ISO date string
extract_time() {
    local date_string="$1"
    # Extract time from ISO date format (2024-01-01 21:00:00 +0000)
    echo "$date_string" | sed -n 's/.*[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} \([0-9]\{2\}:[0-9]\{2\}\):.*/\1/p'
}

# Function to get current time in HH:MM format
get_current_time() {
    date '+%H:%M'
}

# Function to determine if current time is in dark mode period
should_be_dark_mode() {
    local current_time="$1"
    local dark_time="$2"
    local light_time="$3"
    
    # Convert times to minutes since midnight for easier comparison
    local current_minutes=$(echo "$current_time" | awk -F: '{print $1*60 + $2}')
    local dark_minutes=$(echo "$dark_time" | awk -F: '{print $1*60 + $2}')
    local light_minutes=$(echo "$light_time" | awk -F: '{print $1*60 + $2}')
    
    # Handle case where dark period spans midnight
    if [ $dark_minutes -gt $light_minutes ]; then
        # Dark period spans midnight (e.g., 21:00 to 07:00)
        if [ $current_minutes -ge $dark_minutes ] || [ $current_minutes -lt $light_minutes ]; then
            echo "true"
        else
            echo "false"
        fi
    else
        # Dark period within same day (e.g., 07:00 to 21:00) - unusual but possible
        if [ $current_minutes -ge $dark_minutes ] && [ $current_minutes -lt $light_minutes ]; then
            echo "true"
        else
            echo "false"
        fi
    fi
}

# Main logic
main() {
    # Read user preferences
    local prefs=$(read_user_preferences)
    local enabled=$(echo "$prefs" | cut -d'|' -f1)
    local dark_time_raw=$(echo "$prefs" | cut -d'|' -f2)
    local light_time_raw=$(echo "$prefs" | cut -d'|' -f3)
    
    # Check if automatic switching is enabled
    if [ "$enabled" != "1" ] && [ "$enabled" != "true" ]; then
        echo "Automatic switching is disabled"
        exit 0
    fi
    
    # Extract time components
    local dark_time=$(extract_time "$dark_time_raw")
    local light_time=$(extract_time "$light_time_raw")
    
    if [ -z "$dark_time" ] || [ -z "$light_time" ]; then
        echo "Error: Could not read schedule times from preferences"
        exit 1
    fi
    
    # Get current time and system mode
    local current_time=$(get_current_time)
    local current_mode=$(get_current_mode)
    
    # Determine what mode we should be in
    local should_be_dark=$(should_be_dark_mode "$current_time" "$dark_time" "$light_time")
    
    # Check if we need to switch
    if [ "$should_be_dark" = "true" ] && [ "$current_mode" != "true" ]; then
        echo "Switching to dark mode (current: $current_time, schedule: dark at $dark_time)"
        set_appearance_mode "dark"
        if [ $? -eq 0 ]; then
            echo "Successfully switched to dark mode"
        else
            echo "Failed to switch to dark mode"
            exit 1
        fi
    elif [ "$should_be_dark" = "false" ] && [ "$current_mode" != "false" ]; then
        echo "Switching to light mode (current: $current_time, schedule: light at $light_time)"
        set_appearance_mode "light"
        if [ $? -eq 0 ]; then
            echo "Successfully switched to light mode"
        else
            echo "Failed to switch to light mode"
            exit 1
        fi
    else
        echo "No mode change needed (current: $current_time, mode: $([ "$current_mode" = "true" ] && echo "dark" || echo "light"))"
    fi
}

# Run main function
main