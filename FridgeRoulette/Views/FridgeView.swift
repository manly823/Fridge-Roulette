import SwiftUI

struct FridgeView: View {
    @EnvironmentObject var manager: FridgeManager
    @State private var showCatalog = false
    @State private var search = ""

    var filteredFridge: [FridgeItem] {
        search.isEmpty ? manager.fridge : manager.fridge.filter { $0.name.localizedCaseInsensitiveContains(search) }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                header
                if !manager.fridge.isEmpty { searchBar }
                fridgeGrid
            }
            .padding(.horizontal, 20).padding(.bottom, 100)
        }
        .background(Theme.bg)
        .sheet(isPresented: $showCatalog) { CatalogSheet() }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("My Fridge").font(.system(size: 28, weight: .bold, design: .rounded)).foregroundStyle(Theme.text)
                Text("\(manager.fridge.count) ingredients").font(.system(size: 13, design: .rounded)).foregroundStyle(Theme.sub)
            }
            Spacer()
            if !manager.fridge.isEmpty {
                Button { withAnimation { manager.clearFridge() } } label: {
                    Text("Clear").font(.system(size: 13, weight: .semibold, design: .rounded)).foregroundStyle(Theme.danger)
                        .padding(.horizontal, 12).padding(.vertical, 6).background(Theme.danger.opacity(0.12), in: Capsule())
                }
            }
            Button { showCatalog = true } label: {
                Image(systemName: "plus").font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Theme.bg).frame(width: 40, height: 40)
                    .background(Theme.accent, in: Circle())
            }
        }
        .padding(.top, 8)
    }

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass").foregroundStyle(Theme.muted)
            TextField("Search ingredients...", text: $search)
                .font(.system(size: 14, design: .rounded)).foregroundStyle(Theme.text)
        }
        .padding(10).background(Theme.surface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private let cols = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

    private var fridgeGrid: some View {
        Group {
            if filteredFridge.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "refrigerator").font(.system(size: 36)).foregroundStyle(Theme.muted)
                    Text(manager.fridge.isEmpty ? "Your fridge is empty" : "No matches")
                        .font(.system(size: 14, design: .rounded)).foregroundStyle(Theme.sub)
                    if manager.fridge.isEmpty {
                        Text("Tap + to add ingredients").font(.system(size: 12, design: .rounded)).foregroundStyle(Theme.muted)
                    }
                }
                .frame(maxWidth: .infinity).padding(.vertical, 40).glowCard()
            } else {
                LazyVGrid(columns: cols, spacing: 10) {
                    ForEach(filteredFridge) { item in
                        VStack(spacing: 4) {
                            Text(item.emoji).font(.system(size: 28))
                            Text(item.name).font(.system(size: 11, weight: .semibold, design: .rounded))
                                .foregroundStyle(Theme.text).lineLimit(1).minimumScaleFactor(0.7)
                        }
                        .frame(maxWidth: .infinity).padding(.vertical, 12)
                        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Theme.card))
                        .onLongPressGesture { withAnimation { manager.removeFromFridge(item) } }
                    }
                }
            }
        }
    }
}

// MARK: - Catalog Sheet

struct CatalogSheet: View {
    @EnvironmentObject var manager: FridgeManager
    @Environment(\.dismiss) var dismiss
    @State private var selectedCat: IngCategory = .produce
    @State private var search = ""

    var filtered: [IngInfo] {
        let catItems = ingredientCatalog.filter { $0.cat == selectedCat }
        return search.isEmpty ? catItems : catItems.filter { $0.name.localizedCaseInsensitiveContains(search) }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(IngCategory.allCases) { cat in
                            Button { selectedCat = cat } label: {
                                HStack(spacing: 4) {
                                    Text(cat.emoji).font(.system(size: 12))
                                    Text(cat.name).font(.system(size: 12, weight: selectedCat == cat ? .bold : .medium, design: .rounded))
                                }
                                .foregroundStyle(selectedCat == cat ? Theme.bg : Theme.text)
                                .padding(.horizontal, 12).padding(.vertical, 8)
                                .background(selectedCat == cat ? Theme.accent : Theme.surface, in: Capsule())
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }

                let cols = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
                ScrollView {
                    LazyVGrid(columns: cols, spacing: 10) {
                        ForEach(filtered, id: \.name) { info in
                            let inFridge = manager.hasFridgeItem(info.name)
                            Button {
                                if inFridge {
                                    if let item = manager.fridge.first(where: { $0.name.lowercased() == info.name.lowercased() }) {
                                        withAnimation { manager.removeFromFridge(item) }
                                    }
                                } else {
                                    withAnimation { manager.addToFridge(info) }
                                }
                            } label: {
                                VStack(spacing: 4) {
                                    ZStack(alignment: .topTrailing) {
                                        Text(info.emoji).font(.system(size: 28))
                                        if inFridge {
                                            Image(systemName: "checkmark.circle.fill").font(.system(size: 14))
                                                .foregroundStyle(Theme.success).offset(x: 8, y: -4)
                                        }
                                    }
                                    Text(info.name).font(.system(size: 11, weight: .semibold, design: .rounded))
                                        .foregroundStyle(inFridge ? Theme.success : Theme.text)
                                        .lineLimit(1).minimumScaleFactor(0.7)
                                }
                                .frame(maxWidth: .infinity).padding(.vertical, 12)
                                .background(RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(inFridge ? Theme.success.opacity(0.12) : Theme.card))
                            }
                        }
                    }
                    .padding(.horizontal, 20).padding(.bottom, 30)
                }
            }
            .background(Theme.bg.ignoresSafeArea())
            .navigationTitle("Add Ingredients")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }.foregroundStyle(Theme.accent)
                }
            }
        }
    }
}
