import Foundation
import Utilities

let appearanceSwitcher = AppearanceSwitcher()

do {
    try await appearanceSwitcher.checkAndSwitchIfNeeded()
} catch {
    exit(1)
}

exit(0)
