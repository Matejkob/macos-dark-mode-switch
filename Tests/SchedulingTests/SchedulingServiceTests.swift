import Testing
import Foundation
@testable import App

@Suite("Scheduling Service Tests")
final class SchedulingServiceTests {
    let preferencesRepositorySpy = PreferencesRepositorySpy()
    let fileSystemProviderSpy = FileSystemProviderSpy()
    
    lazy var sut = SchedulingService(
        preferencesRepository: preferencesRepositorySpy,
        fileSystemProvider: fileSystemProviderSpy
    )
}
