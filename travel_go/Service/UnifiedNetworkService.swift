//
//  NetworkService.swift
//  travel_go
//
//  Created by Захар Панченко on 14.09.2025.
//

import OpenAPIRuntime
import OpenAPIURLSession
import SwiftUI

actor UnifiedNetworkService: NetworkServiceProtocol {
    let baseURL = "https://api.rasp.yandex.net/v3.0"
    let apiKey: String
    private let client: Client

    nonisolated init(
        apiKey: String = APIKeys.yandexStationKey,
        client: Client = Client(
            serverURL: try! Servers.server1(),
            transport: URLSessionTransport()
        )
    ) {
        self.apiKey = apiKey
        self.client = client
    }

    // MARK: - Cities and Stations
    func fetchCities() async throws -> [City] {
        guard
            let url = URL(
                string: "\(baseURL)/stations_list/?apikey=\(apiKey)&format=json"
            )
        else {
            throw NetworkError(message: "Invalid URL")
        }
        
        print("🔍 Fetching cities from: \(url.absoluteString)")
        
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError(message: "Invalid response type")
        }
        
        print("📥 Response status code: \(httpResponse.statusCode)")
        print("📦 Response size: \(data.count) bytes")
        
        // Логируем только начало сырых данных
        if let rawJSON = String(data: data, encoding: .utf8) {
            let preview = String(rawJSON.prefix(300))
            print("📋 JSON preview (first 300 chars):")
            print(preview)
            print("... (truncated, total: \(rawJSON.count) characters)")
        }

        guard httpResponse.statusCode == 200 else {
            throw NetworkError(message: "Server error: \(httpResponse.statusCode)")
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            let response = try decoder.decode(StationsResponse.self, from: data)
            print("✅ Successfully decoded \(response.countries.count) countries")
            
            // Логируем только мета-информацию, а не содержимое
            if !response.countries.isEmpty {
                let country = response.countries[0]
                print("🌍 First country: '\(country.title)' with \(country.regions.count) regions")
                
                if !country.regions.isEmpty {
                    let region = country.regions[0]
                    print("🗺️ First region with \(region.settlements.count) settlements")
                    
                    if !region.settlements.isEmpty {
                        let settlement = region.settlements[0]
                        print("🏘️ First settlement: '\(settlement.title)' with \(settlement.stations.count) stations")
                        
                        if !settlement.stations.isEmpty {
                            let station = settlement.stations[0]
                            print("🚉 First station: '\(station.title)'")
                        }
                    }
                }
            }
            
            let cities = extractCities(from: response.countries)
            print("🏙️ Extracted \(cities.count) cities")
            
            if !cities.isEmpty {
                print("📍 First city: '\(cities[0].name)', '\(cities[0].country)'")
            }
            
            return cities
            
        } catch let decodingError as DecodingError {
            print("❌ DECODING ERROR DETAILS:")
            switch decodingError {
            case .dataCorrupted(let context):
                print("Data corrupted: \(context)")
            case .keyNotFound(let key, let context):
                print("Key '\(key.stringValue)' not found at: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            case .typeMismatch(let type, let context):
                print("Type '\(type)' mismatch at: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            case .valueNotFound(let type, let context):
                print("Value '\(type)' not found at: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            @unknown default:
                print("Unknown decoding error: \(decodingError)")
            }
            throw NetworkError(message: "Decoding error: \(decodingError.localizedDescription)")
        } catch {
            print("❌ General error: \(error)")
            throw NetworkError(message: "Decoding error: \(error.localizedDescription)")
        }
    }

    func fetchStations(for city: String) async throws -> [Station] {
        guard
            let url = URL(
                string:
                    "\(baseURL)/stations_list/?apikey=\(apiKey)&format=json&city=\(city)"
            )
        else {
            throw NetworkError(message: "Invalid URL")
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw NetworkError(message: "Server error: \(response)")
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            let response = try decoder.decode(StationsResponse.self, from: data)
            return extractStations(from: response.countries, for: city)
        } catch {
            throw NetworkError(
                message: "Decoding error: \(error.localizedDescription)"
            )
        }
    }

    // MARK: - Carrier Info
    func fetchCarrierInfo(code: String, system: String? = nil) async throws
        -> Carrier
    {
        let systemParam = system ?? "iata"
        let urlString =
            "\(baseURL)/carrier/?format=json&apikey=\(apiKey)&lang=ru_RU&code=\(code)&system=\(systemParam)"

        guard
            let url = URL(
                string: urlString.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed
                ) ?? urlString
            )
        else {
            throw NetworkError(message: "Invalid URL")
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw NetworkError(message: "Server error: \(response)")
        }

        do {
            let response = try JSONDecoder().decode(
                CustomCarrierResponse.self,
                from: data
            )
            return response.carrier
        } catch {
            throw NetworkError(
                message: "Decoding error: \(error.localizedDescription)"
            )
        }
    }

    // MARK: - Nearest City
    func fetchNearestCity(
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

    // MARK: - Private Helper Methods
    private func extractCities(from countries: [Country], filterByCountry: String? = "Россия") -> [City] {
        var cities: [City] = []
        
        for country in countries {
            // Если указана фильтрация по стране - применяем её
            if let filterCountry = filterByCountry?.lowercased() {
                let countryName = country.title.lowercased()
                guard countryName == filterCountry ||
                      countryName.contains(filterCountry) ||
                      (filterCountry == "россия" && countryName == "russia") ||
                      (filterCountry == "russia" && countryName == "россия") else {
                    continue
                }
            }
            
            for region in country.regions {
                for settlement in region.settlements {
                    let settlementId = (settlement.codes?["yandex_code"] ?? "").isEmpty ?
                        "unknown_\(settlement.title)" : settlement.codes?["yandex_code"]
                    
                    guard !settlement.title.isEmpty else { continue }
                    
                    let city = City(
                        id: settlementId ?? "unknown_\(UUID().uuidString)",
                        name: settlement.title,
                        country: country.title,
                        stations: []
                    )
                    cities.append(city)
                }
            }
        }
        
        return cities
    }

    private func extractStations(from countries: [Country], for cityId: String) -> [Station] {
        var stations: [Station] = []
        
        for country in countries {
            for region in country.regions {
                for settlement in region.settlements {
                    // Исправьте ключ на "yandex_code" вместо API ключа
                    guard let settlementCode = settlement.codes?["yandex_code"],
                          settlementCode == cityId else {
                        continue
                    }
                    
                    for stationResponse in settlement.stations {
                        let newStation = Station(
                            id: stationResponse.codes?["yandex_code"] ?? "unknown_station", // Прямой доступ к словарю
                            name: stationResponse.title,
                            city: settlement.title,
                            country: country.title,
                            latitude: stationResponse.latitude,
                            longitude: stationResponse.longitude,
                            code: stationResponse.codes?["code"],
                            transportType: stationResponse.transportType,
                            stationType: stationResponse.stationType
                        )
                        stations.append(newStation)
                    }
                }
            }
        }
        
        return stations
    }
    
}
