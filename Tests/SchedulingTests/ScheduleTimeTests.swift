import Testing
import Foundation
@testable import App

@Suite("Schedule Time Tests")
struct ScheduleTimeTests {
    
    @Test("Initializes from date correctly")
    func initializesFromDate() throws {
        var dateComponents = DateComponents()
        dateComponents.hour = 14
        dateComponents.minute = 30
        dateComponents.second = 45 // Should be ignored
        
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let scheduleTime = ScheduleTime(from: date)
        
        #expect(scheduleTime.hour == 14)
        #expect(scheduleTime.minute == 30)
    }
    
    @Test("Formats time correctly with leading zeros")
    func formatsTimeWithLeadingZeros() throws {
        let dateComponents = DateComponents(hour: 9, minute: 5)
        let date = Calendar.current.date(from: dateComponents)!
        
        let scheduleTime = ScheduleTime(from: date)
        
        #expect(scheduleTime.formattedTime == "09:05")
    }
    
    @Test("Formats time correctly without leading zeros needed")
    func formatsTimeWithoutLeadingZeros() throws {
        let dateComponents = DateComponents(hour: 23, minute: 59)
        let date = Calendar.current.date(from: dateComponents)!
        
        let scheduleTime = ScheduleTime(from: date)
        
        #expect(scheduleTime.formattedTime == "23:59")
    }
    
    @Test("Handles midnight correctly")
    func handlesMidnight() throws {
        let dateComponents = DateComponents(hour: 0, minute: 0)
        let date = Calendar.current.date(from: dateComponents)!
        
        let scheduleTime = ScheduleTime(from: date)
        
        #expect(scheduleTime.hour == 0)
        #expect(scheduleTime.minute == 0)
        #expect(scheduleTime.formattedTime == "00:00")
    }
    
    @Test("Handles noon correctly")
    func handlesNoon() throws {
        let dateComponents = DateComponents(hour: 12, minute: 0)
        let date = Calendar.current.date(from: dateComponents)!
        
        let scheduleTime = ScheduleTime(from: date)
        
        #expect(scheduleTime.hour == 12)
        #expect(scheduleTime.minute == 0)
        #expect(scheduleTime.formattedTime == "12:00")
    }
    
    @Test("Handles last minute of day")
    func handlesLastMinuteOfDay() throws {
        let dateComponents = DateComponents(hour: 23, minute: 59)
        let date = Calendar.current.date(from: dateComponents)!
        
        let scheduleTime = ScheduleTime(from: date)
        
        #expect(scheduleTime.hour == 23)
        #expect(scheduleTime.minute == 59)
        #expect(scheduleTime.formattedTime == "23:59")
    }
    
    @Test("Preserves time components from different dates")
    func preservesTimeComponentsFromDifferentDates() throws {
        // Test with different dates but same time
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.current
        
        let date1 = formatter.date(from: "2024-01-01 15:45:30")!
        let date2 = formatter.date(from: "2024-12-31 15:45:59")!
        
        let scheduleTime1 = ScheduleTime(from: date1)
        let scheduleTime2 = ScheduleTime(from: date2)
        
        #expect(scheduleTime1.hour == scheduleTime2.hour)
        #expect(scheduleTime1.minute == scheduleTime2.minute)
        #expect(scheduleTime1.formattedTime == scheduleTime2.formattedTime)
    }
    
    @Test("Handles current date")
    func handlesCurrentDate() throws {
        let now = Date()
        let scheduleTime = ScheduleTime(from: now)
        
        let calendar = Calendar.current
        let expectedHour = calendar.component(.hour, from: now)
        let expectedMinute = calendar.component(.minute, from: now)
        
        #expect(scheduleTime.hour == expectedHour)
        #expect(scheduleTime.minute == expectedMinute)
    }
}