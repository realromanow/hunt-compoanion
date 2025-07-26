// ContentView.swift
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.colorSchemeContrast) var systemContrast
    @State private var selectedTab = 0
    @State private var showOnboarding = false

    var body: some View {
        TabView(selection: $selectedTab) {
            SeasonsView()
                .tabItem {
                    Image(systemName: "circle.grid.2x2")
                    Text("seasons_tab")
                }
                .tag(0)
            
            TrailsView()
                .tabItem {
                    Image(systemName: "map")
                    Text("trails_tab")
                }
                .tag(1)
            
            AnimalsGuideView()
                .tabItem {
                    Image(systemName: "book")
                    Text("guide_tab")
                }
                .tag(2)
            
            BaitWorkshopView()
                .tabItem {
                    Image(systemName: "wrench.and.screwdriver")
                    Text("workshop_tab")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("profile_tab")
                }
                .tag(4)
        }
        .accentColor(settingsManager.selectedTheme.primaryColor)
        .dynamicTypeSize(settingsManager.largeTextEnabled ? .accessibility3 : .large)
        .sheet(isPresented: $showOnboarding) {
            OnboardingView(show: $showOnboarding)
                .environmentObject(settingsManager)
        }
        .onAppear {
            showOnboarding = !settingsManager.hasSeenOnboarding
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(SettingsManager())
                .environment(\.locale, .init(identifier: "en"))
            
            ContentView()
                .environmentObject(SettingsManager())
                .environment(\.locale, .init(identifier: "es"))
        }
    }
}
