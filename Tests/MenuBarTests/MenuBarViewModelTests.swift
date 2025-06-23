import Testing
@testable import App

@MainActor
@Suite("Menu Bar View Model Tests")
struct MenuBarViewModelTests {
    let darkModeServiceSpy = DarkModeServiceSpy()
    lazy var sut: MenuBarViewModel = MenuBarViewModel(
        darkModeViewModel: DarkModeViewModel(darkModeService: darkModeServiceSpy)
    )
}
