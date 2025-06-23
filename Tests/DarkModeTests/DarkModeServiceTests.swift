import Testing
@testable import App

@Suite("Dark Mode Service Tests")
struct DarkModeServiceTests {
    let osascriptProcessRunnerSpy = ProcessRunnerSpy()
    lazy var sut = DarkModeService(osascriptProcessRunner: osascriptProcessRunnerSpy)
}
