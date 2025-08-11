//
//  SearchService.swift
//  travel_go
//
//  Created by Захар Панченко on 27.07.2025.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias Segments = Components.Schemas.Segments

final class SearchService: NetworkServiceProtocol {
    
    let client: Client
    let apiKey: String
    
    init(client: Client, apiKey: String) {
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
}
