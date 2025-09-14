//
//  ScheduleService.swift
//  travel_go
//
//  Created by Захар Панченко on 27.07.2025.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias ScheduleResponse = Components.Schemas.ScheduleResponse

actor ScheduleService: NetworkServiceProtocol {
    private let client: Client
    private let apiKey: String
    
    nonisolated init(client: Client = Client(serverURL: try! Servers.server1(), transport: URLSessionTransport()),
                    apiKey: String = APIKeys.yandexStationKey) {
        self.client = client
        self.apiKey = apiKey
    }
    
    func getStationSchedule(
        station: String,
        date: String? = nil,
        transportTypes: String? = nil,
        event: String? = nil,
        direction: String? = nil
    ) async throws -> ScheduleResponse {
        let response = try await client.getStationSchedule(
            query: .init(
                apikey: apiKey,
                station: station,
                date: date,
                transport_types: transportTypes,
                event: event,
                direction: direction
            )
        )
        return try response.ok.body.json
    }
    
    // MARK: - Protocol Stubs
    nonisolated func fetchCities() async throws -> [City] {
        throw NetworkError(message: "Not implemented in ScheduleService")
    }
    
    nonisolated func fetchStations(for city: String) async throws -> [Station] {
        throw NetworkError(message: "Not implemented in ScheduleService")
    }
    
    nonisolated func fetchCarrierInfo(code: String, system: String?) async throws -> Carrier {
        throw NetworkError(message: "Not implemented in ScheduleService")
    }
    
    nonisolated func fetchNearestCity(latitude: Double, longitude: Double, distance: Int?) async throws -> NearestCityResponse {
        throw NetworkError(message: "Not implemented in ScheduleService")
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
        throw NetworkError(message: "Not implemented in ScheduleService")
    }
}
