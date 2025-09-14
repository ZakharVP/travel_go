//
//  TimeFilterView.swift
//  travel_go
//
//  Created by Захар Панченко on 21.08.2025.
//

import SwiftUI

struct TimeFilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedDate: Date
    var onFiltersApplied: (([String]) -> Void)?
    
    @State private var timeOptions: [TimeOption] = [
        TimeOption(
            title: "Утро",
            timeRange: "06:00 - 12:00",
            isSelected: false
        ),
        TimeOption(
            title: "День",
            timeRange: "12:00 - 18:00",
            isSelected: false
        ),
        TimeOption(
            title: "Вечер",
            timeRange: "18:00 - 00:00",
            isSelected: false
        ),
        TimeOption(
            title: "Ночь",
            timeRange: "00:00 - 06:00",
            isSelected: false
        ),
    ]
    
    @State private var transferOptions: [FilterOption] = [
        FilterOption(title: "Да", isSelected: false),
        FilterOption(title: "Нет", isSelected: true),
    ]
    
    @State private var selectedDateInternal: Date = Date()

    init(selectedDate: Binding<Date>, onFiltersApplied: (([String]) -> Void)? = nil) {
        self._selectedDate = selectedDate
        self._selectedDateInternal = State(initialValue: selectedDate.wrappedValue)
        self.onFiltersApplied = onFiltersApplied
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    
                    Text("Время отправления")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)

                    // Список временных интервалов
                    LazyVStack(spacing: 0) {
                        ForEach($timeOptions) { $option in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(option.title)
                                        .font(.system(size: 17, weight: .semibold))
                                    Text(option.timeRange)
                                        .font(.system(size: 15))
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                Image(
                                    systemName: option.isSelected
                                        ? "checkmark.square.fill" : "square"
                                )
                                .foregroundColor(
                                    option.isSelected ? .blue : .gray
                                )
                                .font(.system(size: 22))
                            }
                            .padding()
                            .contentShape(Rectangle())
                            .onTapGesture {
                                option.isSelected.toggle()
                            }
                            .background(Color(.systemBackground))
                            
                            Divider()
                                .padding(.leading)
                        }
                    }
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    Text("Показывать с пересадками")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)

                    // Опции пересадок
                    LazyVStack(spacing: 0) {
                        ForEach($transferOptions) { $option in
                            HStack {
                                Text(option.title)
                                    .font(.system(size: 17, weight: .semibold))

                                Spacer()

                                Image(
                                    systemName: option.isSelected
                                        ? "checkmark.circle.fill" : "circle"
                                )
                                .foregroundColor(option.isSelected ? .blue : .gray)
                                .font(.system(size: 22))
                            }
                            .padding()
                            .contentShape(Rectangle())
                            .onTapGesture {
                                for index in transferOptions.indices {
                                    transferOptions[index].isSelected = false
                                }
                                option.isSelected = true
                            }
                            .background(Color(.systemBackground))
                            
                            Divider()
                                .padding(.leading)
                        }
                    }
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    Spacer()

                    Button(action: applyFilters) {
                        Text("Применить")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color(.blueUniversal))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
                .padding(.top)
            }
            .navigationBarTitle("Фильтр", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                            .font(.system(size: 20))
                    }
                }
            }
        }
    }
    
    private func applyFilters() {
        selectedDate = selectedDateInternal
        
        // Получаем выбранные временные интервалы
        let selectedTimeRanges = timeOptions
            .filter { $0.isSelected }
            .map { $0.title.lowercased() } // "утро", "день" и т.д.
        
        onFiltersApplied?(selectedTimeRanges)
        dismiss()
    }
}

struct TimeOption: Identifiable {
    let id = UUID()
    let title: String
    let timeRange: String
    var isSelected: Bool
}
