//
//  ThemeStorageService.swift
//  travel_go
//
//  Created by Захар Панченко on 14.09.2025.
//
import SwiftUI

class ThemeStorageService: ThemeStorageProtocol {
    
    private let key: String = "appTheme"
    
    func saveTheme(_ theme: AppTheme) {
        UserDefaults.standard.set(theme.rawValue, forKey: key)
    }
    
    func loadTheme() -> AppTheme {
        if let savedThemeString = UserDefaults.standard.string(forKey: key),
           let savedTheme = AppTheme(rawValue: savedThemeString) {
            return savedTheme
        }
        return .system
    }
}
