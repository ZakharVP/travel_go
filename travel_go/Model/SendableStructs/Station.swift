//
//  Station.swift
//  travel_go
//
//  Created by Захар Панченко on 20.08.2025.
//

struct Station: Codable, Identifiable, Sendable, Hashable {
    let id: String
    let name: String
    let city: String?
    let country: String?
    let latitude: Double?
    let longitude: Double?
    let code: String?
    let transportType: String?
    let stationType: String?
    
    init(id: String, name: String, city: String? = nil, country: String? = nil,
         latitude: Double? = nil, longitude: Double? = nil, code: String? = nil,
         transportType: String? = nil, stationType: String? = nil) {
        self.id = id
        self.name = name
        self.city = city
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.code = code
        self.transportType = transportType
        self.stationType = stationType
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Station, rhs: Station) -> Bool {
        lhs.id == rhs.id
    }
}
