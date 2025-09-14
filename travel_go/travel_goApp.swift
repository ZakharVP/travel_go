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
    @StateObject private var settingsManager = SettingsManager.shared
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environment(
                    \.managedObjectContext,
                    persistenceController.container.viewContext
                )
                .environmentObject(settingsManager)
                .preferredColorScheme(settingsManager.colorScheme)
        }
    }

    let persistenceController = PersistenceController.shared
}
