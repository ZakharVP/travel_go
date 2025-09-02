//
//  MainScreen.swift
//  travel_go
//
//  Created by Захар Панченко on 12.08.2025.
//

import SwiftUI

struct MainScreen: View {
    @State private var selectedTab: Int = 0
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        TabView(selection: $selectedTab) {
            ChoiceRoute()
                .tabItem {
                    Image("MainIcon")
                        .renderingMode(.template)
                        .foregroundColor(selectedTab == 0 ?
                                       (colorScheme == .dark ? .white : .blackUniversal) : .grayUniversal)
                }
                .tag(0)
            SettingsView()
                .tabItem {
                    Image("SettingsIcon")
                        .renderingMode(.template)
                        .foregroundColor(selectedTab == 1 ?
                                       (colorScheme == .dark ? .white : .blackUniversal) : .grayUniversal)
                }
                .tag(1)
        }
        .tint(colorScheme == .dark ? .white : .blackUniversal)
    }
}

#Preview {
    MainScreen()
}
