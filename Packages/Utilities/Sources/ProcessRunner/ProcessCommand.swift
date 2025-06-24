public struct ProcessCommand {
    public typealias Argument = String
    public var arguments: [Argument]
    
    public init(arguments: [Argument]) {
        self.arguments = arguments
    }
}
