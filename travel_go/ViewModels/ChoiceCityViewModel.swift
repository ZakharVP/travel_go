//
//  ChoiceCityViewModel.swift
//  travel_go
//
//  Created by Захар Панченко on 14.09.2025.
//

import SwiftUI

@MainActor
class ChoiceCityViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var error: String?
    @Published var cities: [City] = []
    
    private let networkService: NetworkServiceProtocol
    private let citiesViewModel: CitiesViewModel
    
    // Моковые данные для fallback
    private let mockCities: [City] = [
        City(id: "1", name: "Москва", country: "Россия", stations: []),
        City(id: "2", name: "Санкт-Петербург", country: "Россия", stations: [])
    ]
    
    init(networkService: NetworkServiceProtocol = UnifiedNetworkService.shared,
         citiesViewModel: CitiesViewModel = CitiesViewModel()) {
        self.networkService = networkService
        self.citiesViewModel = citiesViewModel
    }
    
    var filteredCities: [City] {
        if searchText.isEmpty {
            return cities
        } else {
            return cities.filter { city in
                city.name.localizedCaseInsensitiveContains(searchText) ||
                city.country.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func loadCities() async {
        // Если города уже загружены, используем их
        if !citiesViewModel.cities.isEmpty {
            self.cities = citiesViewModel.cities
            return
        }
        
        isLoading = true
        error = nil
        
        do {
            // Загружаем города через общий ViewModel
            await citiesViewModel.loadCities()
            self.cities = citiesViewModel.cities
            
            // Если все еще пусто, используем моковые данные
            if self.cities.isEmpty {
                self.cities = mockCities
            }
        } catch {
            self.error = error.localizedDescription
            print("Error loading cities: \(error)")
            // Fallback to mock data
            self.cities = mockCities
        }
        
        isLoading = false
    }
    
    // Измененная функция для работы с NavigationPath
    func selectCity(_ city: City, navigationPath: Binding<NavigationPath>) {
        navigationPath.wrappedValue.append(city)
    }
    
    // Альтернативный вариант - возвращаем выбранный город
    func selectCity(_ city: City) -> City {
        return city
    }
}
