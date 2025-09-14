//
//  ChoiceStationViewModel.swift
//  travel_go
//
//  Created by Захар Панченко on 14.09.2025.
//

import SwiftUI

@MainActor
class ChoiceStationViewModel: ObservableObject {
    let city: City
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var error: String?
    @Published var stations: [Station] = []
    
    private let networkService: NetworkServiceProtocol
    
    init(city: City, networkService: NetworkServiceProtocol = UnifiedNetworkService.shared) {
        self.city = city
        self.networkService = networkService
        self.stations = city.stations ?? []
    }
    
    var filteredStations: [Station] {
        if searchText.isEmpty {
            return stations
        } else {
            return stations.filter { station in
                station.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func loadStationsIfNeeded() async {
        // Если станции уже загружены, не загружаем повторно
        guard stations.isEmpty else { return }
        
        isLoading = true
        error = nil
        
        do {
            // Загружаем станции из API
            let loadedStations = try await networkService.fetchStations(for: city.id)
            self.stations = loadedStations
        } catch {
            self.error = error.localizedDescription
            print("Error loading stations: \(error)")
            // Моковые данные при ошибке
            self.stations = mockStations(for: city.name)
        }
        
        isLoading = false
    }
    
    func selectStation(_ station: Station, isPresented: Binding<Bool>, selectedStation: Binding<Station?>) {
        selectedStation.wrappedValue = station
        isPresented.wrappedValue = false
    }
    
    // Вспомогательный метод для моковых данных при ошибке
    private func mockStations(for cityName: String) -> [Station] {
        // Моковые данные для fallback
        return [
            Station(id: "1", name: "\(cityName) Центральный", city: cityName, country: cityName, latitude: nil, longitude: nil),
            Station(id: "2", name: "\(cityName) Северный", city: cityName, country: cityName, latitude: nil, longitude: nil),
            Station(id: "3", name: "\(cityName) Южный", city: cityName, country: cityName, latitude: nil, longitude: nil)
        ]
    }
}
