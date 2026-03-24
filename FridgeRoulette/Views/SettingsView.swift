import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var manager: FridgeManager
    @Environment(\.dismiss) var dismiss
    @State private var showReset = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    profileSection
                    summarySection
                    dangerSection
                    appInfoSection
                }
                .padding(20)
            }
            .background(Theme.bg.ignoresSafeArea())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }.foregroundStyle(Theme.accent)
                }
            }
            .alert("Reset All Data?", isPresented: $showReset) {
                Button("Reset", role: .destructive) { manager.resetAllData(); dismiss() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will clear your fridge, reset recipes, and delete all cooking history.")
            }
        }
    }

    private var profileSection: some View {
        HStack(spacing: 14) {
            Text("🎲").font(.system(size: 28))
                .frame(width: 50, height: 50)
                .background(Theme.accent.opacity(0.1), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            VStack(alignment: .leading, spacing: 3) {
                Text("Fridge Roulette").font(.system(size: 17, weight: .bold, design: .rounded)).foregroundStyle(Theme.text)
                Text("\(manager.fridge.count) ingredients · \(manager.recipes.count) recipes")
                    .font(.system(size: 12, design: .rounded)).foregroundStyle(Theme.sub)
            }
            Spacer()
        }
        .glowCard()
    }

    private var summarySection: some View {
        VStack(spacing: 8) {
            dataRow("Fridge Items", "\(manager.fridge.count)", Theme.success)
            dataRow("Total Recipes", "\(manager.recipes.count)", Theme.info)
            dataRow("Favorites", "\(manager.favorites.count)", Theme.secondary)
            Divider().background(Theme.muted)
            dataRow("Meals Cooked", "\(manager.totalCooked)", Theme.accent)
            dataRow("Avg Rating", manager.totalCooked > 0 ? String(format: "%.1f ★", manager.averageRating()) : "-", Theme.warm)
        }
        .glowCard()
    }

    private func dataRow(_ label: String, _ value: String, _ color: Color) -> some View {
        HStack {
            Text(label).font(.system(size: 13, design: .rounded)).foregroundStyle(Theme.sub)
            Spacer()
            Text(value).font(.system(size: 13, weight: .bold, design: .rounded)).foregroundStyle(color)
        }
    }

    private var dangerSection: some View {
        Button { showReset = true } label: {
            HStack {
                Image(systemName: "trash.fill").foregroundStyle(Theme.danger)
                Text("Reset All Data").font(.system(size: 14, weight: .semibold, design: .rounded)).foregroundStyle(Theme.danger)
                Spacer()
            }
        }
        .glowCard()
    }

    private var appInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About").font(.system(size: 14, weight: .bold, design: .rounded)).foregroundStyle(Theme.text)
            infoRow("Version", "1.0")
            infoRow("Recipes", "50")
            infoRow("Ingredients", "75+")
            infoRow("Data", "Local Only")
        }
        .glowCard()
    }

    private func infoRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).foregroundStyle(Theme.sub)
            Spacer()
            Text(value).foregroundStyle(Theme.muted)
        }
        .font(.system(size: 13, design: .rounded))
    }
}
