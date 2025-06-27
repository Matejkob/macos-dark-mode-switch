import Testing
import Foundation
@testable import AppearanceSwitcher

@Suite("Appearance Switcher Time Calculator Tests")
struct AppearanceSwitcherTimeCalculatorTests {
    let sut = AppearanceSwitcherTimeCalculator()
    
    @Test("Should be dark mode when current time is after dark mode time")
    func darkModeAfterDarkTime() {
        let darkModeTime = date(hour: 21, minute: 0) // 9 PM
        let lightModeTime = date(hour: 7, minute: 0) // 7 AM
        let currentTime = date(hour: 22, minute: 30) // 10:30 PM
        
        let result = sut.shouldBeDarkMode(
            currentDate: currentTime,
            darkModeTime: darkModeTime,
            lightModeTime: lightModeTime
        )
        
        #expect(result == true)
    }
    
    @Test("Should be light mode when current time is after light mode time")
    func lightModeAfterLightTime() {
        let darkModeTime = date(hour: 21, minute: 0) // 9 PM
        let lightModeTime = date(hour: 7, minute: 0) // 7 AM
        let currentTime = date(hour: 10, minute: 0) // 10 AM
        
        let result = sut.shouldBeDarkMode(
            currentDate: currentTime,
            darkModeTime: darkModeTime,
            lightModeTime: lightModeTime
        )
        
        #expect(result == false)
    }
    
    @Test("Should be dark mode in early morning before light mode time")
    func darkModeEarlyMorning() {
        let darkModeTime = date(hour: 21, minute: 0) // 9 PM
        let lightModeTime = date(hour: 7, minute: 0) // 7 AM
        let currentTime = date(hour: 5, minute: 0) // 5 AM
        
        let result = sut.shouldBeDarkMode(
            currentDate: currentTime,
            darkModeTime: darkModeTime,
            lightModeTime: lightModeTime
        )
        
        #expect(result == true)
    }
    
    @Test("Should handle inverted schedule (dark mode in morning)")
    func invertedSchedule() {
        let darkModeTime = date(hour: 6, minute: 0) // 6 AM
        let lightModeTime = date(hour: 22, minute: 0) // 10 PM
        let currentTime = date(hour: 8, minute: 0) // 8 AM
        
        let result = sut.shouldBeDarkMode(
            currentDate: currentTime,
            darkModeTime: darkModeTime,
            lightModeTime: lightModeTime
        )
        
        #expect(result == true)
    }
    
    @Test("Should be light mode at night with inverted schedule")
    func lightModeAtNightInverted() {
        let darkModeTime = date(hour: 6, minute: 0) // 6 AM
        let lightModeTime = date(hour: 22, minute: 0) // 10 PM
        let currentTime = date(hour: 23, minute: 0) // 11 PM
        
        let result = sut.shouldBeDarkMode(
            currentDate: currentTime,
            darkModeTime: darkModeTime,
            lightModeTime: lightModeTime
        )
        
        #expect(result == false)
    }
    
    @Test("Should handle exact transition times")
    func exactTransitionTimes() {
        let darkModeTime = date(hour: 21, minute: 0) // 9 PM
        let lightModeTime = date(hour: 7, minute: 0) // 7 AM
        
        // Exactly at dark mode time
        let atDarkTime = date(hour: 21, minute: 0)
        let atDarTimeResult = sut.shouldBeDarkMode(
            currentDate: atDarkTime,
            darkModeTime: darkModeTime,
            lightModeTime: lightModeTime
        )
        
        #expect(atDarTimeResult == true)
        
        // Exactly at light mode time
        let atLightTime = date(hour: 7, minute: 0)
        let atLightTimeResult = sut.shouldBeDarkMode(
            currentDate: atLightTime,
            darkModeTime: darkModeTime,
            lightModeTime: lightModeTime
        )
        
        #expect(atLightTimeResult == false)
    }
    
    // Helper to create date with specific time
    func date(hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components)!
    }
}
