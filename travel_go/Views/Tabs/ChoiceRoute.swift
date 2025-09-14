//
//  ChoiceRoute.swift
//  travel_go
//
//  Created by Захар Панченко on 13.08.2025.
//

import SwiftUI

struct ChoiceRoute: View {
    @StateObject private var viewModel = ChoiceRouteViewModel()
    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Загрузка городов...")
                        .scaleEffect(1.5)
                } else if let error = viewModel.error {
                    ErrorView(
                        error: error,
                        onRetry: {
                            Task {
                                await viewModel.loadCities()
                            }
                        }
                    )
                } else {
                    mainContentView
                }
            }
            .task {
                // Structured concurrency - задача отменится при уничтожении View
                await viewModel.loadCities()
            }
        }
        .fullScreenCover(isPresented: $viewModel.isShowingFromCity) {
            ChoiceCity(
                isForFrom: true,
                isPresented: $viewModel.isShowingFromCity,
                selectedStation: $viewModel.fromStation
            )
        }
        .fullScreenCover(isPresented: $viewModel.isShowingToCity) {
            ChoiceCity(
                isForFrom: false,
                isPresented: $viewModel.isShowingToCity,
                selectedStation: $viewModel.toStation
            )
        }
        .fullScreenCover(isPresented: $viewModel.isShowingCarriers) {
            NavigationStack {
                // Исправлено: передаем Station вместо String
                if let fromStation = viewModel.fromStation,
                   let toStation = viewModel.toStation {
                    ChoiceCarrier(
                        fromStation: fromStation,
                        toStation: toStation
                    )
                } else {
                    // Fallback view если станции не выбраны
                    VStack {
                        Text("Ошибка: станции не выбраны")
                            .font(.headline)
                        Button("Закрыть") {
                            viewModel.isShowingCarriers = false
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.isShowingStories) {
            StoriesView(
                stories: viewModel.stories,
                selectedStoryIndex: $viewModel.selectedStoryIndex,
                isPresented: $viewModel.isShowingStories
            )
        }
    }

    private var mainContentView: some View {
        VStack(spacing: .zero) {
            // Блок с историями
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(
                        Array(viewModel.stories.enumerated()),
                        id: \.element.id
                    ) { index, story in
                        StoryCell(story: story)
                            .onTapGesture {
                                viewModel.selectStory(at: index)
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .background(settingsManager.isDarkMode ? .black : .white)
            .padding(.top, 24)  // Отступ от safe area

            // Основной контент
            VStack {
                HStack {
                    VStack(spacing: .zero) {
                        HStack {
                            Text(viewModel.fromStationText)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(
                                    viewModel.fromStation == nil
                                        ? .gray : .primary
                                )
                                .lineLimit(1)
                            Spacer()
                        }
                        .padding(.horizontal, 0)
                        .padding(.bottom, 8)
                        .background(Color(.systemBackground))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.isShowingFromCity = true
                        }

                        HStack {
                            Text(viewModel.toStationText)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(
                                    viewModel.toStation == nil
                                        ? .gray : .primary
                                )
                                .lineLimit(1)
                            Spacer()
                        }
                        .padding(.horizontal, 0)
                        .padding(.top, 8)
                        .background(Color(.systemBackground))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.isShowingToCity = true
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)

                    Button {
                        viewModel.reverse()
                    } label: {
                        Image(.changeIcon)
                    }
                    .padding(.horizontal, 4)

                }
                .padding()
                .background(Color(.blueUniversal))
                .cornerRadius(20)
                .padding(.horizontal, 16)
                .padding(.top, 44)

                if viewModel.areBothStationsSelected {
                    Button {
                        Task {
                            await viewModel.findRoutes()
                        }
                    } label: {
                        if viewModel.isLoadingRoutes {
                            ProgressView()
                        } else {
                            Text("Найти")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 150, height: 60)
                                .background(Color(.blueUniversal))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.top, 16)
                }

                Spacer()  // Растягиваем контент вверх
            }
        }
    }
}

// Вспомогательный View для ошибок
struct ErrorView: View {
    let error: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 50))
                .foregroundColor(.red)

            Text("Ошибка загрузки")
                .font(.title2)
                .bold()

            Text(error)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            Button("Повторить", action: onRetry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ChoiceRoute()
        .environmentObject(SettingsManager.shared)
}
