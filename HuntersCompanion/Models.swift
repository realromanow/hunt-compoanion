// Models.swift (ИСПРАВЛЕННАЯ ВЕРСИЯ)
import SwiftUI

// MARK: - Animal Model
struct Animal: Identifiable, Hashable {
    let id = UUID()
    let name: String // Изменено с LocalizedStringKey на String
    let scientificName: String
    let icon: String
    let description: String // Изменено с LocalizedStringKey на String
    let habitat: String // Изменено с LocalizedStringKey на String
    let bestSeasons: [Season]
    let activityPattern: ActivityPattern
    let recommendedBaits: [String]
    let difficulty: DifficultyLevel
    let facts: [String] // Изменено с LocalizedStringKey на String
    
    // Equatable implementation
    static func == (lhs: Animal, rhs: Animal) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Hashable implementation
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static let mockAnimals: [Animal] = [
        Animal(
            name: "white_tailed_deer",
            scientificName: "Odocoileus virginianus",
            icon: "🦌",
            description: "white_tailed_deer_description",
            habitat: "deciduous_forests",
            bestSeasons: [.autumn, .early_winter],
            activityPattern: ActivityPattern(
                dawn: .high,
                morning: .medium,
                noon: .low,
                evening: .high
            ),
            recommendedBaits: ["Acorn Scent", "Apple Scent", "Corn Bait"],
            difficulty: .intermediate,
            facts: ["deer_fact_1", "deer_fact_2", "deer_fact_3"]
        ),
        Animal(
            name: "wild_boar",
            scientificName: "Sus scrofa",
            icon: "🐗",
            description: "wild_boar_description",
            habitat: "dense_forests",
            bestSeasons: [.autumn, .winter],
            activityPattern: ActivityPattern(
                dawn: .medium,
                morning: .low,
                noon: .low,
                evening: .high
            ),
            recommendedBaits: ["Corn Bait", "Root Scent", "Fruit Mix"],
            difficulty: .expert,
            facts: ["boar_fact_1", "boar_fact_2", "boar_fact_3"]
        ),
        Animal(
            name: "wild_turkey",
            scientificName: "Meleagris gallopavo",
            icon: "🦃",
            description: "wild_turkey_description",
            habitat: "open_woodlands",
            bestSeasons: [.spring, .autumn],
            activityPattern: ActivityPattern(
                dawn: .high,
                morning: .high,
                noon: .medium,
                evening: .low
            ),
            recommendedBaits: ["Seed Mix", "Berry Scent", "Insect Lure"],
            difficulty: .intermediate,
            facts: ["turkey_fact_1", "turkey_fact_2", "turkey_fact_3"]
        ),
        Animal(
            name: "black_bear",
            scientificName: "Ursus americanus",
            icon: "🐻",
            description: "black_bear_description",
            habitat: "mountain_forests",
            bestSeasons: [.late_summer, .autumn],
            activityPattern: ActivityPattern(
                dawn: .high,
                morning: .medium,
                noon: .low,
                evening: .high
            ),
            recommendedBaits: ["Honey Scent", "Fish Lure", "Berries Mix"],
            difficulty: .expert,
            facts: ["bear_fact_1", "bear_fact_2", "bear_fact_3"]
        )
    ]
}

// MARK: - Activity Pattern
struct ActivityPattern: Hashable {
    let dawn: ActivityLevel
    let morning: ActivityLevel
    let noon: ActivityLevel
    let evening: ActivityLevel
    
    var allPeriods: [(String, ActivityLevel)] {
        [
            ("dawn", dawn),
            ("morning", morning),
            ("noon", noon),
            ("evening", evening)
        ]
    }
}

enum ActivityLevel: String, CaseIterable, Hashable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    
    var color: Color {
        switch self {
        case .low: return .gray
        case .medium: return .yellow
        case .high: return .green
        }
    }
    
    var opacity: Double {
        switch self {
        case .low: return 0.3
        case .medium: return 0.6
        case .high: return 1.0
        }
    }
    
    var localizedName: LocalizedStringKey {
        switch self {
        case .low: return "activity_low"
        case .medium: return "activity_medium"
        case .high: return "activity_high"
        }
    }
}

enum Season: String, CaseIterable, Hashable {
    case spring = "spring"
    case summer = "summer"
    case autumn = "autumn"
    case winter = "winter"
    case early_winter = "early_winter"
    case late_summer = "late_summer"
    
    var localizedName: LocalizedStringKey {
        switch self {
        case .spring: return "season_spring"
        case .summer: return "season_summer"
        case .autumn: return "season_autumn"
        case .winter: return "season_winter"
        case .early_winter: return "season_early_winter"
        case .late_summer: return "season_late_summer"
        }
    }
    
    var color: Color {
        switch self {
        case .spring: return .green
        case .summer: return .yellow
        case .autumn: return .orange
        case .winter, .early_winter: return .blue
        case .late_summer: return .red
        }
    }
}

enum DifficultyLevel: String, CaseIterable, Hashable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case expert = "expert"
    
    var localizedName: LocalizedStringKey {
        switch self {
        case .beginner: return "difficulty_beginner"
        case .intermediate: return "difficulty_intermediate"
        case .expert: return "difficulty_expert"
        }
    }
    
    var color: Color {
        switch self {
        case .beginner: return .green
        case .intermediate: return .yellow
        case .expert: return .red
        }
    }
    
    var stars: Int {
        switch self {
        case .beginner: return 1
        case .intermediate: return 2
        case .expert: return 3
        }
    }
}

// MARK: - Practice Model
struct HuntingPractice: Identifiable {
    let id = UUID()
    let name: String // Изменено с LocalizedStringKey на String
    let description: String // Изменено с LocalizedStringKey на String
    let icon: String
    let category: PracticeCategory
    let duration: TimeInterval // in seconds
    let difficulty: DifficultyLevel
    let instructions: [String] // Изменено с LocalizedStringKey на String
    let tips: [String] // Изменено с LocalizedStringKey на String
    
    static let allPractices: [HuntingPractice] = [
        HuntingPractice(
            name: "practice_breathing",
            description: "practice_breathing_desc",
            icon: "🫁",
            category: .stealth,
            duration: 180, // 3 minutes
            difficulty: .beginner,
            instructions: ["breathing_instruction_1", "breathing_instruction_2", "breathing_instruction_3"],
            tips: ["breathing_tip_1", "breathing_tip_2"]
        ),
        HuntingPractice(
            name: "practice_silent_walking",
            description: "practice_silent_walking_desc",
            icon: "👣",
            category: .stealth,
            duration: 300, // 5 minutes
            difficulty: .beginner,
            instructions: ["walking_instruction_1", "walking_instruction_2", "walking_instruction_3"],
            tips: ["walking_tip_1", "walking_tip_2"]
        ),
        HuntingPractice(
            name: "practice_tracking",
            description: "practice_tracking_desc",
            icon: "🔍",
            category: .tracking,
            duration: 480, // 8 minutes
            difficulty: .intermediate,
            instructions: ["tracking_instruction_1", "tracking_instruction_2", "tracking_instruction_3"],
            tips: ["tracking_tip_1", "tracking_tip_2"]
        ),
        HuntingPractice(
            name: "practice_patience",
            description: "practice_patience_desc",
            icon: "⏳",
            category: .mental,
            duration: 600, // 10 minutes
            difficulty: .expert,
            instructions: ["patience_instruction_1", "patience_instruction_2", "patience_instruction_3"],
            tips: ["patience_tip_1", "patience_tip_2"]
        ),
        HuntingPractice(
            name: "practice_equipment_check",
            description: "practice_equipment_check_desc",
            icon: "🎯",
            category: .equipment,
            duration: 360, // 6 minutes
            difficulty: .beginner,
            instructions: ["equipment_instruction_1", "equipment_instruction_2", "equipment_instruction_3"],
            tips: ["equipment_tip_1", "equipment_tip_2"]
        )
    ]
}

enum PracticeCategory: String, CaseIterable {
    case stealth = "stealth"
    case tracking = "tracking"
    case shooting = "shooting"
    case environment = "environment"
    case equipment = "equipment"
    case mental = "mental"
    
    var localizedName: LocalizedStringKey {
        switch self {
        case .stealth: return "category_stealth"
        case .tracking: return "category_tracking"
        case .shooting: return "category_shooting"
        case .environment: return "category_environment"
        case .equipment: return "category_equipment"
        case .mental: return "category_mental"
        }
    }
    
    var color: Color {
        switch self {
        case .stealth: return .purple
        case .tracking: return .brown
        case .shooting: return .red
        case .environment: return .green
        case .equipment: return .blue
        case .mental: return .orange
        }
    }
}

// MARK: - Bait Model (Simplified)
struct Bait: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let description: String
    let category: BaitCategory
    let effectiveness: Int // 1-4 stars
    
    static let allBaits: [Bait] = [
        Bait(name: "Acorn Scent", icon: "🌰", description: "Natural deer attractant", category: .scent, effectiveness: 4),
        Bait(name: "Apple Scent", icon: "🍎", description: "Sweet fruit scent", category: .scent, effectiveness: 3),
        Bait(name: "Corn Bait", icon: "🌽", description: "High-energy food bait", category: .food, effectiveness: 4),
        Bait(name: "Honey Scent", icon: "🍯", description: "Sweet honey scent", category: .scent, effectiveness: 4),
        Bait(name: "Berries Mix", icon: "🫐", description: "Fresh berry mix", category: .food, effectiveness: 3)
    ]
}

enum BaitCategory: String, CaseIterable {
    case scent = "scent"
    case food = "food"
    case protein = "protein"
    
    var localizedName: LocalizedStringKey {
        switch self {
        case .scent: return "category_scent"
        case .food: return "category_food"
        case .protein: return "category_protein"
        }
    }
    
    var color: Color {
        switch self {
        case .scent: return .purple
        case .food: return .green
        case .protein: return .orange
        }
    }
}
