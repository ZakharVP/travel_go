//
//  Carrier.swift
//  travel_go
//
//  Created by Захар Панченко on 20.08.2025.
//

import SwiftUI

struct MockCarrier: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let duration: String
}

let mockCarriers = [
    MockCarrier(name: "РЖД", price: 1500, duration: "4ч 30м"),
    MockCarrier(name: "Аэроэкспресс", price: 500, duration: "35м"),
    MockCarrier(name: "Самолет", price: 3500, duration: "1ч 15м")
]
