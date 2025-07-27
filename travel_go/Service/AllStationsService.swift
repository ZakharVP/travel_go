//
//  AllStationsService.swift
//  travel_go
//
//  Created by Захар Панченко on 27.07.2025.
//

import OpenAPIRuntime
import OpenAPIURLSession
import Foundation


typealias AllStationsResponse = Components.Schemas.AllStationsResponse

final class AllStationsService: AllStationsServiceProtocol {
    
    let client: Client
    let apiKey: String
    
    init(client: Client, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }
    
    func getAllStations() async throws -> AllStationsResponse {
       let response = try await client.getAllStations(query: .init(apikey: APIKeys.yandexStationKey))

       let responseBody = try response.ok.body.html

       let limit = 50 * 1024 * 1024 // 50Mb
       var fullData = try await Data(collecting: responseBody, upTo: limit)

       let allStations = try JSONDecoder().decode(AllStationsResponse.self, from: fullData)

       return allStations
    } 
}
