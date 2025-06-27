import Foundation
@testable import App
import Utilities

final class PreferencesRepositorySpy: PreferencesRepository, @unchecked Sendable {
    // MARK: - getAutomaticSwitchingEnabled
    
    var getAutomaticSwitchingEnabledCalledCount = 0
    var getAutomaticSwitchingEnabledReturnValue: Bool!
    
    func getAutomaticSwitchingEnabled() -> Bool {
        getAutomaticSwitchingEnabledCalledCount += 1
        return getAutomaticSwitchingEnabledReturnValue
    }

    // MARK: - setAutomaticSwitchingEnabled
    
    var setAutomaticSwitchingEnabledCalledCount = 0
    var setAutomaticSwitchingEnabledReceivedArguments: [Bool] = []

    func setAutomaticSwitchingEnabled(_ enabled: Bool) {
        setAutomaticSwitchingEnabledCalledCount += 1
        setAutomaticSwitchingEnabledReceivedArguments.append(enabled)
    }

    // MARK: - getDarkModeTime
    
    var getDarkModeTimeCalledCount = 0
    var getDarkModeTimeReturnValue: Date?

    func getDarkModeTime() -> Date? {
        getDarkModeTimeCalledCount += 1
        return getDarkModeTimeReturnValue
    }

    // MARK: - setDarkModeTime
    
    var setDarkModeTimeCalledCount = 0
    var setDarkModeTimeReceivedArguments: [Date?] = []

    func setDarkModeTime(_ time: Date?) {
        setDarkModeTimeCalledCount += 1
        setDarkModeTimeReceivedArguments.append(time)
    }

    // MARK: - getLightModeTime
    
    var getLightModeTimeCalledCount = 0
    var getLightModeTimeReturnValue: Date?

    func getLightModeTime() -> Date? {
        getLightModeTimeCalledCount += 1
        return getLightModeTimeReturnValue
    }

    // MARK: - setLightModeTime
    
    var setLightModeTimeCalledCount = 0
    var setLightModeTimeReceivedArguments: [Date?] = []

    func setLightModeTime(_ time: Date?) {
        setLightModeTimeCalledCount += 1
        setLightModeTimeReceivedArguments.append(time)
    }
}
