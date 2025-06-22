import Foundation

struct LaunchAgentInfo {
    let agentLabel: String
    let scriptPath: String
    
    static let shared = LaunchAgentInfo(
        agentLabel: "com.darkmodeswitch.scheduler",
        scriptPath: Bundle.main.path(forResource: "set-appearance-mode", ofType: "sh") ?? ""
    )
}
