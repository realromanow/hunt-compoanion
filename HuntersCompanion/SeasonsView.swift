// SeasonsView.swift
import SwiftUI

struct SeasonsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var selectedAnimal = Animal.mockAnimals[0]
    @State private var showingAnimalSelection = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("hunting_seasons")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(settingsManager.selectedTheme.primaryColor)
                            
                            Text("current_season_activity")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showingAnimalSelection = true
                        }) {
                            Text(selectedAnimal.icon)
                                .font(.system(size: 40))
                                .background(
                                    Circle()
                                        .fill(settingsManager.selectedTheme.primaryColor.opacity(0.1))
                                        .frame(width: 60, height: 60)
                                )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
                
                // Activity Circle
                VStack(spacing: 24) {
                    ActivityCircleView(animal: selectedAnimal)
                        .frame(height: 400) // Увеличили с 300 до 400
                    
                    // Animal Info Card
                    AnimalInfoCard(animal: selectedAnimal)
                        .padding(.horizontal)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .background(settingsManager.selectedTheme.backgroundGradient)
            .sheet(isPresented: $showingAnimalSelection) {
                AnimalSelectionSheet(selectedAnimal: $selectedAnimal)
            }
        }
    }
}

// MARK: - Activity Circle View
struct ActivityCircleView: View {
    let animal: Animal
    @State private var animationProgress: Double = 0
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                .frame(width: 280, height: 280)
            
            // Activity segments
            ForEach(Array(animal.activityPattern.allPeriods.enumerated()), id: \.offset) { index, period in
                ActivitySegment(
                    period: period.0,
                    level: period.1,
                    animal: animal,
                    index: index,
                    progress: animationProgress
                )
            }
            
            // Center content
            VStack(spacing: 8) {
                Text(animal.icon)
                    .font(.system(size: 60))
                    .scaleEffect(1 + sin(animationProgress * 2 * .pi) * 0.1)
                
                Text(LocalizedStringKey(animal.name))
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Text(animal.scientificName)
                    .font(.caption)
                    .italic()
                    .foregroundColor(.secondary)
            }
            .frame(width: 140)
        }
        .frame(width: 400, height: 400) // Увеличили размер контейнера с 300 до 400
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever()) {
                animationProgress = 1
            }
        }
    }
}

struct ActivitySegment: View {
    let period: String
    let level: ActivityLevel
    let animal: Animal
    let index: Int
    let progress: Double
    
    private var startAngle: Angle {
        .degrees(Double(index) * 90 - 90)
    }
    
    var body: some View {
        ZStack {
            // Activity level arc
            Circle()
                .trim(from: 0.25 * Double(index), to: 0.25 * Double(index + 1))
                .stroke(
                    level.color.opacity(level.opacity),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .frame(width: 280, height: 280)
                .rotationEffect(.degrees(-90))
                .scaleEffect(0.95 + sin(progress * 2 * .pi + Double(index)) * 0.05)
            
            // Period label - размещаем дальше от кольца
            VStack(spacing: 2) {
                Text(LocalizedStringKey(period))
                    .font(.caption)
                    .fontWeight(.semibold)
                
                Text(level.localizedName)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(level.color)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                // Добавляем полупрозрачный фон для лучшей читаемости
                RoundedRectangle(cornerRadius: 8)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            )
            .offset(
                // Увеличиваем расстояние с 150 до 180, чтобы текст не накладывался на кольцо
                x: cos(startAngle.radians + .pi/4) * 180,
                y: sin(startAngle.radians + .pi/4) * 180
            )
        }
    }
}

// MARK: - Animal Info Card
struct AnimalInfoCard: View {
    let animal: Animal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("best_seasons")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                        ForEach(animal.bestSeasons, id: \.self) { season in
                            SeasonBadge(season: season)
                        }
                    }
                }
                
                Spacer()
                
                DifficultyBadge(difficulty: animal.difficulty)
            }
            
            Text("habitat_label")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(LocalizedStringKey(animal.habitat))
                .font(.body)
                .foregroundColor(.secondary)
            
            Text("description_label")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(LocalizedStringKey(animal.description))
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
}

struct SeasonBadge: View {
    let season: Season
    
    var body: some View {
        Text(season.localizedName)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(season.color.opacity(0.2))
            )
            .foregroundColor(season.color)
    }
}

struct DifficultyBadge: View {
    let difficulty: DifficultyLevel
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text("difficulty_label")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(spacing: 2) {
                ForEach(0..<3) { index in
                    Image(systemName: index < difficulty.stars ? "star.fill" : "star")
                        .foregroundColor(difficulty.color)
                        .font(.caption)
                }
            }
            
            Text(difficulty.localizedName)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(difficulty.color)
        }
    }
}

// MARK: - Animal Selection Sheet
struct AnimalSelectionSheet: View {
    @Binding var selectedAnimal: Animal
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ForEach(Animal.mockAnimals) { animal in
                    AnimalSelectionCard(
                        animal: animal,
                        isSelected: animal.id == selectedAnimal.id
                    ) {
                        selectedAnimal = animal
                        dismiss()
                    }
                }
            }
            .padding()
            .navigationTitle("select_animal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AnimalSelectionCard: View {
    let animal: Animal
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Text(animal.icon)
                    .font(.system(size: 50))
                
                Text(LocalizedStringKey(animal.name))
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Text(animal.scientificName)
                    .font(.caption)
                    .italic()
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? .blue : .clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
