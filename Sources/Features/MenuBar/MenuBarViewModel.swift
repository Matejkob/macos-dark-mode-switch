import Foundation
import SwiftUI

// MARK: - Menu Bar View Model
@MainActor
@Observable
final class MenuBarViewModel {
    
    // MARK: - Published Properties
    
    // MARK: - Private Properties
    private let darkModeViewModel: DarkModeViewModel
    
    // MARK: - Initialization
    init(darkModeViewModel: DarkModeViewModel) {
        self.darkModeViewModel = darkModeViewModel
    }
    
    // MARK: - Public Methods
    
    func toggleMode() {
        darkModeViewModel.toggleMode()
    }
    
    var currentMode: AppearanceMode {
        darkModeViewModel.currentMode
    }
    
    var isDarkMode: Bool {
        currentMode == .dark
    }
}