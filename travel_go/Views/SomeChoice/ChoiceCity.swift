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
    
    @StateObject private var viewModel = ChoiceCityViewModel()
    @State private var navigationPath = NavigationPath()
    
    private var title: String {
        isForFrom ? "Откуда" : "Куда"
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                // Строка поиска
                searchField
                
                // Контент в зависимости от состояния
                Group {
                    if viewModel.isLoading {
                        loadingView
                    } else if let error = viewModel.error {
                        errorView(error: error)
                    } else if viewModel.filteredCities.isEmpty && !viewModel.searchText.isEmpty {
                        noResultsView
                    } else {
                        citiesList
                    }
                }
            }
            .background(Color(.systemBackground))
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
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
            .task {
                await viewModel.loadCities()
            }
        }
    }
    
    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Поиск города", text: $viewModel.searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
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
    }
    
    private var citiesList: some View {
        List {
            ForEach(viewModel.filteredCities) { city in
                Button {
                    navigationPath.append(city)
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(city.name)
                                .font(.system(size: 17))
                                .foregroundColor(.primary)
                            
                            Text(city.country)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                    .padding(.vertical, 8)
                    .contentShape(Rectangle())
                }
                .listRowBackground(Color(.systemBackground))
            }
        }
        .listStyle(PlainListStyle())
        .background(Color(.systemBackground))
    }
    
    private var loadingView: some View {
        ProgressView("Загрузка городов...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var noResultsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "building.2.crop.circle")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("Город не найден")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Попробуйте изменить запрос")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(error: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Ошибка загрузки")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(error)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Повторить") {
                Task {
                    await viewModel.loadCities()
                }
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    ChoiceCity(
        isForFrom: true,
        isPresented: .constant(true),
        selectedStation: .constant(nil)
    )
}
