// Views/ItemDetailView.swift
import SwiftUI

struct ItemDetailView: View {
    @EnvironmentObject var ds: DataService
    @EnvironmentObject var bm: BookmarkStore
    let item: Item
    
    var usedIn: [Recipe] { ds.recipes.filter { r in r.inputs.contains { $0.itemId == item.id } } }
    var produces: [Recipe] { ds.recipes.filter { r in r.outputs.contains { $0.itemId == item.id } } }
    
    var body: some View {
        List {
            Section {
                Text(item.description ?? "Geen beschrijving").fixedSize(horizontal: false, vertical: true)
            }
            Section("Gemaakt door") {
                ForEach(produces) { r in
                    NavigationLink(r.name, destination: RecipeDetailView(recipe: r))
                }
            }
            Section("Gebruikt in") {
                ForEach(usedIn) { r in
                    NavigationLink(r.name, destination: RecipeDetailView(recipe: r))
                }
            }
        }
        .navigationTitle(item.name)
        .toolbar {
            Button {
                bm.toggle(item.id)
            } label: {
                Image(systemName: bm.contains(item.id) ? "bookmark.fill" : "bookmark")
            }
        }
    }
}
