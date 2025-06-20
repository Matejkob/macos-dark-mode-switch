import Foundation
import SwiftUI

@MainActor
@Observable
final class DarkModeViewModel {
    
        var currentMode: AppearanceMode = .light
    
        private let darkModeService: DarkModeServiceProtocol
    
        init(darkModeService: DarkModeServiceProtocol) {
        self.darkModeService = darkModeService
        refreshCurrentMode()
    }
    
        
    func toggleMode() {
        darkModeService.toggleMode()
        refreshCurrentMode()
    }
    
    func setMode(_ mode: AppearanceMode) {
        darkModeService.setMode(mode)
        refreshCurrentMode()
    }
    
    func refreshCurrentMode() {
        currentMode = darkModeService.getCurrentMode()
    }
}
