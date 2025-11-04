import SwiftUI

struct FactoryPlannerView: View {
    @EnvironmentObject var ds: DataService
    @StateObject private var engine = PlannerEngine()

    @State private var newRecipeId: String = ""
    @State private var newMachineType: String = "assembling-1"
    @State private var newMachines: Double = 1
    @State private var newSpeed: Double = 1.0
    @State private var newProd: Double = 1.0

    var body: some View {
        Form {
            Section("Voeg toe aan plan") {
                Picker("Recept", selection: $newRecipeId) {
                    Text("Kies…").tag("")
                    ForEach(ds.recipes) { r in
                        Text(r.name).tag(r.id)
                    }
                }
                Picker("Machine", selection: $newMachineType) {
                    ForEach(Array(engine.constants.machineSpeeds.keys).sorted(), id: \.self) { m in
                        Text(m).tag(m)
                    }
                }
                Stepper(value: $newMachines, in: 0...2000, step: 1) {
                    HStack { Text("Aantal machines"); Spacer(); Text("\(Int(newMachines))") }
                }
                HStack { Text("Speed multiplier"); Spacer(); TextField("1.0", value: $newSpeed, format: .number).keyboardType(.decimalPad).multilineTextAlignment(.trailing) }
                HStack { Text("Productivity multiplier"); Spacer(); TextField("1.0", value: $newProd, format: .number).keyboardType(.decimalPad).multilineTextAlignment(.trailing) }
                Button("Toevoegen") {
                    guard !newRecipeId.isEmpty else { return }
                    engine.entries.append(PlanEntry(recipeId: newRecipeId, machineType: newMachineType, machines: newMachines, speedMultiplier: newSpeed, prodMultiplier: newProd))
                    engine.recalc()
                }
            }
            if !engine.entries.isEmpty {
                Section("Planregels") {
                    ForEach(engine.entries) { e in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(ds.recipe(by: e.recipeId)?.name ?? e.recipeId).font(.headline)
                            Text("Machine: \(e.machineType) • aantal: \(Int(e.machines)) • speed: \(e.speedMultiplier.clean) • prod: \(e.prodMultiplier.clean)")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                    }
                    .onDelete { i in
                        engine.entries.remove(atOffsets: i)
                        engine.recalc()
                    }
                }
                Section("Netto stroom (/min)") {
                    let keys = engine.totals.keys.sorted()
                    ForEach(keys, id: \.self) { k in
                        HStack {
                            Text(ds.item(by: k)?.name ?? k)
                            Spacer()
                            let v = engine.totals[k] ?? 0
                            Text(v.clean + "/min")
                                .foregroundStyle(v >= 0 ? .green : .red)
                        }
                    }
                }
                if !engine.hints.isEmpty {
                    Section("Hints & mogelijke bottlenecks") {
                        ForEach(engine.hints, id: \.self, content: Text.init)
                    }
                }
            } else {
                Section {
                    Text("Voeg één of meer regels toe om je fabriek te simuleren (x van dit, y van dat).")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .onAppear {
            engine.configure(recipes: ds.recipes)
        }
        .navigationTitle("Factory Planner")
    }
}

private extension Double {
    var clean: String {
        if self.rounded() == self { return String(format: "%.0f", self) }
        return String(format: "%.2f", self)
    }
}
