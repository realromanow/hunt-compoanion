import Foundation
import SwiftData

@Model
final class AchievementEntity {
    @Attribute(.unique) var id: UUID
    var title: String
    var details: String
    var unlocked: Bool

    init(id: UUID = UUID(), title: String, details: String, unlocked: Bool = false) {
        self.id = id
        self.title = title
        self.details = details
        self.unlocked = unlocked
    }
}
