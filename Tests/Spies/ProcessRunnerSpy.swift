import Foundation
@testable import App

final class ProcessRunnerSpy: ProcessRunner, @unchecked Sendable {
    // MARK: - run(arguments:)
    
    var runWithArgumentsCalledCount = 0
    var runWithArgumentsReceivedArguments: [[ProcessCommand.Argument]] = []
    var runWithArgumentsReturnValue: Data = Data()
    var runWithArgumentsShouldThrow: Error?

    @discardableResult
    func run(arguments: ProcessCommand.Argument...) async throws -> Data {
        runWithArgumentsCalledCount += 1
        runWithArgumentsReceivedArguments.append(arguments)
        if let error = runWithArgumentsShouldThrow {
            throw error
        }
        return runWithArgumentsReturnValue
    }

    // MARK: - run(process:)
    
    var runWithProcessCalledCount = 0
    var runWithProcessReceivedArguments: [ProcessCommand] = []
    var runWithProcessReturnValue: Data = Data()
    var runWithProcessShouldThrow: Error?

    @discardableResult
    func run(process: ProcessCommand) async throws -> Data {
        runWithProcessCalledCount += 1
        runWithProcessReceivedArguments.append(process)
        if let error = runWithProcessShouldThrow {
            throw error
        }
        return runWithProcessReturnValue
    }
}
