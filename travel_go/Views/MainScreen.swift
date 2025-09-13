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
                .tag(Tab.main)
            
            SettingsView()
                .tabItem {
                    Image("SettingsIcon")
                        .renderingMode(.template)
                }
                .tag(Tab.settings)
        }
        .tint(.primary)
    }
}

#Preview {
    MainScreen()
}
