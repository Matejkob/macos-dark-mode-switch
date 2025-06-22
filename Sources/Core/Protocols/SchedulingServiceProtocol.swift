import Foundation

protocol SchedulingServiceProtocol: Sendable {
    func enableAutomaticScheduling(darkModeTime: Date, lightModeTime: Date) async throws
    func disableAutomaticScheduling() async throws
    func updateSchedule(darkModeTime: Date, lightModeTime: Date) async throws
    func isSchedulingEnabled() -> Bool
}
