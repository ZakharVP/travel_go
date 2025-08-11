//
//  CopyrightService.swift
//  travel_go
//
//  Created by Захар Панченко on 27.07.2025.
//

import OpenAPIRuntime
import OpenAPIURLSession

final class CopyrightService: CopyrightServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apiKey: String) {
        self.client = client
        self.apikey = apiKey
    }
    
    func getCopyrightInfo() async throws -> String {
        let response = try await client.getCopyrightInfo(
            query: .init(
                apikey: apikey
            )
        )

        let copyrightResponse = try response.ok.body.json
        return copyrightResponse.copyright?.text ?? "Текст копирайта по умолчанию"
    }
}
