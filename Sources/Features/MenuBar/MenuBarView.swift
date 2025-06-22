import SwiftUI

struct MenuBarView: View {
    private var viewModel: MenuBarViewModel
    
    init(viewModel: MenuBarViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Section("Current appearance mode:") {
                Label(
                    viewModel.isDarkMode ? "Dark Mode" : "Light Mode",
                    systemImage: viewModel.isDarkMode ? "moon.fill" : "sun.max.fill"
                )
            }
            
            Section {
                Button {
                    Task { await viewModel.toggleMode() }
                } label: {
                    Label("Toggle Appearance Mode", systemImage: "switch.2")
                }
                .keyboardShortcut("a", modifiers: [.command, .shift])
            }
    
            Section {
                Button {
                    viewModel.openSettings()
                } label: {
                    Label("Settings", systemImage: "gearshape")
                }
                .keyboardShortcut(",", modifiers: .command)
            }
            
            Section {
                Button("Quit") {
                    viewModel.quitApp()
                }
            }
        }
        .task { await viewModel.onAppear() }
    }
}
