import Foundation

protocol SchedulingServiceProtocol: Sendable {
    func enableAutomaticScheduling() throws
    func disableAutomaticScheduling() throws
    func isSchedulingEnabled() -> Bool
}
