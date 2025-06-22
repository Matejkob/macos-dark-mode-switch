import Foundation
import SwiftUI

@MainActor
@Observable
final class MenuBarViewModel {
    private let darkModeViewModel: DarkModeViewModel
    private let settingsOpener: () -> Void
    private let terminateApp: () -> Void
    
    var currentMode: AppearanceMode {
        darkModeViewModel.currentMode
    }
    
    var isDarkMode: Bool {
        currentMode == .dark
    }
    
    init(
        darkModeViewModel: DarkModeViewModel,
        settingsOpener: @escaping @MainActor () -> Void = SettingsOpener.openSettings,
        terminateApp: @escaping () -> Void = { NSApplication.shared.terminate(nil) }
    ) {
        self.darkModeViewModel = darkModeViewModel
        self.settingsOpener = settingsOpener
        self.terminateApp = terminateApp
    }
    
    func onAppear() async {
        await darkModeViewModel.onAppear()
    }
    
    func toggleMode() async {
        try? await darkModeViewModel.toggleMode()
    }
    
    func openSettings() {
        settingsOpener()
    }
    
    func quitApp() {
        terminateApp()
    }
}
