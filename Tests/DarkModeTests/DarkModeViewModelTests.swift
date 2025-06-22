import Testing
@testable import App

@MainActor
@Suite("Dark Mode View Model Tests")
struct DarkModeViewModelTests {
    let darkModeServiceSpy = DarkModeServiceSpy()
    lazy var sut = DarkModeViewModel(darkModeService: darkModeServiceSpy)
}
