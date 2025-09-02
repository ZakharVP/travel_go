//
//  CarrierRow.swift
//  travel_go
//
//  Created by Захар Панченко on 20.08.2025.
//

import SwiftUI

struct CarrierRow: View {
    let mockCarrier: MockCarrier

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Верхняя часть с перевозчиком и датой
            HStack {
                // Картинка перевозчика
                Image(systemName: "train.side.front.car")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.blue)

                // Наименование перевозчика
                Text(mockCarrier.name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)

                Spacer()

                // Дата справа
                Text("14 января")
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .padding(.trailing, 2)
            }

            HStack(spacing: 4) {
                Text("22:30")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.black)

                // Линия с точками
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 4)

                Text("20 часов")
                    .font(.system(size: 13))
                    .foregroundColor(.black)

                // Вторая линия
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 4)

                Text("08:15")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.black)
            }
        }
        .padding(16)
        .background(Color("lightGray"))
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
}
