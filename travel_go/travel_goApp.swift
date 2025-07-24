//
//  travel_goApp.swift
//  travel_go
//
//  Created by Захар Панченко on 24.07.2025.
//

import SwiftUI

@main
struct travel_goApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
