import Testing
@testable import App

@Suite("Menu Bar View Model Tests")
@MainActor
struct MenuBarViewModelTests {
    private var sut: MenuBarViewModel = MenuBarViewModel(
        darkModeViewModel: DarkModeViewModel(darkModeService: DarkModeService())
    )
}
