import Foundation

struct DefaultFileSystemProvider: FileSystemProvider {
    var homeDirectoryForCurrentUser: URL {
        FileManager.default.homeDirectoryForCurrentUser
    }
    
    func fileExists(atPath path: String) -> Bool {
        FileManager.default.fileExists(atPath: path)
    }
    
    func fileExists(atPath path: String, isDirectory: inout ObjCBool) -> Bool {
        FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
    }
    
    func createDirectory(at url: URL, withIntermediateDirectories: Bool) throws {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: withIntermediateDirectories)
    }
    
    func writeData(_ data: Data, to url: URL, options: Data.WritingOptions) throws {
        try data.write(to: url, options: options)
    }
    
    func setAttributes(_ attributes: [FileAttributeKey: Any], ofItemAtPath path: String) throws {
        try FileManager.default.setAttributes(attributes, ofItemAtPath: path)
    }
    
    func removeItem(at url: URL) throws {
        try FileManager.default.removeItem(at: url)
    }
    
    func bundlePath(forResource name: String?, ofType ext: String?) -> String? {
        Bundle.main.path(forResource: name, ofType: ext)
    }
}