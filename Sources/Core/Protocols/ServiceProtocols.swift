import Foundation


protocol DarkModeServiceProtocol {
    func getCurrentMode() -> AppearanceMode
    func setMode(_ mode: AppearanceMode)
    func toggleMode()
}

