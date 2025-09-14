//
//  SettingsViewModel.swift
//  travel_go
//
//  Created by Захар Панченко on 14.09.2025.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var selectedTheme: AppTheme
    
    // MARK: - Private Properties
    
    private let settingsManager: SettingsManager
    
    // MARK: - Initialization
    
    init(settingsManager: SettingsManager = .shared) {
        self.settingsManager = settingsManager
        self.selectedTheme = settingsManager.currentTheme
    }
    
    // MARK: - Public Methods
    
    func toggleTheme() {
        selectedTheme = selectedTheme == .dark ? .light : .dark
        settingsManager.currentTheme = selectedTheme
    }
    
    func setTheme(_ theme: AppTheme) {
        if selectedTheme != theme {
            selectedTheme = theme
            settingsManager.currentTheme = theme
        }
    }
    
    var isDarkMode: Bool {
        get { selectedTheme == .dark }
        set {
            if newValue {
                setTheme(.dark)
            } else {
                setTheme(.light)
            }
        }
    }
    
}
