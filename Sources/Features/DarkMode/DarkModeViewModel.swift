import Foundation
import SwiftUI

@MainActor
@Observable
final class DarkModeViewModel {
    var currentMode: AppearanceMode = .light
    
    private let darkModeService: any DarkModeServiceProtocol
    
    init(darkModeService: any DarkModeServiceProtocol) {
        self.darkModeService = darkModeService
    }
    
    func onAppear() async {
        await refreshCurrentMode()
    }
    
    func toggleMode() async throws {
        try await darkModeService.toggleMode()
        await refreshCurrentMode()
    }
    
    private func refreshCurrentMode() async {
        currentMode = await darkModeService.getCurrentMode()
    }
}
