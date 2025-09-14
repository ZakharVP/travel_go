//
//  ChoiceStation.swift
//  travel_go
//
//  Created by Захар Панченко on 20.08.2025.
//

import SwiftUI

struct ChoiceStation: View {
    let city: City
    @Binding var isPresented: Bool
    @Binding var selectedStation: Station?
    
    @StateObject private var viewModel: ChoiceStationViewModel
    @Environment(\.dismiss) private var dismiss
    
    private var title = "Выбор станции"
    
    init(city: City, isPresented: Binding<Bool>, selectedStation: Binding<Station?>) {
        self.city = city
        self._isPresented = isPresented
        self._selectedStation = selectedStation
        self._viewModel = StateObject(wrappedValue: ChoiceStationViewModel(city: city))
    }
    
    var body: some View {
        VStack {
            // Строка поиска
            searchField
            
            // Контент в зависимости от состояния
            Group {
                if viewModel.isLoading {
                    loadingView
                } else if let error = viewModel.error {
                    errorView(error: error)
                } else if viewModel.filteredStations.isEmpty {
                    emptyView
                } else {
                    stationsList
                }
            }
        }
        .background(Color(.systemBackground))
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
            }
        }
        .task {
            await viewModel.loadStationsIfNeeded()
        }
    }
    
    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Поиск станции", text: $viewModel.searchText)
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
    
    private var stationsList: some View {
        List {
            ForEach(viewModel.filteredStations) { station in
                Button {
                    viewModel.selectStation(station, isPresented: $isPresented, selectedStation: $selectedStation)
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(station.name)
                                .font(.system(size: 17))
                                .foregroundColor(.primary)
                            
                            Text(station.city ?? "Неизвестный город")
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
        ProgressView("Загрузка станций...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "tram.fill")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("Станции не найдены")
                .font(.headline)
                .foregroundColor(.primary)
            
            if !viewModel.searchText.isEmpty {
                Text("Попробуйте изменить запрос")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
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
                    await viewModel.loadStationsIfNeeded()
                }
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    NavigationView {
        ChoiceStation(
            city: City(
                id: "c1",
                name: "Москва",
                country: "Россия",
                stations: []
            ),
            isPresented: .constant(true),
            selectedStation: .constant(nil)
        )
    }
}
