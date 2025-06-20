import Foundation

struct ScheduleTime {
    let hour: Int
    let minute: Int
    
    init(from date: Date) {
        let calendar = Calendar.current
        self.hour = calendar.component(.hour, from: date)
        self.minute = calendar.component(.minute, from: date)
    }
    
    var formattedTime: String {
        return String(format: "%02d:%02d", hour, minute)
    }
}

struct SchedulingSettings {
    let darkModeTime: ScheduleTime
    let lightModeTime: ScheduleTime
    let isEnabled: Bool
    
    init(darkModeTime: Date, lightModeTime: Date, isEnabled: Bool = true) {
        self.darkModeTime = ScheduleTime(from: darkModeTime)
        self.lightModeTime = ScheduleTime(from: lightModeTime)
        self.isEnabled = isEnabled
    }
}

struct LaunchAgentInfo {
    let darkModeAgentLabel: String
    let lightModeAgentLabel: String
    let scriptPath: String
    
    static let shared = LaunchAgentInfo(
        darkModeAgentLabel: "com.darkmodeswitch.darkmode",
        lightModeAgentLabel: "com.darkmodeswitch.lightmode",
        scriptPath: Bundle.main.path(forResource: "set-appearance-mode", ofType: "sh") ?? ""
    )
}

enum SchedulingError: Error {
    case scriptNotFound
    case launchAgentCreationFailed
    case launchAgentRegistrationFailed
    case launchAgentUnregistrationFailed
    case invalidTime
    case fileSystemError(String)
    
    var localizedDescription: String {
        switch self {
        case .scriptNotFound:
            return "Appearance mode script not found"
        case .launchAgentCreationFailed:
            return "Failed to create launch agent"
        case .launchAgentRegistrationFailed:
            return "Failed to register launch agent"
        case .launchAgentUnregistrationFailed:
            return "Failed to unregister launch agent"
        case .invalidTime:
            return "Invalid time provided"
        case .fileSystemError(let message):
            return "File system error: \(message)"
        }
    }
}
