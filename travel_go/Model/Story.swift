//
//  Story.swift
//  travel_go
//
//  Created by Захар Панченко on 02.09.2025.
//

import SwiftUI

struct Story: Identifiable {
    let id = UUID()
    var imageName: String
    var title: String
    var smallText: String
    var isViewed: Bool = false
}
