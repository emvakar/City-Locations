//
//  ResponseModel.swift
//  Fetch Locations
//
//  Created by Emil Karimov on 09/08/2019.
//  Copyright © 2019 TAXCOM. All rights reserved.
//

import Foundation

// MARK: - MapResponse
struct MapResponse: Codable {
    let results: [Result]
//    let timestamp: Timestamp
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case results
//        case timestamp
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Result: Codable {
    let bounds: Bounds?
    let components: Components
}

// MARK: - Bounds
struct Bounds: Codable {
    let northeast, southwest: Geometry
}

// MARK: - Geometry
struct Geometry: Codable {
    let lat, lng: Double
}

// MARK: - Components
struct Components: Codable {
//    let ISO31661_Alpha2: String
//    let ISO31661_Alpha3: String
    let type: String
    let city: String?
    let state: String?
//    let continent: String
    let country: String?
    let countryCode: String?
    
    
    enum CodingKeys: String, CodingKey {
//        case ISO31661_Alpha2
//        case ISO31661_Alpha3
        case type = "_type"
        case city// = "state"
        case state
        case country
        case countryCode = "country_code"
    }
}
