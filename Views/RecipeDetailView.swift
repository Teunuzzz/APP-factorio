// Views/RecipeDetailView.swift
import SwiftUI

struct RecipeDetailView: View {
    @EnvironmentObject var ds: DataService
    let recipe: Recipe
    @State private var targetPerMin: Double = 60
    
    var body: some View {
        Form {
            Section("Recept") {
                HStack { Text("Categorie"); Spacer(); Text(recipe.category) }
                HStack { Text("Machine");  Spacer(); Text(recipe.machine) }
                HStack { Text("Tijd (s)"); Spacer(); Text("\(recipe.time, specifier: "%.2f")") }
                if let notes = recipe.notes { Text(notes) }
            }
            Section("Ingrediënten (per craft)") {
                ForEach(recipe.inputs, id:\.self) { ing in
                    HStack {
                        Text(ds.item(by: ing.itemId)?.name ?? ing.itemId)
                        Spacer()
                        Text("× \(ing.amount.clean)")
                    }
                }
            }
            Section("Uitvoer (per craft)") {
                ForEach(recipe.outputs, id:\.self) { out in
                    HStack {
                        Text(ds.item(by: out.itemId)?.name ?? out.itemId)
                        Spacer()
                        Text("× \(out.amount.clean)")
                    }
                }
            }
            Section("Calculator") {
                Stepper(value: $targetPerMin, in: 1...10000, step: 1) {
                    HStack {
                        Text("Doel output (/min)")
                        Spacer()
                        Text(targetPerMin.clean)
                    }
                }
                let machines = Calculator.machinesNeeded(for: recipe, targetPerMin: targetPerMin)
                HStack { Text("Benodigde fabrieken"); Spacer(); Text(machines.clean) }
            }
        }
        .navigationTitle(recipe.name)
    }
}
