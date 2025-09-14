//
//  StationResponse.swift
//  travel_go
//
//  Created by Захар Панченко on 14.09.2025.
//

struct StationResponse: Codable, Sendable {
    let direction: String?
    let codes: [String: String]?
    let stationType: String?
    let title: String
    let longitude: Double?
    let transportType: String?
    let latitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case direction, codes, title, longitude, latitude
        case stationType = "station_type"
        case transportType = "transport_type"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        direction = try container.decodeIfPresent(String.self, forKey: .direction)
        codes = try container.decodeIfPresent([String: String].self, forKey: .codes)
        stationType = try container.decodeIfPresent(String.self, forKey: .stationType)
        title = try container.decode(String.self, forKey: .title)
        transportType = try container.decodeIfPresent(String.self, forKey: .transportType)
        
        // Более простая обработка координат
        latitude = try? container.decode(Double.self, forKey: .latitude)
        longitude = try? container.decode(Double.self, forKey: .longitude)
    }
}

