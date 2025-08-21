//
//  Untitled.swift
//  travel_go
//
//  Created by Захар Панченко on 13.08.2025.
//
import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 24) {
            // Картинка из ассетов
            Image("no_server")
                .resizable()
                .scaledToFit()
                .frame(width: 223, height: 223)
            
            // Надпись под картинкой
            Text(AppStrings.Errors.noServer)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    SettingsView()
}
