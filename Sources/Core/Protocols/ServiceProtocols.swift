import Foundation

// MARK: - Service Protocols

protocol DarkModeServiceProtocol {
    func getCurrentMode() -> AppearanceMode
    func setMode(_ mode: AppearanceMode)
    func toggleMode()
}

protocol SchedulingServiceProtocol {
    // TODO: Define scheduling service interface
}

protocol PreferencesServiceProtocol {
    // TODO: Define preferences service interface
}