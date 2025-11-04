import SwiftUI
import UniformTypeIdentifiers

struct ImportView: View {
    @EnvironmentObject var ds: DataService
    @State private var showImporter = false
    @State private var lastImportMessage: String = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Importeer dump_*.json vanuit de Bestanden-app").font(.headline)
            Text("Kies één of meer JSON's: dump_items.json, dump_recipes.json, dump_tech.json, dump_planets.json")
                .font(.caption).foregroundStyle(.secondary).multilineTextAlignment(.center)
            Button("Kies bestanden…") { showImporter = true }
            if !lastImportMessage.isEmpty {
                Text(lastImportMessage).font(.footnote).foregroundStyle(.secondary).multilineTextAlignment(.center)
            }
            Spacer()
        }
        .padding()
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.json], allowsMultipleSelection: true) { result in
            switch result {
            case .success(let urls):
                var ok = 0
                for url in urls {
                    if importToDocuments(url: url) { ok += 1 }
                }
                lastImportMessage = "Geïmporteerd: \(ok)/\(urls.count). Herstart app om te laden."
            case .failure(let err):
                lastImportMessage = "Fout bij import: \(err.localizedDescription)"
            }
        }
        .navigationTitle("Import JSON")
    }

    private func importToDocuments(url: URL) -> Bool {
        do {
            let fm = FileManager.default
            let docs = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dest = docs.appendingPathComponent(url.lastPathComponent)
            if fm.fileExists(atPath: dest.path) { try fm.removeItem(at: dest) }
            try fm.copyItem(at: url, to: dest)
            return true
        } catch {
            return false
        }
    }
}

extension UTType {
    static var json: UTType { UTType(importedAs: "public.json") }
}
