import Testing
import Foundation
import Utilities
@testable import AppearanceSwitcher

@Suite("Appearance Switcher Tests")
final class AppearanceSwitcherTests {
    let preferencesRepository = MockPreferencesRepository()
    let processRunner = MockProcessRunner()
    
    // Helper to create date with specific time
    func date(hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components)!
    }
    
    @Test("Should not switch when automatic switching is disabled")
    func doesNotSwitchWhenDisabled() async throws {
        preferencesRepository.automaticSwitchingEnabled = false
        
        let sut = AppearanceSwitcher(
            preferencesRepository: preferencesRepository,
            osascriptProcessRunner: processRunner
        )
        
        try await sut.checkAndSwitchIfNeeded()
        
        #expect(processRunner.runCalls.isEmpty)
    }
    
    @Test("Should switch to dark mode when needed")
    func switchesToDarkMode() async throws {
        preferencesRepository.automaticSwitchingEnabled = true
        preferencesRepository.darkModeTime = date(hour: 21, minute: 0) // 9 PM
        preferencesRepository.lightModeTime = date(hour: 7, minute: 0) // 7 AM
        
        // Currently light mode, but should be dark at 10 PM
        processRunner.mockResponse = "false\n"
        
        let currentTime = date(hour: 22, minute: 0) // 10 PM
        let sut = AppearanceSwitcher(
            preferencesRepository: preferencesRepository,
            osascriptProcessRunner: processRunner,
            dateProvider: { currentTime }
        )
        
        try await sut.checkAndSwitchIfNeeded()
        
        #expect(processRunner.runCalls.count == 2)
        // First call checks current mode, second sets dark mode
        let secondCallArgs = processRunner.runCalls[1].arguments
        #expect(secondCallArgs.contains(where: { $0.contains("set dark mode to true") }))
    }
    
    @Test("Should switch to light mode when needed")
    func switchesToLightMode() async throws {
        preferencesRepository.automaticSwitchingEnabled = true
        preferencesRepository.darkModeTime = date(hour: 21, minute: 0) // 9 PM
        preferencesRepository.lightModeTime = date(hour: 7, minute: 0) // 7 AM
        
        // Currently dark mode, but should be light at 10 AM
        processRunner.mockResponse = "true\n"
        
        let currentTime = date(hour: 10, minute: 0) // 10 AM
        let sut = AppearanceSwitcher(
            preferencesRepository: preferencesRepository,
            osascriptProcessRunner: processRunner,
            dateProvider: { currentTime }
        )
        
        try await sut.checkAndSwitchIfNeeded()
        
        #expect(processRunner.runCalls.count == 2)
        // First call checks current mode, second sets light mode
        let secondCallArgs = processRunner.runCalls[1].arguments
        #expect(secondCallArgs.contains(where: { $0.contains("set dark mode to false") }))
    }
    
    @Test("Should not switch when already in correct mode")
    func doesNotSwitchWhenCorrect() async throws {
        preferencesRepository.automaticSwitchingEnabled = true
        preferencesRepository.darkModeTime = date(hour: 21, minute: 0) // 9 PM
        preferencesRepository.lightModeTime = date(hour: 7, minute: 0) // 7 AM
        
        // Currently light mode and should stay light at 10 AM
        processRunner.mockResponse = "false\n"
        
        let currentTime = date(hour: 10, minute: 0) // 10 AM
        let sut = AppearanceSwitcher(
            preferencesRepository: preferencesRepository,
            osascriptProcessRunner: processRunner,
            dateProvider: { currentTime }
        )
        
        try await sut.checkAndSwitchIfNeeded()
        
        #expect(processRunner.runCalls.count == 1) // Only check, no switch
    }
    
    @Test("Should handle missing time preferences")
    func handlesMissingTimes() async throws {
        preferencesRepository.automaticSwitchingEnabled = true
        preferencesRepository.darkModeTime = nil
        preferencesRepository.lightModeTime = date(hour: 7, minute: 0)
        
        let sut = AppearanceSwitcher(
            preferencesRepository: preferencesRepository,
            osascriptProcessRunner: processRunner
        )
        
        try await sut.checkAndSwitchIfNeeded()
        
        #expect(processRunner.runCalls.isEmpty)
    }
}