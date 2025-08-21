//
//  FilterOption.swift
//  travel_go
//
//  Created by Захар Панченко on 21.08.2025.
//
import SwiftUI

struct FilterOption: Identifiable, Hashable {
    let id = UUID()
    let title: String
    var isSelected: Bool
}
