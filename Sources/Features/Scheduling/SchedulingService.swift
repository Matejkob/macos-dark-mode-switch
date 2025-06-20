import Foundation

struct SchedulingService: SchedulingServiceProtocol {
    
    private let launchAgentInfo = LaunchAgentInfo.shared
    private let fileManager = FileManager.default
    
    private var launchAgentsDirectory: URL {
        fileManager.homeDirectoryForCurrentUser
            .appendingPathComponent("Library")
            .appendingPathComponent("LaunchAgents")
    }
    
    func enableAutomaticScheduling(darkModeTime: Date, lightModeTime: Date) throws {
        // First ensure Launch Agents directory exists
        try createLaunchAgentsDirectoryIfNeeded()
        
        // Create script path if needed
        let scriptPath = try getOrCreateScriptPath()
        
        // Create and register dark mode launch agent
        try createAndRegisterLaunchAgent(
            label: launchAgentInfo.darkModeAgentLabel,
            scriptPath: scriptPath,
            mode: "dark",
            time: ScheduleTime(from: darkModeTime)
        )
        
        // Create and register light mode launch agent
        try createAndRegisterLaunchAgent(
            label: launchAgentInfo.lightModeAgentLabel,
            scriptPath: scriptPath,
            mode: "light",
            time: ScheduleTime(from: lightModeTime)
        )
    }
    
    func disableAutomaticScheduling() throws {
        // Unregister and remove both launch agents
        try unregisterAndRemoveLaunchAgent(label: launchAgentInfo.darkModeAgentLabel)
        try unregisterAndRemoveLaunchAgent(label: launchAgentInfo.lightModeAgentLabel)
    }
    
    func updateSchedule(darkModeTime: Date, lightModeTime: Date) throws {
        // Disable existing schedule and enable with new times
        try disableAutomaticScheduling()
        try enableAutomaticScheduling(darkModeTime: darkModeTime, lightModeTime: lightModeTime)
    }
    
    func isSchedulingEnabled() -> Bool {
        let darkModeAgentPath = launchAgentsDirectory.appendingPathComponent("\(launchAgentInfo.darkModeAgentLabel).plist")
        let lightModeAgentPath = launchAgentsDirectory.appendingPathComponent("\(launchAgentInfo.lightModeAgentLabel).plist")
        
        return fileManager.fileExists(atPath: darkModeAgentPath.path) &&
               fileManager.fileExists(atPath: lightModeAgentPath.path)
    }
    
    // MARK: - Private Methods
    
    private func createLaunchAgentsDirectoryIfNeeded() throws {
        let launchAgentsPath = launchAgentsDirectory.path
        var isDirectory: ObjCBool = false
        
        if !fileManager.fileExists(atPath: launchAgentsPath, isDirectory: &isDirectory) {
            try fileManager.createDirectory(at: launchAgentsDirectory, withIntermediateDirectories: true)
        } else if !isDirectory.boolValue {
            throw SchedulingError.fileSystemError("LaunchAgents path exists but is not a directory")
        }
    }
    
    private func getOrCreateScriptPath() throws -> String {
        // Try to get script from bundle first
        if let bundleScriptPath = Bundle.main.path(forResource: "set-appearance-mode", ofType: "sh"),
           fileManager.fileExists(atPath: bundleScriptPath) {
            return bundleScriptPath
        }
        
        // Fall back to the script we created in the project
        let projectScriptPath = Bundle.main.bundlePath + "/Contents/Resources/set-appearance-mode.sh"
        if fileManager.fileExists(atPath: projectScriptPath) {
            return projectScriptPath
        }
        
        // As last resort, create script in user's home directory
        let homeScriptPath = fileManager.homeDirectoryForCurrentUser
            .appendingPathComponent(".darkmodeswitch-script.sh")
        
        if !fileManager.fileExists(atPath: homeScriptPath.path) {
            try createScriptFile(at: homeScriptPath)
        }
        
        return homeScriptPath.path
    }
    
    private func createScriptFile(at url: URL) throws {
        let scriptContent = """
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
        
        # Use AppleScript to set system appearance
        osascript -e "
        tell application \\"System Events\\"
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
        """
        
        try scriptContent.write(to: url, atomically: true, encoding: .utf8)
        
        // Make script executable
        let attributes = [FileAttributeKey.posixPermissions: 0o755]
        try fileManager.setAttributes(attributes, ofItemAtPath: url.path)
    }
    
    private func createAndRegisterLaunchAgent(label: String, scriptPath: String, mode: String, time: ScheduleTime) throws {
        let plistContent = createLaunchAgentPlist(label: label, scriptPath: scriptPath, mode: mode, time: time)
        let plistPath = launchAgentsDirectory.appendingPathComponent("\(label).plist")
        
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
        if fileManager.fileExists(atPath: plistPath.path) {
            _ = runCommand("/bin/launchctl", arguments: ["unload", plistPath.path])
            // Don't throw error if unload fails - agent might not be loaded
            
            // Remove plist file
            try fileManager.removeItem(at: plistPath)
        }
    }
    
    private func createLaunchAgentPlist(label: String, scriptPath: String, mode: String, time: ScheduleTime) -> String {
        return """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>Label</key>
            <string>\(label)</string>
            <key>ProgramArguments</key>
            <array>
                <string>\(scriptPath)</string>
                <string>\(mode)</string>
            </array>
            <key>StartCalendarInterval</key>
            <dict>
                <key>Hour</key>
                <integer>\(time.hour)</integer>
                <key>Minute</key>
                <integer>\(time.minute)</integer>
            </dict>
            <key>RunAtLoad</key>
            <false/>
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
