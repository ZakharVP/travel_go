//
//  ChoiceCity.swift
//  travel_go
//
//  Created by Захар Панченко on 20.08.2025.
//

import SwiftUI

struct ChoiceCity: View {
    let isForFrom: Bool
    @Binding var isPresented: Bool
    @Binding var selectedStation: Station?
    @State private var navigationPath = NavigationPath()
    @State private var searchText = ""
    
    var title = "Выбор города"
    
    var filteredCities: [City] {
        if searchText.isEmpty {
            return mockCities
        } else {
            return mockCities.filter { city in
                city.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Поиск города", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top)
                
                // Проверяем есть ли результаты поиска
                if filteredCities.isEmpty && !searchText.isEmpty {
                    // Показываем сообщение если нет результатов
                    VStack(spacing: 16) {
                        Spacer()
                        Text("Город не найден")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                } else {
                    // Показываем список если есть результаты
                    List {
                        ForEach(filteredCities) { city in
                            Button(action: {
                                navigationPath.append(city)
                            }) {
                                HStack {
                                    Text(city.name)
                                        .font(.system(size: 17))
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.black)
                                        .font(.system(size: 20))
                                }
                                .padding(.vertical, 12)
                                .contentShape(Rectangle())
                            }
                            .listRowBackground(Color.white)
                            .listRowSeparatorTint(.clear)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.white)
                }
            }
            .background(Color.white)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
            }
            .navigationDestination(for: City.self) { city in
                ChoiceStation(
                    city: city,
                    isPresented: $isPresented,
                    selectedStation: $selectedStation
                )
            }
        }
    }
}
