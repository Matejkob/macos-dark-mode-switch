import Foundation
import SwiftUI

@MainActor
@Observable
final class SchedulingViewModel {
    
        
        private let schedulingService: SchedulingServiceProtocol
    
        init(schedulingService: SchedulingServiceProtocol) {
        self.schedulingService = schedulingService
        // TODO: Setup initial state
    }
    
        
    // TODO: Implement view model methods
}
