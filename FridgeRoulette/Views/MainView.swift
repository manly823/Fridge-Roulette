import SwiftUI

enum AppTab: Int, CaseIterable {
    case fridge, roulette, recipes, history
    var icon: String {
        switch self {
        case .fridge: return "refrigerator.fill"
        case .roulette: return "dice.fill"
        case .recipes: return "book.fill"
        case .history: return "clock.fill"
        }
    }
    var label: String {
        switch self {
        case .fridge: return "Fridge"
        case .roulette: return "Spin"
        case .recipes: return "Recipes"
        case .history: return "History"
        }
    }
}

struct MainView: View {
    @EnvironmentObject var manager: FridgeManager
    @State private var tab: AppTab = .roulette
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Group {
                    switch tab {
                    case .fridge: FridgeView()
                    case .roulette: RouletteView()
                    case .recipes: RecipesView()
                    case .history: HistoryView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                floatingBar
            }
            .background(Theme.bg.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Fridge Roulette").font(.system(size: 22, weight: .bold, design: .rounded)).foregroundStyle(Theme.text)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showSettings = true } label: {
                        Image(systemName: "gearshape.fill").font(.system(size: 15)).foregroundStyle(Theme.sub)
                            .frame(width: 34, height: 34).background(Theme.surface, in: Circle())
                    }
                }
            }
            .sheet(isPresented: $showSettings) { SettingsView() }
        }
    }

    private var floatingBar: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.rawValue) { t in
                Button { withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) { tab = t } } label: {
                    VStack(spacing: 4) {
                        ZStack {
                            if t == .roulette && tab == .roulette {
                                Circle().fill(Theme.accent).frame(width: 44, height: 44)
                            }
                            Image(systemName: t.icon)
                                .font(.system(size: t == .roulette ? 18 : 16, weight: .semibold))
                                .foregroundStyle(tab == t ? (t == .roulette ? Theme.bg : Theme.accent) : Theme.sub)
                        }
                        .frame(height: 44)
                        Text(t.label).font(.system(size: 10, weight: tab == t ? .bold : .medium, design: .rounded))
                            .foregroundStyle(tab == t ? Theme.accent : Theme.sub)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Theme.surface.opacity(0.95))
                .shadow(color: .black.opacity(0.4), radius: 12, y: -2)
        )
        .padding(.horizontal, 16).padding(.bottom, 4)
    }
}
