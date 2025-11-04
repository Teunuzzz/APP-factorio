// Views/HomeView.swift
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var ds: DataService
    
    var body: some View {
        NavigationStack {
            List {
                Section("Snelle toegang") {
                    NavigationLink("Items", destination: ItemList())
                    NavigationLink("Recepten", destination: RecipeListView())
                    NavigationLink("Technologie", destination: TechListView())
                    NavigationLink("Planeten (Space Age)", destination: PlanetListView())
                }
                Section("Handig") {
                    NavigationLink("Cheatsheets", destination: CheatsheetsView())
                    NavigationLink("Ratio Calculator", destination: RatioCalculatorView())
                    NavigationLink("Main Bus Planner", destination: BusPlannerView())
                }
            }
            .navigationTitle("Factorio Companion")
        }
    }
}

struct ItemList: View {
    @EnvironmentObject var ds: DataService
    var body: some View {
        List(ds.items) { item in
            NavigationLink(item.name, destination: ItemDetailView(item: item))
        }
        .navigationTitle("Items")
    }
}
