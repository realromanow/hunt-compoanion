import Foundation
import Combine
import SwiftData

@MainActor
final class AnimalsViewModel: ObservableObject {
    @Published private(set) var animals: [Animal] = []
    private let context: ModelContext

    init(container: ModelContainer = PersistenceController.shared) {
        self.context = ModelContext(container)
        fetchAnimals()
    }

    func fetchAnimals() {
        let descriptor = FetchDescriptor<Animal>()
        if let result = try? context.fetch(descriptor) {
            animals = result
        }
    }
}
