import Foundation

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
