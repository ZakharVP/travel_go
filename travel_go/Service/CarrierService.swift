//
//  CarrierService.swift
//  travel_go
//
//  Created by Захар Панченко on 27.07.2025.
//


import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

struct CustomCarrierResponse: Codable {
    let carrier: Carrier
}

struct Carrier: Codable {
    let code: Int
    let title: String
    let codes: CarrierCodes
    let address: String?
    let url: String?
    let email: String?
    let contacts: String?
    let phone: String?
    let logo: String?
}

struct CarrierCodes: Codable {
    let sirena: String?
    let iata: String
    let icao: String
}

final class CarrierService: NetworkServiceProtocol {
    
    let client: Client
    let apiKey: String
    
    init(client: Client, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }
    
    func getCarrierInfo(
        code: String,
        system: String? = nil
    ) async throws -> Carrier {
        let urlString = "https://api.rasp.yandex.net/v3.0/carrier/?format=json&apikey=\(apiKey)&lang=ru_RU&code=\(code)&system=\(system ?? "")"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let response = try JSONDecoder().decode(CustomCarrierResponse.self, from: data)
            return response.carrier
        } catch {
            print("Decoding error: \(error)")
            throw error
        }
    }
}
