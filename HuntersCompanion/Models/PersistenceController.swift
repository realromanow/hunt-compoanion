import Foundation
import SwiftData

enum PersistenceController {
    static let shared: ModelContainer = {
        let schema = Schema([
            AnimalEntity.self,
            BaitEntity.self,
            UserProgressEntity.self,
            LocationEntity.self,
            AchievementEntity.self,
            SettingsEntity.self
        ])
        let configuration = ModelConfiguration(schema: schema)
        return try! ModelContainer(for: schema, configurations: [configuration])
    }()
}
