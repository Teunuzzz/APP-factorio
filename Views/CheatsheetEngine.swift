import Foundation

struct CheatsheetRow: Identifiable {
    var id: String { key }
    let key: String     // bijv. "Electronic Circuit"
    let value: String   // bijv. "150.0/min per assembling-3"
    let note: String?   // bijv. "time=0.5s, out=1"
    let numeric: Double? // ruwe waarde voor vergelijking (bijv. out/min per machine)
    let machine: String? // gebruikte machine
}

@MainActor
final class CheatsheetEngine: ObservableObject {
    @Published var constants = GameConstants()
    @Published var beltThroughputs: [CheatsheetRow] = []
    @Published var perMachineOutput: [CheatsheetRow] = []   // output/min per machine (eerste output)
    @Published var scienceUsage: [CheatsheetRow] = []

    func rebuild(using items: [Item], recipes: [Recipe], techs: [Technology]) {
        buildBelts()
        buildPerMachineOutput(recipes: recipes)
        buildScience(techs: techs, items: items)
    }

    private func buildBelts() {
        beltThroughputs = constants.beltItemsPerSec
            .map { (k, v) in
                CheatsheetRow(key: "Belt \(k)", value: String(format: "%.0f /s", v), note: nil, numeric: v, machine: nil)
            }
            .sorted { $0.key < $1.key }
    }

    private func buildPerMachineOutput(recipes: [Recipe]) {
        // Neem per recept: (60/time) * machineSpeed(machine) * firstOutputAmount
        var rows: [CheatsheetRow] = []
        for r in recipes {
            let m = r.machine
            let speed = constants.machineSpeeds[m] ?? 1.0
            guard let out = r.outputs.first?.amount else { continue }
            let craftsPerMin = (60.0 / max(0.001, r.time)) * speed
            let outPerMin = craftsPerMin * out
            rows.append(CheatsheetRow(
                key: r.name,
                value: String(format: "%.1f/min per %@", outPerMin, m),
                note: String(format: "t=%.2fs, out=%.2f", r.time, out),
                numeric: outPerMin,
                machine: m
            ))
        }
        perMachineOutput = rows.sorted { $0.key < $1.key }
    }

    private func buildScience(techs: [Technology], items: [Item]) {
        var freq: [String: Int] = [:]
        for t in techs {
            for id in t.sciencePacks {
                freq[id, default: 0] += 1
            }
        }
        let nameById = Dictionary(uniqueKeysWithValues: items.map { ($0.id, $0.name) })
        scienceUsage = freq.map { (k, v) in
            CheatsheetRow(key: nameById[k] ?? k, value: "\(v)× gebruikt", note: nil, numeric: Double(v), machine: nil)
        }.sorted { $0.key < $1.key }
    }
}
