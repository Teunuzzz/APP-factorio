// Views/PlanetListView.swift
import SwiftUI

struct PlanetListView: View {
    @EnvironmentObject var ds: DataService
    var body: some View {
        List(ds.planets) { p in
            NavigationLink(p.name, destination: PlanetDetailView(planet: p))
        }
        .navigationTitle("Planeten")
    }
}

struct PlanetDetailView: View {
    @EnvironmentObject var ds: DataService
    let planet: Planet
    var body: some View {
        List {
            if !planet.traits.isEmpty {
                Section("Eigenschappen") { ForEach(planet.traits, id:\.self, content: Text.init) }
            }
            if !planet.hazards.isEmpty {
                Section("Gevaren") { ForEach(planet.hazards, id:\.self, content: Text.init) }
            }
            if !planet.uniqueResources.isEmpty {
                Section("Unieke grondstoffen") {
                    ForEach(planet.uniqueResources, id:\.self) { id in
                        Text(ds.item(by: id)?.name ?? id)
                    }
                }
            }
            if let n = planet.notes { Section("Notities") { Text(n) } }
        }
        .navigationTitle(planet.name)
    }
}
