//
//  MainScreen.swift
//  travel_go
//
//  Created by Захар Панченко on 12.08.2025.
//

import SwiftUI

struct MainScreen: View {
    @State var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ChoiceRoute()
                .tabItem { Label("", image: "MainIcon") }
                .tag(0)
            SettingsView()
                .tabItem { Label("", image: "SettingsIcon") }
                .tag(1)
        }
    }
}

#Preview {
    MainScreen()
}
