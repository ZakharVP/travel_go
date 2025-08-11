//
//  NearestStationService.swift
//  travel_go
//
//  Created by Захар Панченко on 26.07.2025.
//


import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

typealias NearestStations = Components.Schemas.Stations

final class NearestStationsService: NearestStationsServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apiKey: String) {
        self.client = client
        self.apikey = apiKey
    }
    
    func getNearestStations(
        latitude: Double,
        longitude: Double,
        distance: Int,
        lang: String? = nil,
        format: String? = nil,
        stationTypes: String? = nil,
        transportTypes: String? = nil,
        offset: Int? = nil,
        limit: Int? = nil
    ) async throws -> NearestStations {
        let response = try await client.getNearestStations(
            query: .init(
                apikey: apikey,
                lat: latitude,
                lng: longitude,
                distance: distance,
                lang: lang,
                format: format,
                station_types: stationTypes,
                transport_types: transportTypes,
                offset: offset,
                limit: limit
            )
        )
        
        let stations = try response.ok.body.json
        printFormattedStations(stations)
        return stations
    }
    
    private func printFormattedStations(_ stations: NearestStations) {
        guard let stationList = stations.stations else {
            print("🔴 Нет данных о станциях")
            return
        }
        
        print("🟢 Найдено станций: \(stationList.count)")
        print("========================================")
        
        stationList.enumerated().forEach { index, station in
            print("\n🟢 Станция #\(index + 1)")
            print("🟢────────────────────────────────────")
            
            do {
                print(station.formattedDescription)
                
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try encoder.encode(station)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("\n📦 Raw JSON данные станции:")
                    print(jsonString)
                }
            } catch {
                print("🔴 Ошибка форматирования станции #\(index + 1):")
                print("🔴 Основные данные:")
                print("Название: \(station.title ?? "нет данных")")
                print("Тип: \(station.station_type_name ?? "нет данных")")
                print("Код: \(station.code ?? "нет данных")")
                print("🔴 Техническая информация об ошибке:")
                print(error.localizedDescription)
            }
            
            print("──────────────────────────────────────")
        }
        
        print("\n========================================")
        print("🟢 Вывод завершен")
        print("========================================\n")
    }
}
