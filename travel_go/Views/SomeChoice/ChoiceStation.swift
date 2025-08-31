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
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    
    var title = "Выбор станции"
    
    var filteredStations: [Station] {
        if searchText.isEmpty {
            return city.stations
        } else {
            return city.stations.filter { station in
                station.name.localizedCaseInsensitiveContains(searchText) ||
                station.code.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        VStack {
            // Строка поиска
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Поиск станции", text: $searchText)
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
            
            // Список станций
            List {
                ForEach(filteredStations) { station in
                    Button {
                        selectedStation = station
                        isPresented = false
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(station.name)
                                    .font(.system(size: 17))
                                    .foregroundColor(.primary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.primary)
                                .font(.system(size: 20))
                        }
                        .padding(.vertical, 12)
                        .contentShape(Rectangle())
                    }
                    .listRowBackground(Color(.systemBackground))
                    .listRowSeparatorTint(.clear)
                }
            }
            .listStyle(PlainListStyle())
            .background(Color(.systemBackground))
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
    }
}
