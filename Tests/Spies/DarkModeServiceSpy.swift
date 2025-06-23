import Foundation
@testable import App

final class DarkModeServiceSpy: DarkModeServiceProtocol, @unchecked Sendable {
    // MARK: - getCurrentMode
    
    var getCurrentModeCalledCount = 0
    var getCurrentModeReturnValue: AppearanceMode!

    func getCurrentMode() async -> AppearanceMode {
        getCurrentModeCalledCount += 1
        return getCurrentModeReturnValue
    }

    // MARK: - toggleMode
    
    var toggleModeCalledCount = 0
    var toggleModeShouldThrow: Error?

    func toggleMode() async throws {
        toggleModeCalledCount += 1
        if let error = toggleModeShouldThrow {
            throw error
        }
    }
}
