import SwiftUI

// MARK: - Menu Bar View
struct MenuBarView: View {
    @State private var isDarkMode = false
    
    // MARK: - Body
    var body: some View {
        // Current mode status
        Text(isDarkMode ? "Dark Mode Active" : "Light Mode Active")
        
        Divider()
        
        // Toggle button
        Button(action: {}) {
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