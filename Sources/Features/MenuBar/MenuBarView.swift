import SwiftUI

// MARK: - Menu Bar View
struct MenuBarView: View {
    @State private var viewModel: MenuBarViewModel
    
    // MARK: - Initialization
    init(viewModel: MenuBarViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    // MARK: - Body
    var body: some View {
        // Current mode status
        Text(viewModel.isDarkMode ? "Dark Mode Active" : "Light Mode Active")
        
        Divider()
        
        // Toggle button
        Button(action: {
            viewModel.toggleMode()
        }) {
            Label("Toggle Mode", systemImage: "switch.2")
        }
        
        // Settings button
        Button(action: {
            NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        }) {
            Label("Settings", systemImage: "gearshape")
        }
        
        Divider()
        
        // Quit button
        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }
    }
}