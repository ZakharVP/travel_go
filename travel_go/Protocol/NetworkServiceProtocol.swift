//
//  NetworkServiceProtocol.swift
//  travel_go
//
//  Created by Захар Панченко on 27.07.2025.
//

import OpenAPIRuntime

protocol NetworkServiceProtocol {
    var client: Client { get }
    var apiKey: String { get }
}
