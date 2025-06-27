import Foundation
import Utilities
import ServiceManagement
import OSLog

struct SchedulingService: SchedulingServiceProtocol {
    private nonisolated(unsafe) let appServiceAgent = SMAppService.agent(
        plistName: "io.github.matejkob.DarkModeSwitch.LaunchAgent.plist"
    )
    
    func enableAutomaticScheduling() throws {
        do {
            try appServiceAgent.register()
        } catch {
            throw SchedulingError.registrationFailed(error)
        }
    }
    
    func disableAutomaticScheduling() throws {
        do {
            try appServiceAgent.unregister()
        } catch {
            throw SchedulingError.unregistrationFailed(error)
        }
    }
    
    func isSchedulingEnabled() -> Bool {
        let status = appServiceAgent.status
        
        switch status {
        case .enabled:
            return true
        case .notRegistered, .notFound:
            return false
        case .requiresApproval:
            return false
        @unknown default:
            return false
        }
    }
}
