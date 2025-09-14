//
//  Country.swift
//  travel_go
//
//  Created by Захар Панченко on 14.09.2025.
//

struct Country: Codable, Sendable {
    let title: String
    let regions: [Region]
}
