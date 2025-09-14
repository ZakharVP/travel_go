//
//  Codes.swift
//  travel_go
//
//  Created by Захар Панченко on 14.09.2025.
//

struct Codes: Codable, Sendable {
    let yandexCode: String
    
    enum CodingKeys: String, CodingKey {
        case yandexCode = "d7da3fd8-3adb-459e-8cf8-13283ad0685d"
    }
}
