import Foundation

protocol DarkModeServiceProtocol: Sendable {
    func getCurrentMode() async -> AppearanceMode
    func toggleMode() async throws
}
