import Foundation

struct GameConstants: Codable {
    // Editable defaults (pas aan naar jouw balans/modset indien nodig)
    var beltItemsPerSec: [String: Double] = [
        "yellow": 15.0,
        "red": 30.0,
        "blue": 45.0
    ]
    // Benaderende crafting speeds per machine-type (kun je finetunen)
    var machineSpeeds: [String: Double] = [
        "stone-furnace": 1.0,
        "steel-furnace": 2.0,
        "electric-furnace": 2.0,
        "assembling-1": 0.5,
        "assembling-2": 0.75,
        "assembling-3": 1.25,
        "chem-plant": 1.0,
        "oil-refinery": 1.0,
        "space-assembler": 1.0
    ]
    // Conservatieve inserter doorvoer (items/s) – situatie-afhankelijk
    var inserterItemsPerSec: [String: Double] = [
        "inserter": 0.84,
        "long-handed-inserter": 0.6,
        "fast-inserter": 1.8,
        "stack-inserter": 5.0
    ]
}
