import SwiftUI

struct CompareWithCheatsView: View {
    @EnvironmentObject var ds: DataService
    @StateObject private var cheats = CheatsheetEngine()
    @StateObject private var planner = PlannerEngine()

    var body: some View {
        List {
            Section("Samenvatting") {
                Text("Vergelijkt jouw plan-output met theoretische per-machine output (cheatsheet) en belt-capaciteit.")
            }
            Section("Jouw netto /min vs belt-capaciteit") {
                let blue = cheats.constants.beltItemsPerSec["blue"] ?? 45.0
                ForEach(Array(planner.totals.keys).sorted(), id: \.self) { k in
                    let perMin = planner.totals[k] ?? 0
                    let perSec = perMin / 60.0
                    HStack {
                        VStack(alignment: .leading) {
                            Text(ds.item(by: k)?.name ?? k)
                            Text(String(format: "%.1f/s (%.0f/min)", perSec, perMin)).font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        if abs(perSec) > blue {
                            Text("⚠︎ > blue")
                                .foregroundStyle(.orange)
                        } else {
                            Text("OK")
                                .foregroundStyle(.green)
                        }
                    }
                }
            }
            Section("Per recept: plan vs theoretisch per machine") {
                ForEach(planner.entries) { e in
                    if let r = ds.recipe(by: e.recipeId) {
                        let speed = cheats.constants.machineSpeeds[e.machineType] ?? 1.0
                        let out = r.outputs.first?.amount ?? 1.0
                        let theoryPerMinPerMachine = (60.0 / max(0.001, r.time)) * speed * out
                        let actualPerMinPerMachine = theoryPerMinPerMachine * e.speedMultiplier * e.prodMultiplier
                        VStack(alignment: .leading, spacing: 4) {
                            Text(r.name).font(.headline)
                            Text(String(format: "Theorie per %@: %.1f/min", e.machineType, theoryPerMinPerMachine)).font(.caption)
                            Text(String(format: "Jouw per machine (speed×prod): %.1f/min", actualPerMinPerMachine)).font(.caption)
                            if actualPerMinPerMachine < theoryPerMinPerMachine {
                                Text("🔧 Onder theoretisch (check modules/beacons/speed).").font(.caption2).foregroundStyle(.orange)
                            } else if actualPerMinPerMachine > theoryPerMinPerMachine {
                                Text("⚡ Boven basis: speed/productivity actief.").font(.caption2).foregroundStyle(.green)
                            }
                        }
                    }
                }
            }
            if !planner.hints.isEmpty {
                Section("Extra hints") {
                    ForEach(planner.hints, id: \.self, content: Text.init)
                }
            }
        }
        .onAppear {
            cheats.rebuild(using: ds.items, recipes: ds.recipes, techs: ds.techs)
            planner.configure(recipes: ds.recipes)
        }
        .navigationTitle("Vergelijking")
    }
}
