import Foundation
import SwiftUI

@MainActor
@Observable
final class MenuBarViewModel {
    
        
        private let darkModeViewModel: DarkModeViewModel
    
        init(darkModeViewModel: DarkModeViewModel) {
        self.darkModeViewModel = darkModeViewModel
    }
    
        
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
