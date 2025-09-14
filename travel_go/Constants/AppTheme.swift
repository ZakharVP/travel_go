//
//  AppTheme.swift
//  travel_go
//
//  Created by Захар Панченко on 14.09.2025.
//

enum AppTheme: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    case system = "system"
    
    var displayName: String {
        switch self {
        case .light: return "Светлая"
        case .dark: return "Темная"
        case .system: return "Как в системе"
        }
    }
}
