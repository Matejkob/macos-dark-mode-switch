import Foundation

struct ScheduleTime {
    let hour: Int
    let minute: Int
    
    var formattedTime: String {
        return String(format: "%02d:%02d", hour, minute)
    }
    
    init(from date: Date) {
        let calendar = Calendar.current
        self.hour = calendar.component(.hour, from: date)
        self.minute = calendar.component(.minute, from: date)
    }
}
