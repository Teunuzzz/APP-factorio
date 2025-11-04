// FactorioCompanionApp.swift
import SwiftUI

@main
struct FactorioCompanionApp: App {
    @StateObject private var dataService = DataService()
    @StateObject private var bookmarks = BookmarkStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataService)
                .environmentObject(bookmarks)
        }
    }
}
