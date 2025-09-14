//
//  SearchService.swift
//  travel_go
//
//  Created by Захар Панченко on 27.07.2025.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias Segments = Components.Schemas.Segments

actor SearchService: NetworkServiceProtocol {
    private let client: Client
    private let apiKey: String
    
    nonisolated init(client: Client = Client(serverURL: try! Servers.server1(), transport: URLSessionTransport()),
                    apiKey: String = APIKeys.yandexStationKey) {
        self.client = client
        self.apiKey = apiKey
    }
    
    func getScheduleBetweenStations(
        from: String,
        to: String,
        date: String? = nil,
        lang: String? = nil,
        format: String? = nil,
        transportTypes: String? = nil,
        limit: Int? = nil,
        offset: Int? = nil,
        transfers: Bool? = nil
    ) async throws -> Segments {
        let response = try await client.getSchedualBetweenStations(
            query: .init(
                apikey: apiKey,
                from: from,
                to: to,
                format: format,
                lang: lang,
                date: date,
                transport_types: transportTypes,
                offset: offset,
                limit: limit,
                transfers: transfers
            )
        )
        return try response.ok.body.json
    }
    
    // MARK: - Protocol Stubs
    nonisolated func fetchCities() async throws -> [City] {
        throw NetworkError(message: "Not implemented in SearchService")
    }
    
    nonisolated func fetchStations(for city: String) async throws -> [Station] {
        throw NetworkError(message: "Not implemented in SearchService")
    }
    
    nonisolated func fetchCarrierInfo(code: String, system: String?) async throws -> Carrier {
        throw NetworkError(message: "Not implemented in SearchService")
    }
    
    nonisolated func fetchNearestCity(latitude: Double, longitude: Double, distance: Int?) async throws -> NearestCityResponse {
        throw NetworkError(message: "Not implemented in SearchService")
    }
}
