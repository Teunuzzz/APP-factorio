// Utils/Formatting.swift
import Foundation

extension Double {
    var clean: String {
        let v = self
        if v.rounded() == v { return String(format: "%.0f", v) }
        return String(format: "%.2f", v)
    }
}
