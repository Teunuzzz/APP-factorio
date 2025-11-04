// Views/TechListView.swift
import SwiftUI

struct TechListView: View {
    @EnvironmentObject var ds: DataService
    var body: some View {
        List(ds.techs) { t in
            NavigationLink(t.name, destination: TechDetailView(tech: t))
        }
        .navigationTitle("Technologie")
    }
}

struct TechDetailView: View {
    @EnvironmentObject var ds: DataService
    let tech: Technology
    var body: some View {
        List {
            if let desc = tech.description { Text(desc) }
            Section("Science packs") {
                ForEach(tech.sciencePacks, id:\.self) { id in
                    Text(ds.item(by: id)?.name ?? id)
                }
            }
            if !tech.prerequisites.isEmpty {
                Section("Vereisten") { ForEach(tech.prerequisites, id:\.self, content: Text.init) }
            }
            if !tech.effects.isEmpty {
                Section("Effecten") { ForEach(tech.effects, id:\.self, content: Text.init) }
            }
        }
        .navigationTitle(tech.name + (tech.isSpaceAge ? " 🚀" : ""))
    }
}
