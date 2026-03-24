import SwiftUI

final class FridgeManager: ObservableObject {
    @Published var fridge: [FridgeItem] = [] { didSet { save("fr_fridge", fridge) } }
    @Published var recipes: [Recipe] = [] { didSet { save("fr_recipes", recipes) } }
    @Published var cookLog: [CookLog] = [] { didSet { save("fr_log", cookLog) } }
    @Published var onboardingDone: Bool { didSet { UserDefaults.standard.set(onboardingDone, forKey: "fr_onboarding") } }

    init() {
        onboardingDone = UserDefaults.standard.bool(forKey: "fr_onboarding")
        fridge = Storage.shared.load(forKey: "fr_fridge", default: [])
        recipes = Storage.shared.load(forKey: "fr_recipes", default: Recipe.catalog)
        cookLog = Storage.shared.load(forKey: "fr_log", default: [])
    }

    private func save<T: Codable>(_ key: String, _ value: T) { Storage.shared.save(value, forKey: key) }

    // MARK: - Fridge
    func addToFridge(_ info: IngInfo) {
        guard !fridge.contains(where: { $0.name.lowercased() == info.name.lowercased() }) else { return }
        fridge.append(FridgeItem(name: info.name, emoji: info.emoji))
    }
    func removeFromFridge(_ item: FridgeItem) { fridge.removeAll { $0.id == item.id } }
    func clearFridge() { fridge = [] }
    func hasFridgeItem(_ name: String) -> Bool { fridgeSet.contains(name.lowercased()) }
    var fridgeSet: Set<String> { Set(fridge.map { $0.name.lowercased() }) }

    // MARK: - Recipes
    func toggleFavorite(_ recipe: Recipe) {
        guard let idx = recipes.firstIndex(where: { $0.id == recipe.id }) else { return }
        recipes[idx].isFavorite.toggle()
    }
    var favorites: [Recipe] { recipes.filter(\.isFavorite) }

    // MARK: - Matching
    func matchedRecipes() -> [(recipe: Recipe, match: Double)] {
        let fs = fridgeSet
        guard !fs.isEmpty else { return [] }
        return recipes.map { ($0, $0.matchPercent(fridge: fs)) }
            .filter { $0.1 > 0.3 }
            .sorted { $0.1 > $1.1 }
    }

    func topMatches(count: Int = 10) -> [(recipe: Recipe, match: Double)] {
        Array(matchedRecipes().prefix(count))
    }

    func randomPick() -> (recipe: Recipe, match: Double)? {
        let candidates = matchedRecipes().filter { $0.match >= 0.5 }
        return candidates.randomElement()
    }

    // MARK: - Cook Log
    func logCooked(recipe: Recipe, rating: Int) {
        cookLog.insert(CookLog(recipeName: recipe.name, recipeEmoji: recipe.emoji, rating: rating), at: 0)
    }
    var totalCooked: Int { cookLog.count }

    // MARK: - Stats
    func mealBreakdown() -> [ChartPoint] {
        MealType.allCases.compactMap { meal in
            let count = recipes.filter { $0.meal == meal }.count
            return ChartPoint(id: meal.rawValue, label: meal.name, value: Double(count))
        }
    }
    func topCookedRecipes() -> [(name: String, emoji: String, count: Int)] {
        let grouped = Dictionary(grouping: cookLog, by: \.recipeName)
        return grouped.map { (name: $0.key, emoji: $0.value.first?.recipeEmoji ?? "🍽️", count: $0.value.count) }
            .sorted { $0.count > $1.count }.prefix(5).map { $0 }
    }
    func averageRating() -> Double {
        guard !cookLog.isEmpty else { return 0 }
        return Double(cookLog.reduce(0) { $0 + $1.rating }) / Double(cookLog.count)
    }

    // MARK: - Reset
    func resetAllData() {
        fridge = []; recipes = Recipe.catalog; cookLog = []; onboardingDone = false
        UserDefaults.standard.removeObject(forKey: "fr_onboarding")
    }
}
