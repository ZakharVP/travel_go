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
    
    let carrier: Carrier
    @Environment(\.dismiss) private var dismiss
    
    //MARK: - Content
    
    var body: some View {
        ScrollView {
            VStack(spacing: .zero) {
                headerImage
                carrierTitle
                
                if let email = carrier.email, !email.isEmpty {
                    emailBlock(email: email)
                } else {
                    // Заглушка если email нет
                    emailBlock(email: "info@example.com")
                }
                
                if let phone = carrier.phone, !phone.isEmpty {
                    phoneBlock(phone: phone)
                } else {
                    // Заглушка если телефон нет
                    phoneBlock(phone: "8 (800) 123-45-67")
                }
                
                Spacer()
            }
        }
        .background(Color(.systemBackground))
        .navigationTitle("Информация о перевозчике")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
    }
    
    //MARK: - Views
    
    private var headerImage: some View {
        Image(.mocRGD)
            .resizable()
            .scaledToFit()
            .frame(width: 343, height: 104)
            .padding(.top, 8)
    }
    
    private var carrierTitle: some View {
        HStack {
            Text(carrier.title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
            Spacer()
        }
        .frame(height: 45)
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
    
    private func emailBlock(email: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("E-mail")
                .font(.system(size: 17))
                .foregroundColor(.primary)
            
            Text(email)
                .font(.system(size: 12))
                .foregroundColor(Color("blueUniversal"))
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
    
    private func phoneBlock(phone: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Телефон")
                .font(.system(size: 17))
                .foregroundColor(.primary)
            
            Text(phone)
                .font(.system(size: 12))
                .foregroundColor(Color("blueUniversal"))
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.top, 8) 
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
