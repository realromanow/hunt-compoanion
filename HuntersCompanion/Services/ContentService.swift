import Foundation
import SwiftData

struct AnimalRecord: Codable {
    let name: String
    let scientificName: String
    let icon: String
    let description: String
    let habitat: String
    let bestSeasons: [String]
    let recommendedBaits: [String]
    let difficulty: String
    let facts: [String]
}

final class ContentService {
    static func preloadAnimals(context: ModelContext) {
        let descriptor = FetchDescriptor<AnimalEntity>()
        let existing = (try? context.fetch(descriptor)) ?? []
        guard existing.isEmpty else { return }

        guard let url = Bundle.main.url(forResource: "animals", withExtension: "json") else {
            return
        }
        guard let data = try? Data(contentsOf: url) else { return }
        guard let records = try? JSONDecoder().decode([AnimalRecord].self, from: data) else { return }

        for record in records {
            let entity = AnimalEntity(
                name: record.name,
                scientificName: record.scientificName,
                icon: record.icon,
                details: record.description,
                habitat: record.habitat,
                bestSeasons: record.bestSeasons,
                recommendedBaits: record.recommendedBaits,
                difficulty: record.difficulty,
                facts: record.facts
            )
            context.insert(entity)
        }
        try? context.save()
    }
}
