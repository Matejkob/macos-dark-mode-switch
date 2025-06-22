import Foundation

actor UserDefaultsPreferencesRepository: PreferencesRepository {
    private let userDefaults: UserDefaults
    
    init(suiteName: String = "com.darkmodeswitch.preferences") {
        self.userDefaults = UserDefaults(suiteName: suiteName) ?? UserDefaults.standard
    }
    
    var automaticSwitchingEnabled: Bool {
        get {
            userDefaults.bool(forKey: "automaticSwitchingEnabled")
        }
        set {
            userDefaults.set(newValue, forKey: "automaticSwitchingEnabled")
        }
    }
    
    var darkModeTime: Date? {
        get {
            userDefaults.object(forKey: "darkModeTime") as? Date
        }
        set {
            userDefaults.set(newValue, forKey: "darkModeTime")
        }
    }
    
    var lightModeTime: Date? {
        get {
            userDefaults.object(forKey: "lightModeTime") as? Date
        }
        set {
            userDefaults.set(newValue, forKey: "lightModeTime")
        }
    }
}
