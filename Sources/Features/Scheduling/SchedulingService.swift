import Foundation

struct SchedulingService: SchedulingServiceProtocol {
    private let launchAgentInfo = LaunchAgentInfo.shared
    private let preferencesRepository: any PreferencesRepository
    
    init(preferencesRepository: any PreferencesRepository = UserDefaultsPreferencesRepository()) {
        self.preferencesRepository = preferencesRepository
    }
    
    private var launchAgentsDirectory: URL {
        FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Library")
            .appendingPathComponent("LaunchAgents")
    }
    
    func enableAutomaticScheduling(darkModeTime: Date, lightModeTime: Date) async throws {
        // First ensure Launch Agents directory exists
        try createLaunchAgentsDirectoryIfNeeded()
        
        // Create script path if needed
        let scriptPath = try getOrCreateScriptPath()
        
        // Save schedule preferences for the script to read
        try saveSchedulePreferences(darkModeTime: darkModeTime, lightModeTime: lightModeTime, enabled: true)
        
        // Create and register single launch agent that runs every 5 minutes
        try createAndRegisterSchedulerAgent(scriptPath: scriptPath)
    }
    
    func disableAutomaticScheduling() async throws {
        // Disable scheduling in preferences
        try saveSchedulePreferences(darkModeTime: Date(), lightModeTime: Date(), enabled: false)
        
        // Unregister and remove launch agent
        try unregisterAndRemoveLaunchAgent(label: launchAgentInfo.agentLabel)
    }
    
    func updateSchedule(darkModeTime: Date, lightModeTime: Date) async throws {
        // Simply update the preferences - the agent will pick up the changes
        try saveSchedulePreferences(darkModeTime: darkModeTime, lightModeTime: lightModeTime, enabled: true)
    }
    
    func isSchedulingEnabled() -> Bool {
        let agentPath = launchAgentsDirectory.appendingPathComponent("\(launchAgentInfo.agentLabel).plist")
        return FileManager.default.fileExists(atPath: agentPath.path)
    }
    
    // MARK: - Private Methods
    
    private func createLaunchAgentsDirectoryIfNeeded() throws {
        let launchAgentsPath = launchAgentsDirectory.path
        var isDirectory: ObjCBool = false
        
        if !FileManager.default.fileExists(atPath: launchAgentsPath, isDirectory: &isDirectory) {
            try FileManager.default.createDirectory(at: launchAgentsDirectory, withIntermediateDirectories: true)
        } else if !isDirectory.boolValue {
            throw SchedulingError.fileSystemError("LaunchAgents path exists but is not a directory")
        }
    }
    
    private func getOrCreateScriptPath() throws -> String {
        // Try to get script from bundle first
        if let bundleScriptPath = Bundle.main.path(forResource: "set-appearance-mode", ofType: "sh"),
           FileManager.default.fileExists(atPath: bundleScriptPath) {
            return bundleScriptPath
        }
        
        // Fall back to the script we created in the project
        let projectScriptPath = Bundle.main.bundlePath + "/Contents/Resources/set-appearance-mode.sh"
        if FileManager.default.fileExists(atPath: projectScriptPath) {
            return projectScriptPath
        }
        
        // As last resort, create script in user's home directory
        let homeScriptPath = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".darkmodeswitch-script.sh")
        
        if !FileManager.default.fileExists(atPath: homeScriptPath.path) {
            try createScriptFile(at: homeScriptPath)
        }
        
        return homeScriptPath.path
    }
    
    private func createScriptFile(at url: URL) throws {
        let scriptContent = ###"""
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

        """###
        
        try scriptContent.write(to: url, atomically: true, encoding: .utf8)
        
        // Make script executable
        let attributes = [FileAttributeKey.posixPermissions: 0o755]
        try FileManager.default.setAttributes(attributes, ofItemAtPath: url.path)
    }
    
    private func saveSchedulePreferences(darkModeTime: Date, lightModeTime: Date, enabled: Bool) throws {
        preferencesRepository.setAutomaticSwitchingEnabled(enabled)
        preferencesRepository.setDarkModeTime(darkModeTime)
        preferencesRepository.setLightModeTime(lightModeTime)
    }
    
    private func createAndRegisterSchedulerAgent(scriptPath: String) throws {
        let plistContent = createSchedulerAgentPlist(scriptPath: scriptPath)
        let plistPath = launchAgentsDirectory.appendingPathComponent("\(launchAgentInfo.agentLabel).plist")
        
        // Write plist file
        try plistContent.write(to: plistPath, atomically: true, encoding: .utf8)
        
        // Register with launchctl
        let registerResult = runCommand("/bin/launchctl", arguments: ["load", plistPath.path])
        if registerResult.exitCode != 0 {
            throw SchedulingError.launchAgentRegistrationFailed
        }
    }
    
    private func unregisterAndRemoveLaunchAgent(label: String) throws {
        let plistPath = launchAgentsDirectory.appendingPathComponent("\(label).plist")
        
        // First try to unregister if it exists
        if FileManager.default.fileExists(atPath: plistPath.path) {
            _ = runCommand("/bin/launchctl", arguments: ["unload", plistPath.path])
            // Don't throw error if unload fails - agent might not be loaded
            
            // Remove plist file
            try FileManager.default.removeItem(at: plistPath)
        }
    }
    
    private func createSchedulerAgentPlist(scriptPath: String) -> String {
        return """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>Label</key>
            <string>\(launchAgentInfo.agentLabel)</string>
            <key>ProgramArguments</key>
            <array>
                <string>\(scriptPath)</string>
            </array>
            <key>StartInterval</key>
            <integer>300</integer>
            <key>RunAtLoad</key>
            <false/>
            <key>StandardOutPath</key>
            <string>/tmp/darkmodeswitch.log</string>
            <key>StandardErrorPath</key>
            <string>/tmp/darkmodeswitch.log</string>
        </dict>
        </plist>
        """
    }
    
    private func runCommand(_ command: String, arguments: [String]) -> (output: String, exitCode: Int32) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: command)
        process.arguments = arguments
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8) ?? ""
            
            return (output, process.terminationStatus)
        } catch {
            return ("", -1)
        }
    }
}
