import Foundation

public final class UserDefaultsPreferencesRepository: PreferencesRepository {
    nonisolated(unsafe) private let userDefaults: UserDefaults
    
    public init(suiteName: String = "com.darkmodeswitch.preferences") {
        self.userDefaults = UserDefaults(suiteName: suiteName) ?? UserDefaults.standard
    }
    
    public func getAutomaticSwitchingEnabled() -> Bool {
        userDefaults.bool(forKey: "automaticSwitchingEnabled")
    }
    
    public func setAutomaticSwitchingEnabled(_ enabled: Bool) {
        userDefaults.set(enabled, forKey: "automaticSwitchingEnabled")
    }
    
    public func getDarkModeTime() -> Date? {
        userDefaults.object(forKey: "darkModeTime") as? Date
    }
    
    public func setDarkModeTime(_ time: Date?) {
        userDefaults.set(time, forKey: "darkModeTime")
    }
    
    public func getLightModeTime() -> Date? {
        userDefaults.object(forKey: "lightModeTime") as? Date
    }
    
    public func setLightModeTime(_ time: Date?) {
        userDefaults.set(time, forKey: "lightModeTime")
    }
}
