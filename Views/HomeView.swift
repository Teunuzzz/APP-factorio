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
                    NavigationLink("Cheatsheets (auto)", destination: CheatsheetsView_Dynamic())
                    NavigationLink("Factory Planner", destination: FactoryPlannerView())
                    NavigationLink("Vergelijking", destination: CompareWithCheatsView())
                    
                }
                Section("Handig") {
                    NavigationLink("Cheatsheets", destination: CheatsheetsView())
                    NavigationLink("Ratio Calculator", destination: RatioCalculatorView())
                    NavigationLink("Main Bus Planner", destination: BusPlannerView())
                    NavigationLink("Import JSON", destination: ImportView())
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
