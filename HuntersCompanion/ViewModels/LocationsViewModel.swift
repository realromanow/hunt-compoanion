import Foundation
import Combine
import SwiftData

@MainActor
final class LocationsViewModel: ObservableObject {
    @Published private(set) var locations: [LocationEntity] = []
    private let context: ModelContext

    init(container: ModelContainer = PersistenceController.shared) {
        self.context = ModelContext(container)
        fetch()
    }

    func fetch() {
        let descriptor = FetchDescriptor<LocationEntity>()
        if let result = try? context.fetch(descriptor) {
            locations = result
        }
    }

    func add(name: String, latitude: Double, longitude: Double) {
        let loc = LocationEntity(name: name, latitude: latitude, longitude: longitude)
        context.insert(loc)
        try? context.save()
        fetch()
    }
}
