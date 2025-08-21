//
//  TimeFilterView.swift
//  travel_go
//
//  Created by Захар Панченко on 21.08.2025.
//
import SwiftUI

struct TimeFilterView: View {
    @Environment(\.dismiss) private var dismiss
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

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                Text("Время отправления")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .padding(.bottom, 16)

                // Список временных интервалов
                List {
                    ForEach($timeOptions) { $option in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(option.title)
                                    .font(.system(size: 17, weight: .semibold))
                                Text(option.timeRange)
                                    .font(.system(size: 15))
                                    .foregroundColor(.primary)
                            }

                            Spacer()

                            Image(
                                systemName: option.isSelected
                                    ? "checkmark.square.fill" : "square"
                            )
                            .foregroundColor(
                                option.isSelected ? .primary : .gray
                            )
                            .font(.system(size: 22))
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            option.isSelected.toggle()
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color(.systemBackground))
                    }
                }
                .listStyle(PlainListStyle())
                .frame(height: 250)

                Text("Показывать варианты с пересадками")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 44)
                    .padding(.bottom, 16)

                List {
                    ForEach($transferOptions) { $option in
                        HStack {
                            Text(option.title)
                                .font(.system(size: 17, weight: .semibold))

                            Spacer()

                            Image(
                                systemName: option.isSelected
                                    ? "checkmark.circle.fill" : "circle"
                            )
                            .foregroundColor(option.isSelected ? .primary : .gray)
                            .font(.system(size: 22))
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            for index in transferOptions.indices {
                                transferOptions[index].isSelected = false
                            }
                            option.isSelected = true
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color(.systemBackground))
                    }
                }
                .listStyle(PlainListStyle())
                .frame(height: 120)

                Spacer()

                Button(action: {
                    print("Применены фильтры")
                    dismiss()
                }) {
                    Text("Применить")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color("blue_universal"))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 58)
            }
            .navigationBarTitleDisplayMode(.inline)
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
}
