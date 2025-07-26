import Foundation
import Combine
import SwiftData

@MainActor
final class ProgressViewModel: ObservableObject {
    @Published var completedPracticeIds: Set<UUID> = []
    private let context: ModelContext
    private var progress: UserProgressEntity?

    init(container: ModelContainer = PersistenceController.shared) {
        self.context = ModelContext(container)
        load()
    }

    func load() {
        let descriptor = FetchDescriptor<UserProgressEntity>()
        if let progress = try? context.fetch(descriptor).first {
            self.progress = progress
            completedPracticeIds = Set(progress.completedPracticeIds)
        } else {
            let new = UserProgressEntity()
            context.insert(new)
            self.progress = new
            try? context.save()
        }
    }

    func togglePractice(id: UUID) {
        if completedPracticeIds.contains(id) {
            completedPracticeIds.remove(id)
        } else {
            completedPracticeIds.insert(id)
        }
        save()
    }

    func save() {
        progress?.completedPracticeIds = Array(completedPracticeIds)
        try? context.save()
    }
}
