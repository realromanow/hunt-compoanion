import SwiftUI

extension View {
    func accessibilityContrastCompat(_ isHighContrast: Bool) -> some View {
        // Note: colorSchemeContrast is read-only per Apple's design
        // Apps cannot override user's accessibility choice
        // This modifier is kept for compatibility but does nothing
        self
    }
}
