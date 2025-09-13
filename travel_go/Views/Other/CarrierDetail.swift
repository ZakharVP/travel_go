//
//  CarrierDetail.swift
//  travel_go
//
//  Created by Захар Панченко on 20.08.2025.
//

import SwiftUI

struct CarrierDetail: View {
    let mockCarrier: MockCarrier
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: .zero) {
                // Картинка в указанном размере
                Image(.mocRGD)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 343, height: 104)
                    .padding(.top, 16)
                
                // Надпись ОАО "РЖД"
                HStack {
                    Text("ОАО \"РЖД\"")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                    Spacer()
                }
                .frame(height: 45)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                // Блок с email
                VStack(alignment: .leading, spacing: 8) {
                    Text("E-mail")
                        .font(.system(size: 17))
                        .foregroundColor(.primary)
                    
                    Text("I.logkina@yandex.ru")
                        .font(.system(size: 12))
                        .foregroundColor(Color("blueUniversal"))
                }
                .frame(height: 60)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                
                // Блок с телефоном
                VStack(alignment: .leading, spacing: 8) {
                    Text("Телефон")
                        .font(.system(size: 17))
                        .foregroundColor(.primary)
                    
                    Text("8 (926) 281-01-01")
                        .font(.system(size: 12))
                        .foregroundColor(Color("blueUniversal"))
                }
                .frame(height: 60)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                
                Spacer()
            }
        }
        .background(Color(.systemBackground))
        .navigationTitle("Информация о перевозчике")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // Скрываем стандартную кнопку
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss() // Возврат назад
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                        .font(.system(size: 20))
                }
            }
        }
    }
}
