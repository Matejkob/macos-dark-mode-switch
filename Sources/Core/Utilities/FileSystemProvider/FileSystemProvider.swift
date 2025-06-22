import Foundation

protocol FileSystemProvider: Sendable {
    var homeDirectoryForCurrentUser: URL { get }
    
    func fileExists(atPath path: String) -> Bool
    func fileExists(atPath path: String, isDirectory: inout ObjCBool) -> Bool
    func createDirectory(at url: URL, withIntermediateDirectories: Bool) throws
    func writeData(_ data: Data, to url: URL, options: Data.WritingOptions) throws
    func setAttributes(_ attributes: [FileAttributeKey: Any], ofItemAtPath path: String) throws
    func removeItem(at url: URL) throws
    func bundlePath(forResource name: String?, ofType ext: String?) -> String?
}