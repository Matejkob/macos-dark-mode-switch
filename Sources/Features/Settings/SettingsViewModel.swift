import Foundation
import SwiftUI

@MainActor
@Observable
final class SettingsViewModel {
    var automaticSwitchingEnabled = true
    var darkModeTime = Date()
    var lightModeTime = Date()
    
    private let schedulingService: any SchedulingServiceProtocol
    private var preferencesRepository: any PreferencesRepository
    
    init(
        schedulingService: any SchedulingServiceProtocol = SchedulingService(),
        preferencesRepository: any PreferencesRepository = UserDefaultsPreferencesRepository()
    ) {
        self.schedulingService = schedulingService
        self.preferencesRepository = preferencesRepository
        Task {
            await loadSettings()
        }
    }
    
    func save() {
        Task {
            do {
                if automaticSwitchingEnabled {
                    if schedulingService.isSchedulingEnabled() {
                        // Update existing schedule
                        try await schedulingService.updateSchedule(darkModeTime: darkModeTime, lightModeTime: lightModeTime)
                    } else {
                        // Enable new schedule
                        try await schedulingService.enableAutomaticScheduling(darkModeTime: darkModeTime, lightModeTime: lightModeTime)
                    }
                } else {
                    // Disable scheduling if it was enabled
                    if schedulingService.isSchedulingEnabled() {
                        try await schedulingService.disableAutomaticScheduling()
                    }
                }
                
                // Save to UserDefaults
                await saveSettings()
                
            } catch {
                print("Failed to save scheduling settings: \(error)")
                // TODO: Show error to user
            }
        }
    }
    
    func cancel() {
        Task {
            await loadSettings()
        }
    }
    
    private func loadSettings() async {
        automaticSwitchingEnabled = await preferencesRepository.getAutomaticSwitchingEnabled()
        
        // Load times with defaults
        if let darkModeTimeData = await preferencesRepository.getDarkModeTime() {
            darkModeTime = darkModeTimeData
        } else {
            // Default to 9 PM
            darkModeTime = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: Date()) ?? Date()
        }
        
        if let lightModeTimeData = await preferencesRepository.getLightModeTime() {
            lightModeTime = lightModeTimeData
        } else {
            // Default to 7 AM
            lightModeTime = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date()) ?? Date()
        }
        
        // Sync with actual scheduling state
        let actualSchedulingEnabled = schedulingService.isSchedulingEnabled()
        if automaticSwitchingEnabled != actualSchedulingEnabled {
            automaticSwitchingEnabled = actualSchedulingEnabled
        }
    }
    
    private func saveSettings() async {
        await preferencesRepository.setAutomaticSwitchingEnabled(automaticSwitchingEnabled)
        await preferencesRepository.setDarkModeTime(darkModeTime)
        await preferencesRepository.setLightModeTime(lightModeTime)
    }
}
