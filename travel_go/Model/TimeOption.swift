//
//  TimeOption.swift
//  travel_go
//
//  Created by Захар Панченко on 21.08.2025.
//
import SwiftUI

struct TimeOption: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let timeRange: String
    var isSelected: Bool
}
