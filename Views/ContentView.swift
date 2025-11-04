// Views/ContentView.swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
            SearchView()
                .tabItem { Label("Zoeken", systemImage: "magnifyingglass") }
            CheatsheetsView()
                .tabItem { Label("Cheats", systemImage: "list.bullet.rectangle") }
            RatioCalculatorView()
                .tabItem { Label("Calc", systemImage: "function") }
            BookmarksView()
                .tabItem { Label("Favorieten", systemImage: "bookmark") }
        }
    }
}
