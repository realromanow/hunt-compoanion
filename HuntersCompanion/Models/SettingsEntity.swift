import Foundation
import SwiftData

@Model
final class SettingsEntity {
    @Attribute(.unique) var id: UUID
    var language: String
    var theme: String
    var largeText: Bool
    var highContrast: Bool
    var hasSeenOnboarding: Bool

    init(id: UUID = UUID(), language: String = "en", theme: String = "nature", largeText: Bool = false, highContrast: Bool = false, hasSeenOnboarding: Bool = false) {
        self.id = id
        self.language = language
        self.theme = theme
        self.largeText = largeText
        self.highContrast = highContrast
        self.hasSeenOnboarding = hasSeenOnboarding
    }
}
