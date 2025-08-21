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

    var body: some View {
        NavigationStack {
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
                        Image("change_icon")
                    }
                    .padding(.horizontal, 4)

                }
                .padding()
                .background(Color("blue_universal"))
                .cornerRadius(20)
                .padding(.horizontal, 16)

                if areBothStationsSelected {
                    Button(action: findRoutes) {
                        Text("Найти")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 150, height: 60)
                            .background(Color("blue_universal"))
                            .cornerRadius(12)
                    }
                    .padding(.top, 16)
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
