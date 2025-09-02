//
//  ChoiceCarrier.swift
//  travel_go
//
//  Created by Захар Панченко on 20.08.2025.
//

import SwiftUI

public struct ChoiceCarrier: View {
    let fromStation: String
    let toStation: String
    @State private var showingTimePicker = false
    @Environment(\.dismiss) private var dismiss

    init(fromStation: String, toStation: String) {
        self.fromStation = fromStation
        self.toStation = toStation
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            // Основной контент
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    Text("\(fromStation) → \(toStation)")
                        .font(.system(size: 24, weight: .bold))
                }
                .foregroundColor(.primary)
                .padding(.horizontal)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))

                List {
                    if mockCarriers.isEmpty {
                        VStack {
                            Text(AppStrings.Errors.noResult)
                                .font(.system(size: 17))
                                .foregroundColor(.secondary)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .listRowSeparator(.hidden)
                    } else {
                        ForEach(mockCarriers) { mockCarrier in
                            ZStack {

                                NavigationLink(
                                    destination: CarrierDetail(
                                        mockCarrier: mockCarrier
                                    )
                                ) {
                                    EmptyView()
                                }
                                .opacity(0)

                                // Видимая ячейка
                                CarrierRow(mockCarrier: mockCarrier)
                            }
                            .contentShape(Rectangle())
                            .listRowSeparator(.hidden)
                            .listRowInsets(
                                EdgeInsets(
                                    top: 4,
                                    leading: 0,
                                    bottom: 4,
                                    trailing: 0
                                )
                            )
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }

            Button(action: {
                showingTimePicker = true
            }) {
                Text("Уточнить время")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color(.blueUniversal))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 16)
        }
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
        .fullScreenCover(isPresented: $showingTimePicker) {
            TimeFilterView() 
        }
    }
}
