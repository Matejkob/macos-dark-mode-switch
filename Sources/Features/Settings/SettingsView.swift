import SwiftUI

// MARK: - Settings View
struct SettingsView: View {
    @State private var automaticSwitchingEnabled = true
    @State private var darkModeTime = Date()
    @State private var lightModeTime = Date()
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "gearshape.2.fill")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                
                Text("Dark Mode Settings")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .padding(.top)
            
            Divider()
            
            // Automatic switching toggle
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "clock.arrow.2.circlepath")
                        .foregroundColor(.green)
                    
                    Text("Automatic Switching")
                        .font(.headline)
                    
                    Spacer()
                    
                    Toggle("", isOn: $automaticSwitchingEnabled)
                }
                
                if automaticSwitchingEnabled {
                    Text("Enable automatic dark/light mode switching at custom times")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.leading, 24)
                }
            }
            
            if automaticSwitchingEnabled {
                Divider()
                
                // Time settings
                VStack(spacing: 16) {
                    // Dark mode time
                    HStack {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.purple)
                            .frame(width: 20)
                        
                        Text("Switch to Dark Mode:")
                            .font(.subheadline)
                        
                        Spacer()
                        
                        DatePicker("", selection: $darkModeTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    
                    // Light mode time
                    HStack {
                        Image(systemName: "sun.max.fill")
                            .foregroundColor(.orange)
                            .frame(width: 20)
                        
                        Text("Switch to Light Mode:")
                            .font(.subheadline)
                        
                        Spacer()
                        
                        DatePicker("", selection: $lightModeTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
                .padding(.horizontal, 8)
            }
            
            Spacer()
            
            Divider()
            
            // Action buttons
            HStack(spacing: 12) {
                Button("Cancel") {}
                    .buttonStyle(.bordered)
                
                Button("Save") {}
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(24)
        .frame(width: 400, height: automaticSwitchingEnabled ? 400 : 300)
    }
}