import Foundation

enum SchedulingError: LocalizedError {
    case registrationFailed(any Error)
    case unregistrationFailed(any Error)
    case macOSVersionNotSupported
    
    var errorDescription: String? {
        switch self {
        case .registrationFailed(let error):
            return "Failed to register launch agent: \(error.localizedDescription)"
        case .unregistrationFailed(let error):
            return "Failed to unregister launch agent: \(error.localizedDescription)"
        case .macOSVersionNotSupported:
            return "Service Management requires macOS 13.0 or later"
        }
    }
}
