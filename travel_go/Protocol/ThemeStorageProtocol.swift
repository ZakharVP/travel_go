//
//  ThemeStorageProtocol.swift
//  travel_go
//
//  Created by Захар Панченко on 14.09.2025.
//

import Foundation

protocol ThemeStorageProtocol {
    func loadTheme() -> AppTheme
    func saveTheme(_ theme: AppTheme)
}
