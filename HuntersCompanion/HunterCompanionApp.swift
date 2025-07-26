// HunterCompanionApp.swift
import SwiftUI
import SwiftData

@main
struct HunterCompanionApp: App {
    @StateObject private var settingsManager = SettingsManager()
    let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainer(for: AnimalEntity.self)
            let context = ModelContext(modelContainer)
            ContentService.preloadAnimals(context: context)
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settingsManager)
                .environment(\.locale, .init(identifier: settingsManager.currentLanguage.rawValue))
                .modelContainer(modelContainer)
        }
    }
}

// MARK: - Settings Manager
class SettingsManager: ObservableObject {
    @Published var currentLanguage: AppLanguage = .en
    @Published var selectedTheme: AppTheme = .nature
    @Published var largeTextEnabled: Bool = false
    @Published var highContrastEnabled: Bool = false
    
    init() {
        loadSettings()
    }
    
    private func loadSettings() {
        if let langRaw = UserDefaults.standard.string(forKey: "app_language"),
           let lang = AppLanguage(rawValue: langRaw) {
            currentLanguage = lang
        } else {
            currentLanguage = .en
        }
        if let themeRaw = UserDefaults.standard.string(forKey: "app_theme"),
           let theme = AppTheme(rawValue: themeRaw) {
            selectedTheme = theme
        }
        largeTextEnabled = UserDefaults.standard.bool(forKey: "large_text")
        highContrastEnabled = UserDefaults.standard.bool(forKey: "high_contrast")
    }
    
    func saveSettings() {
        UserDefaults.standard.set(currentLanguage.rawValue, forKey: "app_language")
        UserDefaults.standard.set(selectedTheme.rawValue, forKey: "app_theme")
        UserDefaults.standard.set(largeTextEnabled, forKey: "large_text")
        UserDefaults.standard.set(highContrastEnabled, forKey: "high_contrast")
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
