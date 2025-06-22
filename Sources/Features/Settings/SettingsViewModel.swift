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
        loadSettings()
    }
    
    func save() {
        do {
            if automaticSwitchingEnabled {
                if schedulingService.isSchedulingEnabled() {
                    // Update existing schedule
                    try schedulingService.updateSchedule(darkModeTime: darkModeTime, lightModeTime: lightModeTime)
                } else {
                    // Enable new schedule
                    try schedulingService.enableAutomaticScheduling(darkModeTime: darkModeTime, lightModeTime: lightModeTime)
                }
            } else {
                // Disable scheduling if it was enabled
                if schedulingService.isSchedulingEnabled() {
                    try schedulingService.disableAutomaticScheduling()
                }
            }
            
            // Save to UserDefaults
            saveSettings()
            
        } catch {
            print("Failed to save scheduling settings: \(error)")
            // TODO: Show error to user
        }
    }
    
    func cancel() {
        loadSettings()
    }
    
    private func loadSettings() {
        automaticSwitchingEnabled = preferencesRepository.automaticSwitchingEnabled
        
        // Load times with defaults
        if let darkModeTimeData = preferencesRepository.darkModeTime {
            darkModeTime = darkModeTimeData
        } else {
            // Default to 9 PM
            darkModeTime = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: Date()) ?? Date()
        }
        
        if let lightModeTimeData = preferencesRepository.lightModeTime {
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
    
    private func saveSettings() {
        preferencesRepository.automaticSwitchingEnabled = automaticSwitchingEnabled
        preferencesRepository.darkModeTime = darkModeTime
        preferencesRepository.lightModeTime = lightModeTime
    }
}
