//
//  Station.swift
//  travel_go
//
//  Created by Захар Панченко on 20.08.2025.
//

import SwiftUI

struct Station: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let code: String
}
