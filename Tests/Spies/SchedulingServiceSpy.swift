import Foundation
@testable import App

final class SchedulingServiceSpy: SchedulingServiceProtocol, @unchecked Sendable {
    // MARK: - enableAutomaticScheduling
    
    var enableAutomaticSchedulingCalledCount = 0
    var enableAutomaticSchedulingReceivedArguments: [(darkModeTime: Date, lightModeTime: Date)] = []
    var enableAutomaticSchedulingShouldThrow: Error?

    func enableAutomaticScheduling(darkModeTime: Date, lightModeTime: Date) async throws {
        enableAutomaticSchedulingCalledCount += 1
        enableAutomaticSchedulingReceivedArguments.append((darkModeTime, lightModeTime))
        if let error = enableAutomaticSchedulingShouldThrow {
            throw error
        }
    }

    // MARK: - disableAutomaticScheduling
    
    var disableAutomaticSchedulingCalledCount = 0
    var disableAutomaticSchedulingShouldThrow: Error?

    func disableAutomaticScheduling() async throws {
        disableAutomaticSchedulingCalledCount += 1
        if let error = disableAutomaticSchedulingShouldThrow {
            throw error
        }
    }

    // MARK: - updateSchedule
    
    var updateScheduleCalledCount = 0
    var updateScheduleReceivedArguments: [(darkModeTime: Date, lightModeTime: Date)] = []
    var updateScheduleShouldThrow: Error?

    func updateSchedule(darkModeTime: Date, lightModeTime: Date) async throws {
        updateScheduleCalledCount += 1
        updateScheduleReceivedArguments.append((darkModeTime, lightModeTime))
        if let error = updateScheduleShouldThrow {
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
