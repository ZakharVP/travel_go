//
//  Untitled.swift
//  travel_go
//
//  Created by Захар Панченко on 13.08.2025.
//
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showUserAgreement = false
    
    var body: some View {
        VStack(spacing: .zero) {
            // Блок с темной темой
            HStack {
                Text("Темная тема")
                    .font(.system(size: 17))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Toggle("", isOn: Binding(
                    get: { settingsManager.isDarkMode },
                    set: { settingsManager.isDarkMode = $0 }
                ))
                .labelsHidden()
                .tint(.blue)
            }
            .frame(height: 60)
            .padding(.horizontal, 16)
            
            
            // Блок с пользовательским соглашением 
            Button(action: {
                showUserAgreement = true
            }) {
                HStack {
                    Text("Пользовательское соглашение")
                        .font(.system(size: 17))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .frame(height: 60)
            .padding(.horizontal, 16)
            
            Spacer()
            
            // Нижний блок с информацией
            VStack(spacing: 4) {
                Text("Приложение использует API «Яндекс.Расписания»")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text("Версия 1.0 (beta)")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .frame(height: 44)
            .padding(.bottom, 24)
        }
        .padding(.top, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .fullScreenCover(isPresented: $showUserAgreement) {
            UserAgreementView()
        }
    }
}

#Preview {
    SettingsView()
}
