import SwiftUI

@main
struct DarkModeSwitchApp: App {
    @State private var isDarkMode = false
    
    var body: some Scene {
        MenuBarExtra("Dark Mode Switch", systemImage: isDarkMode ? "moon.fill" : "sun.max.fill") {
            MenuBarView()
        }
        .menuBarExtraStyle(.menu)
        
        Settings {
            SettingsView()
        }
    }
}
