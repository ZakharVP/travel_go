//
//  ChoiceCarrier.swift
//  travel_go
//
//  Created by Захар Панченко on 20.08.2025.
//

import SwiftUI

public struct ChoiceCarrier: View {
    @StateObject private var viewModel: ChoiceCarrierViewModel
    @State private var showingTimePicker = false
    @Environment(\.dismiss) private var dismiss

    init(fromStation: Station, toStation: Station) {
        _viewModel = StateObject(
            wrappedValue: ChoiceCarrierViewModel(
                fromStation: fromStation,
                toStation: toStation
            )
        )
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            // Основной контент
            VStack(spacing: .zero) {
                // Заголовок
                headerView

                // Список перевозчиков
                carriersListView
            }

            // Кнопка уточнения времени
            timeFilterButton
        }
        .navigationBarBackButtonHidden(true)
        .toolbar { toolbarItem }
        .fullScreenCover(isPresented: $showingTimePicker) {
            TimeFilterView(selectedDate: $viewModel.selectedDate) { timeRanges in
                viewModel.applyFilters(timeRanges: timeRanges)
            }
        }
        .task {
            await viewModel.loadCarriers()
        }
        .refreshable {
            await viewModel.refreshCarriers()
        }
    }

    // MARK: - Subviews

    private var headerView: some View {
        HStack(spacing: 8) {
            Text("\(viewModel.fromStationText) → \(viewModel.toStationText)")
                .font(.system(size: 24, weight: .bold))
        }
        .foregroundColor(.primary)
        .padding(.horizontal)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
    }

    private var carriersListView: some View {
        Group {
            if viewModel.isLoading {
                loadingView
            } else if let error = viewModel.error {
                errorView(error: error)
            } else if viewModel.carriers.isEmpty {
                emptyView
            } else {
                carriersList
            }
        }
    }

    private var carriersList: some View {
        List {
            ForEach(viewModel.carriers) { carrier in
                ZStack {
                    NavigationLink(
                        destination: CarrierDetail(carrier: carrier)
                    ) {
                        EmptyView()
                    }
                    .opacity(0)

                    CarrierRow(carrier: carrier)
                }
                .contentShape(Rectangle())
                .listRowSeparator(.hidden)
                .listRowInsets(
                    EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0)
                )
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(PlainListStyle())
    }

    private var loadingView: some View {
        ProgressView("Загрузка перевозчиков...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(error: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 50))
                .foregroundColor(.red)

            Text("Ошибка загрузки")
                .font(.headline)

            Text(error)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button("Повторить") {
                Task { await viewModel.refreshCarriers() }
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private var emptyView: some View {
        Text("Вариантов нет")
            .font(.system(size: 24, weight: .bold))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .multilineTextAlignment(.center)
    }

    private var timeFilterButton: some View {
        Button(action: { showingTimePicker = true }) {
            Text("Уточнить время")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color(.blueUniversal))
                .cornerRadius(12)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }

    private var toolbarItem: some ToolbarContent {
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
