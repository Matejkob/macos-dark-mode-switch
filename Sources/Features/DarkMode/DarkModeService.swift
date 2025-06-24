import Foundation
import AppKit
import Cocoa
import Utilities

struct DarkModeService: DarkModeServiceProtocol {
    private let osascriptProcessRunner: any ProcessRunner
    
    init(
        osascriptProcessRunner: any ProcessRunner = FoundationProcessRunner(
            launchPath: "/usr/bin/osascript"
        )
    ) {
        self.osascriptProcessRunner = osascriptProcessRunner
    }
    
    func getCurrentMode() async -> AppearanceMode {
        // Use AppleScript as primary method since it's more reliable for system-wide detection
        let script = """
        tell application "System Events" to tell appearance preferences to return dark mode
        """
        
        do {
            let data = try await osascriptProcessRunner.run(arguments: "-e", script)
            let output = String(data: data, encoding: .utf8)?
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            return output == "true" ? .dark : .light
        } catch {
            return await MainActor.run {
                if let appearance = NSApplication.shared
                    .effectiveAppearance
                    .bestMatch(from: [.aqua, .darkAqua]) {
                    return appearance == .darkAqua ? .dark : .light
                }
                return .light
            }
        }
    }
    
    func toggleMode() async throws {
        let script = """
        tell application "System Events" to tell appearance preferences to set dark mode to not dark mode
        """
        
        try await osascriptProcessRunner.run(arguments: "-e", script)
    }
}
