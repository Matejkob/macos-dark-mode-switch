import Foundation
import SwiftUI
import Utilities

@MainActor
@Observable
final class SettingsViewModel {
    var automaticSwitchingEnabled = true
    var darkModeTime = Date()
    var lightModeTime = Date()
    
    private let schedulingService: any SchedulingServiceProtocol
    private var preferencesRepository: any PreferencesRepository
    
    init(
        schedulingService: any SchedulingServiceProtocol,
        preferencesRepository: any PreferencesRepository
    ) {
        self.schedulingService = schedulingService
        self.preferencesRepository = preferencesRepository
    }
    
    func onAppear() async {
        await loadSettings()
    }
    
    func save() async throws {
        // Save settings to UserDefaults first
        await saveSettings()
        
        if automaticSwitchingEnabled {
            // Enable scheduling if not already enabled
            if !schedulingService.isSchedulingEnabled() {
                try schedulingService.enableAutomaticScheduling()
            }
            // The launch agent will read the updated times from preferences
        } else {
            // Disable scheduling if it was enabled
            if schedulingService.isSchedulingEnabled() {
                try schedulingService.disableAutomaticScheduling()
            }
        }
    }
    
    func cancel() async {
        await loadSettings()
    }
    
    private func loadSettings() async {
        automaticSwitchingEnabled = preferencesRepository.getAutomaticSwitchingEnabled()
        
        // Load times with defaults
        if let darkModeTimeData = preferencesRepository.getDarkModeTime() {
            darkModeTime = darkModeTimeData
        } else {
            // Default to 9 PM
            darkModeTime = Calendar.current.date(
                bySettingHour: 21,
                minute: 0,
                second: 0,
                of: Date()
            ) ?? Date()
        }
        
        if let lightModeTimeData = preferencesRepository.getLightModeTime() {
            lightModeTime = lightModeTimeData
        } else {
            // Default to 7 AM
            lightModeTime = Calendar.current.date(
                bySettingHour: 7,
                minute: 0,
                second: 0,
                of: Date()
            ) ?? Date()
        }
        
        // Sync with actual scheduling state
        let actualSchedulingEnabled = schedulingService.isSchedulingEnabled()
        if automaticSwitchingEnabled != actualSchedulingEnabled {
            automaticSwitchingEnabled = actualSchedulingEnabled
        }
    }
    
    private func saveSettings() async {
        preferencesRepository.setAutomaticSwitchingEnabled(automaticSwitchingEnabled)
        preferencesRepository.setDarkModeTime(darkModeTime)
        preferencesRepository.setLightModeTime(lightModeTime)
    }
}
