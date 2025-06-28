import Foundation
@testable import App

final class SchedulingServiceSpy: SchedulingServiceProtocol, @unchecked Sendable {
    // MARK: - enableAutomaticScheduling
    
    var enableAutomaticSchedulingCalledCount = 0
    var enableAutomaticSchedulingShouldThrow: (any Error)?
    
    func enableAutomaticScheduling() throws {
        enableAutomaticSchedulingCalledCount += 1
        if let error = enableAutomaticSchedulingShouldThrow {
            throw error
        }
    }
    
    // MARK: - disableAutomaticScheduling
    
    var disableAutomaticSchedulingCalledCount = 0
    var disableAutomaticSchedulingShouldThrow: (any Error)?
    
    func disableAutomaticScheduling() throws {
        disableAutomaticSchedulingCalledCount += 1
        if let error = disableAutomaticSchedulingShouldThrow {
            throw error
        }
    }
    
    // MARK: - isSchedulingEnabled
    
    var isSchedulingEnabledCalledCount = 0
    var isSchedulingEnabledReturnValue: Bool!
    
    func isSchedulingEnabled() -> Bool {
        isSchedulingEnabledCalledCount += 1
        return isSchedulingEnabledReturnValue
    }
}
