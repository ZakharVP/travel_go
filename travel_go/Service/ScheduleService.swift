//
//  ScheduleService.swift
//  travel_go
//
//  Created by Захар Панченко on 27.07.2025.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias ScheduleResponse = Components.Schemas.ScheduleResponse

final class ScheduleService: NetworkServiceProtocol {
    
    let client: Client
    let apiKey: String
    
    init(client: Client, apiKey: String) {
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
}
