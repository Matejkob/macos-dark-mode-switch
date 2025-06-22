import SwiftUI

@main
struct DarkModeSwitchApp: App {
    @State private var menuBarViewModel: MenuBarViewModel = MenuBarViewModel(
        darkModeViewModel: DarkModeViewModel(darkModeService: DarkModeService())
    )
    
    var body: some Scene {
        // Hidden WindowGroup to make Settings work in MenuBarExtra-only apps
        // This is a workaround for FB10184971
        WindowGroup("HiddenWindow") {
            HiddenWindowView()
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 1, height: 1)
        .windowStyle(.hiddenTitleBar)
        
        MenuBarExtra(
            "Dark Mode Switch",
            systemImage: menuBarViewModel.isDarkMode ? "moon.fill" : "sun.max.fill"
        ) {
            MenuBarView(viewModel: menuBarViewModel)
        }
        .menuBarExtraStyle(.menu)
        
        Settings {
            SettingsView()
        }
    }
}
