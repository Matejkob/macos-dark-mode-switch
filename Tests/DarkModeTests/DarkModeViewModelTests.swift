import Testing
@testable import App

@Suite("Dark Mode View Model Tests")
@MainActor
struct DarkModeViewModelTests {
    private var sut: DarkModeViewModel = DarkModeViewModel(darkModeService: DarkModeService())
    private var mockService: MockDarkModeService = MockDarkModeService()
}

private class MockDarkModeService: DarkModeServiceProtocol {
    // TODO: Implement mock
}
