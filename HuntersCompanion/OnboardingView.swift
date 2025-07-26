import SwiftUI
import AuthenticationServices

struct OnboardingView: View {
    @Binding var show: Bool
    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        VStack {
            TabView {
                OnboardingPage(image: "hare.fill", text: "onboarding_discover")
                OnboardingPage(image: "leaf.fill", text: "onboarding_workshop")
                OnboardingPage(image: "hand.raised.fill", text: "onboarding_accessibility")
            }
            .tabViewStyle(PageTabViewStyle())

            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { _ in }
            .signInWithAppleButtonStyle(.black)
            .frame(height: 45)
            .padding(.top)
            .accessibilityLabel(Text("sign_in_with_apple"))

            Button("get_started") {
                UserDefaults.standard.set(true, forKey: "has_seen_onboarding")
                show = false
            }
            .padding()
        }
        .padding()
    }
}

struct OnboardingPage: View {
    let image: String
    let text: LocalizedStringKey

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding()
            Text(text)
                .font(.title2)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

