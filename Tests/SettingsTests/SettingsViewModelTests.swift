import Testing
import Foundation
@testable import App

@Suite("Settings View Model Tests")
@MainActor
struct SettingsViewModelTests {
    let schedulingServiceSpy = SchedulingServiceSpy()
    var preferencesRepositorySpy = PreferencesRepositorySpy()
    
    lazy var sut = SettingsViewModel(
        schedulingService: schedulingServiceSpy,
        preferencesRepository: preferencesRepositorySpy
    )
}
