import Foundation

final class UserDefaultsPreferencesRepository: PreferencesRepository {
    nonisolated(unsafe) private let userDefaults: UserDefaults
    
    init(suiteName: String = "com.darkmodeswitch.preferences") {
        self.userDefaults = UserDefaults(suiteName: suiteName) ?? UserDefaults.standard
    }
    
    func getAutomaticSwitchingEnabled() -> Bool {
        userDefaults.bool(forKey: "automaticSwitchingEnabled")
    }
    
    func setAutomaticSwitchingEnabled(_ enabled: Bool) {
        userDefaults.set(enabled, forKey: "automaticSwitchingEnabled")
    }
    
    func getDarkModeTime() -> Date? {
        userDefaults.object(forKey: "darkModeTime") as? Date
    }
    
    func setDarkModeTime(_ time: Date?) {
        userDefaults.set(time, forKey: "darkModeTime")
    }
    
    func getLightModeTime() -> Date? {
        userDefaults.object(forKey: "lightModeTime") as? Date
    }
    
    func setLightModeTime(_ time: Date?) {
        userDefaults.set(time, forKey: "lightModeTime")
    }
}
