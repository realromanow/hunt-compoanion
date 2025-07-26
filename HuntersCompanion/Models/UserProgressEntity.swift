import Foundation
import SwiftData

@Model
final class UserProgressEntity {
    @Attribute(.unique) var id: UUID
    var completedPracticeIds: [UUID]

    init(id: UUID = UUID(), completedPracticeIds: [UUID] = []) {
        self.id = id
        self.completedPracticeIds = completedPracticeIds
    }
}
