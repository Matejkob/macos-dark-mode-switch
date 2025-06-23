import SwiftUI

struct SettingsView: View {
    @State private var viewModel = SettingsViewModel(
        schedulingService: SchedulingService(),
        preferencesRepository: UserDefaultsPreferencesRepository()
    )
    
    var body: some View {
        Form {
            Section {
                Toggle("Automatic Switching", isOn: $viewModel.automaticSwitchingEnabled)
                
                if viewModel.automaticSwitchingEnabled {
                    DatePicker("Switch to Dark Mode", 
                              selection: $viewModel.darkModeTime, 
                              displayedComponents: .hourAndMinute)
                    
                    DatePicker("Switch to Light Mode", 
                              selection: $viewModel.lightModeTime, 
                              displayedComponents: .hourAndMinute)
                }
            } header: {
                Text("Dark Mode Settings")
            } footer: {
                if viewModel.automaticSwitchingEnabled {
                    Text("Enable automatic dark/light mode switching at custom times")
                }
            }
            
            Section {
                HStack {
                    Button("Cancel") {
                        Task {
                            await viewModel.cancel()
                        }
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    Button("Save") {
                        Task {
                            try? await viewModel.save()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .formStyle(.grouped)
        .frame(maxWidth: 350, minHeight: 100)
        .task {
            await viewModel.onAppear()
        }
    }
}
