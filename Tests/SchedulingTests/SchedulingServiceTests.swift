import Testing
@testable import App

@Suite("Scheduling Service Tests")
struct SchedulingServiceTests {
    let preferencesRepositorySpy = PreferencesRepositorySpy()
    let fileSystemProviderSpy = FileSystemProviderSpy()
    let launchctlProcessRunnerSpy = ProcessRunnerSpy()
    lazy var sut = SchedulingService(
        preferencesRepository: preferencesRepositorySpy,
        fileSystemProvider: fileSystemProviderSpy,
        launchctlProcessRunner: launchctlProcessRunnerSpy
    )
}
