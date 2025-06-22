import Foundation

protocol SchedulingServiceProtocol: Sendable {
    func enableAutomaticScheduling(darkModeTime: Date, lightModeTime: Date) throws
    func disableAutomaticScheduling() throws
    func updateSchedule(darkModeTime: Date, lightModeTime: Date) throws
    func isSchedulingEnabled() -> Bool
}
