import Foundation

struct SchedulingService: SchedulingServiceProtocol {
    private let preferencesRepository: any PreferencesRepository
    private let fileSystemProvider: any FileSystemProvider
    
    init(
        preferencesRepository: any PreferencesRepository = UserDefaultsPreferencesRepository(),
        fileSystemProvider: any FileSystemProvider = DefaultFileSystemProvider()
    ) {
        self.preferencesRepository = preferencesRepository
        self.fileSystemProvider = fileSystemProvider
    }
    
    func enableAutomaticScheduling(darkModeTime: Date, lightModeTime: Date) async throws {
    
    }
    
    func disableAutomaticScheduling() async throws {
        
    }
    
    func updateSchedule(darkModeTime: Date, lightModeTime: Date) async throws {
        
    }
    
    func isSchedulingEnabled() -> Bool {
        true
    }
}
