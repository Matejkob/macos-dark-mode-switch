import Foundation
import SwiftUI

// MARK: - Scheduling View Model
@MainActor
@Observable
final class SchedulingViewModel {
    
    // MARK: - Published Properties
    
    // MARK: - Private Properties
    private let schedulingService: SchedulingServiceProtocol
    
    // MARK: - Initialization
    init(schedulingService: SchedulingServiceProtocol) {
        self.schedulingService = schedulingService
        // TODO: Setup initial state
    }
    
    // MARK: - Public Methods
    
    // TODO: Implement view model methods
}