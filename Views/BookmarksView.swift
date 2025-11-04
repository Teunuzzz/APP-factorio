// Views/BookmarksView.swift
import SwiftUI

struct BookmarksView: View {
    @EnvironmentObject var ds: DataService
    @EnvironmentObject var bm: BookmarkStore
    
    var bookmarkedItems: [Item] {
        ds.items.filter { bm.contains($0.id) }
    }
    
    var body: some View {
        List {
            if bookmarkedItems.isEmpty {
                Text("Nog geen favorieten. Open een item en tik op het bladwijzer-icoon.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(bookmarkedItems) { item in
                    NavigationLink(item.name, destination: ItemDetailView(item: item))
                }
            }
        }
        .navigationTitle("Favorieten")
    }
}
