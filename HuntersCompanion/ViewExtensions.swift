import SwiftUI

extension View {
    @ViewBuilder
    func accessibilityContrastCompat(_ contrast: AccessibilityContrast) -> some View {
        if #available(iOS 15.0, *) {
            self.accessibilityContrast(contrast)
        } else {
            self.environment(\.accessibilityContrast, contrast)
        }
    }
}
