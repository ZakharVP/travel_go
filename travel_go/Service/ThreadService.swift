//
//  ThreadService.swift
//  travel_go
//
//  Created by Захар Панченко on 27.07.2025.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias ThreadStationsResponse = Components.Schemas.ThreadStationsResponse

final class ThreadService: NetworkServiceProtocol {
    
    let client: Client
    let apiKey: String
    
    init(client: Client, apiKey: String) {
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
}
