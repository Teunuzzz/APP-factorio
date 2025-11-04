// Utils/BookmarkStore.swift
import Foundation

final class BookmarkStore: ObservableObject {
    @Published private(set) var ids: Set<String>
    init() {
        if let data = UserDefaults.standard.array(forKey: "bookmarks") as? [String] {
            ids = Set(data)
        } else { ids = [] }
    }
    func toggle(_ id: String) {
        if ids.contains(id) { ids.remove(id) } else { ids.insert(id) }
        UserDefaults.standard.set(Array(ids), forKey: "bookmarks")
        objectWillChange.send()
    }
    func contains(_ id: String) -> Bool { ids.contains(id) }
}
