import Foundation
import Combine
import SwiftData

@MainActor
final class BaitsViewModel: ObservableObject {
    @Published private(set) var baits: [Bait] = []
    private let context: ModelContext

    init(container: ModelContainer = PersistenceController.shared) {
        self.context = ModelContext(container)
        fetchBaits()
    }

    func fetchBaits() {
        let descriptor = FetchDescriptor<Bait>()
        if let result = try? context.fetch(descriptor) {
            baits = result
        }
    }
}
