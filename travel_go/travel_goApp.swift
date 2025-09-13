//
//  travel_goApp.swift
//  travel_go
//
//  Created by Захар Панченко on 24.07.2025.
//

// 

import SwiftUI

@main
struct travel_goApp: App {
    @AppStorage("darkMode") var isDarkMode: Bool = false
    @StateObject private var settingsManager = SettingsManager.shared
    
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(settingsManager)
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .onChange(of: isDarkMode) { newValue in
                    settingsManager.isDarkMode = newValue
                }
        }
    }
    
    let persistenceController = PersistenceController.shared
}
