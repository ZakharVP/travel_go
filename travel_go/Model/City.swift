//
//  Untitled.swift
//  travel_go
//
//  Created by Захар Панченко on 20.08.2025.
//

import SwiftUI

struct City: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let stations: [Station]
}

let mockCities = [
    City(
        name: "Москва", stations: [
        Station(name: "Курский вокзал", code: "KUR"),
        Station(name: "Павелецкий вокзал", code: "PVE"),
        Station(name: "Ленинградский вокзал", code: "LEN"),
        Station(name: "Киевский вокзал", code: "KIEV")
    ]),
    City(name: "Санкт-Петербург", stations: [
        Station(name: "Московский вокзал", code: "MOS"),
        Station(name: "Финляндский вокзал", code: "FIN"),
        Station(name: "Витебсктий вокзал", code: "VIT"),
        Station(name: "Варшавский вокзал", code: "VAR")
    ]),
    City(name: "Сочи", stations: [
        Station(name: "Центральный вокзал", code: "CNV"),
        Station(name: "Адлер вокзал", code: "ADV"),
        Station(name: "Олимпийский парк вокзал", code: "OPV"),
        Station(name: "Красная поляна вокзал", code: "KPV")
    ]),
    City(name: "Горный воздух", stations: [
        Station(name: "Первый вокзал", code: "PVG"),
        Station(name: "Второй вокзал", code: "GVV"),
        Station(name: "Третий вокзал", code: "TVV")
    ]),
    City(name: "Краснодар", stations: [
        Station(name: "Краснодар-1 вокзал", code: "CNV"),
        Station(name: "Краснодар-2 вокзал", code: "ADV")
    ]),
    City(name: "Казань", stations: [
        Station(name: "Центральный вокзал", code: "KCV"),
        Station(name: "Северный вокзал", code: "KSV")
    ]),
    City(name: "Омск", stations: [
        Station(name: "Фадино вокзал", code: "CNV"),
        Station(name: "Карбышево вокзал", code: "ADV")
    ]),
]
