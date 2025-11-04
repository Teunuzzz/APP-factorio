import Foundation

struct PlanEntry: Identifiable, Hashable {
    let id = UUID()
    var recipeId: String
    var machineType: String
    var machines: Double
    var speedMultiplier: Double // modules/beacons, etc.
    var prodMultiplier: Double  // productivity effect (>=1.0)
}

@MainActor
final class PlannerEngine: ObservableObject {
    @Published var entries: [PlanEntry] = []
    @Published var totals: [String: Double] = [:] // itemId -> net /min
    @Published var hints: [String] = []

    var constants = GameConstants()
    var recipes: [Recipe] = []

    func configure(recipes: [Recipe]) {
        self.recipes = recipes
    }

    func recalc() {
        var net: [String: Double] = [:]
        for e in entries {
            guard let r = recipes.first(where: { $0.id == e.recipeId }) else { continue }
            let baseSpeed = constants.machineSpeeds[e.machineType] ?? 1.0
            let craftsPerMin = (60.0 / max(0.001, r.time)) * baseSpeed * e.speedMultiplier * max(0.0, e.machines)
            for ing in r.inputs {
                net[ing.itemId, default: 0.0] -= ing.amount * craftsPerMin
            }
            for out in r.outputs {
                net[out.itemId, default: 0.0] += out.amount * craftsPerMin * e.prodMultiplier
            }
        }
        totals = net
        buildHints()
    }

    private func buildHints() {
        var h: [String] = []
        let blue = constants.beltItemsPerSec["blue"] ?? 45.0
        // Hint 1: Doorvoer > blue belt
        for (item, perMin) in totals {
            let perSec = perMin / 60.0
            if abs(perSec) > blue {
                h.append("⚠︎ \(item): \(String(format: "%.1f", abs(perSec))) /s > blue belt (\(Int(blue))/s). Overweeg extra lanes of trains.")
            }
        }
        // Hint 2: Onbalans input/output
        // (Als er consumptie is zonder productie in plan, highlight)
        for (item, perMin) in totals where perMin < 0 {
            h.append("🔧 Tekort aan \(item): \(String(format: "%.1f", -perMin))/min. Voeg productie toe of verlaag verbruik.")
        }
        // Hint 3: Overproductie
        for (item, perMin) in totals where perMin > 0 {
            if perMin > 0 {
                h.append("📦 Overproductie \(item): \(String(format: "%.1f", perMin))/min. Buffers of lagere aantallen overwegen.")
            }
        }
        // (Je kunt nog meer hints maken op basis van inserter-capaciteit, preferred machine, etc.)
        // Dedup simple
        hints = Array(Set(h)).sorted()
    }
}
