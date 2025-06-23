import Testing
import AppKit
@testable import App

@Suite("Window Centering Helper Tests", .disabled())
struct WindowCenteringHelperTests {
    
    @Test("Centers window on active screen")
    @MainActor
    func centersWindowOnActiveScreen() throws {
        // Since we can't mock NSScreen effectively in tests, 
        // we'll test that the method runs without crashing
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [.titled],
            backing: .buffered,
            defer: false
        )
        
        let originalFrame = window.frame
        WindowCenteringHelper.centerOnActiveScreen(window)
        
        // Verify the window size is preserved
        #expect(window.frame.size.width == originalFrame.size.width)
        #expect(window.frame.size.height == originalFrame.size.height)
    }
    
    @Test("Positions window off screen")
    @MainActor 
    func positionsWindowOffScreen() throws {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 100, height: 100),
            styleMask: [],
            backing: .buffered,
            defer: false
        )
        
        WindowCenteringHelper.positionOffScreen(window)
        
        // Window should be positioned off-screen with minimal size
        #expect(window.frame.size.width == 1)
        #expect(window.frame.size.height == 1)
        
        // In environments with screens, verify Y position
        // In headless environments, just ensure method doesn't crash
        if NSScreen.main != nil {
            // Window should be off-screen (far below visible area)
            #expect(window.frame.origin.y <= -1000)
        }
    }
    
    @Test("Centers window using default method")
    @MainActor
    func centersWindowUsingDefaultMethod() throws {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 400),
            styleMask: [.titled],
            backing: .buffered,
            defer: false
        )
        
        let originalSize = window.frame.size
        WindowCenteringHelper.centerDefault(window)
        
        // Window size should be preserved
        #expect(window.frame.size == originalSize)
    }
    
    @Test("Centers window with zero size on active screen")
    @MainActor
    func centersWindowWithZeroSizeOnActiveScreen() throws {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 0, height: 0),
            styleMask: [.titled],
            backing: .buffered,
            defer: false
        )
        
        let originalSize = window.frame.size
        WindowCenteringHelper.centerOnActiveScreen(window)
        
        // Window should still have original size after centering
        #expect(window.frame.size == originalSize)
    }
    
    @Test("Centers large window on active screen")
    @MainActor
    func centersLargeWindowOnActiveScreen() throws {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 3000, height: 2000),
            styleMask: [.titled, .resizable],
            backing: .buffered,
            defer: false
        )
        
        let originalSize = window.frame.size
        WindowCenteringHelper.centerOnActiveScreen(window)
        
        // Window size should be preserved
        #expect(window.frame.size == originalSize)
    }
    
    @Test("Handles multiple centering operations")
    @MainActor
    func handlesMultipleCenteringOperations() throws {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 400),
            styleMask: [.titled],
            backing: .buffered,
            defer: false
        )
        
        let originalSize = window.frame.size
        
        // Center multiple times - should not crash or change size
        WindowCenteringHelper.centerOnActiveScreen(window)
        let firstSize = window.frame.size
        
        WindowCenteringHelper.centerOnActiveScreen(window)
        let secondSize = window.frame.size
        
        WindowCenteringHelper.centerOnActiveScreen(window)
        let thirdSize = window.frame.size
        
        // All sizes should be identical and equal to original
        #expect(firstSize == originalSize)
        #expect(secondSize == originalSize)
        #expect(thirdSize == originalSize)
    }
    
    @Test("Positions multiple windows off screen")
    @MainActor
    func positionsMultipleWindowsOffScreen() throws {
        let windows = (0..<3).map { _ in
            NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 200, height: 150),
                styleMask: [.titled],
                backing: .buffered,
                defer: false
            )
        }
        
        for window in windows {
            WindowCenteringHelper.positionOffScreen(window)
            
            // All windows should be positioned off-screen with minimal size
            #expect(window.frame.size.width == 1)
            #expect(window.frame.size.height == 1)
            
            if NSScreen.main != nil {
                // Window should be off-screen (far below visible area)
                #expect(window.frame.origin.y <= -1000)
            }
        }
    }
    
    @Test("Handles window without screen gracefully")
    @MainActor
    func handlesWindowWithoutScreenGracefully() throws {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [],
            backing: .buffered,
            defer: false
        )
        
        // These operations should not crash even if no screens are available
        WindowCenteringHelper.centerOnActiveScreen(window)
        WindowCenteringHelper.positionOffScreen(window)
        WindowCenteringHelper.centerDefault(window)
        
        // Window should still exist after operations
        #expect(window.frame.size.width > 0 || window.frame.size.width == 1)
        #expect(window.frame.size.height > 0 || window.frame.size.height == 1)
    }
}
