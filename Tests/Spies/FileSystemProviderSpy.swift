import Foundation
@testable import App

final class FileSystemProviderSpy: FileSystemProvider, @unchecked Sendable {
    // MARK: - homeDirectoryForCurrentUser
    
    var homeDirectoryForCurrentUser: URL = URL(fileURLWithPath: "/mock/home")

    // MARK: - fileExists(atPath:)
    
    var fileExistsAtPathCalledCount = 0
    var fileExistsAtPathReceivedArguments: [String] = []
    var fileExistsAtPathReturnValue: Bool = false

    func fileExists(atPath path: String) -> Bool {
        fileExistsAtPathCalledCount += 1
        fileExistsAtPathReceivedArguments.append(path)
        return fileExistsAtPathReturnValue
    }

    // MARK: - fileExists(atPath:isDirectory:)
    
    var fileExistsWithDirectoryFlagCalledCount = 0
    var fileExistsWithDirectoryFlagReceivedArguments: [String] = []
    var fileExistsWithDirectoryFlagReturnValue: Bool = false
    var fileExistsWithDirectoryFlagIsDirectoryValue: ObjCBool = false

    func fileExists(atPath path: String, isDirectory: inout ObjCBool) -> Bool {
        fileExistsWithDirectoryFlagCalledCount += 1
        fileExistsWithDirectoryFlagReceivedArguments.append(path)
        isDirectory = fileExistsWithDirectoryFlagIsDirectoryValue
        return fileExistsWithDirectoryFlagReturnValue
    }

    // MARK: - createDirectory
    
    var createDirectoryCalledCount = 0
    var createDirectoryReceivedArguments: [(url: URL, withIntermediateDirectories: Bool)] = []
    var createDirectoryShouldThrow: (any Error)?

    func createDirectory(at url: URL, withIntermediateDirectories: Bool) throws {
        createDirectoryCalledCount += 1
        createDirectoryReceivedArguments.append((url, withIntermediateDirectories))
        if let error = createDirectoryShouldThrow {
            throw error
        }
    }

    // MARK: - writeData
    
    var writeDataCalledCount = 0
    var writeDataReceivedArguments: [(data: Data, url: URL, options: Data.WritingOptions)] = []
    var writeDataShouldThrow: (any Error)?

    func writeData(_ data: Data, to url: URL, options: Data.WritingOptions) throws {
        writeDataCalledCount += 1
        writeDataReceivedArguments.append((data, url, options))
        if let error = writeDataShouldThrow {
            throw error
        }
    }

    // MARK: - setAttributes
    
    var setAttributesCalledCount = 0
    var setAttributesReceivedArguments: [(attributes: [FileAttributeKey: Any], path: String)] = []
    var setAttributesShouldThrow: (any Error)?

    func setAttributes(_ attributes: [FileAttributeKey: Any], ofItemAtPath path: String) throws {
        setAttributesCalledCount += 1
        setAttributesReceivedArguments.append((attributes, path))
        if let error = setAttributesShouldThrow {
            throw error
        }
    }

    // MARK: - removeItem
    
    var removeItemCalledCount = 0
    var removeItemReceivedArguments: [URL] = []
    var removeItemShouldThrow: (any Error)?

    func removeItem(at url: URL) throws {
        removeItemCalledCount += 1
        removeItemReceivedArguments.append(url)
        if let error = removeItemShouldThrow {
            throw error
        }
    }

    // MARK: - bundlePath
    
    var bundlePathCalledCount = 0
    var bundlePathReceivedArguments: [(name: String?, ext: String?)] = []
    var bundlePathReturnValue: String?

    func bundlePath(forResource name: String?, ofType ext: String?) -> String? {
        bundlePathCalledCount += 1
        bundlePathReceivedArguments.append((name, ext))
        return bundlePathReturnValue
    }
}
