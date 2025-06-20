import Foundation
import SwiftUI

@MainActor
@Observable
final class SettingsViewModel {
    
    var automaticSwitchingEnabled = true
    var darkModeTime = Date()
    var lightModeTime = Date()
    
    private let schedulingService: SchedulingServiceProtocol
    private let userDefaults = UserDefaults.standard
    
    init(schedulingService: SchedulingServiceProtocol = SchedulingService()) {
        self.schedulingService = schedulingService
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
        automaticSwitchingEnabled = userDefaults.bool(forKey: "automaticSwitchingEnabled")
        
        // Load times with defaults
        if let darkModeTimeData = userDefaults.object(forKey: "darkModeTime") as? Date {
            darkModeTime = darkModeTimeData
        } else {
            // Default to 9 PM
            darkModeTime = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: Date()) ?? Date()
        }
        
        if let lightModeTimeData = userDefaults.object(forKey: "lightModeTime") as? Date {
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
        userDefaults.set(automaticSwitchingEnabled, forKey: "automaticSwitchingEnabled")
        userDefaults.set(darkModeTime, forKey: "darkModeTime")
        userDefaults.set(lightModeTime, forKey: "lightModeTime")
    }
}
