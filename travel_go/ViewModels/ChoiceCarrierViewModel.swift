//
//  ChoiceCarrierViewModel.swift
//  travel_go
//
//  Created by Захар Панченко on 14.09.2025.
//

import SwiftUI

@MainActor
class ChoiceCarrierViewModel: ObservableObject {
    @Published var carriers: [Carrier] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var selectedDate: Date = Date()
    @Published var selectedTimeRanges: [String] = []
    
    let fromStation: Station
    let toStation: Station
    private let networkService: NetworkServiceProtocol
    
    private var allCarriers: [Carrier] = []
    
    init(fromStation: Station, toStation: Station,
         networkService: NetworkServiceProtocol = UnifiedNetworkService.shared) {
        self.fromStation = fromStation
        self.toStation = toStation
        self.networkService = networkService
    }
    
    var fromStationText: String {
        fromStation.name
    }

    var toStationText: String {
        toStation.name
    }
    
    func loadCarriers() async {
        isLoading = true
        error = nil
        
        do {
            let segments = try await networkService.getScheduleBetweenStations(
                from: fromStation.id,
                to: toStation.id,
                date: formattedDate(selectedDate),
                lang: "ru_RU",
                format: "json",
                transportTypes: nil,
                limit: 50,
                offset: nil,
                transfers: nil
            )
            
            // Сохраняем все загруженные перевозчики
            let loadedCarriers = try await convertSegmentsToCarriers(segments)
            self.allCarriers = loadedCarriers
            
            // Применяем фильтры к загруженным данным
            self.carriers = applyFiltersToCarriers(loadedCarriers)
            print("✅ Loaded \(carriers.count) carriers")
            
        } catch {
            self.error = "Ошибка загрузки перевозчиков: \(error.localizedDescription)"
            print("❌ Error loading carriers: \(error)")
        }
        
        isLoading = false
    }
    
    func refreshCarriers() async {
        await loadCarriers()
    }
    
    func applyFilters(timeRanges: [String]) {
        self.selectedTimeRanges = timeRanges
        
        // Применяем фильтры к уже загруженным данным (без перезагрузки с сервера)
        self.carriers = applyFiltersToCarriers(allCarriers)
        
        print("🔍 Applied filters: \(timeRanges)")
        print("📊 Filtered carriers: \(carriers.count) out of \(allCarriers.count)")
    }
    
    
    private func applyFiltersToCarriers(_ carriers: [Carrier]) -> [Carrier] {
        var filteredCarriers = carriers
        
        // Фильтрация по времени (только если выбраны диапазоны)
        if !selectedTimeRanges.isEmpty {
            filteredCarriers = filteredCarriers.filter { carrier in
                guard let departureTime = carrier.departureTime else { return false }
                return isTimeInSelectedRanges(departureTime)
            }
        }
        
        return filteredCarriers
    }
    
    private func parseTime(_ timeString: String) -> (hour: Int, minute: Int)? {
        // Обрабатываем разные форматы времени
        let cleanTimeString = timeString
            .replacingOccurrences(of: "T", with: " ")
            .split(separator: " ").last ?? Substring(timeString)
        
        let components = cleanTimeString.split(separator: ":")
        guard components.count >= 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else {
            return nil
        }
        return (hour, minute)
    }
    
    private func isTimeInSelectedRanges(_ timeString: String) -> Bool {
        guard let time = parseTime(timeString) else { return false }
        
        for timeRange in selectedTimeRanges {
            switch timeRange {
            case "утро":
                if (6...11).contains(time.hour) { return true }
            case "день":
                if (12...17).contains(time.hour) { return true }
            case "вечер":
                if (18...23).contains(time.hour) { return true }
            case "ночь":
                if (0...5).contains(time.hour) || time.hour == 24 { return true }
            default:
                continue
            }
        }
        
        return false
    }
    
    func changeDate(_ newDate: Date) {
        selectedDate = newDate
        Task {
            await loadCarriers()
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func convertSegmentsToCarriers(_ segments: Segments) async throws -> [Carrier] {
        var carriers: [Carrier] = []
        
        guard let segmentsList = segments.segments else { return [] }
        
        for segment in segmentsList {
            let carrier = try await createCarrier(from: segment)
            carriers.append(carrier)
        }
        
        // Сортируем по времени отправления
        return carriers.sorted {
            ($0.departureTime ?? "") < ($1.departureTime ?? "")
        }
    }
    
    private func createCarrier(from segment: Components.Schemas.Segment) async throws -> Carrier {
        // Исправлено: правильное получение кода перевозчика
        let carrierCode: String
        if let code = segment.thread?.carrier?.code {
            carrierCode = String(code)  // Конвертируем Int в String
        } else {
            carrierCode = ""
        }
        
        let carrierTitle = segment.thread?.carrier?.title ?? "Неизвестный перевозчик"
        
        // Получаем детальную информацию о перевозчике если доступен код
        var detailedCarrier: Carrier?
        if !carrierCode.isEmpty {
            do {
                // Исправлено: добавляем параметр system
                detailedCarrier = try await networkService.fetchCarrierInfo(
                    code: carrierCode,
                    system: "yandex"
                )
            } catch {
                print("⚠️ Could not fetch detailed carrier info: \(error)")
            }
        }
        
        return Carrier(
            id: segment.thread?.uid ?? UUID().uuidString,
            code: Int(carrierCode),  // Конвертируем обратно в Int для свойства code
            title: carrierTitle,
            codes: CarrierCodes(
                iata: nil,
                icao: nil,
                sirena: nil,
                express: nil,
                yandexCode: carrierCode.isEmpty ? nil : carrierCode
            ),
            address: detailedCarrier?.address,
            url: detailedCarrier?.url,
            email: detailedCarrier?.email,
            contacts: detailedCarrier?.contacts,
            phone: detailedCarrier?.phone,
            logo: detailedCarrier?.logo,
            price: extractPrice(from: segment),
            duration: formatDuration(segment.duration ?? 0),
            departureTime: formatTime(segment.departure ?? Date()),
            arrivalTime: formatTime(segment.arrival ?? Date()),
            transportType: segment.thread?.transport_type
        )
    }
    
    private func extractPrice(from segment: Components.Schemas.Segment) -> Double? {
        // Временное решение - случайная цена для демонстрации
        return Double.random(in: 500...5000)
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        return "\(hours)ч \(minutes)м"
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
