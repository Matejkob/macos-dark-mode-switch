import Foundation

protocol ProcessRunner: Sendable {
    @discardableResult
    func run(arguments: ProcessCommand.Argument...) async throws -> Data
    @discardableResult
    func run(process: ProcessCommand) async throws -> Data
}
