import Foundation

struct ProcessHandler {
    struct ProcessCommand {
        typealias Argument = String
        var arguments: [Argument]
    }
    
    enum ProcessError: Error {
        case failure(code: Int32, reason: String?)
        case executionFailed(any Error)
    }
    
    // FIXME: `launchPath` property well be deprecated in the future version of macOS.
    let launchPath: String
    
    @discardableResult
    func run(arguments: [ProcessCommand.Argument]) async throws -> Data {
        try await run(process: ProcessCommand(arguments: arguments))
    }
    
    @discardableResult
    func run(process: ProcessCommand) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            let subProcess = Process()
            let standardOutputPipe = Pipe()
            let standardErrorPipe = Pipe()
            
            subProcess.standardOutput = standardOutputPipe
            subProcess.standardError = standardErrorPipe
            subProcess.arguments = process.arguments
            subProcess.launchPath = launchPath
            
            subProcess.terminationHandler = { process in
                let data = standardOutputPipe.fileHandleForReading.readDataToEndOfFile()
                
                if process.terminationStatus == 0 {
                    continuation.resume(returning: data)
                } else {
                    let errorData = standardErrorPipe.fileHandleForReading.readDataToEndOfFile()
                    let errorString = String(data: errorData, encoding: .utf8)
                    let error = ProcessError.failure(
                        code: process.terminationStatus,
                        reason: errorString
                    )
                    continuation.resume(throwing: error)
                }
            }
            
            do {
                try subProcess.run()
            } catch {
                continuation.resume(throwing: ProcessError.executionFailed(error))
            }
        }
    }
}
