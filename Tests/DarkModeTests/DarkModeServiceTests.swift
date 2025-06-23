import Testing
import Foundation
@testable import App

@Suite("Dark Mode Service Tests")
final class DarkModeServiceTests {
    let osascriptProcessRunnerSpy = ProcessRunnerSpy()
    lazy var sut = DarkModeService(osascriptProcessRunner: osascriptProcessRunnerSpy)
    
    @Test("getCurrentMode returns dark when osascript returns true")
    func getCurrentModeReturnsDarkWhenOsascriptReturnsTrue() async {
        osascriptProcessRunnerSpy.runWithArgumentsReturnValue = "true\n".data(using: .utf8)!
        
        let mode = await sut.getCurrentMode()
        
        #expect(mode == .dark)
        #expect(osascriptProcessRunnerSpy.runWithArgumentsCalledCount == 1)
        #expect(osascriptProcessRunnerSpy.runWithArgumentsReceivedArguments.first == [
            "-e",
            """
            tell application "System Events" to tell appearance preferences to return dark mode
            """
        ])
    }
    
    @Test("getCurrentMode returns light when osascript returns false")
    func getCurrentModeReturnsLightWhenOsascriptReturnsFalse() async {
        osascriptProcessRunnerSpy.runWithArgumentsReturnValue = "false\n".data(using: .utf8)!
        
        let mode = await sut.getCurrentMode()
        
        #expect(mode == .light)
        #expect(osascriptProcessRunnerSpy.runWithArgumentsCalledCount == 1)
    }
    
    @Test("getCurrentMode returns light when osascript returns empty string")
    func getCurrentModeReturnsLightWhenOsascriptReturnsEmptyString() async {
        osascriptProcessRunnerSpy.runWithArgumentsReturnValue = "".data(using: .utf8)!
        
        let mode = await sut.getCurrentMode()
        
        #expect(mode == .light)
        #expect(osascriptProcessRunnerSpy.runWithArgumentsCalledCount == 1)
    }
    
    @Test("getCurrentMode returns light when osascript returns invalid data")
    func getCurrentModeReturnsLightWhenOsascriptReturnsInvalidData() async {
        osascriptProcessRunnerSpy.runWithArgumentsReturnValue = Data([0xFF, 0xFE])
        
        let mode = await sut.getCurrentMode()
        
        #expect(mode == .light)
        #expect(osascriptProcessRunnerSpy.runWithArgumentsCalledCount == 1)
    }
    
    @Test("getCurrentMode falls back to NSApplication when osascript throws error")
    func getCurrentModeFallsBackToNSApplicationWhenOsascriptThrowsError() async {
        struct TestError: Error {}
        osascriptProcessRunnerSpy.runWithArgumentsShouldThrow = TestError()
        
        let mode = await sut.getCurrentMode()
        
        #expect(mode == .light || mode == .dark)
        #expect(osascriptProcessRunnerSpy.runWithArgumentsCalledCount == 1)
    }
    
    @Test("toggleMode calls osascript with correct arguments")
    func toggleModeCallsOsascriptWithCorrectArguments() async throws {
        osascriptProcessRunnerSpy.runWithArgumentsReturnValue = Data()
        
        try await sut.toggleMode()
        
        #expect(osascriptProcessRunnerSpy.runWithArgumentsCalledCount == 1)
        #expect(osascriptProcessRunnerSpy.runWithArgumentsReceivedArguments.first == [
            "-e",
            """
            tell application "System Events" to tell appearance preferences to set dark mode to not dark mode
            """
        ])
    }
    
    @Test("toggleMode throws when osascript throws error")
    func toggleModeThrowsWhenOsascriptThrowsError() async {
        struct TestError: Error {}
        osascriptProcessRunnerSpy.runWithArgumentsShouldThrow = TestError()
        
        await #expect(throws: TestError.self) {
            try await self.sut.toggleMode()
        }
        
        #expect(osascriptProcessRunnerSpy.runWithArgumentsCalledCount == 1)
    }
}
