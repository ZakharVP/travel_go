//
//  CarrierDetail.swift
//  travel_go
//
//  Created by Захар Панченко on 20.08.2025.
//

import SwiftUI

struct CarrierDetail: View {
    let mockCarrier: MockCarrier
    
    var body: some View {
        VStack(spacing: 16) {
            // Картинка из ассетов
            Image("no_internet")
                .resizable()
                .scaledToFit()
                .frame(width: 223, height: 223)
            
            // Надпись под картинкой
            Text("Нет интернета")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .navigationTitle("Детали перевозчика")
        .navigationBarTitleDisplayMode(.inline)
    }
}
