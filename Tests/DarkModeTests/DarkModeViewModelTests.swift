import Testing
@testable import DarkModeSwitch

@Suite("Dark Mode View Model Tests")
struct DarkModeViewModelTests {
    private var sut: DarkModeViewModel = DarkModeViewModel(darkModeService: DarkModeService())
    private var mockService: MockDarkModeService = MockDarkModeService()
}

private class MockDarkModeService: DarkModeServiceProtocol {
    // TODO: Implement mock
}