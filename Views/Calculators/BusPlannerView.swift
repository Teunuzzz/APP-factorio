// Views/Calculators/BusPlannerView.swift
import SwiftUI

struct BusPlannerView: View {
    @State private var greenPerMin: Double = 1800 // voorbeeld
    var yellowBeltsNeeded: Double { greenPerMin / 900.0 } // 900/min = 15/s
    var redBeltsNeeded: Double    { greenPerMin / 1800.0 }
    var blueBeltsNeeded: Double   { greenPerMin / 2700.0 }
    
    var body: some View {
        Form {
            Section("Doorvoer") {
                HStack { Text("Green circuits / min"); Spacer()
                    TextField("0", value: $greenPerMin, format: .number).multilineTextAlignment(.trailing).keyboardType(.numberPad)
                }
            }
            Section("Benodigde belt-lanes") {
                LabeledContent("Yellow (~900/min)", value: yellowBeltsNeeded.clean)
                LabeledContent("Red (~1800/min)", value: redBeltsNeeded.clean)
                LabeledContent("Blue (~2700/min)", value: blueBeltsNeeded.clean)
            }
        }
        .navigationTitle("Main Bus Planner")
    }
}
