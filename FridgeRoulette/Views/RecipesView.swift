import SwiftUI

struct RecipesView: View {
    @EnvironmentObject var manager: FridgeManager
    @State private var selectedMeal: MealType?
    @State private var search = ""
    @State private var showDetail = false
    @State private var detailRecipe: Recipe?

    var filtered: [Recipe] {
        var list = manager.recipes
        if let meal = selectedMeal { list = list.filter { $0.meal == meal } }
        if !search.isEmpty { list = list.filter { $0.name.localizedCaseInsensitiveContains(search) } }
        return list
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 14) {
                header
                searchBar
                mealFilter
                recipeList
            }
            .padding(.horizontal, 20).padding(.bottom, 100)
        }
        .background(Theme.bg)
        .sheet(isPresented: $showDetail) {
            if let r = detailRecipe {
                let m = r.matchPercent(fridge: manager.fridgeSet)
                RecipeDetail(recipe: r, match: m)
            }
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("All Recipes").font(.system(size: 28, weight: .bold, design: .rounded)).foregroundStyle(Theme.text)
                Text("\(manager.recipes.count) recipes").font(.system(size: 13, design: .rounded)).foregroundStyle(Theme.sub)
            }
            Spacer()
        }
        .padding(.top, 8)
    }

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass").foregroundStyle(Theme.muted)
            TextField("Search recipes...", text: $search)
                .font(.system(size: 14, design: .rounded)).foregroundStyle(Theme.text)
        }
        .padding(10).background(Theme.surface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var mealFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterChip("All", nil)
                ForEach(MealType.allCases) { meal in filterChip(meal.emoji + " " + meal.name, meal) }
            }
        }
    }

    private func filterChip(_ label: String, _ meal: MealType?) -> some View {
        let sel = selectedMeal == meal
        return Button { withAnimation { selectedMeal = meal } } label: {
            Text(label).font(.system(size: 12, weight: sel ? .bold : .medium, design: .rounded))
                .foregroundStyle(sel ? Theme.bg : Theme.text)
                .padding(.horizontal, 14).padding(.vertical, 8)
                .background(sel ? Theme.accent : Theme.surface, in: Capsule())
        }
    }

    private var recipeList: some View {
        VStack(spacing: 10) {
            if filtered.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "book").font(.system(size: 28)).foregroundStyle(Theme.muted)
                    Text("No recipes found").font(.system(size: 13, design: .rounded)).foregroundStyle(Theme.sub)
                }
                .frame(maxWidth: .infinity).padding(.vertical, 30).glowCard()
            } else {
                ForEach(filtered) { recipe in
                    Button {
                        detailRecipe = recipe; showDetail = true
                    } label: {
                        HStack(spacing: 12) {
                            Text(recipe.emoji).font(.system(size: 24))
                                .frame(width: 44, height: 44)
                                .background(recipe.meal.color.opacity(0.12), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            VStack(alignment: .leading, spacing: 3) {
                                Text(recipe.name).font(.system(size: 15, weight: .bold, design: .rounded)).foregroundStyle(Theme.text)
                                HStack(spacing: 6) {
                                    Text(recipe.meal.name).font(.system(size: 11, design: .rounded)).foregroundStyle(Theme.sub)
                                    Text("·").foregroundStyle(Theme.muted)
                                    Text("\(recipe.cookTime) min").font(.system(size: 11, design: .rounded)).foregroundStyle(Theme.sub)
                                    Text("·").foregroundStyle(Theme.muted)
                                    Text(recipe.difficulty.name).font(.system(size: 11, weight: .semibold, design: .rounded)).foregroundStyle(recipe.difficulty.color)
                                }
                            }
                            Spacer()
                            if recipe.isFavorite {
                                Image(systemName: "heart.fill").font(.system(size: 12)).foregroundStyle(Theme.accent)
                            }
                            let m = recipe.matchPercent(fridge: manager.fridgeSet)
                            if m > 0 {
                                Text(String(format: "%.0f%%", m * 100))
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundStyle(m >= 0.8 ? Theme.success : m >= 0.5 ? Theme.secondary : Theme.warm)
                            }
                        }
                        .padding(12).background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Theme.card))
                    }
                }
            }
        }
    }
}
