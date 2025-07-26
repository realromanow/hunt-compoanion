import Foundation
import SwiftData

@Model
final class AnimalEntity {
    @Attribute(.unique) var id: UUID
    var name: String
    var scientificName: String
    var icon: String
    var details: String
    var habitat: String
    var bestSeasons: [String]
    var recommendedBaits: [String]
    var difficulty: String
    var facts: [String]

    init(id: UUID = UUID(),
         name: String,
         scientificName: String,
         icon: String,
         details: String,
         habitat: String,
         bestSeasons: [String],
         recommendedBaits: [String],
         difficulty: String,
         facts: [String]) {
        self.id = id
        self.name = name
        self.scientificName = scientificName
        self.icon = icon
        self.details = details
        self.habitat = habitat
        self.bestSeasons = bestSeasons
        self.recommendedBaits = recommendedBaits
        self.difficulty = difficulty
        self.facts = facts
    }
}
