//
//  MainScreen.swift
//  travel_go
//
//  Created by Захар Панченко on 12.08.2025.
//

import SwiftUI

struct MainScreen: View {
    @State private var selectedTab: Int = 0
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ChoiceRoute()
                .tabItem {
                    Image("MainIcon")
                        .renderingMode(.template)
                }
                .tag(0)
            
            SettingsView()
                .tabItem {
                    Image("SettingsIcon")
                        .renderingMode(.template)
                }
                .tag(1)
        }
        .tint(.primary)
    }
}

#Preview {
    MainScreen()
}
