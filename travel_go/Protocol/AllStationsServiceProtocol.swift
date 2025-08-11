//
//  AllStationsServiceProtocol.swift
//  travel_go
//
//  Created by Захар Панченко on 27.07.2025.
//

protocol AllStationsServiceProtocol {
    func getAllStations() async throws -> AllStationsResponse
}
