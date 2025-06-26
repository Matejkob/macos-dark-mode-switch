import Foundation
import Utilities

struct AppearanceSwitcher {
    private let preferencesRepository: any PreferencesRepository
    private let osascriptProcessRunner: any ProcessRunner
    private let timeCalculator: AppearanceSwitcherTimeCalculator
    private let dateProvider: () -> Date
    
    init(
        preferencesRepository: any PreferencesRepository = UserDefaultsPreferencesRepository(),
        osascriptProcessRunner: any ProcessRunner = FoundationProcessRunner(launchPath: "/usr/bin/osascript"),
        timeCalculator: AppearanceSwitcherTimeCalculator = AppearanceSwitcherTimeCalculator(),
        dateProvider: @escaping () -> Date = Date.init
    ) {
        self.preferencesRepository = preferencesRepository
        self.osascriptProcessRunner = osascriptProcessRunner
        self.timeCalculator = timeCalculator
        self.dateProvider = dateProvider
    }
    
    func checkAndSwitchIfNeeded() async throws {
        // Check if automatic switching is enabled
        guard preferencesRepository.getAutomaticSwitchingEnabled() else {
            return
        }
        
        // Get stored times
        guard let darkModeTime = preferencesRepository.getDarkModeTime(),
              let lightModeTime = preferencesRepository.getLightModeTime() else {
            return
        }
        
        let currentDate = dateProvider()
        let shouldBeDarkMode = timeCalculator.shouldBeDarkMode(
            currentDate: currentDate,
            darkModeTime: darkModeTime,
            lightModeTime: lightModeTime
        )
        
        // Check current mode
        let currentlyDarkMode = try await getCurrentDarkModeState()
        
        // Only change if needed
        if currentlyDarkMode != shouldBeDarkMode {
            try await setDarkMode(shouldBeDarkMode)
        }
    }
    
    private func getCurrentDarkModeState() async throws -> Bool {
        let script = """
        tell application "System Events" to tell appearance preferences to return dark mode
        """
        
        let data = try await osascriptProcessRunner.run(arguments: "-e", script)
        let output = String(data: data, encoding: .utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        return output == "true"
    }
    
    private func setDarkMode(_ enabled: Bool) async throws {
        let script = """
        tell application "System Events" to tell appearance preferences to set dark mode to \(enabled)
        """
        
        try await osascriptProcessRunner.run(arguments: "-e", script)
    }
}
