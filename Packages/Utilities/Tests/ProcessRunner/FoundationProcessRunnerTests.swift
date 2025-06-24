import Testing
@testable import Utilities
import Foundation

@Suite("Foundation Process Runner Tests")
struct FoundationProcessRunnerTests {
    
    @Test("Executes simple command successfully")
    func executesSimpleCommand() async throws {
        let sut = FoundationProcessRunner(launchPath: "/bin/echo")
        let result = try await sut.run(arguments: "Hello", "World")
        
        let output = String(data: result, encoding: .utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        #expect(output == "Hello World")
    }
    
    @Test("Captures error output and throws")
    func capturesErrorOutputAndThrows() async throws {
        let sut = FoundationProcessRunner(launchPath: "/bin/sh")
        
        await #expect(throws: ProcessRunnerError.self) {
            _ = try await sut.run(arguments: "-c", "echo 'Error' >&2; exit 1")
        }
    }
    
    @Test("Handles non-existent command")
    func handlesNonExistentCommand() async throws {
        let sut = FoundationProcessRunner(launchPath: "/non/existent/command")
        
        await #expect(throws: ProcessRunnerError.self) {
            _ = try await sut.run(arguments: "test")
        }
    }
    
    @Test("Executes command with no arguments")
    func executesCommandWithNoArguments() async throws {
        let sut = FoundationProcessRunner(launchPath: "/bin/pwd")
        let result = try await sut.run(process: ProcessCommand(arguments: []))
        
        let output = String(data: result, encoding: .utf8)
        #expect(output != nil)
        #expect(!output!.isEmpty)
    }
    
    @Test("Executes command with multiple arguments")
    func executesCommandWithMultipleArguments() async throws {
        let sut = FoundationProcessRunner(launchPath: "/bin/ls")
        let result = try await sut.run(arguments: "-a", "/tmp")
        
        let output = String(data: result, encoding: .utf8)
        #expect(output != nil)
        #expect(!output!.isEmpty)
        // /tmp should at least contain . and ..
        #expect(output!.contains("."))
        #expect(output!.contains(".."))
    }
    
    @Test("Returns correct data from command", .timeLimit(.minutes(1)))
    func returnsCorrectDataFromCommand() async throws {
        let sut = FoundationProcessRunner(launchPath: "/bin/echo")
        let testString = "Test String 123"
        let result = try await sut.run(arguments: testString)
        
        let output = String(data: result, encoding: .utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        #expect(output == testString)
    }
    
    @Test("Executes AppleScript successfully")
    func executesAppleScriptSuccessfully() async throws {
        let sut = FoundationProcessRunner(launchPath: "/usr/bin/osascript")
        let script = "return \"Hello from AppleScript\""
        
        let result = try await sut.run(arguments: "-e", script)
        let output = String(data: result, encoding: .utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        #expect(output == "Hello from AppleScript")
    }
    
    @Test("Handles process failure with non-zero exit code")
    func handlesProcessFailureWithNonZeroExitCode() async throws {
        let sut = FoundationProcessRunner(launchPath: "/bin/false")
        
        await #expect(throws: ProcessRunnerError.self) {
            _ = try await sut.run(process: ProcessCommand(arguments: []))
        }
    }
}
