import Foundation


protocol DarkModeServiceProtocol {
    func getCurrentMode() -> AppearanceMode
    func setMode(_ mode: AppearanceMode)
    func toggleMode()
}

protocol SchedulingServiceProtocol {
    func enableAutomaticScheduling(darkModeTime: Date, lightModeTime: Date) throws
    func disableAutomaticScheduling() throws
    func updateSchedule(darkModeTime: Date, lightModeTime: Date) throws
    func isSchedulingEnabled() -> Bool
}

protocol PreferencesServiceProtocol {
    // TODO: Define preferences service interface
}
