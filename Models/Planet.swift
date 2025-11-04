// Models/Planet.swift
import Foundation

struct Planet: Identifiable, Codable, Hashable {
    let id: String           // "fulgora"
    let name: String         // "Fulgora"
    let traits: [String]     // bulletpoints
    let hazards: [String]
    let uniqueResources: [String] // item ids
    let notes: String?
}
