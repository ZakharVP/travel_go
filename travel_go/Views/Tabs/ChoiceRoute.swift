//
//  ChoiceCity.swift
//  travel_go
//
//  Created by Захар Панченко on 13.08.2025.
//

import SwiftUI

struct ChoiceRoute: View {
    @State private var fromStation: Station?
    @State private var toStation: Station?
    @State private var isShowingFromCity = false
    @State private var isShowingToCity = false
    @State private var isShowingCarriers = false
    @State private var isShowingStories = false
    @State private var selectedStoryIndex = 0
    
    @State private var stories: [Story] = [
        Story(imageName: "storiesOne", title: "Механик", smallText: AppStrings.StoryText.small, isViewed: false),
        Story(imageName: "storiesTwo", title: "Проводница", smallText: AppStrings.StoryText.small, isViewed: false),
        Story(imageName: "storiesThree", title: "Стоп кран", smallText: AppStrings.StoryText.small, isViewed: false),
        Story(imageName: "storiesFour", title: "Пустой вагон", smallText: AppStrings.StoryText.small, isViewed: false),
    ]
    
    @EnvironmentObject var settingManager: SettingsManager

    var body: some View {
         NavigationStack {
             VStack(spacing: 0) { // Убираем стандартные отступы между элементами
                 // Блок с историями
                 ScrollView(.horizontal, showsIndicators: false) {
                     HStack(spacing: 12) {
                         ForEach(Array(stories.enumerated()), id: \.element.id) { index, story in
                             StoryCell(story: story)
                                 .onTapGesture {
                                     isShowingStories = true
                                     selectedStoryIndex = index
                                     stories[index].isViewed = true
                                 }
                         }
                     }
                     .padding(.horizontal, 16)
                     .padding(.vertical, 8)
                 }
                 .background(settingManager.isDarkMode ? .black : .white)
                 .padding(.top, 24) // Отступ от safe area
                 
                 // Основной контент
                 VStack {
                     HStack {
                         VStack(spacing: 0) {
                             HStack {
                                 Text(fromStationText)
                                     .font(.system(size: 17, weight: .regular))
                                     .foregroundColor(
                                         fromStation == nil ? .gray : .black
                                     )
                                     .lineLimit(1)
                                 Spacer()
                             }
                             .padding(.horizontal, 0)
                             .padding(.bottom, 8)
                             .background(.white)
                             .contentShape(Rectangle())
                             .onTapGesture {
                                 isShowingFromCity = true
                             }

                             HStack {
                                 Text(toStationText)
                                     .font(.system(size: 17, weight: .regular))
                                     .foregroundColor(
                                         toStation == nil ? .gray : .black
                                     )
                                     .lineLimit(1)
                                 Spacer()
                             }
                             .padding(.horizontal, 0)
                             .padding(.top, 8)
                             .background(.white)
                             .contentShape(Rectangle())
                             .onTapGesture {
                                 isShowingToCity = true
                             }
                         }
                         .padding()
                         .background(.white)
                         .cornerRadius(20)

                         Button(action: reverse) {
                             Image(.changeIcon)
                         }
                         .padding(.horizontal, 4)

                     }
                     .padding()
                     .background(Color(.blueUniversal))
                     .cornerRadius(20)
                     .padding(.horizontal, 16)
                     .padding(.top, 44) // Отступ 44 от блока с историями

                     if areBothStationsSelected {
                         Button(action: findRoutes) {
                             Text("Найти")
                                 .font(.system(size: 17, weight: .semibold))
                                 .foregroundColor(.white)
                                 .frame(width: 150, height: 60)
                                 .background(Color(.blueUniversal))
                                 .cornerRadius(12)
                         }
                         .padding(.top, 16)
                     }
                     
                     Spacer() // Растягиваем контент вверх
                 }
             }
         }
        .fullScreenCover(isPresented: $isShowingFromCity) {
            ChoiceCity(
                isForFrom: true,
                isPresented: $isShowingFromCity,
                selectedStation: $fromStation
            )
        }
        .fullScreenCover(isPresented: $isShowingToCity) {
            ChoiceCity(
                isForFrom: false,
                isPresented: $isShowingToCity,
                selectedStation: $toStation
            )
        }
        .fullScreenCover(isPresented: $isShowingCarriers) {
            NavigationStack {
                ChoiceCarrier(
                    fromStation: fromStationText,
                    toStation: toStationText
                )
            }
        }
        .fullScreenCover(isPresented: $isShowingStories) {
            StoriesView(
                stories: stories,
                selectedStoryIndex: $selectedStoryIndex,
                isPresented: $isShowingStories
            )
        }
    }

    private var fromStationText: String {
        if let station = fromStation {
            // Находим город для выбранной станции
            if let city = findCity(for: station) {
                return "\(city.name) (\(station.name))"
            }
            return station.name
        }
        return "Откуда"
    }

    private var areBothStationsSelected: Bool {
        fromStation != nil && toStation != nil
    }

    private func findRoutes() {
        isShowingCarriers = true
    }

    private var toStationText: String {
        if let station = toStation {
            // Находим город для выбранной станции
            if let city = findCity(for: station) {
                return "\(city.name) (\(station.name))"
            }
            return station.name
        }
        return "Куда"
    }

    private func findCity(for station: Station) -> City? {
        for city in mockCities {
            if city.stations.contains(where: { $0.id == station.id }) {
                return city
            }
        }
        return nil
    }

    private func reverse() {
        (fromStation, toStation) = (toStation, fromStation)
    }
}

#Preview {
    ChoiceRoute()
}
