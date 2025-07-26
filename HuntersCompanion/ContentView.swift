// ContentView.swift
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var selectedTab = 0
    
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
