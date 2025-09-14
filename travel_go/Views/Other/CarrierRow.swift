//
//  CarrierRow.swift
//  travel_go
//
//  Created by Захар Панченко on 20.08.2025.
//

import SwiftUI

struct CarrierRow: View {
    let carrier: Carrier

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Верхняя часть с перевозчиком и датой
            HStack {
                // Картинка перевозчика
                Image(systemName: transportIconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.blue)

                // Наименование перевозчика
                Text(carrier.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)

                Spacer()

                // Дата справа
                if let departureTime = carrier.departureTime {
                    Text(extractDateFromTimeString(departureTime))
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .padding(.trailing, 2)
                }
            }

            // Время и длительность
            HStack(spacing: 4) {
                if let departureTime = carrier.departureTime {
                    Text(departureTime)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.black)
                }

                // Линия с точками
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 4)

                if let duration = carrier.duration {
                    Text(duration)
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                }

                // Вторая линия
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 4)

                if let arrivalTime = carrier.arrivalTime {
                    Text(arrivalTime)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.black)
                }
            }
        }
        .padding(16)
        .background(Color("lightGray"))
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
    
    private var transportIconName: String {
        guard let transportType = carrier.transportType?.lowercased() else {
            return "car.fill"
        }
        
        switch transportType {
        case "train": return "train.side.front.car"
        case "bus": return "bus"
        case "plane": return "airplane"
        case "suburban": return "tram.fill"
        case "water": return "ferry.fill"
        default: return "car.fill"
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
    
    private func extractDateFromTimeString(_ timeString: String) -> String {
        // Предполагаем формат "YYYY-MM-DDTHH:MM:SS" или подобный
        let components = timeString.split(separator: "T")
        if components.count > 0 {
            let datePart = String(components[0])
            
            // Парсим дату в формате "YYYY-MM-DD"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale(identifier: "ru_RU")
            
            if let date = dateFormatter.date(from: datePart) {
                let displayFormatter = DateFormatter()
                displayFormatter.dateFormat = "d MMMM"
                displayFormatter.locale = Locale(identifier: "ru_RU")
                return displayFormatter.string(from: date)
            }
        }
        
        // Если не удалось распарсить, возвращаем оригинальную строку или заглушку
        return timeString
    }
}
