import Foundation
import SwiftUI

// MARK: - Dark Mode View Model
@MainActor
@Observable
final class DarkModeViewModel {
    
    // MARK: - Published Properties
    var currentMode: AppearanceMode = .light
    
    // MARK: - Private Properties
    private let darkModeService: DarkModeServiceProtocol
    
    // MARK: - Initialization
    init(darkModeService: DarkModeServiceProtocol) {
        self.darkModeService = darkModeService
        refreshCurrentMode()
    }
    
    // MARK: - Public Methods
    
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