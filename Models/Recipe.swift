// Models/Recipe.swift
import Foundation

struct Ingredient: Codable, Hashable {
    let itemId: String
    let amount: Double
}

struct Recipe: Identifiable, Codable, Hashable {
    let id: String            // "iron-plate-smelting"
    let name: String
    let category: String      // "smelting","crafting","chemistry","space"
    let inputs: [Ingredient]
    let outputs: [Ingredient]
    let time: Double          // sec per craft
    let machine: String       // "stone-furnace","assembling-1","chem-plant","space-assembler"
    let notes: String?
}
