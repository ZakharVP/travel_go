//
//  NearestStationsServiceProtocol.swift
//  travel_go
//
//  Created by Захар Панченко on 26.07.2025.
//

import OpenAPIRuntime

protocol NearestStationsServiceProtocol {
    func getNearestStations(
        latitude: Double,
        longitude: Double,
        distance: Int,
        lang: String?,
        format: String?,
        stationTypes: String?,
        transportTypes: String?,
        offset: Int?,
        limit: Int?
    ) async throws -> NearestStations
}
