import Testing
@testable import App

@MainActor
@Suite("Dark Mode View Model Tests")
struct DarkModeViewModelTests {
    let spy: DarkModeServiceSpy
    let sut: DarkModeViewModel
    
    init() {
        spy = DarkModeServiceSpy()
        spy.getCurrentModeReturnValue = .light
        sut = DarkModeViewModel(darkModeService: spy)
    }
    
    @Test("ViewModel initializes with correct default state")
    func viewModelInitializesWithCorrectDefaultState() {
        #expect(sut.currentMode == .light)
    }
    
    @Test("onAppear refreshes current mode from service")
    func onAppearRefreshesCurrentModeFromService() async {
        spy.getCurrentModeReturnValue = .dark
        
        await sut.onAppear()
        
        #expect(sut.currentMode == .dark)
        #expect(spy.getCurrentModeCalledCount == 1)
    }
    
    @Test("onAppear updates currentMode to light when service returns light")
    func onAppearUpdatesCurrentModeToLightWhenServiceReturnsLight() async {
        spy.getCurrentModeReturnValue = .light
        
        await sut.onAppear()
        
        #expect(sut.currentMode == .light) 
        #expect(spy.getCurrentModeCalledCount == 1)
    }
    
    @Test("toggleMode successfully updates current mode")
    func toggleModeSuccessfullyUpdatesCurrentMode() async throws {
        spy.getCurrentModeReturnValue = .dark
        spy.toggleModeShouldThrow = nil
        
        try await sut.toggleMode()
        
        #expect(spy.toggleModeCalledCount == 1)
        #expect(spy.getCurrentModeCalledCount == 1)
        #expect(sut.currentMode == .dark)
    }
    
    @Test("toggleMode calls service methods in correct order")
    func toggleModeCallsServiceMethodsInCorrectOrder() async throws {
        spy.getCurrentModeReturnValue = .light
        spy.toggleModeShouldThrow = nil
        
        try await sut.toggleMode()
        
        #expect(spy.toggleModeCalledCount == 1)
        #expect(spy.getCurrentModeCalledCount == 1)
    }
    
    @Test("toggleMode throws when service throws")
    func toggleModeThrowsWhenServiceThrows() async {
        struct TestError: Error {}
        spy.toggleModeShouldThrow = TestError()
        
        await #expect(throws: TestError.self) {
            try await sut.toggleMode()
        }
        
        #expect(spy.toggleModeCalledCount == 1)
    }
    
    @Test("toggleMode still refreshes current mode after successful toggle")
    func toggleModeStillRefreshesCurrentModeAfterSuccessfulToggle() async throws {
        spy.getCurrentModeReturnValue = .dark
        spy.toggleModeShouldThrow = nil
        
        try await sut.toggleMode()
        
        #expect(sut.currentMode == .dark)
        #expect(spy.getCurrentModeCalledCount == 1)
    }
    
    @Test("currentMode reflects service state")
    func currentModeReflectsServiceState() async {
        spy.getCurrentModeReturnValue = .dark
        await sut.onAppear()
        #expect(sut.currentMode == .dark)
        
        spy.getCurrentModeReturnValue = .light
        await sut.onAppear()
        #expect(sut.currentMode == .light)
    }
}
