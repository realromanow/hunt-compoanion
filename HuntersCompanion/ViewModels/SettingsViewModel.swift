import Foundation
import Combine
import SwiftData

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var currentLanguage: AppLanguage = .en
    @Published var selectedTheme: AppTheme = .nature
    @Published var largeTextEnabled: Bool = false
    @Published var highContrastEnabled: Bool = false
    @Published var hasSeenOnboarding: Bool = false

    private let context: ModelContext
    private var settings: SettingsEntity?

    init(container: ModelContainer = PersistenceController.shared) {
        self.context = ModelContext(container)
        load()
    }

    func load() {
        let descriptor = FetchDescriptor<SettingsEntity>()
        if let entity = try? context.fetch(descriptor).first {
            settings = entity
            currentLanguage = AppLanguage(rawValue: entity.language) ?? .en
            selectedTheme = AppTheme(rawValue: entity.theme) ?? .nature
            largeTextEnabled = entity.largeText
            highContrastEnabled = entity.highContrast
            hasSeenOnboarding = entity.hasSeenOnboarding
        } else {
            let entity = SettingsEntity()
            context.insert(entity)
            settings = entity
            try? context.save()
        }
    }

    func save() {
        settings?.language = currentLanguage.rawValue
        settings?.theme = selectedTheme.rawValue
        settings?.largeText = largeTextEnabled
        settings?.highContrast = highContrastEnabled
        settings?.hasSeenOnboarding = hasSeenOnboarding
        try? context.save()
    }
}
