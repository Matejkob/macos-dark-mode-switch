import Foundation

struct AppearanceSwitcherTimeCalculator {
    let calendar: Calendar
    
    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }
    
    func shouldBeDarkMode(
        currentDate: Date,
        darkModeTime: Date,
        lightModeTime: Date
    ) -> Bool {
        let currentMinutes = minutesSinceMidnight(from: currentDate)
        let darkMinutes = minutesSinceMidnight(from: darkModeTime)
        let lightMinutes = minutesSinceMidnight(from: lightModeTime)
        
        if darkMinutes > lightMinutes {
            // Dark mode starts later in the day than light mode (normal case)
            // e.g., dark at 9 PM (1260), light at 7 AM (420)
            return currentMinutes >= darkMinutes || currentMinutes < lightMinutes
        } else {
            // Light mode starts later in the day than dark mode (less common)
            // e.g., dark at 6 AM (360), light at 10 PM (1320)
            return currentMinutes >= darkMinutes && currentMinutes < lightMinutes
        }
    }
    
    private func minutesSinceMidnight(from date: Date) -> Int {
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        return hour * 60 + minute
    }
}
