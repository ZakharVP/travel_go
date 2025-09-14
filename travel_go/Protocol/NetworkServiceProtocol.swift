//
//  NetworkServiceProtocol.swift
//  travel_go
//
//  Created by Захар Панченко on 27.07.2025.
//

import OpenAPIRuntime

protocol NetworkServiceProtocol: Sendable {
    // Города и станции
    func fetchCities() async throws -> [City]
    func fetchStations(for city: String) async throws -> [Station]

    // Перевозчики
    func fetchCarrierInfo(code: String, system: String?) async throws -> Carrier

    // Ближайший город
    func fetchNearestCity(latitude: Double, longitude: Double, distance: Int?)
        async throws -> NearestCityResponse

    func getScheduleBetweenStations(
        from: String,
        to: String,
        date: String?,
        lang: String?,
        format: String?,
        transportTypes: String?,
        limit: Int?,
        offset: Int?,
        transfers: Bool?
    ) async throws -> Segments
}
