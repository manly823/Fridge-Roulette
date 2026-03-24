import SwiftUI

@main
struct FridgeRouletteApp: App {
    @StateObject private var manager = FridgeManager()
    var body: some Scene {
        WindowGroup {
            Group {
                if manager.onboardingDone { MainView() } else { OnboardingView() }
            }
            .environmentObject(manager)
            .preferredColorScheme(.dark)
        }
    }
}
