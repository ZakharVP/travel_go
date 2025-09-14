//
//  ChoiceRouteViewModel.swift
//  travel_go
//
//  Created by Захар Панченко on 14.09.2025.
//

//
//  ChoiceRouteViewModel.swift
//  travel_go
//
//  Created by Захар Панченко on 14.09.2025.
//

import SwiftUI

@MainActor
class ChoiceRouteViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var fromStation: Station?
    @Published var toStation: Station?
    @Published var isShowingFromCity = false
    @Published var isShowingToCity = false
    @Published var isShowingCarriers = false
    @Published var isShowingStories = false
    @Published var selectedStoryIndex = 0
    @Published var routes: [Route] = []
    @Published var isLoadingRoutes = false
    
    @Published var cities: [City] = []
    @Published var isLoading = false
    @Published var error: String?
    
    @Published var stories: [Story] = [
        Story(
            imageName: "storiesOne",
            title: "Механик",
            smallText: AppStrings.StoryText.small,
            isViewed: false
        ),
        Story(
            imageName: "storiesTwo",
            title: "Проводница",
            smallText: AppStrings.StoryText.small,
            isViewed: false
        ),
        Story(
            imageName: "storiesThree",
            title: "Стоп кран",
            smallText: AppStrings.StoryText.small,
            isViewed: false
        ),
        Story(
            imageName: "storiesFour",
            title: "Пустой вагон",
            smallText: AppStrings.StoryText.small,
            isViewed: false
        ),
    ]
    
    private let citiesViewModel: CitiesViewModel
    private let networkService: NetworkServiceProtocol

    // MARK: - Computed Properties

    var fromStationText: String {
        if let station = fromStation {
            if let city = findCity(for: station) {
                return "\(city.name) (\(station.name))"
            }
            return station.name
        }
        return "Откуда"
    }

    var toStationText: String {
        if let station = toStation {
            if let city = findCity(for: station) {
                return "\(city.name) (\(station.name))"
            }
            return station.name
        }
        return "Куда"
    }

    var areBothStationsSelected: Bool {
        fromStation != nil && toStation != nil
    }
    
    init(citiesViewModel: CitiesViewModel = CitiesViewModel(),
         networkService: NetworkServiceProtocol = UnifiedNetworkService.shared) {
        self.citiesViewModel = citiesViewModel
        self.networkService = networkService
    }

    // MARK: - Public Methods
    
    func loadCities() async {
        isLoading = true
        error = nil
        
        await citiesViewModel.loadCities()
        self.cities = citiesViewModel.cities
        self.error = citiesViewModel.error
        self.isLoading = false
    }
    
    func loadStations(for city: City) async {
        await citiesViewModel.loadStations(for: city)
        if let updatedCity = citiesViewModel.cities.first(where: { $0.id == city.id }) {
            if let index = cities.firstIndex(where: { $0.id == city.id }) {
                cities[index] = updatedCity
            }
        }
    }

    func findRoutes() async {
        guard let fromStation = fromStation, let toStation = toStation else {
            error = "Выберите станции отправления и назначения"
            return
        }
        
        isLoadingRoutes = true
        error = nil
        
        do {
            // Используем networkService для поиска маршрутов
            let segments = try await networkService.getScheduleBetweenStations(
                from: fromStation.id,
                to: toStation.id,
                date: formattedCurrentDate(),
                lang: "ru_RU",
                format: nil,
                transportTypes: nil,
                limit: 20,
                offset: nil,
                transfers: nil
            )
            
            // Конвертируем segments в массив Route
            self.routes = convertSegmentsToRoutes(segments, fromStation: fromStation, toStation: toStation)
            isShowingCarriers = true
            
        } catch {
            self.error = "Ошибка при поиске маршрутов: \(error.localizedDescription)"
            print("Error finding routes: \(error)")
        }
        
        isLoadingRoutes = false
    }

    func reverse() {
        (fromStation, toStation) = (toStation, fromStation)
    }

    func selectStory(at index: Int) {
        isShowingStories = true
        selectedStoryIndex = index
        stories[index].isViewed = true
    }

    // MARK: - Private Methods

    private func findCity(for station: Station) -> City? {
        for city in cities {
            if (city.stations ?? []).contains(where: { $0.id == station.id }) {
                return city
            }
        }
        return nil
    }
    
    private func formattedCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    private func convertSegmentsToRoutes(_ segments: Segments, fromStation: Station, toStation: Station) -> [Route] {
        var routes: [Route] = []
        
        if let segmentsList = segments.segments {
            for segment in segmentsList {
                let route = Route(
                    id: segment.thread?.uid ?? UUID().uuidString,
                    fromStation: fromStation,
                    toStation: toStation,
                    departureTime: segment.departure ?? Date(),
                    arrivalTime: segment.arrival ?? Date(),
                    duration: TimeInterval(segment.duration ?? 0),
                    carrier: segment.thread?.carrier?.title ?? "Неизвестный перевозчик",
                    price: nil,
                    transportType: segment.thread?.transport_type ?? "unknown",
                    thread: segment.thread
                )
                routes.append(route)
            }
        }
        
        return routes
    }
}
