//
//  SettlementService.swift
//  travel_go
//
//  Created by Захар Панченко on 27.07.2025.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestCityResponse = Components.Schemas.NearestCityResponse

final class SettlementService: NetworkServiceProtocol {
    
    let client: Client
    let apiKey: String
    
    init(client: Client, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }
    
    func getNearestCity(
        latitude: Double,
        longitude: Double,
        distance: Int? = nil
    ) async throws -> NearestCityResponse {
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
}
