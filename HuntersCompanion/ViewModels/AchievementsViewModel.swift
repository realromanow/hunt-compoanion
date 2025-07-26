import Foundation
import Combine
import SwiftData

@MainActor
final class AchievementsViewModel: ObservableObject {
    @Published private(set) var achievements: [AchievementEntity] = []
    private let context: ModelContext

    init(container: ModelContainer = PersistenceController.shared) {
        self.context = ModelContext(container)
        fetch()
    }

    func fetch() {
        let descriptor = FetchDescriptor<AchievementEntity>()
        if let result = try? context.fetch(descriptor) {
            achievements = result
        }
    }

    func unlock(_ achievement: AchievementEntity) {
        achievement.unlocked = true
        try? context.save()
        fetch()
    }
}
