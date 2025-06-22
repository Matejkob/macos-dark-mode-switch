import Foundation

protocol PreferencesRepository: Sendable {
    var automaticSwitchingEnabled: Bool { get set }
    var darkModeTime: Date? { get set }
    var lightModeTime: Date? { get set }
}
