//import Testing
//import Foundation
//@testable import App
//
//@Suite("Settings View Model Tests")
//@MainActor
//struct SettingsViewModelTests {
//    
//    // MARK: - Initialization Tests
//    
//    @Test("Initializes with repository values when available")
//    func initializesWithRepositoryValues() async {
//        let preferencesRepositorySpy = PreferencesRepositorySpy()
//        let schedulingServiceSpy = SchedulingServiceSpy()
//        
//        let testDarkModeTime = Calendar.current.date(bySettingHour: 22, minute: 30, second: 0, of: Date())!
//        let testLightModeTime = Calendar.current.date(bySettingHour: 6, minute: 45, second: 0, of: Date())!
//        
//        preferencesRepositorySpy.getAutomaticSwitchingEnabledReturnValue = false
//        preferencesRepositorySpy.getDarkModeTimeReturnValue = testDarkModeTime
//        preferencesRepositorySpy.getLightModeTimeReturnValue = testLightModeTime
//        schedulingServiceSpy.isSchedulingEnabledReturnValue = false
//        
//        let sut = SettingsViewModel(
//            schedulingService: schedulingServiceSpy,
//            preferencesRepository: preferencesRepositorySpy
//        )
//        
//        // Allow async initialization to complete
//        try? await Task.sleep(for: .milliseconds(100))
//        
//        #expect(sut.automaticSwitchingEnabled == false)
//        #expect(sut.darkModeTime == testDarkModeTime)
//        #expect(sut.lightModeTime == testLightModeTime)
//        #expect(preferencesRepositorySpy.getAutomaticSwitchingEnabledCalledCount == 1)
//        #expect(preferencesRepositorySpy.getDarkModeTimeCalledCount == 1)
//        #expect(preferencesRepositorySpy.getLightModeTimeCalledCount == 1)
//        #expect(schedulingServiceSpy.isSchedulingEnabledCalledCount == 1)
//    }
//    
//    @Test("Initializes with default times when repository returns nil")
//    func initializesWithDefaultTimesWhenRepositoryReturnsNil() async {
//        let preferencesRepositorySpy = PreferencesRepositorySpy()
//        let schedulingServiceSpy = SchedulingServiceSpy()
//        
//        preferencesRepositorySpy.getAutomaticSwitchingEnabledReturnValue = true
//        preferencesRepositorySpy.getDarkModeTimeReturnValue = nil
//        preferencesRepositorySpy.getLightModeTimeReturnValue = nil
//        schedulingServiceSpy.isSchedulingEnabledReturnValue = true
//        
//        let sut = SettingsViewModel(
//            schedulingService: schedulingServiceSpy,
//            preferencesRepository: preferencesRepositorySpy
//        )
//        
//        try? await Task.sleep(for: .milliseconds(100))
//        
//        let calendar = Calendar.current
//        let expectedDarkModeTime = calendar.date(bySettingHour: 21, minute: 0, second: 0, of: Date())!
//        let expectedLightModeTime = calendar.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
//        
//        #expect(sut.automaticSwitchingEnabled == true)
//        #expect(calendar.component(.hour, from: sut.darkModeTime) == 21)
//        #expect(calendar.component(.minute, from: sut.darkModeTime) == 0)
//        #expect(calendar.component(.hour, from: sut.lightModeTime) == 7)
//        #expect(calendar.component(.minute, from: sut.lightModeTime) == 0)
//    }
//    
//    @Test("Syncs automatic switching state with actual scheduling service state")
//    func syncsAutomaticSwitchingStateWithActualSchedulingServiceState() async {
//        let preferencesRepositorySpy = PreferencesRepositorySpy()
//        let schedulingServiceSpy = SchedulingServiceSpy()
//        
//        preferencesRepositorySpy.getAutomaticSwitchingEnabledReturnValue = true
//        schedulingServiceSpy.isSchedulingEnabledReturnValue = false
//        
//        let sut = SettingsViewModel(
//            schedulingService: schedulingServiceSpy,
//            preferencesRepository: preferencesRepositorySpy
//        )
//        
//        try? await Task.sleep(for: .milliseconds(100))
//        
//        #expect(sut.automaticSwitchingEnabled == false)
//    }
//    
//    // MARK: - Save Tests
//    
//    @Test("Save enables automatic scheduling when enabled and not currently scheduled")
//    func saveEnablesAutomaticSchedulingWhenEnabledAndNotCurrentlyScheduled() async {
//        let preferencesRepositorySpy = PreferencesRepositorySpy()
//        let schedulingServiceSpy = SchedulingServiceSpy()
//        
//        schedulingServiceSpy.isSchedulingEnabledReturnValue = false
//        
//        let sut = SettingsViewModel(
//            schedulingService: schedulingServiceSpy,
//            preferencesRepository: preferencesRepositorySpy
//        )
//        
//        try? await Task.sleep(for: .milliseconds(100))
//        
//        sut.automaticSwitchingEnabled = true
//        let testDarkModeTime = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date())!
//        let testLightModeTime = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
//        sut.darkModeTime = testDarkModeTime
//        sut.lightModeTime = testLightModeTime
//        
//        sut.save()
//        
//        try? await Task.sleep(for: .milliseconds(100))
//        
//        #expect(schedulingServiceSpy.enableAutomaticSchedulingCalledCount == 1)
//        #expect(schedulingServiceSpy.enableAutomaticSchedulingReceivedArguments[0].darkModeTime == testDarkModeTime)
//        #expect(schedulingServiceSpy.enableAutomaticSchedulingReceivedArguments[0].lightModeTime == testLightModeTime)
//        #expect(preferencesRepositorySpy.setAutomaticSwitchingEnabledCalledCount == 1)
//        #expect(preferencesRepositorySpy.setAutomaticSwitchingEnabledReceivedArguments[0] == true)
//    }
//    
//    @Test("Save updates existing schedule when enabled and currently scheduled")
//    func saveUpdatesExistingScheduleWhenEnabledAndCurrentlyScheduled() async {
//        let preferencesRepositorySpy = PreferencesRepositorySpy()
//        let schedulingServiceSpy = SchedulingServiceSpy()
//        
//        schedulingServiceSpy.isSchedulingEnabledReturnValue = true
//        
//        let sut = SettingsViewModel(
//            schedulingService: schedulingServiceSpy,
//            preferencesRepository: preferencesRepositorySpy
//        )
//        
//        try? await Task.sleep(for: .milliseconds(100))
//        
//        sut.automaticSwitchingEnabled = true
//        let testDarkModeTime = Calendar.current.date(bySettingHour: 23, minute: 15, second: 0, of: Date())!
//        let testLightModeTime = Calendar.current.date(bySettingHour: 5, minute: 30, second: 0, of: Date())!
//        sut.darkModeTime = testDarkModeTime
//        sut.lightModeTime = testLightModeTime
//        
//        sut.save()
//        
//        try? await Task.sleep(for: .milliseconds(100))
//        
//        #expect(schedulingServiceSpy.updateScheduleCalledCount == 1)
//        #expect(schedulingServiceSpy.updateScheduleReceivedArguments[0].darkModeTime == testDarkModeTime)
//        #expect(schedulingServiceSpy.updateScheduleReceivedArguments[0].lightModeTime == testLightModeTime)
//        #expect(schedulingServiceSpy.enableAutomaticSchedulingCalledCount == 0)
//        #expect(preferencesRepositorySpy.setAutomaticSwitchingEnabledCalledCount == 1)
//        #expect(preferencesRepositorySpy.setAutomaticSwitchingEnabledReceivedArguments[0] == true)
//    }
//    
//    @Test("Save disables automatic scheduling when disabled and currently scheduled")
//    func saveDisablesAutomaticSchedulingWhenDisabledAndCurrentlyScheduled() async {
//        let preferencesRepositorySpy = PreferencesRepositorySpy()
//        let schedulingServiceSpy = SchedulingServiceSpy()
//        
//        schedulingServiceSpy.isSchedulingEnabledReturnValue = true
//        
//        let sut = SettingsViewModel(
//            schedulingService: schedulingServiceSpy,
//            preferencesRepository: preferencesRepositorySpy
//        )
//        
//        try? await Task.sleep(for: .milliseconds(100))
//        
//        sut.automaticSwitchingEnabled = false
//        
//        sut.save()
//        
//        try? await Task.sleep(for: .milliseconds(100))
//        
//        #expect(schedulingServiceSpy.disableAutomaticSchedulingCalledCount == 1)
//        #expect(schedulingServiceSpy.enableAutomaticSchedulingCalledCount == 0)
//        #expect(schedulingServiceSpy.updateScheduleCalledCount == 0)
//        #expect(preferencesRepositorySpy.setAutomaticSwitchingEnabledCalledCount == 1)
//        #expect(preferencesRepositorySpy.setAutomaticSwitchingEnabledReceivedArguments[0] == false)
//    }
//    
//    @Test("Save does nothing when disabled and not currently scheduled")
//    func saveDoesNothingWhenDisabledAndNotCurrentlyScheduled() async {
//        let preferencesRepositorySpy = PreferencesRepositorySpy()
//        let schedulingServiceSpy = SchedulingServiceSpy()
//        
//        schedulingServiceSpy.isSchedulingEnabledReturnValue = false
//        
//        let sut = SettingsViewModel(
//            schedulingService: schedulingServiceSpy,
//            preferencesRepository: preferencesRepositorySpy
//        )
//        
//        try? await Task.sleep(for: .milliseconds(100))
//        
//        sut.automaticSwitchingEnabled = false
//        
//        sut.save()
//        
//        try? await Task.sleep(for: .milliseconds(100))
//        
//        #expect(schedulingServiceSpy.disableAutomaticSchedulingCalledCount == 0)
//        #expect(schedulingServiceSpy.enableAutomaticSchedulingCalledCount == 0)
//        #expect(schedulingServiceSpy.updateScheduleCalledCount == 0)
//        #expect(preferencesRepositorySpy.setAutomaticSwitchingEnabledCalledCount == 1)
//        #expect(preferencesRepositorySpy.setAutomaticSwitchingEnabledReceivedArguments[0] == false)
//    }
//    
//    @Test("Save handles scheduling service errors gracefully")
//    func saveHandlesSchedulingServiceErrorsGracefully() async {
//        let preferencesRepositorySpy = PreferencesRepositorySpy()
//        let schedulingServiceSpy = SchedulingServiceSpy()
//        
//        struct TestError: Error {}
//        
//        schedulingServiceSpy.isSchedulingEnabledReturnValue = false
//        schedulingServiceSpy.enableAutomaticSchedulingShouldThrow = TestError()
//        
//        let sut = SettingsViewModel(
//            schedulingService: schedulingServiceSpy,
//            preferencesRepository: preferencesRepositorySpy
//        )
//        
//        try? await Task.sleep(for: .milliseconds(100))
//        
//        sut.automaticSwitchingEnabled = true
//        
//        sut.save()
//        
//        try? await Task.sleep(for: .milliseconds(100))
//        
//        #expect(schedulingServiceSpy.enableAutomaticSchedulingCalledCount == 1)
//        #expect(preferencesRepositorySpy.setAutomaticSwitchingEnabledCalledCount == 0)
//    }
//    
//    // MARK: - Cancel Tests
//    
//    @Test("Cancel reloads settings from repository")
//    func cancelReloadsSettingsFromRepository() async {
//        let preferencesRepositorySpy = PreferencesRepositorySpy()
//        let schedulingServiceSpy = SchedulingServiceSpy()
//        
//        let initialDarkModeTime = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date())!
//        let initialLightModeTime = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
//        
//        preferencesRepositorySpy.getAutomaticSwitchingEnabledReturnValue = true
//        preferencesRepositorySpy.getDarkModeTimeReturnValue = initialDarkModeTime
//        preferencesRepositorySpy.getLightModeTimeReturnValue = initialLightModeTime
//        schedulingServiceSpy.isSchedulingEnabledReturnValue = true
//        
//        let sut = SettingsViewModel(
//            schedulingService: schedulingServiceSpy,
//            preferencesRepository: preferencesRepositorySpy
//        )
//        
//        try? await Task.sleep(for: .milliseconds(100))
//        
//        sut.automaticSwitchingEnabled = false
//        sut.darkModeTime = Calendar.current.date(bySettingHour: 22, minute: 30, second: 0, of: Date())!
//        sut.lightModeTime = Calendar.current.date(bySettingHour: 6, minute: 15, second: 0, of: Date())!
//        
//        let initialCallCount = preferencesRepositorySpy.getAutomaticSwitchingEnabledCalledCount
//        
//        sut.cancel()
//        
//        try? await Task.sleep(for: .milliseconds(100))
//        
//        #expect(sut.automaticSwitchingEnabled == true)
//        #expect(sut.darkModeTime == initialDarkModeTime)
//        #expect(sut.lightModeTime == initialLightModeTime)
//        #expect(preferencesRepositorySpy.getAutomaticSwitchingEnabledCalledCount == initialCallCount + 1)
//    }
//}
