import Foundation
import AppKit
import Cocoa

struct DarkModeService: DarkModeServiceProtocol {
    typealias ProcessRunner = @Sendable ([ProcessHandler.ProcessCommand.Argument]) async throws -> Data
    
    private let osascriptProcessRunner: ProcessRunner
    
    init(
        osascriptProcessRunner: @escaping ProcessRunner = { arguments in
            try await ProcessHandler(launchPath: "/usr/bin/osascript").run(arguments: arguments)
        }
    ) {
        self.osascriptProcessRunner = osascriptProcessRunner
    }
    
    func getCurrentMode() async -> AppearanceMode {
        // Use AppleScript as primary method since it's more reliable for system-wide detection
        let script = """
        tell application "System Events" to tell appearance preferences to return dark mode
        """
        
        do {
            let data = try await osascriptProcessRunner(["-e", script])
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
        
        let _ = try await osascriptProcessRunner(["-e", script])
    }
}
