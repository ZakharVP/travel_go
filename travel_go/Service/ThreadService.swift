//
//  ThreadService.swift
//  travel_go
//
//  Created by Захар Панченко on 27.07.2025.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias ThreadStationsResponse = Components.Schemas.ThreadStationsResponse

actor ThreadService: NetworkServiceProtocol {
    private let client: Client
    private let apiKey: String
    
    nonisolated init(client: Client = Client(serverURL: try! Servers.server1(), transport: URLSessionTransport()),
                    apiKey: String = APIKeys.yandexStationKey) {
        self.client = client
        self.apiKey = apiKey
    }
    
    func getRouteStations(
        uid: String,
        from: String? = nil,
        to: String? = nil,
        date: String? = nil,
        format: String? = "json",
        lang: String? = "ru_RU",
        show_systems: String? = "all"
    ) async throws -> ThreadStationsResponse {
        let response = try await client.getRouteStations(
            query: .init(
                apikey: apiKey,
                uid: uid,
                from: from,
                to: to,
                format: format,
                lang: lang,
                date: date,
                show_systems: show_systems
            )
        )
        return try response.ok.body.json
    }
    
    // MARK: - Protocol Stubs
    nonisolated func fetchCities() async throws -> [City] {
        throw NetworkError(message: "Not implemented in ThreadService")
    }
    
    nonisolated func fetchStations(for city: String) async throws -> [Station] {
        throw NetworkError(message: "Not implemented in ThreadService")
    }
    
    nonisolated func fetchCarrierInfo(code: String, system: String?) async throws -> Carrier {
        throw NetworkError(message: "Not implemented in ThreadService")
    }
    
    nonisolated func fetchNearestCity(latitude: Double, longitude: Double, distance: Int?) async throws -> NearestCityResponse {
        throw NetworkError(message: "Not implemented in ThreadService")
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
        throw NetworkError(message: "Not implemented in ThreadService")
    }
}

