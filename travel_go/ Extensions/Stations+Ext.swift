//
//  Stations+Ext.swift
//  travel_go
//
//  Created by Захар Панченко on 27.07.2025.
//

import OpenAPIRuntime

extension Components.Schemas.Station {
    var formattedDescription: String {
        """
        🚉 Станция: \(title ?? "Нет названия")
        📌 Тип: \(station_type_name ?? "Неизвестно")
        🏷️ Код: \(code ?? "Нет кода")
        📍 Координаты: \(lat?.description ?? "?"), \(lng?.description ?? "?")
        🚌 Транспорт: \(transport_type ?? "Неизвестно")
        📏 Расстояние: \(distance?.description ?? "?") км
        """
    }
    
    // Можно добавить другие полезные расширения для Station
    var shortInfo: String {
        "\(title ?? "Станция") (\(station_type_name ?? "тип неизвестен"))"
    }
}
