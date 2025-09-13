//
//  CarrierDetail.swift
//  travel_go
//
//  Created by Захар Панченко on 20.08.2025.
//

import SwiftUI

//MARK: - CarrierDetail

struct CarrierDetail: View {
    
    //MARK: - Properties
    
    let mockCarrier: MockCarrier
    @Environment(\.dismiss) private var dismiss
    
    //MARK: - Content
    
    var body: some View {
        ScrollView {
            VStack(spacing: .zero) {
                headerImage
                carrierTitle
                emailBlock
                phoneBlock
                Spacer()
                
            }
        }
        .background(Color(.systemBackground))
        .navigationTitle("Информация о перевозчике")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                backButton
            }
        }
    }
    
    //MARK: - Views
    
    private var headerImage: some View {
        Image(.mocRGD)
            .resizable()
            .scaledToFit()
            .frame(width: 343, height: 343)
            .padding(.top, 16)
    }
    
    private var carrierTitle: some View {
        HStack {
            Text("ОАО \"РЖД\"")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
            Spacer()
        }
        .frame(height: 45)
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
    
    private var emailBlock: some View {
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
    }
    
    private var phoneBlock: some View {
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
    }
    
    //MARK: - ToolbarItem Back Button
    
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundColor(.primary)
                .font(.system(size: 20))
        }
    }
}

// MARK: - CarrierDetail_Preview

#Preview {
    CarrierDetail(mockCarrier: MockCarrier(
        name: "ОАО \"РЖД\"",
        price: 0.11,
        duration: "8 (926) 281-11-11"
    ))
}
