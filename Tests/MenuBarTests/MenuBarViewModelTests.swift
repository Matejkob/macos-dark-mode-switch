import Testing
@testable import App

@MainActor
@Suite("Menu Bar View Model Tests")
final class MenuBarViewModelTests {
    let darkModeServiceSpy = DarkModeServiceSpy()
    let darkModeViewModel: DarkModeViewModel
    var settingsOpenerCalled = false
    var terminateAppCalled = false
    var sut: MenuBarViewModel
    
    init() {
        darkModeServiceSpy.getCurrentModeReturnValue = .light
        darkModeViewModel = DarkModeViewModel(darkModeService: darkModeServiceSpy)
        sut = MenuBarViewModel(
            darkModeViewModel: darkModeViewModel,
            settingsOpener: {},
            terminateApp: {}
        )
        sut = MenuBarViewModel(
            darkModeViewModel: darkModeViewModel,
            settingsOpener: { @MainActor in self.settingsOpenerCalled = true },
            terminateApp: { self.terminateAppCalled = true }
        )
    }
    
    @Test("currentMode returns mode from darkModeViewModel")
    func currentModeReturnsValueFromDarkModeViewModel() {
        #expect(sut.currentMode == .light)
        #expect(sut.currentMode == darkModeViewModel.currentMode)
    }
    
    @Test("isDarkMode returns true when currentMode is dark")
    func isDarkModeReturnsTrueWhenCurrentModeIsDark() async {
        darkModeServiceSpy.getCurrentModeReturnValue = .dark
        await sut.onAppear()
        
        #expect(sut.isDarkMode == true)
        #expect(sut.currentMode == .dark)
    }
    
    @Test("isDarkMode returns false when currentMode is light")
    func isDarkModeReturnsFalseWhenCurrentModeIsLight() async {
        darkModeServiceSpy.getCurrentModeReturnValue = .light
        await sut.onAppear()
        
        #expect(sut.isDarkMode == false)
        #expect(sut.currentMode == .light)
    }
    
    @Test("onAppear delegates to darkModeViewModel")
    func onAppearDelegatesToDarkModeViewModel() async {
        darkModeServiceSpy.getCurrentModeReturnValue = .dark
        
        await sut.onAppear()
        
        #expect(darkModeServiceSpy.getCurrentModeCalledCount == 1)
        #expect(sut.currentMode == .dark)
    }
    
    @Test("toggleMode delegates to darkModeViewModel")
    func toggleModeDelegatesToDarkModeViewModel() async {
        darkModeServiceSpy.toggleModeShouldThrow = nil
        darkModeServiceSpy.getCurrentModeReturnValue = .dark
        
        await sut.toggleMode()
        
        #expect(darkModeServiceSpy.toggleModeCalledCount == 1)
        #expect(darkModeServiceSpy.getCurrentModeCalledCount == 1)
    }
    
    @Test("toggleMode silently handles errors from darkModeViewModel")
    func toggleModeSilentlyHandlesErrors() async {
        struct TestError: Error {}
        darkModeServiceSpy.toggleModeShouldThrow = TestError()
        
        await sut.toggleMode()
        
        #expect(darkModeServiceSpy.toggleModeCalledCount == 1)
    }
    
    @Test("openSettings calls settingsOpener closure")
    func openSettingsCallsSettingsOpener() {
        settingsOpenerCalled = false
        
        sut.openSettings()
        
        #expect(settingsOpenerCalled == true)
    }
    
    @Test("quitApp calls terminateApp closure")
    func quitAppCallsTerminateApp() {
        terminateAppCalled = false
        
        sut.quitApp()
        
        #expect(terminateAppCalled == true)
    }
    
    @Test("default settingsOpener and terminateApp are injected correctly")
    func defaultInjectionsWork() {
        let defaultSut = MenuBarViewModel(darkModeViewModel: darkModeViewModel)
        
        #expect(defaultSut.currentMode == darkModeViewModel.currentMode)
    }
    
    @Test("currentMode updates after toggleMode")
    func currentModeUpdatesAfterToggleMode() async {
        darkModeServiceSpy.getCurrentModeReturnValue = .light
        await sut.onAppear()
        #expect(sut.currentMode == .light)
        
        darkModeServiceSpy.toggleModeShouldThrow = nil
        darkModeServiceSpy.getCurrentModeReturnValue = .dark
        await sut.toggleMode()
        
        #expect(sut.currentMode == .dark)
        #expect(darkModeServiceSpy.toggleModeCalledCount == 1)
    }
}
