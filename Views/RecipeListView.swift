// Views/RecipeListView.swift
import SwiftUI

struct RecipeListView: View {
    @EnvironmentObject var ds: DataService
    
    var body: some View {
        List(ds.recipes) { r in
            NavigationLink(r.name, destination: RecipeDetailView(recipe: r))
        }
        .navigationTitle("Recepten")
    }
}
