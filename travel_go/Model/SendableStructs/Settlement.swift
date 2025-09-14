//
//  Untitled.swift
//  travel_go
//
//  Created by Захар Панченко on 14.09.2025.
//

struct Settlement: Codable, Sendable {
    let title: String
    let codes: [String: String]?
    let stations: [StationResponse]
}

