import Foundation
import SwiftData

@Model
final class BaitEntity {
    @Attribute(.unique) var id: UUID
    var name: String
    var icon: String
    var details: String
    var category: String
    var effectiveness: Int
    var ingredients: [String]
    var steps: [String]

    init(id: UUID = UUID(),
         name: String,
         icon: String,
         details: String,
         category: String,
         effectiveness: Int,
         ingredients: [String],
         steps: [String]) {
        self.id = id
        self.name = name
        self.icon = icon
        self.details = details
        self.category = category
        self.effectiveness = effectiveness
        self.ingredients = ingredients
        self.steps = steps
    }
}
