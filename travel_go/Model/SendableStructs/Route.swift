//
//  Route.swift
//  travel_go
//
//  Created by Захар Панченко on 14.09.2025.
//
import SwiftUI

struct Route: Identifiable, Sendable {
    let id: String
    let fromStation: Station
    let toStation: Station
    let departureTime: Date
    let arrivalTime: Date
    let duration: TimeInterval
    let carrier: String
    let price: Double?
    let transportType: String
    let thread: Components.Schemas.Thread?
}
