import Testing
import Foundation
@testable import App
@testable import Utilities

@Suite("Process Runner Error Tests")
struct ProcessRunnerErrorTests {
    @Test("Failure error with code and reason")
    func failureErrorWithCodeAndReason() {
        let error = ProcessRunnerError.failure(code: 127, reason: "Command not found")
        
        if case .failure(let code, let reason) = error {
            #expect(code == 127)
            #expect(reason == "Command not found")
        } else {
            #expect(Bool(false), "Expected failure case")
        }
    }
    
    @Test("Failure error with code and nil reason")
    func failureErrorWithCodeAndNilReason() {
        let error = ProcessRunnerError.failure(code: 1, reason: nil)
        
        if case .failure(let code, let reason) = error {
            #expect(code == 1)
            #expect(reason == nil)
        } else {
            #expect(Bool(false), "Expected failure case")
        }
    }
    
    @Test("Failure error with zero exit code")
    func failureErrorWithZeroExitCode() {
        let error = ProcessRunnerError.failure(code: 0, reason: "Some error despite zero exit code")
        
        if case .failure(let code, let reason) = error {
            #expect(code == 0)
            #expect(reason == "Some error despite zero exit code")
        } else {
            #expect(Bool(false), "Expected failure case")
        }
    }
    
    @Test("Failure error with negative exit code")
    func failureErrorWithNegativeExitCode() {
        let error = ProcessRunnerError.failure(code: -1, reason: "Signal termination")
        
        if case .failure(let code, let reason) = error {
            #expect(code == -1)
            #expect(reason == "Signal termination")
        } else {
            #expect(Bool(false), "Expected failure case")
        }
    }
    
    @Test("Execution failed error with NSError")
    func executionFailedErrorWithNSError() {
        let underlyingError = NSError(domain: "TestDomain", code: 42, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        let error = ProcessRunnerError.executionFailed(underlyingError)
        
        if case .executionFailed(let capturedError) = error {
            let nsError = capturedError as NSError
            #expect(nsError.domain == "TestDomain")
            #expect(nsError.code == 42)
            #expect(nsError.localizedDescription == "Test error")
        } else {
            #expect(Bool(false), "Expected executionFailed case")
        }
    }
    
    @Test("Execution failed error with custom error")
    func executionFailedErrorWithCustomError() {
        struct CustomError: Error {
            let message: String
        }
        
        let customError = CustomError(message: "Custom execution error")
        let error = ProcessRunnerError.executionFailed(customError)
        
        if case .executionFailed(let capturedError) = error {
            #expect(capturedError is CustomError)
            if let custom = capturedError as? CustomError {
                #expect(custom.message == "Custom execution error")
            }
        } else {
            #expect(Bool(false), "Expected executionFailed case")
        }
    }
    
    @Test("Error conforms to Error protocol")
    func errorConformsToErrorProtocol() {
        let error1: Error = ProcessRunnerError.failure(code: 1, reason: "test")
        let error2: Error = ProcessRunnerError.executionFailed(NSError(domain: "test", code: 1))
        
        #expect(error1 is ProcessRunnerError)
        #expect(error2 is ProcessRunnerError)
    }
    
    @Test("Failure errors with different codes are not equal")
    func failureErrorsWithDifferentCodesAreNotEqual() {
        let error1 = ProcessRunnerError.failure(code: 1, reason: "same reason")
        let error2 = ProcessRunnerError.failure(code: 2, reason: "same reason")
        
        // These should be different errors
        if case .failure(let code1, _) = error1,
           case .failure(let code2, _) = error2 {
            #expect(code1 != code2)
        }
    }
    
    @Test("Failure errors with different reasons are not equal")
    func failureErrorsWithDifferentReasonsAreNotEqual() {
        let error1 = ProcessRunnerError.failure(code: 1, reason: "reason1")
        let error2 = ProcessRunnerError.failure(code: 1, reason: "reason2")
        
        // These should be different errors
        if case .failure(_, let reason1) = error1,
           case .failure(_, let reason2) = error2 {
            #expect(reason1 != reason2)
        }
    }
}
