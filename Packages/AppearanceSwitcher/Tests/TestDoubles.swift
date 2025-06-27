import Foundation
import Utilities
@testable import AppearanceSwitcher

// Mock PreferencesRepository
final class MockPreferencesRepository: PreferencesRepository, @unchecked Sendable {
    var automaticSwitchingEnabled = true
    var darkModeTime: Date? = {
        var components = DateComponents()
        components.hour = 21
        components.minute = 0
        return Calendar.current.date(from: components)
    }()
    var lightModeTime: Date? = {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components)
    }()
    
    func getAutomaticSwitchingEnabled() -> Bool {
        automaticSwitchingEnabled
    }
    
    func setAutomaticSwitchingEnabled(_ enabled: Bool) {
        automaticSwitchingEnabled = enabled
    }
    
    func getDarkModeTime() -> Date? {
        darkModeTime
    }
    
    func setDarkModeTime(_ time: Date?) {
        darkModeTime = time
    }
    
    func getLightModeTime() -> Date? {
        lightModeTime
    }
    
    func setLightModeTime(_ time: Date?) {
        lightModeTime = time
    }
}

// Mock ProcessRunner
final class MockProcessRunner: ProcessRunner, @unchecked Sendable {
    var runCalls: [(arguments: [String], result: Result<Data, Error>)] = []
    var mockResponse: String = "false"
    
    func run(arguments: ProcessCommand.Argument...) async throws -> Data {
        runCalls.append((arguments: arguments, result: .success(Data())))
        return mockResponse.data(using: .utf8)!
    }
    
    func run(process: ProcessCommand) async throws -> Data {
        runCalls.append((arguments: process.arguments, result: .success(Data())))
        return mockResponse.data(using: .utf8)!
    }
}