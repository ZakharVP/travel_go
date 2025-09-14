//
//  CitiesViewModel.swift
//  travel_go
//
//  Created by Захар Панченко on 14.09.2025.
//

import SwiftUI

@MainActor
class CitiesViewModel: ObservableObject {
    @Published var cities: [City] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = UnifiedNetworkService.shared) {
        self.networkService = networkService
    }
    
    func loadCities() async {
        isLoading = true
        error = nil
        
        do {
            async let citiesTask = networkService.fetchCities()
            let loadedCities = try await citiesTask
            self.cities = loadedCities
        } catch {
            self.error = error.localizedDescription
            print("Error loading cities: \(error)")
        }
        
        isLoading = false
    }
    
    func loadStations(for city: City) async {
        do {
            async let stationsTask = networkService.fetchStations(for: city.id)
            let stations = try await stationsTask
            
            if let index = cities.firstIndex(where: { $0.id == city.id }) {
                cities[index].stations = stations
            }
        } catch {
            print("Error loading stations for \(city.name): \(error)")
        }
    }
}
