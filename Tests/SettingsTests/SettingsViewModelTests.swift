import Testing
import Foundation
@testable import App

@Suite("Settings View Model Tests")
@MainActor
struct SettingsViewModelTests {
    let schedulingServiceSpy = SchedulingServiceSpy()
    let preferencesRepositorySpy = PreferencesRepositorySpy()
    
    var sut: SettingsViewModel {
        SettingsViewModel(
            schedulingService: schedulingServiceSpy,
            preferencesRepository: preferencesRepositorySpy
        )
    }
    
    @Test("onAppear loads settings from preferences repository")
    func onAppear_loadsSettings() async throws {
        // Given
        preferencesRepositorySpy.getAutomaticSwitchingEnabledReturnValue = true
        preferencesRepositorySpy.getDarkModeTimeReturnValue = Date(timeIntervalSince1970: 1000)
        preferencesRepositorySpy.getLightModeTimeReturnValue = Date(timeIntervalSince1970: 2000)
        schedulingServiceSpy.isSchedulingEnabledReturnValue = true
        
        let viewModel = sut
        
        // When
        await viewModel.onAppear()
        
        // Then
        #expect(preferencesRepositorySpy.getAutomaticSwitchingEnabledCalledCount == 1)
        #expect(preferencesRepositorySpy.getDarkModeTimeCalledCount == 1)
        #expect(preferencesRepositorySpy.getLightModeTimeCalledCount == 1)
        #expect(schedulingServiceSpy.isSchedulingEnabledCalledCount == 1)
        
        #expect(viewModel.automaticSwitchingEnabled == true)
        #expect(viewModel.darkModeTime == Date(timeIntervalSince1970: 1000))
        #expect(viewModel.lightModeTime == Date(timeIntervalSince1970: 2000))
    }
    
    @Test("onAppear syncs automatic switching with actual scheduling state")
    func onAppear_syncsAutomaticSwitchingWithSchedulingState() async throws {
        // Given
        preferencesRepositorySpy.getAutomaticSwitchingEnabledReturnValue = true
        schedulingServiceSpy.isSchedulingEnabledReturnValue = false
        
        let viewModel = sut
        
        // When
        await viewModel.onAppear()
        
        // Then
        #expect(viewModel.automaticSwitchingEnabled == false)
    }
    
    @Test("onAppear sets default times when preferences return nil")
    func onAppear_setsDefaultTimesWhenNil() async throws {
        // Given
        preferencesRepositorySpy.getAutomaticSwitchingEnabledReturnValue = false
        preferencesRepositorySpy.getDarkModeTimeReturnValue = nil
        preferencesRepositorySpy.getLightModeTimeReturnValue = nil
        schedulingServiceSpy.isSchedulingEnabledReturnValue = false
        
        let viewModel = sut
        
        // When
        await viewModel.onAppear()
        
        // Then
        let calendar = Calendar.current
        let darkModeHour = calendar.component(.hour, from: viewModel.darkModeTime)
        let lightModeHour = calendar.component(.hour, from: viewModel.lightModeTime)
        
        #expect(darkModeHour == 21) // 9 PM
        #expect(lightModeHour == 7)  // 7 AM
    }
    
    @Test("save enables scheduling when automatic switching is enabled and scheduling is disabled")
    func save_enablesSchedulingWhenNeeded() async throws {
        // Given
        schedulingServiceSpy.isSchedulingEnabledReturnValue = false
        
        let viewModel = sut
        viewModel.automaticSwitchingEnabled = true
        viewModel.darkModeTime = Date(timeIntervalSince1970: 1000)
        viewModel.lightModeTime = Date(timeIntervalSince1970: 2000)
        
        // When
        try await viewModel.save()
        
        // Then
        #expect(preferencesRepositorySpy.setAutomaticSwitchingEnabledCalledCount == 1)
        #expect(preferencesRepositorySpy.setAutomaticSwitchingEnabledReceivedArguments.last == true)
        #expect(preferencesRepositorySpy.setDarkModeTimeCalledCount == 1)
        #expect(preferencesRepositorySpy.setLightModeTimeCalledCount == 1)
        
        #expect(schedulingServiceSpy.isSchedulingEnabledCalledCount == 1)
        #expect(schedulingServiceSpy.enableAutomaticSchedulingCalledCount == 1)
        #expect(schedulingServiceSpy.disableAutomaticSchedulingCalledCount == 0)
    }
    
    @Test("save does not enable scheduling when already enabled")
    func save_doesNotEnableSchedulingWhenAlreadyEnabled() async throws {
        // Given
        schedulingServiceSpy.isSchedulingEnabledReturnValue = true
        
        let viewModel = sut
        viewModel.automaticSwitchingEnabled = true
        
        // When
        try await viewModel.save()
        
        // Then
        #expect(schedulingServiceSpy.isSchedulingEnabledCalledCount == 1)
        #expect(schedulingServiceSpy.enableAutomaticSchedulingCalledCount == 0)
    }
    
    @Test("save disables scheduling when automatic switching is disabled and scheduling is enabled")
    func save_disablesSchedulingWhenNeeded() async throws {
        // Given
        schedulingServiceSpy.isSchedulingEnabledReturnValue = true
        
        let viewModel = sut
        viewModel.automaticSwitchingEnabled = false
        
        // When
        try await viewModel.save()
        
        // Then
        #expect(preferencesRepositorySpy.setAutomaticSwitchingEnabledCalledCount == 1)
        #expect(preferencesRepositorySpy.setAutomaticSwitchingEnabledReceivedArguments.last == false)
        
        #expect(schedulingServiceSpy.isSchedulingEnabledCalledCount == 1)
        #expect(schedulingServiceSpy.disableAutomaticSchedulingCalledCount == 1)
        #expect(schedulingServiceSpy.enableAutomaticSchedulingCalledCount == 0)
    }
    
    @Test("save does not disable scheduling when already disabled")
    func save_doesNotDisableSchedulingWhenAlreadyDisabled() async throws {
        // Given
        schedulingServiceSpy.isSchedulingEnabledReturnValue = false
        
        let viewModel = sut
        viewModel.automaticSwitchingEnabled = false
        
        // When
        try await viewModel.save()
        
        // Then
        #expect(schedulingServiceSpy.isSchedulingEnabledCalledCount == 1)
        #expect(schedulingServiceSpy.disableAutomaticSchedulingCalledCount == 0)
    }
    
    @Test("save throws when enableAutomaticScheduling fails")
    func save_throwsWhenEnablingFails() async throws {
        // Given
        struct TestError: Error {}
        schedulingServiceSpy.isSchedulingEnabledReturnValue = false
        schedulingServiceSpy.enableAutomaticSchedulingShouldThrow = TestError()
        
        let viewModel = sut
        viewModel.automaticSwitchingEnabled = true
        
        // When/Then
        await #expect(throws: TestError.self) {
            try await viewModel.save()
        }
    }
    
    @Test("save throws when disableAutomaticScheduling fails")
    func save_throwsWhenDisablingFails() async throws {
        // Given
        struct TestError: Error {}
        schedulingServiceSpy.isSchedulingEnabledReturnValue = true
        schedulingServiceSpy.disableAutomaticSchedulingShouldThrow = TestError()
        
        let viewModel = sut
        viewModel.automaticSwitchingEnabled = false
        
        // When/Then
        await #expect(throws: TestError.self) {
            try await viewModel.save()
        }
    }
    
    @Test("cancel reloads settings from preferences")
    func cancel_reloadsSettings() async throws {
        // Given
        preferencesRepositorySpy.getAutomaticSwitchingEnabledReturnValue = false
        preferencesRepositorySpy.getDarkModeTimeReturnValue = Date(timeIntervalSince1970: 3000)
        preferencesRepositorySpy.getLightModeTimeReturnValue = Date(timeIntervalSince1970: 4000)
        schedulingServiceSpy.isSchedulingEnabledReturnValue = false
        
        let viewModel = sut
        // Modify the view model state
        viewModel.automaticSwitchingEnabled = true
        viewModel.darkModeTime = Date(timeIntervalSince1970: 1000)
        viewModel.lightModeTime = Date(timeIntervalSince1970: 2000)
        
        // When
        await viewModel.cancel()
        
        // Then
        #expect(preferencesRepositorySpy.getAutomaticSwitchingEnabledCalledCount == 1)
        #expect(preferencesRepositorySpy.getDarkModeTimeCalledCount == 1)
        #expect(preferencesRepositorySpy.getLightModeTimeCalledCount == 1)
        
        #expect(viewModel.automaticSwitchingEnabled == false)
        #expect(viewModel.darkModeTime == Date(timeIntervalSince1970: 3000))
        #expect(viewModel.lightModeTime == Date(timeIntervalSince1970: 4000))
    }
}
