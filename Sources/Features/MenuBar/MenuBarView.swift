import SwiftUI

struct MenuBarView: View {
    @State private var viewModel: MenuBarViewModel
    
        init(viewModel: MenuBarViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
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
            SettingsOpener.openSettings()
        }) {
            Label("Settings", systemImage: "gearshape")
        }
        .keyboardShortcut(",", modifiers: .command)
        
        Divider()
        
        // Quit button
        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }
    }
}
