// Data/DataService.swift
import Foundation

@MainActor
final class DataService: ObservableObject {
    @Published var items: [Item] = []
    @Published var recipes: [Recipe] = []
    @Published var techs: [Technology] = []
    @Published var planets: [Planet] = []
    
    init() {
        Task { await loadAll() }
    }
    
    func loadAll() async {
        items = await load("seed_items.json")
        recipes = await load("seed_recipes.json")
        techs = await load("seed_tech.json")
        planets = await load("seed_planets.json")
    }
    
    private func load<T: Decodable>(_ filename: String) async -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            fatalError("Kon \(filename) niet laden of decoderen")
        }
        return decoded
    }
    
    func item(by id: String) -> Item? { items.first { $0.id == id } }
    func recipe(by id: String) -> Recipe? { recipes.first { $0.id == id } }
    func tech(by id: String) -> Technology? { techs.first { $0.id == id } }
}
