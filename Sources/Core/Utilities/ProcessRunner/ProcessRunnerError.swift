import Foundation

enum ProcessRunnerError: Error {
    case failure(code: Int32, reason: String?)
    case executionFailed(any Error)
}
