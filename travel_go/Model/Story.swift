//
//  Story.swift
//  travel_go
//
//  Created by Захар Панченко on 02.09.2025.
//

import SwiftUI

struct Story: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let smallText: String
    var isViewed: Bool = false
}
