import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var manager: FridgeManager
    @State private var showFavs = false

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                header
                statsOverview
                toggle
                if showFavs { favoritesSection } else { logSection }
            }
            .padding(.horizontal, 20).padding(.bottom, 100)
        }
        .background(Theme.bg)
    }

    private var header: some View {
        HStack {
            Text("History").font(.system(size: 28, weight: .bold, design: .rounded)).foregroundStyle(Theme.text)
            Spacer()
        }
        .padding(.top, 8)
    }

    private var statsOverview: some View {
        HStack(spacing: 10) {
            statTile("\(manager.totalCooked)", "Cooked", Theme.accent)
            statTile("\(manager.favorites.count)", "Favorites", Theme.secondary)
            statTile(manager.totalCooked > 0 ? String(format: "%.1f", manager.averageRating()) : "-", "Avg Rating", Theme.warm)
        }
    }

    private func statTile(_ value: String, _ label: String, _ color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value).font(.system(size: 18, weight: .bold, design: .rounded)).foregroundStyle(color)
            Text(label).font(.system(size: 10, design: .rounded)).foregroundStyle(Theme.sub)
        }
        .frame(maxWidth: .infinity).glowCard()
    }

    private var toggle: some View {
        HStack(spacing: 8) {
            Button { withAnimation { showFavs = false } } label: {
                Text("Cook Log").font(.system(size: 13, weight: !showFavs ? .bold : .medium, design: .rounded))
                    .foregroundStyle(!showFavs ? Theme.bg : Theme.sub)
                    .padding(.horizontal, 16).padding(.vertical, 8)
                    .background(!showFavs ? Theme.accent : Theme.surface, in: Capsule())
            }
            Button { withAnimation { showFavs = true } } label: {
                Text("Favorites (\(manager.favorites.count))").font(.system(size: 13, weight: showFavs ? .bold : .medium, design: .rounded))
                    .foregroundStyle(showFavs ? Theme.bg : Theme.sub)
                    .padding(.horizontal, 16).padding(.vertical, 8)
                    .background(showFavs ? Theme.secondary : Theme.surface, in: Capsule())
            }
            Spacer()
        }
    }

    private var logSection: some View {
        VStack(spacing: 10) {
            if manager.cookLog.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "frying.pan").font(.system(size: 28)).foregroundStyle(Theme.muted)
                    Text("Nothing cooked yet").font(.system(size: 13, design: .rounded)).foregroundStyle(Theme.sub)
                    Text("Spin the roulette and log your meals").font(.system(size: 11, design: .rounded)).foregroundStyle(Theme.muted)
                }
                .frame(maxWidth: .infinity).padding(.vertical, 30).glowCard()
            } else {
                ForEach(manager.cookLog) { log in
                    HStack(spacing: 12) {
                        Text(log.recipeEmoji).font(.system(size: 22))
                            .frame(width: 42, height: 42)
                            .background(Theme.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(log.recipeName).font(.system(size: 14, weight: .bold, design: .rounded)).foregroundStyle(Theme.text)
                            Text(log.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.system(size: 11, design: .rounded)).foregroundStyle(Theme.sub)
                        }
                        Spacer()
                        HStack(spacing: 2) {
                            ForEach(1...5, id: \.self) { s in
                                Image(systemName: s <= log.rating ? "star.fill" : "star")
                                    .font(.system(size: 9)).foregroundStyle(s <= log.rating ? Theme.secondary : Theme.muted)
                            }
                        }
                    }
                    .padding(12).background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Theme.card))
                }

                if !manager.topCookedRecipes().isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Most Cooked").font(.system(size: 15, weight: .bold, design: .rounded)).foregroundStyle(Theme.text)
                        ForEach(manager.topCookedRecipes(), id: \.name) { item in
                            HStack(spacing: 10) {
                                Text(item.emoji).font(.system(size: 14))
                                Text(item.name).font(.system(size: 13, weight: .semibold, design: .rounded)).foregroundStyle(Theme.text)
                                Spacer()
                                Text("\(item.count)×").font(.system(size: 13, weight: .bold, design: .rounded)).foregroundStyle(Theme.accent)
                            }
                        }
                    }
                    .glowCard()
                }
            }
        }
    }

    private var favoritesSection: some View {
        VStack(spacing: 10) {
            if manager.favorites.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "heart").font(.system(size: 28)).foregroundStyle(Theme.muted)
                    Text("No favorites yet").font(.system(size: 13, design: .rounded)).foregroundStyle(Theme.sub)
                }
                .frame(maxWidth: .infinity).padding(.vertical, 30).glowCard()
            } else {
                ForEach(manager.favorites) { recipe in
                    HStack(spacing: 12) {
                        Text(recipe.emoji).font(.system(size: 22))
                            .frame(width: 42, height: 42)
                            .background(Theme.secondary.opacity(0.12), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(recipe.name).font(.system(size: 14, weight: .bold, design: .rounded)).foregroundStyle(Theme.text)
                            HStack(spacing: 6) {
                                Text(recipe.meal.name).font(.system(size: 11, design: .rounded)).foregroundStyle(Theme.sub)
                                Text("·").foregroundStyle(Theme.muted)
                                Text("\(recipe.cookTime) min").font(.system(size: 11, design: .rounded)).foregroundStyle(Theme.sub)
                            }
                        }
                        Spacer()
                        Button { withAnimation { manager.toggleFavorite(recipe) } } label: {
                            Image(systemName: "heart.fill").font(.system(size: 14)).foregroundStyle(Theme.accent)
                        }
                    }
                    .padding(12).background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Theme.card))
                }
            }
        }
    }
}
