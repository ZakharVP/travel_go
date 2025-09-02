//
//  Untitled.swift
//  travel_go
//
//  Created by Захар Панченко on 02.09.2025.
//
import SwiftUI

struct ProgressBar: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width: min(CGFloat(progress) * geometry.size.width, geometry.size.width), height: geometry.size.height)
            }
            .cornerRadius(1.5)
        }
    }
}
