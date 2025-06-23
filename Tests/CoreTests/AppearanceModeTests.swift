import Testing
import Foundation
@testable import App

@Suite("Appearance Mode Tests")
struct AppearanceModeTests {
    @Test("Raw values are correct")
    func rawValuesAreCorrect() {
        #expect(AppearanceMode.light.rawValue == "light")
        #expect(AppearanceMode.dark.rawValue == "dark")
        #expect(AppearanceMode.auto.rawValue == "auto")
    }
    
    @Test("Initializes from raw value")
    func initializesFromRawValue() {
        #expect(AppearanceMode(rawValue: "light") == .light)
        #expect(AppearanceMode(rawValue: "dark") == .dark)
        #expect(AppearanceMode(rawValue: "auto") == .auto)
    }
    
    @Test("Returns nil for invalid raw value")
    func returnsNilForInvalidRawValue() {
        #expect(AppearanceMode(rawValue: "invalid") == nil)
        #expect(AppearanceMode(rawValue: "") == nil)
        #expect(AppearanceMode(rawValue: "Light") == nil) // Case sensitive
        #expect(AppearanceMode(rawValue: "DARK") == nil) // Case sensitive
    }
    
    @Test("All cases are iterable")
    func allCasesAreIterable() {
        let allCases = AppearanceMode.allCases
        
        #expect(allCases.count == 3)
        #expect(allCases.contains(.light))
        #expect(allCases.contains(.dark))
        #expect(allCases.contains(.auto))
    }
    
    @Test("All cases maintain order")
    func allCasesMaintainOrder() {
        let allCases = AppearanceMode.allCases
        
        #expect(allCases[0] == .light)
        #expect(allCases[1] == .dark)
        #expect(allCases[2] == .auto)
    }
    
    @Test("Conforms to CaseIterable")
    func conformsToCaseIterable() {
        // This test verifies the type conforms to CaseIterable
        let _: any CaseIterable.Type = AppearanceMode.self
        
        // Verify we can iterate
        var count = 0
        for _ in AppearanceMode.allCases {
            count += 1
        }
        #expect(count == 3)
    }
    
    @Test("Enum cases are equatable")
    func enumCasesAreEquatable() {
        #expect(AppearanceMode.light == AppearanceMode.light)
        #expect(AppearanceMode.dark == AppearanceMode.dark)
        #expect(AppearanceMode.auto == AppearanceMode.auto)
        
        #expect(AppearanceMode.light != AppearanceMode.dark)
        #expect(AppearanceMode.light != AppearanceMode.auto)
        #expect(AppearanceMode.dark != AppearanceMode.auto)
    }
    
    @Test("Raw value round trip")
    func rawValueRoundTrip() {
        for mode in AppearanceMode.allCases {
            let rawValue = mode.rawValue
            let reconstructed = AppearanceMode(rawValue: rawValue)
            #expect(reconstructed == mode)
        }
    }
}
