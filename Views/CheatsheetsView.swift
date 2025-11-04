// Views/CheatsheetsView.swift
import SwiftUI

struct CheatsheetsView: View {
    var body: some View {
        List {
            Section("Belt doorvoer (items/s)") {
                Label("Yellow belt ≈ 15/s", systemImage: "bolt")
                Label("Red belt ≈ 30/s", systemImage: "bolt")
                Label("Blue belt ≈ 45/s", systemImage: "bolt")
            }
            Section("Inserter tips") {
                Text("Long-handed is trager; stack size en stack bonus tellen bij stack inserters.")
            }
            Section("Power") {
                Text("1 Boiler → 1 Steam Engine (oude), check 2.0-balans per map; solar ’s nachts 0 output.")
            }
            Section("Space Age hints") {
                Text("Fulgora: stormen → stroompieken; Vulcanus: lava-warmte; Gleba: organics; Aquilo: ijs en cryo-ketens.")
            }
            Section("Blueprint tips") {
                Text("Main bus: ijzer, koper, green circuits, staal, plastic, batterij, low-density, red/blue circuits.")
            }
        }
        .navigationTitle("Cheatsheets")
    }
}
