import Foundation
import AppKit
import Cocoa

struct DarkModeService: DarkModeServiceProtocol {
    
        
    func getCurrentMode() -> AppearanceMode {
        // Use AppleScript as primary method since it's more reliable for system-wide detection
        let script = """
        tell application "System Events"
            tell appearance preferences
                return dark mode
            end tell
        end tell
        """
        
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["-e", script]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        
        task.launch()
        task.waitUntilExit()
        
        if task.terminationStatus != 0 {
            // If AppleScript fails, try native detection as fallback
            if Thread.isMainThread,
               let appearance = NSApplication.shared.effectiveAppearance.bestMatch(from: [.aqua, .darkAqua]) {
                return appearance == .darkAqua ? .dark : .light
            }
            return .light
        }
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return output == "true" ? .dark : .light
    }
    
    func setMode(_ mode: AppearanceMode) {
        switch mode {
        case .dark:
            setSystemAppearance(dark: true)
        case .light:
            setSystemAppearance(dark: false)
        case .auto:
            break
        }
    }
    
    func toggleMode() {
        let currentMode = getCurrentMode()
        let newMode: AppearanceMode = currentMode == .dark ? .light : .dark
        setMode(newMode)
    }
    
        
    private func setSystemAppearance(dark: Bool) {
        let script = """
        tell application "System Events"
            tell appearance preferences
                set dark mode to \(dark)
            end tell
        end tell
        """
        
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["-e", script]
        
        task.launch()
        task.waitUntilExit()
        
        // If AppleScript fails, we could try the defaults approach as fallback
        if task.terminationStatus != 0 {
            print("AppleScript failed with exit code: \(task.terminationStatus)")
        }
    }
}
