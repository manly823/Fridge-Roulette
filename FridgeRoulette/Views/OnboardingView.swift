import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var manager: FridgeManager
    @State private var page = 0

    private let pages: [(icon: String, title: String, body: String, color: Color)] = [
        ("refrigerator.fill", "Stock Your Fridge",
         "Add the ingredients you have at home. Choose from 75+ common items across produce, dairy, meat, pantry, and more.",
         Theme.success),
        ("dice.fill", "Spin the Roulette",
         "Tap Spin and discover what you can cook with what you already have. The app matches your ingredients to 50 recipes.",
         Theme.accent),
        ("book.fill", "Browse & Cook",
         "Explore all recipes by category, see match percentages, step-by-step instructions, and log every meal you cook.",
         Theme.info),
        ("heart.fill", "Save Favorites",
         "Heart the recipes you love. Track your cooking history with ratings and see your most-cooked dishes.",
         Theme.secondary),
    ]

    var body: some View {
        VStack(spacing: 0) {
            if page < pages.count { infoPage } else { readyPage }
        }
        .background(Theme.bg.ignoresSafeArea())
    }

    private var infoPage: some View {
        VStack(spacing: 30) {
            Spacer()
            let p = pages[page]
            Image(systemName: p.icon).font(.system(size: 52)).foregroundStyle(p.color)
                .frame(width: 120, height: 120)
                .background(p.color.opacity(0.1), in: Circle())
            VStack(spacing: 10) {
                Text(p.title).font(.system(size: 26, weight: .bold, design: .rounded)).foregroundStyle(Theme.text)
                Text(p.body).font(.system(size: 15, design: .rounded)).foregroundStyle(Theme.sub)
                    .multilineTextAlignment(.center).padding(.horizontal, 30)
            }
            Spacer()
            dots
            nextButton("Next") { withAnimation { page += 1 } }
            Spacer().frame(height: 30)
        }
    }

    private var readyPage: some View {
        VStack(spacing: 30) {
            Spacer()
            Text("🎲").font(.system(size: 60))
                .frame(width: 120, height: 120)
                .background(Theme.accent.opacity(0.1), in: Circle())
            VStack(spacing: 10) {
                Text("Let's Cook!").font(.system(size: 26, weight: .bold, design: .rounded)).foregroundStyle(Theme.text)
                Text("Start by adding ingredients to your fridge, then spin the roulette to discover your next meal!")
                    .font(.system(size: 15, design: .rounded)).foregroundStyle(Theme.sub)
                    .multilineTextAlignment(.center).padding(.horizontal, 30)
            }
            Spacer()
            dots
            nextButton("Get Started") { manager.onboardingDone = true }
            Spacer().frame(height: 30)
        }
    }

    private var dots: some View {
        HStack(spacing: 8) {
            ForEach(0..<pages.count + 1, id: \.self) { i in
                Circle().fill(i == page ? Theme.accent : Theme.muted).frame(width: 8, height: 8)
            }
        }
    }

    private func nextButton(_ text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(text).font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.bg).frame(maxWidth: .infinity).padding(.vertical, 16)
                .background(Theme.accent, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .padding(.horizontal, 30)
    }
}
