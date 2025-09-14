//
//  SettlementService.swift
//  travel_go
//
//  Created by Захар Панченко on 27.07.2025.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestCityResponse = Components.Schemas.NearestCityResponse

actor SettlementService: NetworkServiceProtocol {
    private let client: Client
    private let apiKey: String
    
    nonisolated init(client: Client = Client(serverURL: try! Servers.server1(), transport: URLSessionTransport()),
                    apiKey: String = APIKeys.yandexStationKey) {
        self.client = client
        self.apiKey = apiKey
    }
    
    func fetchNearestCity(latitude: Double, longitude: Double, distance: Int? = nil) async throws -> NearestCityResponse {
        let response = try await client.getNearestCity(
            query: .init(
                apikey: apiKey,
                lat: latitude,
                lng: longitude,
                distance: distance
            )
        )
        return try response.ok.body.json
    }
    
    // MARK: - Protocol Stubs (не используются в этом сервисе)
    nonisolated func fetchCities() async throws -> [City] {
        throw NetworkError(message: "Not implemented in SettlementService")
    }
    
    nonisolated func fetchStations(for city: String) async throws -> [Station] {
        throw NetworkError(message: "Not implemented in SettlementService")
    }
    
    nonisolated func fetchCarrierInfo(code: String, system: String?) async throws -> Carrier {
        throw NetworkError(message: "Not implemented in SettlementService")
    }
    
    nonisolated func getScheduleBetweenStations(
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
        throw NetworkError(message: "Not implemented in SettlementService")
    }
}
