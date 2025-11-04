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
        items = await load("dump_items.json", fallback: "seed_items.json")
        recipes = await load("dump_recipes.json", fallback: "seed_recipes.json")
        techs = await load("dump_tech.json", fallback: "seed_tech.json")
        planets = await load("dump_planets.json", fallback: "seed_planets.json")
    }

    private func load<T: Decodable>(_ preferred: String, fallback: String) async -> T {
        if let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let preferredURL = docsURL.appendingPathComponent(preferred)
            if let data = try? Data(contentsOf: preferredURL),
               let decoded = try? JSONDecoder().decode(T.self, from: data) {
                return decoded
            }
        }
        guard let url = Bundle.main.url(forResource: fallback, withExtension: nil),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            fatalError("Kon \(preferred) of \(fallback) niet laden/decoderen")
        }
        return decoded
    }

    func item(by id: String) -> Item? { items.first { $0.id == id } }
    func recipe(by id: String) -> Recipe? { recipes.first { $0.id == id } }
    func tech(by id: String) -> Technology? { techs.first { $0.id == id } }
}
