import Testing
import Foundation
@testable import Utilities

@Suite("UserDefaults Preferences Repository Tests", .serialized)
struct UserDefaultsPreferencesRepositoryTests {
    private let testSuiteName = "com.darkmodeswitch.test"
    
    private func createRepository() -> UserDefaultsPreferencesRepository {
        UserDefaults(suiteName: testSuiteName)?.removePersistentDomain(forName: testSuiteName)
        return UserDefaultsPreferencesRepository(suiteName: testSuiteName)
    }
    
    private func cleanup() {
        UserDefaults(suiteName: testSuiteName)?.removePersistentDomain(forName: testSuiteName)
    }
    
    @Test("Stores and retrieves automatic switching enabled state")
    func storesAutomaticSwitchingEnabled() throws {
        let sut = createRepository()
        defer { cleanup() }
        
        // Initial state should be false
        #expect(sut.getAutomaticSwitchingEnabled() == false)
        
        sut.setAutomaticSwitchingEnabled(true)
        #expect(sut.getAutomaticSwitchingEnabled() == true)
        
        sut.setAutomaticSwitchingEnabled(false)
        #expect(sut.getAutomaticSwitchingEnabled() == false)
    }
    
    @Test("Stores and retrieves dark mode time")
    func storesDarkModeTime() throws {
        let sut = createRepository()
        defer { cleanup() }
        
        let testTime = Date(timeIntervalSince1970: 1234567890)
        
        #expect(sut.getDarkModeTime() == nil)
        
        sut.setDarkModeTime(testTime)
        let retrievedTime = sut.getDarkModeTime()
        #expect(retrievedTime != nil)
        if let retrievedTime = retrievedTime {
            #expect(abs(retrievedTime.timeIntervalSince1970 - testTime.timeIntervalSince1970) < 0.001)
        }
        
        sut.setDarkModeTime(nil)
        #expect(sut.getDarkModeTime() == nil)
    }
    
    @Test("Stores and retrieves light mode time")
    func storesLightModeTime() throws {
        let sut = createRepository()
        defer { cleanup() }
        
        let testTime = Date(timeIntervalSince1970: 9876543210)
        
        #expect(sut.getLightModeTime() == nil)
        
        sut.setLightModeTime(testTime)
        let retrievedTime = sut.getLightModeTime()
        #expect(retrievedTime != nil)
        if let retrievedTime = retrievedTime {
            #expect(abs(retrievedTime.timeIntervalSince1970 - testTime.timeIntervalSince1970) < 0.001)
        }
        
        sut.setLightModeTime(nil)
        #expect(sut.getLightModeTime() == nil)
    }
    
    @Test("Handles multiple properties simultaneously")
    func handlesMultipleProperties() throws {
        let sut = createRepository()
        defer { cleanup() }
        
        let darkTime = Date(timeIntervalSince1970: 1000000)
        let lightTime = Date(timeIntervalSince1970: 2000000)
        
        sut.setAutomaticSwitchingEnabled(true)
        sut.setDarkModeTime(darkTime)
        sut.setLightModeTime(lightTime)
        
        #expect(sut.getAutomaticSwitchingEnabled() == true)
        
        if let retrievedDarkTime = sut.getDarkModeTime() {
            #expect(abs(retrievedDarkTime.timeIntervalSince1970 - darkTime.timeIntervalSince1970) < 0.001)
        } else {
            #expect(Bool(false), "Dark time should not be nil")
        }
        
        if let retrievedLightTime = sut.getLightModeTime() {
            #expect(abs(retrievedLightTime.timeIntervalSince1970 - lightTime.timeIntervalSince1970) < 0.001)
        } else {
            #expect(Bool(false), "Light time should not be nil")
        }
    }
    
    @Test("Persists values across instances")
    func persistsValuesAcrossInstances() throws {
        let sut = createRepository()
        defer { cleanup() }
        
        let darkTime = Date(timeIntervalSince1970: 3000000)
        let lightTime = Date(timeIntervalSince1970: 4000000)
        
        sut.setAutomaticSwitchingEnabled(true)
        sut.setDarkModeTime(darkTime)
        sut.setLightModeTime(lightTime)
        
        let newRepository = UserDefaultsPreferencesRepository(suiteName: testSuiteName)
        
        #expect(newRepository.getAutomaticSwitchingEnabled() == true)
        
        if let retrievedDarkTime = newRepository.getDarkModeTime() {
            #expect(abs(retrievedDarkTime.timeIntervalSince1970 - darkTime.timeIntervalSince1970) < 0.001)
        } else {
            #expect(Bool(false), "Dark time should not be nil")
        }
        
        if let retrievedLightTime = newRepository.getLightModeTime() {
            #expect(abs(retrievedLightTime.timeIntervalSince1970 - lightTime.timeIntervalSince1970) < 0.001)
        } else {
            #expect(Bool(false), "Light time should not be nil")
        }
    }
    
    @Test("Returns default values for unset properties")
    func returnsDefaultValues() throws {
        let freshSuiteName = "com.darkmodeswitch.test.fresh"
        let freshRepository = UserDefaultsPreferencesRepository(suiteName: freshSuiteName)
        defer {
            UserDefaults(suiteName: freshSuiteName)?.removePersistentDomain(forName: freshSuiteName)
        }
        
        #expect(!freshRepository.getAutomaticSwitchingEnabled())
        #expect(freshRepository.getDarkModeTime() == nil)
        #expect(freshRepository.getLightModeTime() == nil)
    }
    
    @Test("Uses correct UserDefaults suite")
    func usesCorrectUserDefaultsSuite() throws {
        let customSuiteName = "com.darkmodeswitch.test.custom"
        let sut = UserDefaultsPreferencesRepository(suiteName: customSuiteName)
        defer {
            UserDefaults(suiteName: customSuiteName)?.removePersistentDomain(forName: customSuiteName)
        }
        
        let testTime = Date()
        sut.setDarkModeTime(testTime)
        
        // Verify data is stored in the correct suite
        let userDefaults = UserDefaults(suiteName: customSuiteName)
        let storedTime = userDefaults?.object(forKey: "darkModeTime") as? Date
        #expect(storedTime == testTime)
    }
    
    @Test("Falls back to standard UserDefaults when suite creation fails")
    func fallsBackToStandardUserDefaults() throws {
        // UserDefaultsPreferencesRepository uses UserDefaults.standard as fallback
        // This test verifies the repository works even with an invalid suite name
        let sut = UserDefaultsPreferencesRepository(suiteName: "")
        
        // Should not crash and should use standard defaults
        sut.setAutomaticSwitchingEnabled(true)
        #expect(sut.getAutomaticSwitchingEnabled())
        
        // Clean up standard UserDefaults
        UserDefaults.standard.removeObject(forKey: "automaticSwitchingEnabled")
    }
}
