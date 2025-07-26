// OtherViews.swift
import SwiftUI

// MARK: - Trails View
struct TrailsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @StateObject private var trailsManager = TrailsManager()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("hunter_trails")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(settingsManager.selectedTheme.primaryColor)
                            
                            Text("complete_practices")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("progress_label")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("\(trailsManager.completedPractices)/\(trailsManager.allPractices.count)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(settingsManager.selectedTheme.primaryColor)
                        }
                    }
                    
                    // Progress bar
                    ProgressView(value: trailsManager.progress)
                        .tint(settingsManager.selectedTheme.primaryColor)
                }
                .padding()
                
                // Trail practices
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(Array(trailsManager.allPractices.enumerated()), id: \.element.id) { index, practice in
                            TrailPointView(
                                practice: practice,
                                isUnlocked: trailsManager.isPracticeUnlocked(at: index),
                                isCompleted: trailsManager.isPracticeCompleted(practice),
                                position: index
                            ) {
                                trailsManager.completePractice(practice)
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(settingsManager.selectedTheme.backgroundGradient)
        }
    }
}

// MARK: - Trails Manager
class TrailsManager: ObservableObject {
    @Published var completedPracticeIds: Set<UUID> = []
    
    let allPractices: [HuntingPractice] = HuntingPractice.allPractices
    
    var completedPractices: Int {
        completedPracticeIds.count
    }
    
    var progress: Double {
        guard !allPractices.isEmpty else { return 0 }
        return Double(completedPractices) / Double(allPractices.count)
    }
    
    init() {
        loadProgress()
    }
    
    func isPracticeUnlocked(at index: Int) -> Bool {
        if index == 0 { return true }
        return completedPracticeIds.contains(allPractices[index - 1].id)
    }
    
    func isPracticeCompleted(_ practice: HuntingPractice) -> Bool {
        completedPracticeIds.contains(practice.id)
    }
    
    func completePractice(_ practice: HuntingPractice) {
        completedPracticeIds.insert(practice.id)
        saveProgress()
    }
    
    private func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: "completed_practices"),
           let ids = try? JSONDecoder().decode(Set<UUID>.self, from: data) {
            completedPracticeIds = ids
        }
    }
    
    private func saveProgress() {
        if let data = try? JSONEncoder().encode(completedPracticeIds) {
            UserDefaults.standard.set(data, forKey: "completed_practices")
        }
    }
}

// MARK: - Trail Point View
struct TrailPointView: View {
    let practice: HuntingPractice
    let isUnlocked: Bool
    let isCompleted: Bool
    let position: Int
    let onComplete: () -> Void
    
    @State private var showingDetail = false
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        HStack {
            if position % 2 == 0 {
                Spacer()
            }
            
            Button(action: {
                if isUnlocked {
                    showingDetail = true
                }
            }) {
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(circleColor)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 3)
                            )
                        
                        if isCompleted {
                            Image(systemName: "checkmark")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        } else if isUnlocked {
                            Text(practice.icon)
                                .font(.title)
                        } else {
                            Image(systemName: "lock.fill")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    VStack(spacing: 4) {
                    Text(LocalizedStringKey(practice.name))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(isUnlocked ? .primary : .gray)
                        .multilineTextAlignment(.center)
                        
                        if isUnlocked {
                            HStack(spacing: 2) {
                                ForEach(0..<3) { index in
                                    Image(systemName: index < practice.difficulty.stars ? "star.fill" : "star")
                                        .foregroundColor(practice.difficulty.color)
                                        .font(.caption2)
                                }
                            }
                        }
                    }
                }
                .frame(width: 120)
            }
            .disabled(!isUnlocked)
            .buttonStyle(PlainButtonStyle())
            
            if position % 2 == 1 {
                Spacer()
            }
        }
        .sheet(isPresented: $showingDetail) {
            PracticeDetailView(practice: practice, onComplete: onComplete)
        }
    }
    
    private var circleColor: Color {
        if isCompleted {
            return .green
        } else if isUnlocked {
            return settingsManager.selectedTheme.primaryColor
        } else {
            return .gray
        }
    }
}

// MARK: - Practice Detail View
struct PracticeDetailView: View {
    let practice: HuntingPractice
    let onComplete: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var timerRunning = false
    @State private var timeRemaining: TimeInterval
    @State private var timer: Timer?
    
    init(practice: HuntingPractice, onComplete: @escaping () -> Void) {
        self.practice = practice
        self.onComplete = onComplete
        self._timeRemaining = State(initialValue: practice.duration)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(spacing: 16) {
                        Text(practice.icon)
                            .font(.system(size: 80))
                        
                        Text(LocalizedStringKey(practice.name))
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text(LocalizedStringKey(practice.description))
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                    )
                    
                    // Timer
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                                .frame(width: 120, height: 120)
                            
                            Circle()
                                .trim(from: 0, to: 1 - (timeRemaining / practice.duration))
                                .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                .frame(width: 120, height: 120)
                                .rotationEffect(.degrees(-90))
                            
                            Text(formatTime(timeRemaining))
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        HStack(spacing: 20) {
                            Button(action: toggleTimer) {
                                Image(systemName: timerRunning ? "pause.fill" : "play.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50)
                                    .background(Circle().fill(.blue))
                            }
                            
                            Button(action: resetTimer) {
                                Image(systemName: "stop.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50)
                                    .background(Circle().fill(.red))
                            }
                            
                            if timeRemaining <= 0 {
                                Button(action: {
                                    onComplete()
                                    dismiss()
                                }) {
                                    Text("mark_completed")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 8).fill(.green))
                                }
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                    )
                    
                    // Instructions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("instructions_label")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        ForEach(Array(practice.instructions.enumerated()), id: \.offset) { index, instruction in
                            HStack(alignment: .top, spacing: 12) {
                                Text("\(index + 1)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                                    .background(Circle().fill(.blue))
                                
                                Text(LocalizedStringKey(instruction))
                                    .font(.body)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                    )
                }
                .padding()
            }
            .navigationTitle("practice_detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("close") {
                        dismiss()
                    }
                }
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func toggleTimer() {
        if timerRunning {
            timer?.invalidate()
            timer = nil
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    timer?.invalidate()
                    timer = nil
                    timerRunning = false
                }
            }
        }
        timerRunning.toggle()
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
        timerRunning = false
        timeRemaining = practice.duration
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Animals Guide View
struct AnimalsGuideView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var selectedAnimal: Animal?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("animals_guide")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(settingsManager.selectedTheme.primaryColor)
                        
                        Spacer()
                        
                        Image(systemName: "book.fill")
                            .font(.title)
                            .foregroundColor(settingsManager.selectedTheme.primaryColor)
                    }
                    
                    Text("learn_about_animals")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                // Animals list
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(Animal.mockAnimals) { animal in
                            AnimalGuideCard(animal: animal) {
                                selectedAnimal = animal
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(settingsManager.selectedTheme.backgroundGradient)
            .sheet(item: $selectedAnimal) { animal in
                AnimalDetailView(animal: animal)
            }
        }
    }
}

struct AnimalGuideCard: View {
    let animal: Animal
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(animal.icon)
                    .font(.system(size: 50))
                    .frame(width: 70, height: 70)
                    .background(RoundedRectangle(cornerRadius: 12).fill(.blue.opacity(0.1)))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(LocalizedStringKey(animal.name))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(animal.scientificName)
                        .font(.caption)
                        .italic()
                        .foregroundColor(.secondary)
                    
                    Text(LocalizedStringKey(animal.description))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AnimalDetailView: View {
    let animal: Animal
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(spacing: 16) {
                        Text(animal.icon)
                            .font(.system(size: 100))
                        
                        Text(LocalizedStringKey(animal.name))
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(animal.scientificName)
                            .font(.title3)
                            .italic()
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial))
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("description_label")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text(LocalizedStringKey(animal.description))
                            .font(.body)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial))
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("interesting_facts")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        ForEach(Array(animal.facts.enumerated()), id: \.offset) { index, fact in
                            HStack(alignment: .top, spacing: 12) {
                                Text("💡")
                                    .font(.title3)
                                
                                Text(LocalizedStringKey(fact))
                                    .font(.body)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial))
                }
                .padding()
            }
            .navigationTitle("animal_details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("close") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Bait Workshop View
struct BaitWorkshopView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var selectedBait: Bait?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("bait_workshop")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(settingsManager.selectedTheme.primaryColor)
                        
                        Spacer()
                        
                        Image(systemName: "wrench.and.screwdriver.fill")
                            .font(.title)
                            .foregroundColor(settingsManager.selectedTheme.primaryColor)
                    }
                    
                    Text("craft_perfect_baits")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        ForEach(Bait.allBaits) { bait in
                            BaitCard(bait: bait) {
                                selectedBait = bait
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(settingsManager.selectedTheme.backgroundGradient)
            .sheet(item: $selectedBait) { bait in
                BaitDetailView(bait: bait)
            }
        }
    }
}

struct BaitCard: View {
    let bait: Bait
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(bait.icon)
                        .font(.system(size: 40))
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        ForEach(0..<4) { index in
                            Image(systemName: index < bait.effectiveness ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .font(.caption2)
                        }
                    }
                }
                
                Text(bait.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(bait.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct BaitDetailView: View {
    let bait: Bait
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(spacing: 16) {
                    Text(bait.icon)
                        .font(.system(size: 80))
                    
                    Text(bait.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(bait.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 2) {
                        ForEach(0..<4) { index in
                            Image(systemName: index < bait.effectiveness ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial))
                
                Spacer()
            }
            .padding()
            .navigationTitle("bait_recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("close") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Profile View
struct ProfileView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(spacing: 16) {
                    Text("🏹")
                        .font(.system(size: 80))
                        .frame(width: 120, height: 120)
                        .background(Circle().fill(.blue.opacity(0.1)))
                    
                    Text("Hunter")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("hunter_title")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 12) {
                    Button(action: { showingSettings = true }) {
                        HStack {
                            Image(systemName: "gear")
                                .foregroundColor(.blue)
                            Text("settings")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Spacer()
                
                Text("app_version")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(settingsManager.selectedTheme.backgroundGradient)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        NavigationStack {
            Form {
                Section("appearance_settings") {
                    Picker("app_theme", selection: $settingsManager.selectedTheme) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            Text(theme.localizedName).tag(theme)
                        }
                    }
                }
                
                Section("about_app") {
                    HStack {
                        Text("app_version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done") {
                        settingsManager.saveSettings()
                        dismiss()
                    }
                }
            }
        }
    }
}
