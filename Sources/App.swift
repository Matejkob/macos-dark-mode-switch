import SwiftUI

@main
struct DarkModeSwitchApp: App {
    @State private var menuBarViewModel: MenuBarViewModel = MenuBarViewModel(
        darkModeViewModel: DarkModeViewModel(darkModeService: DarkModeService())
    )
    
    var body: some Scene {
        MenuBarExtra("Dark Mode Switch", systemImage: menuBarViewModel.isDarkMode ? "moon.fill" : "sun.max.fill") {
            MenuBarView(viewModel: menuBarViewModel)
        }
        .menuBarExtraStyle(.menu)
        
        Settings {
            SettingsView()
        }
    }
}
