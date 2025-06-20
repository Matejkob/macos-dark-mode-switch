import Foundation
import SwiftUI

@MainActor
@Observable
final class SettingsViewModel {
    
        var automaticSwitchingEnabled = true
    var darkModeTime = Date()
    var lightModeTime = Date()
    
        
        init() {
        loadSettings()
    }
    
        func save() {
        // TODO: Save settings to UserDefaults or other persistence
    }
    
    func cancel() {
        loadSettings()
    }
    
        private func loadSettings() {
        // TODO: Load settings from UserDefaults or other persistence
        // For now, using default values
    }
}
