//
//  Untitled.swift
//  travel_go
//
//  Created by Захар Панченко on 20.08.2025.
//

struct City: Codable, Identifiable, Sendable, Hashable {
    let id: String
    let name: String
    let country: String
    var stations: [Station]?
    
    init(id: String, name: String, country: String, stations: [Station]? = nil) {
        self.id = id
        self.name = name
        self.country = country
        self.stations = stations
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: City, rhs: City) -> Bool {
        lhs.id == rhs.id
    }
}
