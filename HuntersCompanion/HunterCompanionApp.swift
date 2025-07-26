// HunterCompanionApp.swift
import SwiftUI
import SwiftData

@main
struct HunterCompanionApp: App {
    @StateObject private var settingsManager = SettingsManager()
    @StateObject private var animalsVM = AnimalsViewModel()
    @StateObject private var baitsVM = BaitsViewModel()
    @StateObject private var progressVM = ProgressViewModel()
    @StateObject private var locationsVM = LocationsViewModel()
    @StateObject private var achievementsVM = AchievementsViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settingsManager)
                .environmentObject(animalsVM)
                .environmentObject(baitsVM)
                .environmentObject(progressVM)
                .environmentObject(locationsVM)
                .environmentObject(achievementsVM)
                .environment(\.locale, .init(identifier: settingsManager.currentLanguage.rawValue))
                .modelContainer(PersistenceController.shared)
        }
    }
}

// MARK: - Settings Manager
class SettingsManager: ObservableObject {
    @Published var currentLanguage: AppLanguage = .en
    @Published var selectedTheme: AppTheme = .nature
    @Published var largeTextEnabled: Bool = false
    @Published var highContrastEnabled: Bool = false
    @Published var hasSeenOnboarding: Bool = false

    private let context = ModelContext(PersistenceController.shared)
    private var entity: SettingsEntity?
    
    init() {
        loadSettings()
    }
    
    private func loadSettings() {
        let descriptor = FetchDescriptor<SettingsEntity>()
        if let item = try? context.fetch(descriptor).first {
            entity = item
            currentLanguage = AppLanguage(rawValue: item.language) ?? .en
            selectedTheme = AppTheme(rawValue: item.theme) ?? .nature
            largeTextEnabled = item.largeText
            highContrastEnabled = item.highContrast
            hasSeenOnboarding = item.hasSeenOnboarding
        } else {
            let item = SettingsEntity()
            context.insert(item)
            entity = item
            try? context.save()
        }
    }
    
    func saveSettings() {
        entity?.language = currentLanguage.rawValue
        entity?.theme = selectedTheme.rawValue
        entity?.largeText = largeTextEnabled
        entity?.highContrast = highContrastEnabled
        entity?.hasSeenOnboarding = hasSeenOnboarding
        try? context.save()
    }
}

enum AppLanguage: String, CaseIterable {
    case en
    case es

    var localizedName: LocalizedStringKey {
        switch self {
        case .en: return "language_en"
        case .es: return "language_es"
        }
    }
}

// MARK: - App Theme
enum AppTheme: String, CaseIterable {
    case nature = "nature"
    case autumn = "autumn"
    case winter = "winter"
    
    var primaryColor: Color {
        switch self {
        case .nature: return Color(.systemGreen)
        case .autumn: return Color(.systemOrange)
        case .winter: return Color(.systemBlue)
        }
    }
    
    var backgroundGradient: LinearGradient {
        switch self {
        case .nature:
            return LinearGradient(
                colors: [Color(.systemGreen).opacity(0.1), Color(.systemMint).opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .autumn:
            return LinearGradient(
                colors: [Color(.systemOrange).opacity(0.1), Color(.systemYellow).opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .winter:
            return LinearGradient(
                colors: [Color(.systemBlue).opacity(0.1), Color(.systemCyan).opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    var localizedName: LocalizedStringKey {
        switch self {
        case .nature: return "theme_nature"
        case .autumn: return "theme_autumn"
        case .winter: return "theme_winter"
        }
    }
}
