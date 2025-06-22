import Testing
import Foundation
@testable import App

@Suite("Process Command Tests")
struct ProcessCommandTests {
    @Test("Initializes with empty arguments")
    func initializesWithEmptyArguments() {
        let command = ProcessCommand(arguments: [])
        #expect(command.arguments.isEmpty)
        #expect(command.arguments.count == 0)
    }
    
    @Test("Initializes with single argument")
    func initializesWithSingleArgument() {
        let command = ProcessCommand(arguments: ["test"])
        #expect(command.arguments.count == 1)
        #expect(command.arguments[0] == "test")
    }
    
    @Test("Initializes with multiple arguments")
    func initializesWithMultipleArguments() {
        let args = ["arg1", "arg2", "arg3"]
        let command = ProcessCommand(arguments: args)
        
        #expect(command.arguments.count == 3)
        #expect(command.arguments[0] == "arg1")
        #expect(command.arguments[1] == "arg2")
        #expect(command.arguments[2] == "arg3")
    }
    
    @Test("Preserves argument order")
    func preservesArgumentOrder() {
        let args = ["first", "second", "third", "fourth"]
        let command = ProcessCommand(arguments: args)
        
        for (index, arg) in args.enumerated() {
            #expect(command.arguments[index] == arg)
        }
    }
    
    @Test("Handles arguments with spaces")
    func handlesArgumentsWithSpaces() {
        let command = ProcessCommand(arguments: ["arg with spaces", "another arg"])
        
        #expect(command.arguments.count == 2)
        #expect(command.arguments[0] == "arg with spaces")
        #expect(command.arguments[1] == "another arg")
    }
    
    @Test("Handles empty string arguments")
    func handlesEmptyStringArguments() {
        let command = ProcessCommand(arguments: ["", "non-empty", ""])
        
        #expect(command.arguments.count == 3)
        #expect(command.arguments[0] == "")
        #expect(command.arguments[1] == "non-empty")
        #expect(command.arguments[2] == "")
    }
    
    @Test("Handles special characters in arguments")
    func handlesSpecialCharactersInArguments() {
        let specialArgs = ["-flag", "--option=value", "/path/to/file", "arg&with&ampersand"]
        let command = ProcessCommand(arguments: specialArgs)
        
        #expect(command.arguments.count == 4)
        #expect(command.arguments[0] == "-flag")
        #expect(command.arguments[1] == "--option=value")
        #expect(command.arguments[2] == "/path/to/file")
        #expect(command.arguments[3] == "arg&with&ampersand")
    }
    
    @Test("Arguments are mutable")
    func argumentsAreMutable() {
        var command = ProcessCommand(arguments: ["initial"])
        
        command.arguments.append("added")
        #expect(command.arguments.count == 2)
        #expect(command.arguments[1] == "added")
        
        command.arguments[0] = "modified"
        #expect(command.arguments[0] == "modified")
        
        command.arguments.removeAll()
        #expect(command.arguments.isEmpty)
    }
    
    @Test("Type alias works correctly")
    func typeAliasWorksCorrectly() {
        let arg: ProcessCommand.Argument = "test"
        let command = ProcessCommand(arguments: [arg])
        
        #expect(command.arguments[0] == "test")
        #expect(type(of: command.arguments[0]) == String.self)
    }
}
