import Testing
import Foundation
@testable import App

@Suite("Default File System Provider Tests")
struct DefaultFileSystemProviderTests {
    private var sut: DefaultFileSystemProvider = DefaultFileSystemProvider()
    
    private func createTestDirectory() -> URL {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent("DarkModeSwitchTests-\(UUID().uuidString)")
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }
    
    private func cleanupDirectory(_ directory: URL) {
        try? FileManager.default.removeItem(at: directory)
    }
    
    @Test("Writes data to file successfully")
    func writesDataToFile() throws {
        let testDirectory = createTestDirectory()
        defer { cleanupDirectory(testDirectory) }
        
        let fileURL = testDirectory.appendingPathComponent("test.txt")
        let testData = "Hello, World!".data(using: .utf8)!
        
        try sut.writeData(testData, to: fileURL, options: .atomic)
        
        #expect(FileManager.default.fileExists(atPath: fileURL.path))
        let readData = try Data(contentsOf: fileURL)
        #expect(readData == testData)
    }
    
    @Test("Creates directory successfully")
    func createsDirectory() throws {
        let testDirectory = createTestDirectory()
        defer { cleanupDirectory(testDirectory) }
        
        let directoryURL = testDirectory.appendingPathComponent("subdirectory")
        
        try sut.createDirectory(at: directoryURL, withIntermediateDirectories: false)
        
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: directoryURL.path, isDirectory: &isDirectory)
        #expect(exists)
        #expect(isDirectory.boolValue)
    }
    
    @Test("Creates directory with intermediate directories")
    func createsDirectoryWithIntermediateDirectories() throws {
        let testDirectory = createTestDirectory()
        defer { cleanupDirectory(testDirectory) }
        
        let deepDirectory = testDirectory
            .appendingPathComponent("level1")
            .appendingPathComponent("level2")
            .appendingPathComponent("level3")
        
        try sut.createDirectory(at: deepDirectory, withIntermediateDirectories: true)
        
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: deepDirectory.path, isDirectory: &isDirectory)
        #expect(exists)
        #expect(isDirectory.boolValue)
    }
    
    @Test("Removes file successfully")
    func removesFile() throws {
        let testDirectory = createTestDirectory()
        defer { cleanupDirectory(testDirectory) }
        
        let fileURL = testDirectory.appendingPathComponent("to-remove.txt")
        try "Test content".data(using: .utf8)?.write(to: fileURL)
        
        #expect(FileManager.default.fileExists(atPath: fileURL.path))
        
        try sut.removeItem(at: fileURL)
        
        #expect(!FileManager.default.fileExists(atPath: fileURL.path))
    }
    
    @Test("Removes directory successfully")
    func removesDirectory() throws {
        let testDirectory = createTestDirectory()
        defer { cleanupDirectory(testDirectory) }
        
        let directoryURL = testDirectory.appendingPathComponent("to-remove-dir")
        try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        
        #expect(FileManager.default.fileExists(atPath: directoryURL.path))
        
        try sut.removeItem(at: directoryURL)
        
        #expect(!FileManager.default.fileExists(atPath: directoryURL.path))
    }
    
    @Test("Checks file existence correctly")
    func checksFileExistence() throws {
        let testDirectory = createTestDirectory()
        defer { cleanupDirectory(testDirectory) }
        
        let existingFile = testDirectory.appendingPathComponent("existing.txt")
        let nonExistingFile = testDirectory.appendingPathComponent("non-existing.txt")
        
        try "Content".data(using: .utf8)?.write(to: existingFile)
        
        #expect(sut.fileExists(atPath: existingFile.path))
        #expect(!sut.fileExists(atPath: nonExistingFile.path))
    }
    
    @Test("Checks directory existence correctly")
    func checksDirectoryExistence() throws {
        let testDirectory = createTestDirectory()
        defer { cleanupDirectory(testDirectory) }
        
        let subdirectory = testDirectory.appendingPathComponent("subdir")
        try FileManager.default.createDirectory(at: subdirectory, withIntermediateDirectories: true)
        
        var isDirectory: ObjCBool = false
        #expect(sut.fileExists(atPath: subdirectory.path, isDirectory: &isDirectory))
        #expect(isDirectory.boolValue)
        
        var isFile: ObjCBool = false
        let file = testDirectory.appendingPathComponent("file.txt")
        try "Content".data(using: .utf8)?.write(to: file)
        #expect(sut.fileExists(atPath: file.path, isDirectory: &isFile))
        #expect(!isFile.boolValue)
    }
    
    @Test("Sets file attributes successfully")
    func setsFileAttributes() throws {
        let testDirectory = createTestDirectory()
        defer { cleanupDirectory(testDirectory) }
        
        let fileURL = testDirectory.appendingPathComponent("test.txt")
        try "Content".data(using: .utf8)?.write(to: fileURL)
        
        let attributes: [FileAttributeKey: Any] = [
            .posixPermissions: 0o644
        ]
        
        try sut.setAttributes(attributes, ofItemAtPath: fileURL.path)
        
        let fileAttributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
        #expect(fileAttributes[.posixPermissions] as? Int == 0o644)
    }
    
    @Test("Returns home directory URL")
    func returnsHomeDirectory() throws {
        let homeDir = sut.homeDirectoryForCurrentUser
        
        #expect(homeDir.path.hasPrefix("/Users"))
        #expect(FileManager.default.fileExists(atPath: homeDir.path))
    }
    
    @Test("Returns nil for non-existent bundle resource")
    func returnsNilForNonExistentBundleResource() throws {
        let path = sut.bundlePath(forResource: "NonExistentResource", ofType: "txt")
        #expect(path == nil)
    }
    
    @Test("Throws error when removing non-existent item")
    func throwsErrorWhenRemovingNonExistentItem() throws {
        let testDirectory = createTestDirectory()
        defer { cleanupDirectory(testDirectory) }
        
        let nonExistentURL = testDirectory.appendingPathComponent("does-not-exist.txt")
        
        #expect(throws: (any Error).self) {
            try sut.removeItem(at: nonExistentURL)
        }
    }
}
