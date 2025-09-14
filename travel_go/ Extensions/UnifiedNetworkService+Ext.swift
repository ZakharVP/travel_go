//
//  UnifiedNetworkService+Ext.swift
//  travel_go
//
//  Created by Захар Панченко on 14.09.2025.
//
import SwiftUI

extension UnifiedNetworkService {
    static let shared = UnifiedNetworkService()
    
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
        
        // Создаем базовый URL с обязательными параметрами
        var urlString = "\(baseURL)/search/?apikey=\(apiKey)&from=\(from)&to=\(to)"
        
        // Добавляем опциональные параметры
        if let format = format {
            urlString += "&format=\(format)"
        } else {
            urlString += "&format=json"
        }
        
        if let lang = lang {
            urlString += "&lang=\(lang)"
        } else {
            urlString += "&lang=ru_RU"
        }
        
        if let date = date {
            urlString += "&date=\(date)"
        }
        
        if let limit = limit {
            urlString += "&limit=\(limit)"
        } else {
            urlString += "&limit=20"
        }
        
        if let offset = offset {
            urlString += "&offset=\(offset)"
        }
        
        if let transportTypes = transportTypes {
            urlString += "&transport_types=\(transportTypes)"
        }
        
        if let transfers = transfers {
            urlString += "&transfers=\(transfers)"
        }
        
        // Кодируем URL для безопасности
        guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURLString) else {
            throw NetworkError(message: "Invalid URL")
        }
        
        print("🔍 Searching routes: \(url.absoluteString)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError(message: "Invalid response type")
        }
        
        print("📥 Search response status: \(httpResponse.statusCode)")
        
        guard httpResponse.statusCode == 200 else {
            // Логируем тело ошибки для отладки
            if let errorBody = String(data: data, encoding: .utf8) {
                print("❌ Server error body: \(errorBody)")
            }
            throw NetworkError(message: "Server error: \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            // Логируем сырой ответ для отладки
            if let rawJSON = String(data: data, encoding: .utf8) {
                print("📦 Raw JSON response:")
                print(rawJSON.prefix(1000)) // Логируем первые 1000 символов
            }
            
            let searchResponse = try decoder.decode(SearchResponse.self, from: data)
            print("✅ Successfully decoded search response")
            
            // Преобразуем SearchResponse в Segments
            return convertToSegments(searchResponse)
            
        } catch let decodingError as DecodingError {
            print("❌ DECODING ERROR DETAILS:")
            switch decodingError {
            case .dataCorrupted(let context):
                print("Data corrupted: \(context)")
            case .keyNotFound(let key, let context):
                print("Key '\(key.stringValue)' not found at: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
                print("Available keys in JSON: \(try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])?.keys ?? [])")
            case .typeMismatch(let type, let context):
                print("Type '\(type)' mismatch at: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            case .valueNotFound(let type, let context):
                print("Value '\(type)' not found at: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            @unknown default:
                print("Unknown decoding error: \(decodingError)")
            }
            throw NetworkError(message: "Search decoding error: \(decodingError.localizedDescription)")
        } catch {
            print("❌ General error: \(error)")
            throw NetworkError(message: "Search decoding error: \(error.localizedDescription)")
        }
    }
    
    // Функция для преобразования SearchResponse в Segments
    nonisolated private func convertToSegments(_ searchResponse: SearchResponse) -> Segments {
        var segments = Segments()
        
        // Преобразуем каждый segment
        segments.segments = searchResponse.segments?.map { customSegment in
            var segment = Components.Schemas.Segment()
            
            // Основная информация
            segment.departure = parseDate(customSegment.departure)
            segment.arrival = parseDate(customSegment.arrival)
            segment.duration = customSegment.duration.map { Int($0) }
            
            // Информация о потоке (thread)
            if let customThread = customSegment.thread {
                var thread = Components.Schemas.Thread()
                thread.uid = customThread.uid
                thread.title = customThread.title
                thread.number = customThread.number
                thread.transport_type = customThread.transportType
                
                // Информация о перевозчике
                if let customCarrier = customThread.carrier {
                    var carrier = Components.Schemas.Carrier()
                    carrier.code = customCarrier.code
                    carrier.title = customCarrier.title
                    thread.carrier = carrier
                }
                
                segment.thread = thread
            }
            
            // Информация о станциях
            if let fromStation = customSegment.from {
                var from = Components.Schemas.Station()
                from.code = fromStation.code
                from.title = fromStation.title
                segment.from = from
            }
            
            if let toStation = customSegment.to {
                var to = Components.Schemas.Station()
                to.code = toStation.code
                to.title = toStation.title
                segment.to = to
            }
            
            return segment
        }
        
        return segments
    }

    // Вспомогательная функция для парсинга дат
    nonisolated private func parseDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = formatter.date(from: dateString) {
            return date
        }
        
        // Попробуем другие форматы если ISO8601 не сработал
        let alternativeFormatters = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
            "yyyy-MM-dd HH:mm:ss"
        ]
        
        for format in alternativeFormatters {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        
        return nil
    }
}
