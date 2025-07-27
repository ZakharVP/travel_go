//
//  NearestStationsService+Ext.swift
//  travel_go
//
//  Created by Захар Панченко on 27.07.2025.
//

extension NearestStationsServiceProtocol {
    
    func getNearestStations(
        latitude: Double,
        longitude: Double,
        distance: Int
    ) async throws -> NearestStations {
        try await getNearestStations(
            latitude: latitude,
            longitude: longitude,
            distance: distance,
            lang: nil,
            format: nil,
            stationTypes: nil,
            transportTypes: nil,
            offset: nil,
            limit: nil
        )
    }
    
}
