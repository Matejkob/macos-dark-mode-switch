//import Testing
//import Foundation
//@testable import App
//
//@Suite("Scheduling Service Tests")
//struct SchedulingServiceTests {
//    let preferencesRepositorySpy = PreferencesRepositorySpy()
//    let fileSystemProviderSpy = FileSystemProviderSpy()
//    let launchctlProcessRunnerSpy = ProcessRunnerSpy()
//    lazy var sut = SchedulingService(
//        preferencesRepository: preferencesRepositorySpy,
//        fileSystemProvider: fileSystemProviderSpy,
//        launchctlProcessRunner: launchctlProcessRunnerSpy
//    )
//    
//    // MARK: - enableAutomaticScheduling Tests
//    
//    @Test("enableAutomaticScheduling creates launch agents directory when it doesn't exist")
//    func enableAutomaticSchedulingCreatesLaunchAgentsDirectory() async throws {
//        let darkTime = createDate(hour: 21, minute: 0)
//        let lightTime = createDate(hour: 7, minute: 0)
//        
//        fileSystemProviderSpy.fileExistsWithDirectoryFlagReturnValue = false
//        fileSystemProviderSpy.bundlePathReturnValue = "/mock/script/path.sh"
//        fileSystemProviderSpy.fileExistsAtPathReturnValue = true
//        
//        try await sut.enableAutomaticScheduling(darkModeTime: darkTime, lightModeTime: lightTime)
//        
//        #expect(fileSystemProviderSpy.createDirectoryCalledCount == 1)
//        let expectedDirectory = URL(fileURLWithPath: "/mock/home/Library/LaunchAgents")
//        #expect(fileSystemProviderSpy.createDirectoryReceivedArguments.first?.url == expectedDirectory)
//        #expect(fileSystemProviderSpy.createDirectoryReceivedArguments.first?.withIntermediateDirectories == true)
//    }
//    
//    @Test("enableAutomaticScheduling throws when launch agents path exists but is not directory")
//    func enableAutomaticSchedulingThrowsWhenPathExistsButIsNotDirectory() async {
//        let darkTime = createDate(hour: 21, minute: 0)
//        let lightTime = createDate(hour: 7, minute: 0)
//        
//        fileSystemProviderSpy.fileExistsWithDirectoryFlagReturnValue = true
//        fileSystemProviderSpy.fileExistsWithDirectoryFlagIsDirectoryValue = false
//        
//        await #expect(throws: SchedulingError.self) {
//            try await sut.enableAutomaticScheduling(darkModeTime: darkTime, lightModeTime: lightTime)
//        }
//    }
//    
//    @Test("enableAutomaticScheduling uses bundle script when available")
//    func enableAutomaticSchedulingUsesBundleScript() async throws {
//        let darkTime = createDate(hour: 21, minute: 0)
//        let lightTime = createDate(hour: 7, minute: 0)
//        
//        fileSystemProviderSpy.fileExistsWithDirectoryFlagReturnValue = true
//        fileSystemProviderSpy.fileExistsWithDirectoryFlagIsDirectoryValue = true
//        fileSystemProviderSpy.bundlePathReturnValue = "/bundle/script.sh"
//        fileSystemProviderSpy.fileExistsAtPathReturnValue = true
//        
//        try await sut.enableAutomaticScheduling(darkModeTime: darkTime, lightModeTime: lightTime)
//        
//        let expectedPlistContent = createExpectedPlistContent(scriptPath: "/bundle/script.sh")
//        #expect(fileSystemProviderSpy.writeDataCalledCount == 1)
//        let writtenData = fileSystemProviderSpy.writeDataReceivedArguments.first?.data
//        let writtenContent = String(data: writtenData!, encoding: .utf8)
//        #expect(writtenContent == expectedPlistContent)
//    }
//    
//    @Test("enableAutomaticScheduling creates script in home directory when bundle not available")
//    func enableAutomaticSchedulingCreatesScriptInHomeDirectory() async throws {
//        let darkTime = createDate(hour: 21, minute: 0)
//        let lightTime = createDate(hour: 7, minute: 0)
//        
//        fileSystemProviderSpy.fileExistsWithDirectoryFlagReturnValue = true
//        fileSystemProviderSpy.fileExistsWithDirectoryFlagIsDirectoryValue = true
//        fileSystemProviderSpy.bundlePathReturnValue = nil
//        
//        var fileExistsCallCount = 0
//        fileSystemProviderSpy.fileExistsAtPathReturnValue = false
//        
//        try await sut.enableAutomaticScheduling(darkModeTime: darkTime, lightModeTime: lightTime)
//        
//        #expect(fileSystemProviderSpy.writeDataCalledCount == 2) // Script + plist
//        #expect(fileSystemProviderSpy.setAttributesCalledCount == 1)
//    }
//    
//    @Test("enableAutomaticScheduling saves preferences correctly")
//    func enableAutomaticSchedulingSavesPreferences() async throws {
//        let darkTime = createDate(hour: 21, minute: 0)
//        let lightTime = createDate(hour: 7, minute: 0)
//        
//        fileSystemProviderSpy.fileExistsWithDirectoryFlagReturnValue = true
//        fileSystemProviderSpy.fileExistsWithDirectoryFlagIsDirectoryValue = true
//        fileSystemProviderSpy.bundlePathReturnValue = "/mock/script.sh"
//        fileSystemProviderSpy.fileExistsAtPathReturnValue = true
//        
//        try await sut.enableAutomaticScheduling(darkModeTime: darkTime, lightModeTime: lightTime)
//        
//        #expect(preferencesRepositorySpy.setAutomaticSwitchingEnabledCalledCount == 1)
//        #expect(preferencesRepositorySpy.setAutomaticSwitchingEnabledReceivedArguments.first == true)
//        #expect(preferencesRepositorySpy.setDarkModeTimeCalledCount == 1)
//        #expect(preferencesRepositorySpy.setDarkModeTimeReceivedArguments.first == darkTime)
//        #expect(preferencesRepositorySpy.setLightModeTimeCalledCount == 1)
//        #expect(preferencesRepositorySpy.setLightModeTimeReceivedArguments.first == lightTime)
//    }
//    
//    @Test("enableAutomaticScheduling registers launch agent")
//    func enableAutomaticSchedulingRegistersLaunchAgent() async throws {
//        let darkTime = createDate(hour: 21, minute: 0)
//        let lightTime = createDate(hour: 7, minute: 0)
//        
//        fileSystemProviderSpy.fileExistsWithDirectoryFlagReturnValue = true
//        fileSystemProviderSpy.fileExistsWithDirectoryFlagIsDirectoryValue = true
//        fileSystemProviderSpy.bundlePathReturnValue = "/mock/script.sh"
//        fileSystemProviderSpy.fileExistsAtPathReturnValue = true
//        
//        try await sut.enableAutomaticScheduling(darkModeTime: darkTime, lightModeTime: lightTime)
//        
//        #expect(launchctlProcessRunnerSpy.runWithArgumentsCalledCount == 1)
//        let arguments = launchctlProcessRunnerSpy.runWithArgumentsReceivedArguments.first
//        #expect(arguments?.count == 2)
//        #expect(arguments?.first?.raw == "load")
//        #expect(arguments?.last?.raw.contains("com.darkmodeswitch.scheduler.plist") == true)
//    }
//    
//    // MARK: - disableAutomaticScheduling Tests
//    
//    @Test("disableAutomaticScheduling saves disabled preference")
//    func disableAutomaticSchedulingSavesDisabledPreference() async throws {
//        try await sut.disableAutomaticScheduling()
//        
//        #expect(preferencesRepositorySpy.setAutomaticSwitchingEnabledCalledCount == 1)
//        #expect(preferencesRepositorySpy.setAutomaticSwitchingEnabledReceivedArguments.first == false)
//    }
//    
//    @Test("disableAutomaticScheduling unregisters launch agent when file exists")
//    func disableAutomaticSchedulingUnregistersLaunchAgent() async throws {
//        fileSystemProviderSpy.fileExistsAtPathReturnValue = true
//        
//        try await sut.disableAutomaticScheduling()
//        
//        #expect(launchctlProcessRunnerSpy.runWithArgumentsCalledCount == 1)
//        let arguments = launchctlProcessRunnerSpy.runWithArgumentsReceivedArguments.first
//        #expect(arguments?.count == 2)
//        #expect(arguments?.first?.raw == "unload")
//        #expect(arguments?.last?.raw.contains("com.darkmodeswitch.scheduler.plist") == true)
//        
//        #expect(fileSystemProviderSpy.removeItemCalledCount == 1)
//    }
//    
//    @Test("disableAutomaticScheduling does not call launchctl when file doesn't exist")
//    func disableAutomaticSchedulingDoesNotCallLaunchctlWhenFileDoesNotExist() async throws {
//        fileSystemProviderSpy.fileExistsAtPathReturnValue = false
//        
//        try await sut.disableAutomaticScheduling()
//        
//        #expect(launchctlProcessRunnerSpy.runWithArgumentsCalledCount == 0)
//        #expect(fileSystemProviderSpy.removeItemCalledCount == 0)
//    }
//    
//    // MARK: - updateSchedule Tests
//    
//    @Test("updateSchedule saves new schedule preferences")
//    func updateScheduleSavesNewSchedulePreferences() async throws {
//        let darkTime = createDate(hour: 22, minute: 30)
//        let lightTime = createDate(hour: 6, minute: 30)
//        
//        try await sut.updateSchedule(darkModeTime: darkTime, lightModeTime: lightTime)
//        
//        #expect(preferencesRepositorySpy.setAutomaticSwitchingEnabledCalledCount == 1)
//        #expect(preferencesRepositorySpy.setAutomaticSwitchingEnabledReceivedArguments.first == true)
//        #expect(preferencesRepositorySpy.setDarkModeTimeCalledCount == 1)
//        #expect(preferencesRepositorySpy.setDarkModeTimeReceivedArguments.first == darkTime)
//        #expect(preferencesRepositorySpy.setLightModeTimeCalledCount == 1)
//        #expect(preferencesRepositorySpy.setLightModeTimeReceivedArguments.first == lightTime)
//    }
//    
//    // MARK: - isSchedulingEnabled Tests
//    
//    @Test("isSchedulingEnabled returns true when plist file exists")
//    func isSchedulingEnabledReturnsTrueWhenPlistFileExists() {
//        fileSystemProviderSpy.fileExistsAtPathReturnValue = true
//        
//        let result = sut.isSchedulingEnabled()
//        
//        #expect(result == true)
//        #expect(fileSystemProviderSpy.fileExistsAtPathCalledCount == 1)
//        let checkedPath = fileSystemProviderSpy.fileExistsAtPathReceivedArguments.first
//        #expect(checkedPath?.contains("com.darkmodeswitch.scheduler.plist") == true)
//    }
//    
//    @Test("isSchedulingEnabled returns false when plist file doesn't exist")
//    func isSchedulingEnabledReturnsFalseWhenPlistFileDoesNotExist() {
//        fileSystemProviderSpy.fileExistsAtPathReturnValue = false
//        
//        let result = sut.isSchedulingEnabled()
//        
//        #expect(result == false)
//        #expect(fileSystemProviderSpy.fileExistsAtPathCalledCount == 1)
//    }
//    
//    // MARK: - Error Handling Tests
//    
//    @Test("enableAutomaticScheduling throws when directory creation fails")
//    func enableAutomaticSchedulingThrowsWhenDirectoryCreationFails() async {
//        let darkTime = createDate(hour: 21, minute: 0)
//        let lightTime = createDate(hour: 7, minute: 0)
//        
//        struct TestError: Error {}
//        fileSystemProviderSpy.fileExistsWithDirectoryFlagReturnValue = false
//        fileSystemProviderSpy.createDirectoryShouldThrow = TestError()
//        
//        await #expect(throws: TestError.self) {
//            try await sut.enableAutomaticScheduling(darkModeTime: darkTime, lightModeTime: lightTime)
//        }
//    }
//    
//    @Test("enableAutomaticScheduling throws when script writing fails")
//    func enableAutomaticSchedulingThrowsWhenScriptWritingFails() async {
//        let darkTime = createDate(hour: 21, minute: 0)
//        let lightTime = createDate(hour: 7, minute: 0)
//        
//        struct TestError: Error {}
//        fileSystemProviderSpy.fileExistsWithDirectoryFlagReturnValue = true
//        fileSystemProviderSpy.fileExistsWithDirectoryFlagIsDirectoryValue = true
//        fileSystemProviderSpy.bundlePathReturnValue = nil
//        fileSystemProviderSpy.fileExistsAtPathReturnValue = false
//        fileSystemProviderSpy.writeDataShouldThrow = TestError()
//        
//        await #expect(throws: TestError.self) {
//            try await sut.enableAutomaticScheduling(darkModeTime: darkTime, lightModeTime: lightTime)
//        }
//    }
//    
//    @Test("enableAutomaticScheduling throws when launchctl fails")
//    func enableAutomaticSchedulingThrowsWhenLaunchctlFails() async {
//        let darkTime = createDate(hour: 21, minute: 0)
//        let lightTime = createDate(hour: 7, minute: 0)
//        
//        struct TestError: Error {}
//        fileSystemProviderSpy.fileExistsWithDirectoryFlagReturnValue = true
//        fileSystemProviderSpy.fileExistsWithDirectoryFlagIsDirectoryValue = true
//        fileSystemProviderSpy.bundlePathReturnValue = "/mock/script.sh"
//        fileSystemProviderSpy.fileExistsAtPathReturnValue = true
//        launchctlProcessRunnerSpy.runWithArgumentsShouldThrow = TestError()
//        
//        await #expect(throws: TestError.self) {
//            try await sut.enableAutomaticScheduling(darkModeTime: darkTime, lightModeTime: lightTime)
//        }
//    }
//    
//    @Test("disableAutomaticScheduling throws when file removal fails")
//    func disableAutomaticSchedulingThrowsWhenFileRemovalFails() async {
//        struct TestError: Error {}
//        fileSystemProviderSpy.fileExistsAtPathReturnValue = true
//        fileSystemProviderSpy.removeItemShouldThrow = TestError()
//        
//        await #expect(throws: TestError.self) {
//            try await sut.disableAutomaticScheduling()
//        }
//    }
//    
//    // MARK: - Helper Methods
//    
//    private func createDate(hour: Int, minute: Int = 0) -> Date {
//        var calendar = Calendar.current
//        calendar.timeZone = TimeZone.current
//        var components = DateComponents()
//        components.hour = hour
//        components.minute = minute
//        return calendar.date(from: components) ?? Date()
//    }
//    
//    private func createExpectedPlistContent(scriptPath: String) -> String {
//        return """
//        <?xml version="1.0" encoding="UTF-8"?>
//        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
//        <plist version="1.0">
//        <dict>
//            <key>Label</key>
//            <string>com.darkmodeswitch.scheduler</string>
//            <key>ProgramArguments</key>
//            <array>
//                <string>\(scriptPath)</string>
//            </array>
//            <key>StartInterval</key>
//            <integer>300</integer>
//            <key>RunAtLoad</key>
//            <false/>
//            <key>StandardOutPath</key>
//            <string>/tmp/darkmodeswitch.log</string>
//            <key>StandardErrorPath</key>
//            <string>/tmp/darkmodeswitch.log</string>
//        </dict>
//        </plist>
//        """
//    }
//}
