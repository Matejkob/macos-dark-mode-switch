import Testing
import Foundation
@testable import App

@Suite("Scheduling Error Tests")
struct SchedulingErrorTests {
    
    @Test("Script not found error has correct description")
    func scriptNotFoundDescription() {
        let error = SchedulingError.scriptNotFound
        #expect(error.localizedDescription == "Appearance mode script not found")
    }
    
    @Test("Launch agent creation failed error has correct description")
    func launchAgentCreationFailedDescription() {
        let error = SchedulingError.launchAgentCreationFailed
        #expect(error.localizedDescription == "Failed to create launch agent")
    }
    
    @Test("Launch agent registration failed error has correct description")
    func launchAgentRegistrationFailedDescription() {
        let error = SchedulingError.launchAgentRegistrationFailed
        #expect(error.localizedDescription == "Failed to register launch agent")
    }
    
    @Test("Launch agent unregistration failed error has correct description")
    func launchAgentUnregistrationFailedDescription() {
        let error = SchedulingError.launchAgentUnregistrationFailed
        #expect(error.localizedDescription == "Failed to unregister launch agent")
    }
    
    @Test("Invalid time error has correct description")
    func invalidTimeDescription() {
        let error = SchedulingError.invalidTime
        #expect(error.localizedDescription == "Invalid time provided")
    }
    
    @Test("File system error includes custom message")
    func fileSystemErrorIncludesCustomMessage() {
        let customMessage = "Permission denied"
        let error = SchedulingError.fileSystemError(customMessage)
        #expect(error.localizedDescription == "File system error: Permission denied")
    }
    
    @Test("File system error with empty message")
    func fileSystemErrorWithEmptyMessage() {
        let error = SchedulingError.fileSystemError("")
        #expect(error.localizedDescription == "File system error: ")
    }
    
    @Test("File system error with complex message")
    func fileSystemErrorWithComplexMessage() {
        let complexMessage = "Failed to write to /path/to/file: EACCES (Permission denied)"
        let error = SchedulingError.fileSystemError(complexMessage)
        #expect(error.localizedDescription == "File system error: Failed to write to /path/to/file: EACCES (Permission denied)")
    }
    
    @Test("All error cases are unique")
    func allErrorCasesAreUnique() {
        let errors: [SchedulingError] = [
            .scriptNotFound,
            .launchAgentCreationFailed,
            .launchAgentRegistrationFailed,
            .launchAgentUnregistrationFailed,
            .invalidTime,
            .fileSystemError("test")
        ]
        
        let descriptions = errors.map { $0.localizedDescription }
        let uniqueDescriptions = Set(descriptions)
        
        // All descriptions should be unique (except the fileSystemError which has a parameter)
        #expect(uniqueDescriptions.count == descriptions.count)
    }
    
    @Test("Error conforms to Error protocol")
    func errorConformsToErrorProtocol() {
        let error: Error = SchedulingError.scriptNotFound
        #expect(error is SchedulingError)
    }
}