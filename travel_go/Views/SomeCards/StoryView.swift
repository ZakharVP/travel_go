//
//  StoryView.swift
//  travel_go
//
//  Created by Захар Панченко on 13.08.2025.
//

import SwiftUI

struct StoriesView: View {
    let stories: [Story]
    @Binding var selectedStoryIndex: Int
    @Binding var isPresented: Bool
    @State private var progress: Double = 0.0
    @State private var timer: Timer? = nil
    @State private var currentDisplayIndex: Int = 0

    // Показываем 3 картинки: выбранная + две фиксированные
    private var fullScreenStories: [Story] {
        var result: [Story] = []

        // 1. Выбранная картинка (на которую тапнули)
        let firstStory = Story(
            imageName: stories[selectedStoryIndex].imageName,
            title: AppStrings.StoryText.fullScreenBig,
            smallText: AppStrings.StoryText.fullScreenSmall,
            isViewed: false
        )
        result.append(firstStory)

        // 2. Вторая всегда storyBigTwo
        let secondStory = Story(
            imageName: "storyBigTwo",
            title: AppStrings.StoryText.fullScreenBig,
            smallText: AppStrings.StoryText.fullScreenSmall,
            isViewed: false
        )
        result.append(secondStory)

        // 3. Третья всегда storyBigThree
        let thirdStory = Story(
            imageName: "storyBigThree",
            title: AppStrings.StoryText.fullScreenBig,
            smallText: AppStrings.StoryText.fullScreenSmall,
            isViewed: false
        )
        result.append(thirdStory)

        return result
    }

    var body: some View {
        ZStack {
            Color("blackUniversal")
                .ignoresSafeArea()

            // Текущая сторис
            if currentDisplayIndex < fullScreenStories.count {
                let story = fullScreenStories[currentDisplayIndex]

                ZStack {
                    Image(story.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height
                                - (safeAreaInsets.top + safeAreaInsets.bottom)
                        )
                        .clipped()
                        .cornerRadius(40)
                        .offset(y: 0)

                    // Текстовый блок поверх картинки
                    VStack(spacing: 16) {
                        Spacer()

                        // Основной текстовый контейнер
                        VStack(alignment: .leading, spacing: 16) {
                            // Заголовок
                            Text(story.title)
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                                .tracking(0.4)

                            // Описание
                            Text(story.smallText)
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(.white)
                                .tracking(0.4)
                        }
                        .frame(
                            width: 343,
                            height: 208,
                            alignment: .bottomLeading
                        )
                        .padding(.bottom, 50)
                    }
                    .padding(.horizontal, 16)

                    // Верхняя панель с индикаторами и крестиком
                    VStack {
                        HStack(spacing: 4) {
                            ForEach(0..<fullScreenStories.count, id: \.self) {
                                index in
                                ProgressBar(
                                    progress: index == currentDisplayIndex
                                        ? progress
                                        : (index < currentDisplayIndex
                                            ? 1.0 : 0.0)
                                )
                                .frame(height: 3)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, safeAreaInsets.top + 8)

                        HStack {
                            Text(
                                "\(currentDisplayIndex + 1)/\(fullScreenStories.count)"
                            )
                            .font(.system(size: 14))
                            .foregroundColor(.white)

                            Spacer()

                            Button(action: {
                                stopTimer()
                                isPresented = false
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        Spacer()
                    }
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            // Сбрасываем индекс отображения при каждом открытии
            currentDisplayIndex = 0
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    handleSwipe(value: value)
                }
        )
        .onTapGesture { location in
            handleTap(location: location)
        }
    }

    // Вычисляем safe area insets
    private var safeAreaInsets: UIEdgeInsets {
        UIApplication.shared.windows.first?.safeAreaInsets ?? .zero
    }

    private func startTimer() {
        progress = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {
            _ in
            withAnimation(.linear(duration: 0.1)) {
                progress += 0.01  // 10 секунд на одну сторис
            }

            if progress >= 1.0 {
                goToNextStory()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func goToNextStory() {
        stopTimer()

        if currentDisplayIndex < fullScreenStories.count - 1 {
            currentDisplayIndex += 1
            startTimer()
        } else {
            isPresented = false
        }
    }

    private func goToPreviousStory() {
        stopTimer()

        if currentDisplayIndex > 0 {
            currentDisplayIndex -= 1
            startTimer()
        }
    }

    private func handleSwipe(value: DragGesture.Value) {
        let horizontalSwipe = value.translation.width
        let verticalSwipe = value.translation.height

        // Свайп вниз для закрытия
        if verticalSwipe > 100 {
            stopTimer()
            isPresented = false
            return
        }

        // Свайп влево/вправо для навигации
        if horizontalSwipe < -50 {
            goToNextStory()
        } else if horizontalSwipe > 50 {
            goToPreviousStory()
        }
    }

    private func handleTap(location: CGPoint) {
        let screenWidth = UIScreen.main.bounds.width

        if location.x > screenWidth * 0.6 {
            goToNextStory()
        } else if location.x < screenWidth * 0.4 {
            goToPreviousStory()
        }
    }
}
