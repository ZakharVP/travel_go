//
//  SettingsManager.swift
//  travel_go
//
//  Created by Захар Панченко on 01.09.2025.
//

import SwiftUI

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()

    private let themeStorage: ThemeStorageProtocol

    @Published var currentTheme: AppTheme {
        didSet {
            themeStorage.saveTheme(currentTheme)
            applyTheme()
        }
    }

    private init(themeStorage: ThemeStorageProtocol = ThemeStorageService()) {
        self.themeStorage = themeStorage
        self.currentTheme = themeStorage.loadTheme()
        applyTheme()
    }

    func applyTheme() {
        objectWillChange.send()
        print("Тема изменена на: \(currentTheme.displayName)")
    }

    var colorScheme: ColorScheme? {
        switch currentTheme {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
    
    var isDarkMode: Bool {
        get { currentTheme == .dark }
        set { currentTheme = newValue ? .dark : .light }
    }
}
