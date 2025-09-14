//
//  SearchResponse.swift
//  travel_go
//
//  Created by Захар Панченко on 15.09.2025.
//

import Foundation

struct SearchResponse: Codable, Sendable {
    let search: SearchInfo?
    let segments: [Segment]?
    let intervalSegments: [Segment]?
    let pagination: Pagination?
    
    enum CodingKeys: String, CodingKey {
        case search, segments
        case intervalSegments = "interval_segments"
        case pagination
    }
}

struct SearchInfo: Codable, Sendable {
    let from: StationInfo?
    let to: StationInfo?
    let date: String?
}

struct Segment: Codable, Sendable {
    let arrival: String?
    let departure: String?
    let thread: Thread?
    let from: StationInfo?
    let to: StationInfo?
    let duration: Double?
    let startDate: String?
    let ticketsInfo: TicketsInfo?
    let stops: String?
    let hasTransfers: Bool?
    let arrivalPlatform: String?
    let departurePlatform: String?
    
    enum CodingKeys: String, CodingKey {
        case arrival, departure, thread, from, to, duration, stops
        case startDate = "start_date"
        case ticketsInfo = "tickets_info"
        case hasTransfers = "has_transfers"
        case arrivalPlatform = "arrival_platform"
        case departurePlatform = "departure_platform"
    }
}

struct Thread: Codable, Sendable {
    let uid: String?
    let number: String?
    let title: String?
    let shortTitle: String?
    let transportType: String?
    let carrier: ThreadCarrier?
    let transportSubtype: TransportSubtype?
    let vehicle: String?
    
    enum CodingKeys: String, CodingKey {
        case uid, number, title, carrier, vehicle
        case shortTitle = "short_title"
        case transportType = "transport_type"
        case transportSubtype = "transport_subtype"
    }
}

struct ThreadCarrier: Codable, Sendable {
    let code: Int?
    let title: String?
    let address: String?
    let url: String?
    let email: String?
    let contacts: String?
    let phone: String?
    let logo: String?
    let logoSvg: String?
    let codes: CarrierCodes?
    
    enum CodingKeys: String, CodingKey {
        case code, title, address, url, email, contacts, phone, logo, codes
        case logoSvg = "logo_svg"
    }
}

struct CarrierCodes: Codable, Sendable {
    let iata: String?
    let icao: String?
    let sirena: String?
    let express: String?
    let yandexCode: String?
    
    enum CodingKeys: String, CodingKey {
        case iata, icao, sirena, express
        case yandexCode = "yandex_code"
    }
}

struct TransportSubtype: Codable, Sendable {
    let code: String?
    let color: String?
    let title: String?
}

struct StationInfo: Codable, Sendable {
    let code: String?
    let title: String?
    let type: String?
    let shortTitle: String?
    let popularTitle: String?
    let stationType: String?
    let stationTypeName: String?
    let transportType: String?
    
    enum CodingKeys: String, CodingKey {
        case code, title, type
        case shortTitle = "short_title"
        case popularTitle = "popular_title"
        case stationType = "station_type"
        case stationTypeName = "station_type_name"
        case transportType = "transport_type"
    }
}

struct TicketsInfo: Codable, Sendable {
    let etMarker: Bool?
    let places: [Place]?
    
    enum CodingKeys: String, CodingKey {
        case etMarker = "et_marker"
        case places
    }
}

struct Place: Codable, Sendable {
    let currency: String?
    let name: String?
    let price: Price?
}

struct Price: Codable, Sendable {
    let whole: Int?
    let cents: Int?
    
    var total: Double? {
        guard let whole = whole, let cents = cents else { return nil }
        return Double(whole) + Double(cents) / 100.0
    }
}

struct Pagination: Codable, Sendable {
    let total: Int?
    let limit: Int?
    let offset: Int?
}
