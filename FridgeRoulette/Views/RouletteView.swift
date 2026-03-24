import SwiftUI

struct RouletteView: View {
    @EnvironmentObject var manager: FridgeManager
    @State private var spinning = false
    @State private var displayRecipe: Recipe?
    @State private var displayMatch: Double = 0
    @State private var showDetail = false
    @State private var spinAngle: Double = 0

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                header
                if manager.fridge.isEmpty { emptyState } else { rouletteContent }
            }
            .padding(.horizontal, 20).padding(.bottom, 100)
        }
        .background(Theme.bg)
        .sheet(isPresented: $showDetail) {
            if let r = displayRecipe { RecipeDetail(recipe: r, match: displayMatch) }
        }
    }

    private var header: some View {
        VStack(spacing: 4) {
            Text("Spin the Roulette").font(.system(size: 28, weight: .bold, design: .rounded)).foregroundStyle(Theme.text)
            Text("\(manager.fridge.count) ingredients in your fridge")
                .font(.system(size: 13, design: .rounded)).foregroundStyle(Theme.sub)
        }
        .padding(.top, 8)
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "refrigerator").font(.system(size: 40)).foregroundStyle(Theme.muted)
            Text("Add ingredients first").font(.system(size: 16, weight: .semibold, design: .rounded)).foregroundStyle(Theme.sub)
            Text("Go to Fridge tab and add what you have at home")
                .font(.system(size: 13, design: .rounded)).foregroundStyle(Theme.muted).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 50).glowCard()
    }

    private var rouletteContent: some View {
        VStack(spacing: 20) {
            spinButton
            if let r = displayRecipe { resultCard(r) }
            matchList
        }
    }

    private var spinButton: some View {
        Button { spin() } label: {
            ZStack {
                Circle().fill(
                    RadialGradient(colors: [Theme.accent, Theme.accent.opacity(0.6)], center: .center, startRadius: 0, endRadius: 80)
                )
                .frame(width: 140, height: 140)
                .shadow(color: Theme.accent.opacity(0.4), radius: 16)

                VStack(spacing: 4) {
                    Image(systemName: "dice.fill")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(Theme.bg)
                        .rotationEffect(.degrees(spinAngle))
                    Text(spinning ? "..." : "SPIN").font(.system(size: 16, weight: .black, design: .rounded))
                        .foregroundStyle(Theme.bg)
                }
            }
        }
        .disabled(spinning || manager.matchedRecipes().isEmpty)
        .frame(maxWidth: .infinity)
    }

    private func resultCard(_ recipe: Recipe) -> some View {
        Button { showDetail = true } label: {
            VStack(spacing: 10) {
                HStack(spacing: 4) {
                    Text("Match").font(.system(size: 12, weight: .semibold, design: .rounded)).foregroundStyle(Theme.sub)
                    Text(String(format: "%.0f%%", displayMatch * 100))
                        .font(.system(size: 14, weight: .bold, design: .rounded)).foregroundStyle(matchColor(displayMatch))
                    Spacer()
                    Text(recipe.meal.emoji).font(.system(size: 12))
                    Text(recipe.difficulty.name).font(.system(size: 11, weight: .semibold, design: .rounded)).foregroundStyle(recipe.difficulty.color)
                }
                HStack(spacing: 14) {
                    Text(recipe.emoji).font(.system(size: 36))
                        .frame(width: 60, height: 60)
                        .background(Theme.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    VStack(alignment: .leading, spacing: 4) {
                        Text(recipe.name).font(.system(size: 18, weight: .bold, design: .rounded)).foregroundStyle(Theme.text)
                        HStack(spacing: 8) {
                            Label("\(recipe.cookTime) min", systemImage: "clock").font(.system(size: 11, design: .rounded)).foregroundStyle(Theme.sub)
                            Label("\(recipe.servings) srv", systemImage: "person.2").font(.system(size: 11, design: .rounded)).foregroundStyle(Theme.sub)
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.right").font(.system(size: 14)).foregroundStyle(Theme.muted)
                }
            }
            .glowCard(Theme.card.opacity(0.9))
        }
    }

    private var matchList: some View {
        let matches = manager.topMatches(count: 8)
        return VStack(alignment: .leading, spacing: 10) {
            if !matches.isEmpty {
                Text("Top Matches").font(.system(size: 16, weight: .bold, design: .rounded)).foregroundStyle(Theme.text)
                ForEach(matches, id: \.recipe.id) { item in
                    Button {
                        displayRecipe = item.recipe; displayMatch = item.match; showDetail = true
                    } label: {
                        HStack(spacing: 12) {
                            Text(item.recipe.emoji).font(.system(size: 20))
                                .frame(width: 40, height: 40)
                                .background(matchColor(item.match).opacity(0.12), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.recipe.name).font(.system(size: 14, weight: .semibold, design: .rounded)).foregroundStyle(Theme.text)
                                Text("\(item.recipe.cookTime) min · \(item.recipe.difficulty.name)")
                                    .font(.system(size: 11, design: .rounded)).foregroundStyle(Theme.sub)
                            }
                            Spacer()
                            Text(String(format: "%.0f%%", item.match * 100))
                                .font(.system(size: 13, weight: .bold, design: .rounded)).foregroundStyle(matchColor(item.match))
                        }
                        .padding(12).background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Theme.card))
                    }
                }
            }
        }
    }

    private func matchColor(_ m: Double) -> Color {
        if m >= 0.8 { return Theme.success }
        if m >= 0.5 { return Theme.secondary }
        return Theme.warm
    }

    private func spin() {
        let candidates = manager.matchedRecipes().filter { $0.match >= 0.4 }
        guard !candidates.isEmpty else { return }
        spinning = true; displayRecipe = nil
        var step = 0; let total = 18
        func next() {
            let delay = 0.05 + Double(step) * 0.02
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeOut(duration: 0.1)) {
                    let pick = candidates[Int.random(in: 0..<candidates.count)]
                    displayRecipe = pick.recipe; displayMatch = pick.match
                    spinAngle += 45
                }
                step += 1
                if step < total { next() } else {
                    let finalPick = candidates.randomElement()!
                    withAnimation(.spring(response: 0.4)) {
                        displayRecipe = finalPick.recipe; displayMatch = finalPick.match
                        spinning = false
                    }
                }
            }
        }
        next()
    }
}

// MARK: - Recipe Detail

struct RecipeDetail: View {
    @EnvironmentObject var manager: FridgeManager
    @Environment(\.dismiss) var dismiss
    let recipe: Recipe; let match: Double
    @State private var rating = 4
    @State private var cooked = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    heroSection
                    ingredientsSection
                    stepsSection
                    cookSection
                }
                .padding(20)
            }
            .background(Theme.bg.ignoresSafeArea())
            .navigationTitle(recipe.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("Close") { dismiss() }.foregroundStyle(Theme.sub) }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { withAnimation { manager.toggleFavorite(recipe) } } label: {
                        Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(recipe.isFavorite ? Theme.accent : Theme.sub)
                    }
                }
            }
        }
    }

    private var heroSection: some View {
        VStack(spacing: 10) {
            Text(recipe.emoji).font(.system(size: 56))
                .frame(width: 100, height: 100)
                .background(Theme.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            HStack(spacing: 12) {
                tag(recipe.meal.emoji + " " + recipe.meal.name, recipe.meal.color)
                tag(recipe.difficulty.name, recipe.difficulty.color)
                tag("\(recipe.cookTime) min", Theme.info)
                tag("\(recipe.servings) srv", Theme.sub)
            }
            Text(String(format: "%.0f%% match", match * 100))
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(match >= 0.8 ? Theme.success : match >= 0.5 ? Theme.secondary : Theme.warm)
        }
        .frame(maxWidth: .infinity).glowCard()
    }

    private func tag(_ text: String, _ color: Color) -> some View {
        Text(text).font(.system(size: 11, weight: .semibold, design: .rounded))
            .foregroundStyle(color).padding(.horizontal, 8).padding(.vertical, 4)
            .background(color.opacity(0.12), in: Capsule())
    }

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Ingredients").font(.system(size: 16, weight: .bold, design: .rounded)).foregroundStyle(Theme.text)
            ForEach(recipe.ingredients, id: \.self) { ing in
                let has = manager.hasFridgeItem(ing)
                HStack(spacing: 10) {
                    Image(systemName: has ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 14)).foregroundStyle(has ? Theme.success : Theme.danger)
                    Text(ing.capitalized).font(.system(size: 14, design: .rounded))
                        .foregroundStyle(has ? Theme.text : Theme.text.opacity(0.6))
                    Spacer()
                    if !has { Text("missing").font(.system(size: 10, design: .rounded)).foregroundStyle(Theme.danger) }
                }
            }
        }
        .glowCard()
    }

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Steps").font(.system(size: 16, weight: .bold, design: .rounded)).foregroundStyle(Theme.text)
            ForEach(Array(recipe.steps.enumerated()), id: \.offset) { idx, step in
                HStack(alignment: .top, spacing: 12) {
                    Text("\(idx + 1)").font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.bg).frame(width: 26, height: 26)
                        .background(Theme.accent, in: Circle())
                    Text(step).font(.system(size: 14, design: .rounded)).foregroundStyle(Theme.text)
                }
            }
        }
        .glowCard()
    }

    private var cookSection: some View {
        VStack(spacing: 12) {
            if cooked {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(Theme.success)
                    Text("Logged!").font(.system(size: 14, weight: .bold, design: .rounded)).foregroundStyle(Theme.success)
                }
            } else {
                Text("Rate & Log").font(.system(size: 14, weight: .bold, design: .rounded)).foregroundStyle(Theme.text)
                HStack(spacing: 8) {
                    ForEach(1...5, id: \.self) { star in
                        Button { rating = star } label: {
                            Image(systemName: star <= rating ? "star.fill" : "star")
                                .font(.system(size: 22)).foregroundStyle(star <= rating ? Theme.secondary : Theme.muted)
                        }
                    }
                }
                Button {
                    manager.logCooked(recipe: recipe, rating: rating)
                    withAnimation { cooked = true }
                } label: {
                    Text("I Cooked This!").font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.bg).frame(maxWidth: .infinity).padding(.vertical, 12)
                        .background(Theme.accent, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            }
        }
        .glowCard()
    }
}
