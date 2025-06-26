import Foundation

public protocol PreferencesRepository: Sendable {
    func getAutomaticSwitchingEnabled() -> Bool
    func setAutomaticSwitchingEnabled(_ enabled: Bool)
    func getDarkModeTime() -> Date?
    func setDarkModeTime(_ time: Date?)
    func getLightModeTime() -> Date?
    func setLightModeTime(_ time: Date?)
}
