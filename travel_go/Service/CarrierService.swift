//
//  CarrierService.swift
//  travel_go
//
//  Created by Захар Панченко on 27.07.2025.
//


import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

struct CustomCarrierResponse: Codable, Sendable {
    let carrier: Carrier
}

struct Carrier: Identifiable, Codable, Sendable {
    let id: String
    let title: String
    let price: Double?
    let duration: String?
    let departureTime: String?
    let arrivalTime: String?
    let transportType: String?
    
    // Остальные поля как опциональные с значениями по умолчанию
    let code: Int?
    let codes: CarrierCodes?
    let address: String?
    let url: String?
    let email: String?
    let contacts: String?
    let phone: String?
    let logo: String?
    
    init(
        id: String,
        code: Int? = nil,
        title: String,
        codes: CarrierCodes? = nil,
        address: String? = nil,
        url: String? = nil,
        email: String? = nil,
        contacts: String? = nil,
        phone: String? = nil,
        logo: String? = nil,
        price: Double? = nil,
        duration: String? = nil,
        departureTime: String? = nil,
        arrivalTime: String? = nil,
        transportType: String? = nil
    ) {
        self.id = id
        self.code = code
        self.title = title
        self.codes = codes
        self.address = address
        self.url = url
        self.email = email
        self.contacts = contacts
        self.phone = phone
        self.logo = logo
        self.price = price
        self.duration = duration
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.transportType = transportType
    }
    
    var name: String { title }
}

actor CarrierService: NetworkServiceProtocol {
    private let client: Client
    private let apiKey: String
    
    nonisolated init(client: Client = Client(serverURL: try! Servers.server1(), transport: URLSessionTransport()),
                    apiKey: String = APIKeys.yandexStationKey) {
        self.client = client
        self.apiKey = apiKey
    }
    
    func fetchCarrierInfo(code: String, system: String? = nil) async throws -> Carrier {
        let systemParam = system ?? "iata"
        let urlString = "https://api.rasp.yandex.net/v3.0/carrier/?format=json&apikey=\(apiKey)&lang=ru_RU&code=\(code)&system=\(systemParam)"
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlString) else {
            throw NetworkError(message: "Invalid URL")
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError(message: "Server error: \(response)")
        }
        
        do {
            let response = try JSONDecoder().decode(CustomCarrierResponse.self, from: data)
            return response.carrier
        } catch {
            throw NetworkError(message: "Decoding error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Protocol Stubs (не используются в этом сервисе)
    nonisolated func fetchCities() async throws -> [City] {
        throw NetworkError(message: "Not implemented in CarrierService")
    }
    
    nonisolated func fetchStations(for city: String) async throws -> [Station] {
        throw NetworkError(message: "Not implemented in CarrierService")
    }
    
    nonisolated func fetchNearestCity(latitude: Double, longitude: Double, distance: Int?) async throws -> NearestCityResponse {
        throw NetworkError(message: "Not implemented in CarrierService")
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
        throw NetworkError(message: "Not implemented in CarrierService")
    }
}
