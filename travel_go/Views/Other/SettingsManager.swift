//
//  SettingsManager.swift
//  travel_go
//
//  Created by Захар Панченко on 01.09.2025.
//

import SwiftUI

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @Published var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "darkMode") {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "darkMode")
        }
    }
    
    private init() {}
}
