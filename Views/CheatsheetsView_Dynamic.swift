import SwiftUI

struct CheatsheetsViewDynamic: View {
    @EnvironmentObject var ds: DataService
    @StateObject private var engine = CheatsheetEngine()

    var body: some View {
        List {
            if !engine.beltThroughputs.isEmpty {
                Section("Belt doorvoer (items/s)") {
                    ForEach(engine.beltThroughputs) { row in
                        HStack { Text(row.key.capitalized); Spacer(); Text(row.value) }
                    }
                }
            }
            if !engine.perMachineOutput.isEmpty {
                Section("Output per machine (auto)") {
                    ForEach(engine.perMachineOutput) { row in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(row.key)
                            HStack {
                                Text(row.value).font(.callout)
                                Spacer()
                                if let note = row.note { Text(note).font(.caption).foregroundStyle(.secondary) }
                            }
                        }
                    }
                }
            }
            if !engine.scienceUsage.isEmpty {
                Section("Science packs (gebruik in tech)") {
                    ForEach(engine.scienceUsage) { row in
                        HStack { Text(row.key); Spacer(); Text(row.value) }
                    }
                }
            }
        }
        .onAppear { engine.rebuild(using: ds.items, recipes: ds.recipes, techs: ds.techs) }
        .onChange(of: ds.items.count) { _ in engine.rebuild(using: ds.items, recipes: ds.recipes, techs: ds.techs) }
        .onChange(of: ds.recipes.count) { _ in engine.rebuild(using: ds.items, recipes: ds.recipes, techs: ds.techs) }
        .onChange(of: ds.techs.count) { _ in engine.rebuild(using: ds.items, recipes: ds.recipes, techs: ds.techs) }
        .navigationTitle("Cheatsheets (auto)")
    }
}
